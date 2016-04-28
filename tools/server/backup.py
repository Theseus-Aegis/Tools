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
ROOT = "C:\\"
TEMP = "C:\\tmp\\backup"
ARMA_SERVERS_PATH = "Theseus\\Arma 3\\Servers"
MYSQLDUMP_PATH = "C:\\Program Files\\MySQL\\MySQL Server 5.7\\bin"
# CONTENTS
ITEMS = ["Apache24", "php", "Program Files (x86)\\hMailServer\\Data", "ProgramData\\MySQL\\MySQL Server 5.7\\Data", "Theseus\\Arma 3\\Missions Archive", "Theseus\\Arma 3\\Modpack\\development", "Theseus\\Athena", "Theseus\\TeamSpeak 3 Server", "Theseus\\www\\drupal", "Theseus\\www\\resources", "Theseus\\www\\webmail", "Theseus\\files_changed.txt"]
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
    args = parser.parse_args()

    items = ITEMS
    if args.specificitem:
        items = [args.specificitem]

    databases = DATABASES
    if args.specificdatabase:
        databases = [args.specificdatabase]


    # Prepare temporary folders and date
    date = time.strftime("%Y%m%d")

    tempFiles = os.path.join(TEMP,"files")
    packedFiles = os.path.join(TEMP,"packed")
    if os.path.exists(TEMP):
        shutil.rmtree(TEMP, onerror=remove_readonly)
    os.mkdir(TEMP)
    os.mkdir(packedFiles)


    # Backup items
    print("Backing up items...")

    for item in items:
        itemPath = os.path.join(ROOT,item)
        if os.path.exists(itemPath):
            print("- {}".format(itemPath))

            # Copy to temporary folder to prevent access issues
            os.mkdir(tempFiles)
            if os.path.isdir(itemPath):
                tempFolder = itemPath.rsplit("\\", 1)[1]
                tempFolder = os.path.join(tempFiles,tempFolder)
                shutil.copytree(itemPath,tempFolder)
            else:
                shutil.copy2(itemPath,tempFiles)

            # Zip it up and move it to another folder
            name = item.replace(" ", "_").replace("\\", "_").replace("__", "_").lower()
            if "." in name:
                name = name.split(".", 1)[0]

            archive = shutil.make_archive("{}_{}".format(date,name), "zip", tempFiles)
            shutil.move(archive,packedFiles)

            # Remove temporary folder to allow copytree to create it again
            shutil.rmtree(tempFiles, onerror=remove_readonly)


    # Backup Arma 3 Server items
    print("\nBacking up Arma 3 Server items...")

    serversPath = os.path.join(ROOT,ARMA_SERVERS_PATH)
    if os.path.exists(serversPath):
        for serverDir in os.listdir(serversPath):
            serverPath = os.path.join(serversPath,serverDir)
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
            name = ARMA_SERVERS_PATH.replace(" ", "_").replace("\\", "_")
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


    # Upload to backup server
    if args.ftpserver and args.ftpuser and args.ftppassword:
        print("\nUploading to backup server...")

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

        # Remove oldest backup when there is more than 10
        ftp.cwd("..")
        folders = ftp.nlst()
        if len(folders) > BACKUPS_TO_KEEP + 3: # 3 = [".", "..", ".banner"]
            for folder in folders:
                if folder.startswith("2"):
                    print("- Removing old backup: {}".format(folder))
                    ftp.cwd(folder)
                    for file in ftp.nlst():
                        if file.startswith("2"):
                            ftp.delete(file)
                    ftp.cwd("..")
                    ftp.rmd(folder)
                if len(ftp.nlst()) <= BACKUPS_TO_KEEP + 3: # 3 = [".", "..", ".banner"]
                    break
    else:
        print("\nSkipping upload to backup server (no user and password)")


    # Remove temporary folder
    shutil.rmtree(TEMP, onerror=remove_readonly)


if __name__ == "__main__":
    sys.exit(main())
