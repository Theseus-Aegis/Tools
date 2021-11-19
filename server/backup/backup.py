#!/usr/bin/env python3

import os
import sys
import shutil
import time
import argparse
import subprocess
import ftplib
import stat


# PATHS
TEMP = "C:\\Theseus\\Tools\\temp"
ARMA_SERVERS_PATH = "C:\\Theseus\\Arma 3\\Servers"
MYSQLDUMP_PATH = "C:\\Program Files\\MySQL\\MySQL Server 8.0\\bin"
STORAGE = "C:\\Theseus\\Backup"
# CONTENTS
ITEMS = ["C:\\Apache24", "C:\\php7", "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data",
         "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\my.ini", "C:\\Theseus\\Arma 3\\Missions Archive",
         "C:\\Theseus\\Athena", "C:\\Theseus\\TeamSpeak 3 Server", "C:\\Theseus\\www\\drupal",
         "C:\\Theseus\\www\\resources\\TheseusServices", "C:\\Theseus\\www\\squadxml", "C:\\Theseus\\tac_notes.txt"]
ARMA_SERVER_ITEMS = ["Apollo", "mpmissions", "apollo.properties", "jni.conf", "jni.dll", "jni_x64.dll", "params.cfg",
                     "server.cfg"]
DATABASES = ["apollo", "apollo_test", "drupal"]
# OTHER
BACKUPS_TO_KEEP = 10
BACKUPS_TO_KEEP_GDRIVE = 5
GDRIVE_FOLDER_ID = "1dxY569UQP_84eesABDYIZ-vzxS1wVCcS"


def log(text):
    print(text)
    with open("backup.log", "a") as logfile:
        logfile.write(f"[{time.strftime('%Y%m%dT%H%M%S')}] {text}\n")


def remove_readonly(function, path, exc):
    os.chmod(path, stat.S_IWRITE)
    function(path)


