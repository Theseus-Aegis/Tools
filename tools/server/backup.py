#!/usr/bin/env python3

import os
import sys
import shutil
import time
import argparse
import subprocess
import ftplib
import stat

######## GLOBALS #########
# PATHS
TEMP = "D:\\Theseus\\Tools\\temp"
ARMA_SERVERS_PATH = "C:\\Theseus\\Arma 3 Servers"
MYSQLDUMP_PATH = "C:\\Program Files\\MySQL\\MySQL Server 5.7\\bin"
STORAGE = "D:\\Backup"
# CONTENTS
ITEMS = ["C:\\Apache24", "C:\\php", "C:\\Program Files (x86)\\hMailServer\\Data", "C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Data", "D:\\Theseus\\Arma 3\\Missions Archive", "D:\\Theseus\\Arma 3\\Modpack\\development", "D:\\Theseus\\Athena", "D:\\Theseus\\TeamSpeak 3 Server", "D:\\Theseus\\www\\drupal", "D:\\Theseus\\www\\resources\\TheseusServices", "D:\\Theseus\\www\\squadxml", "D:\\Theseus\\www\\webmail", "D:\\Theseus\\files_changed.txt"]
ARMA_SERVER_ITEMS = ["Apollo", "mpmissions", "apollo.properties", "jni.conf", "jni.dll", "params.cfg", "server.cfg"]
DATABASES = ["apollo", "apollo_test", "drupal", "hmaildb"]
# OTHER
BACKUPS_TO_KEEP = 10
##########################

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
    parser.add_argument("-ftpp", "--ftppassword", default=False, type=str, required=False, help="FTP backup server password")
    parser.add_argument("-si", "--specificitem", default=False, type=str, required=False, help="backup only specific item")
    parser.add_argument("-sdb", "--specificdatabase", default=False, type=str, required=False, help="backup only specific database")
    keep_parser = parser.add_mutually_exclusive_group(required=False)
    keep_parser.add_argument("-k", "--keep", dest="keep", action="store_true", help="keep backup locally")
    keep_parser.add_argument("-nk", "--no-keep", dest="keep", action="store_false", help="remove local backup")
    parser.set_defaults(keep=True)
    args = parser.parse_args()

    items = ITEMS
    if args.specificitem:
        items = [args.specificitem]

    databases = DATABASES
    if args.specificdatabase:
        databases = [args.specificdatabase]


    # Prepare temporary folders and date
    date = time.strftime("%Y%m%dT%H%M%S")

    tempFiles = os.path.join(TEMP,"files")
    packedFiles = os.path.join(TEMP,"packed")
    if os.path.exists(TEMP):
        shutil.rmtree(TEMP, onerror=remove_readonly)
    os.mkdir(TEMP)
    os.mkdir(packedFiles)


    # Backup items
    print("Backing up items...")

    for item in items:
        if os.path.exists(item):
            print("- {}".format(item))

            # Copy to temporary folder to prevent access issues
            os.mkdir(tempFiles)
            if os.path.isdir(item):
                tempFolder = item.rsplit("\\", 1)[1]
                tempFolder = os.path.join(tempFiles,tempFolder)
                shutil.copytree(item,tempFolder)
            else:
                shutil.copy2(item,tempFiles)

            # Zip it up and move it to another folder
            name = item[3:].replace(" ", "_").replace("\\", "_").replace("__", "_").lower()
            if "." in name:
                name = name.split(".", 1)[0]

            archive = shutil.make_archive("{}_{}".format(date,name), "zip", tempFiles)
            shutil.move(archive,packedFiles)

            # Remove temporary folder to allow copytree to create it again
            shutil.rmtree(tempFiles, onerror=remove_readonly)


    # Backup Arma 3 Server items
    print("\nBacking up Arma 3 Server items...")

    if os.path.exists(ARMA_SERVERS_PATH):
        for serverDir in os.listdir(ARMA_SERVERS_PATH):
            serverPath = os.path.join(ARMA_SERVERS_PATH,serverDir)
            print("- {}".format(serverPath))

            os.mkdir(tempFiles)
            for item in ARMA_SERVER_ITEMS:
                itemPath = os.path.join(serverPath,item)
                if os.path.exists(itemPath):
                    # Copy to temporary folder to prevent access issues
                    if os.path.isdir(itemPath):
                        tempFolder = itemPath.rsplit("\\", 1)[1]
                        tempFolder = os.path.join(tempFiles,tempFolder)
                        shutil.copytree(itemPath,tempFolder)
                    else:
                        shutil.copy2(itemPath,tempFiles)

            # Zip it up and move it to another folder
            name = ARMA_SERVERS_PATH[3:].replace(" ", "_").replace("\\", "_")
            name = "{}_{}".format(name,serverDir).lower()

            archive = shutil.make_archive("{}_{}".format(date,name), "zip", tempFiles)
            shutil.move(archive,packedFiles)

            # Remove temporary folder to allow copytree to create it again
            shutil.rmtree(tempFiles, onerror=remove_readonly)


    # Export databases
    if args.databaseuser and args.databasepassword:
        print("\nBacking up databases...")

        os.mkdir(tempFiles)
        for database in databases:
            print("- {}".format(database))

            subprocess.call([
                "{}\mysqldump".format(MYSQLDUMP_PATH),
                "-u",
                "{}".format(args.databaseuser),
                "-p{}".format(args.databasepassword),
                "{}".format(database),
                ">",
                "{}\{}.sql".format(tempFiles,database)
            ], shell=True)

        # Zip it up and move it to another folder
        archive = shutil.make_archive("{}_mysql_dump".format(date), "zip", tempFiles)
        shutil.move(archive,packedFiles)

        # Remove temporary folder to allow copytree to create it again
        shutil.rmtree(tempFiles, onerror=remove_readonly)
    else:
        print("\nSkipping database backup (no user and password)")


    # Upload to FTP server
    if args.ftpserver and args.ftpuser and args.ftppassword:
        print("\nUploading to FTP server...")

        # Establish FTP connection
        ftp = ftplib.FTP(args.ftpserver)
        ftp.login(args.ftpuser,args.ftppassword)

        # Upload files
        folder = "{}_theseus_backup".format(date)

        if not folder in ftp.nlst():
            ftp.mkd(folder)

        ftp.cwd(folder)
        for file in os.listdir(packedFiles):
            filePath = os.path.join(packedFiles,file)
            print("- {}".format(filePath))
            ftp.storbinary("STOR {}".format(file), open(filePath, "rb"), 1024)

        # Remove oldest backup when there are more than BACKUPS_TO_KEEP
        ftp.cwd("..")
        folders = [x for x in ftp.nlst() if "_theseus_backup" in x]
        folders.sort()
        amountToRemove = len(folders) - BACKUPS_TO_KEEP - 4 # 4 = [".", "..", ".banner", ".ftpquota"]
        if amountToRemove > 0:
            print("- Removing {} old backup(s)...".format(amountToRemove))

            for folder in folders[:amountToRemove]:
                print("  - {}".format(folder))

                ftp.cwd(folder)
                for file in ftp.nlst():
                    if file.startswith("2"):
                        ftp.delete(file)
                ftp.cwd("..")
                ftp.rmd(folder)
        else:
            print("- Skipping removal of old backups (not enough of them)")
    else:
        print("\nSkipping upload to FTP server (no user and password)")


    # Move to specified storage location or remove
    if args.keep:
        print("\nMoving to storage location...")

        if not os.path.exists(STORAGE):
            os.mkdir(STORAGE)

        folder = "{}\\{}_theseus_backup".format(STORAGE,date)
        shutil.move(packedFiles,folder)

        # Remove oldest backup when there are more than BACKUPS_TO_KEEP
        folders = [x for x in os.listdir(STORAGE) if "_theseus_backup" in x]
        folders.sort()
        amountToRemove = len(folders) - BACKUPS_TO_KEEP
        if amountToRemove > 0:
            print("- Removing {} old backup(s)...".format(amountToRemove))

            for folder in folders[:amountToRemove]:
                print("  - {}".format(folder))
                shutil.rmtree(os.path.join(STORAGE,folder), onerror=remove_readonly)
        else:
            print("- Skipping removal of old backups (not enough of them)")
    else:
        print("\nSkipping move to storage location (removing local backup)")


    # Remove temporary folder
    shutil.rmtree(TEMP, onerror=remove_readonly)


if __name__ == "__main__":
    sys.exit(main())