def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description="Process item type to parse")
    parser.add_argument("-dbu", "--databaseuser", default=False, type=str, required=False, help="database user")
    parser.add_argument("-dbp", "--databasepassword", default=False, type=str, required=False, help="database password")
    parser.add_argument("-ftps", "--ftpserver", default=False, type=str, required=False, help="FTP backup server URL")
    parser.add_argument("-ftpu", "--ftpuser", default=False, type=str, required=False, help="FTP backup server user")
    parser.add_argument("-ftpp", "--ftppassword", default=False, type=str, required=False,
                        help="FTP backup server password")
    parser.add_argument("-si", "--specificitem", default=False, type=str, required=False,
                        help="backup only specific item")
    parser.add_argument("-sdb", "--specificdatabase", default=False, type=str, required=False,
                        help="backup only specific database")
    parser.add_argument("-k", "--keep", default=False, action="store_true", help="keep backup locally")
    args = parser.parse_args()

    items = ITEMS
    if args.specificitem:
        items = [args.specificitem]

    databases = DATABASES
    if args.specificdatabase:
        databases = [args.specificdatabase]

    ###
    # Import optional pip packages
    use_gauth = os.path.isfile("settings.yaml")
    if use_gauth:
        from pydrive2.auth import GoogleAuth
        from pydrive2.drive import GoogleDrive

    ###
    # Prepare temporary folders and date
    date = time.strftime("%Y%m%dT%H%M%S")
    log("Starting backup!")

    tempFiles = os.path.join(TEMP, "files")
    packedFiles = os.path.join(TEMP, "packed")

    # Make sure temporary folder is clean
    if os.path.exists(TEMP):
        shutil.rmtree(TEMP, onerror=remove_readonly)

    os.mkdir(TEMP)
    os.mkdir(packedFiles)

    ###
    # Backup items
    log("Backing up items...")

    for item in items:
        if os.path.exists(item):
            log(f"- {item}")

            # Copy to temporary folder to prevent access issues
            os.mkdir(tempFiles)
            if os.path.isdir(item):
                tempFolder = item.rsplit("\\", 1)[1]
                tempFolder = os.path.join(tempFiles, tempFolder)
                shutil.copytree(item, tempFolder)
            else:
                shutil.copy2(item, tempFiles)

            # Zip it up and move it to another folder
            name = item[3:].replace(" ", "_").replace("\\", "_").replace("__", "_").lower()
            if "." in name:
                name = name.rsplit(".", 1)[0]

            archive = shutil.make_archive(f"{date}_{name}", "zip", tempFiles)
            shutil.move(archive, packedFiles)

            # Remove temporary folder to allow copytree to create it again
            shutil.rmtree(tempFiles, onerror=remove_readonly)

    # Backup Arma 3 Server items
    log("Backing up Arma 3 Server items...")

    if os.path.exists(ARMA_SERVERS_PATH):
        for serverDir in os.listdir(ARMA_SERVERS_PATH):
            serverPath = os.path.join(ARMA_SERVERS_PATH, serverDir)
            log(f"- {serverPath}")

            os.mkdir(tempFiles)
            for item in ARMA_SERVER_ITEMS:
                itemPath = os.path.join(serverPath, item)
                if os.path.exists(itemPath):
                    # Copy to temporary folder to prevent access issues
                    if os.path.isdir(itemPath):
                        tempFolder = itemPath.rsplit("\\", 1)[1]
                        tempFolder = os.path.join(tempFiles, tempFolder)
                        shutil.copytree(itemPath, tempFolder)
                    else:
                        shutil.copy2(itemPath, tempFiles)

            # Zip it up and move it to another folder
            name = ARMA_SERVERS_PATH[3:].replace(" ", "_").replace("\\", "_")
            name = f"{name}_{serverDir}".lower()

            archive = shutil.make_archive(f"{date}_{name}", "zip", tempFiles)
            shutil.move(archive, packedFiles)

            # Remove temporary folder to allow copytree to create it again
            shutil.rmtree(tempFiles, onerror=remove_readonly)

    ###
    # Export databases
    if args.databaseuser and args.databasepassword:
        log("Backing up databases...")

        os.mkdir(tempFiles)
        for database in databases:
            log(f"- {database}")

            subprocess.call([
                f"{MYSQLDUMP_PATH}\\mysqldump",
                "-u",
                f"{args.databaseuser}",
                f"-p{args.databasepassword}",
                f"{database}",
                ">",
                f"{tempFiles}\\{database}.sql"
            ], shell=True)

        # Zip it up and move it to another folder
        archive = shutil.make_archive(f"{date}_mysql_dump", "zip", tempFiles)
        shutil.move(archive, packedFiles)

        # Remove temporary folder to allow copytree to create it again
        shutil.rmtree(tempFiles, onerror=remove_readonly)
    else:
        log("Skipping database backup (no user and password)")

    ###
    # Upload to FTP server
    if args.ftpserver and args.ftpuser and args.ftppassword:
        log("Uploading to FTP server...")

        # Establish FTP connection
        ftp = ftplib.FTP(args.ftpserver)
        ftp.login(args.ftpuser, args.ftppassword)

        # Upload files
        folder = f"{date}_theseus_backup"

        if folder not in ftp.nlst():
            ftp.mkd(folder)

        ftp.cwd(folder)
        for file in os.listdir(packedFiles):
            filePath = os.path.join(packedFiles, file)
            log("- {}".format(filePath))
            ftp.storbinary("STOR {}".format(file), open(filePath, "rb"), 1024)

        # Remove oldest backup when there are more than BACKUPS_TO_KEEP
        ftp.cwd("..")
        folders = [x for x in ftp.nlst() if "_theseus_backup" in x]
        folders.sort()
        amountToRemove = len(folders) - BACKUPS_TO_KEEP - 4  # 4 = [".", "..", ".banner", ".ftpquota"]
        if amountToRemove > 0:
            log(f"- Removing {amountToRemove} old backup(s)...")

            for folder in folders[:amountToRemove]:
                log(f"  - {folder}")

                ftp.cwd(folder)
                for file in ftp.nlst():
                    if file.startswith("2"):
                        ftp.delete(file)
                ftp.cwd("..")
                ftp.rmd(folder)
        else:
            log("- Skipping removal of old backups (not enough of them)")
    else:
        log("Skipping upload to FTP server (no user and password)")

    ###
    # Upload to Google Drive
    if use_gauth:
        log("Uploading to Google Drive...")

        # Establish Google Drive connection
        gauth = GoogleAuth()
        drive = GoogleDrive(gauth)

        # Upload files
        gfolder = drive.CreateFile({
            "title": f"{date}_theseus_backup",
            "mimeType": "application/vnd.google-apps.folder",
            "parents": [{
                "id": GDRIVE_FOLDER_ID,
            }],
        })
        gfolder.Upload()

        for file in os.listdir(packedFiles):
            filePath = os.path.join(packedFiles, file)
            log(f"- {filePath}")

            gfile = drive.CreateFile({
                "title": file,
                "parents": [{
                    "id": gfolder["id"],
                }],
            })
            gfile.SetContentFile(filePath)
            gfile.Upload()

        # Remove oldest backup when there are more than BACKUPS_TO_KEEP_GDRIVE
        gfolders = drive.ListFile({
            "q": f"\"{GDRIVE_FOLDER_ID}\" in parents and trashed=False",
        }).GetList()
        gfolders = sorted(gfolders, key=lambda item: item["title"])
        amountToRemove = len(gfolders) - BACKUPS_TO_KEEP_GDRIVE
        if amountToRemove > 0:
            log(f"- Removing {amountToRemove} old backup(s)...")

            for gfolder in gfolders[:amountToRemove]:
                log(f"  - {gfolder['title']}")
                gfolder.Delete()
        else:
            log("- Skipping removal of old backups (not enough of them)")
    else:
        log("Skipping upload to Google Drive (no authentication)")

    ###
    # Move to specified storage location or remove
    if args.keep:
        log("Moving to storage location...")

        if not os.path.exists(STORAGE):
            os.mkdir(STORAGE)

        folder = f"{STORAGE}\\{date}_theseus_backup"
        shutil.move(packedFiles, folder)

        # Remove oldest backup when there are more than BACKUPS_TO_KEEP
        folders = [x for x in os.listdir(STORAGE) if "_theseus_backup" in x]
        folders.sort()
        amountToRemove = len(folders) - BACKUPS_TO_KEEP
        if amountToRemove > 0:
            log(f"- Removing {amountToRemove} old backup(s)...")

            for folder in folders[:amountToRemove]:
                log(f"--- {folder}")
                shutil.rmtree(os.path.join(STORAGE, folder), onerror=remove_readonly)
        else:
            log("- Skipping removal of old backups (not enough of them)")
    else:
        log("Skipping move to storage location (removing local backup)")

    return 0


if __name__ == "__main__":
    try:
        status = main()
    except Exception as e:
        log(e)
        status = 1
    finally:
        # Remove temporary folder
        if os.path.exists(TEMP):
            shutil.rmtree(TEMP, onerror=remove_readonly)

    if status == 0:
        log("Backup SUCCESSFUL!")
    else:
        log("Backup FAILED!")

    sys.exit(status)
