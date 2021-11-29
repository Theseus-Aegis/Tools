import os
import requests

from getpass import getpass
from mysql.connector import connect, Error


CHRONOS_LOCATION = "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/"
CHRONOS_NAME = "chronos.csv"
SCRIPT_PATH = "C:\\Theseus\\Tools\\dbscripts\\armory_fast_import_min.sql"
DB_NAME = "apollo_test"

#GOOGLE_DOCS_URL = "https://docs.google.com/spreadsheets/d/1ZGwujcqU2tdi1Y7l-sqeiB78O1mwAnGyAqWgeAVvQAk/gviz/tq?tqx=out:csv&sheet=item_list" # Theseus sheet
GOOGLE_DOCS_URL = "https://docs.google.com/spreadsheets/d/1DJUc0hzYLLtpapYyJCLmwlzRp-SuPspFccf5WMJ5vPA/gviz/tq?tqx=out:csv&sheet=item_list"  # Ian's testing sheet

if __name__ == "__main__":

    print("Downloading from google docs...")
    res = requests.get(GOOGLE_DOCS_URL)
    assert res.status_code == 200, 'Wrong status code'

    print("Saving file...")
    with open(f"raw_{CHRONOS_NAME}", "wb") as fp:
        fp.write(res.content)

    with open(f"raw_{CHRONOS_NAME}") as fp:
        lines = fp.readlines()

    linesDown = len(lines)-1
    print(f"\tGOT {linesDown} ITEMS")
    lines.append("\r\n")

    # Check if file exists (it has to because windows and it's permissions....)
    if not os.path.isfile(f"{CHRONOS_LOCATION}{CHRONOS_NAME}"):
        print(f"ERROR: file {CHRONOS_LOCATION}{CHRONOS_NAME} could not be found, please create it.")
        input("Press any key to continiue...")
        exit(1)

    #Writing to Uploads/chronos.csv file...
    with open(f"{CHRONOS_LOCATION}{CHRONOS_NAME}", "w") as fp:
        fp.writelines(lines)

    print("Connecting to DB...")
    try:
        with connect(
            host="localhost",
            database=f"{DB_NAME}",
            allow_local_infile=True,
            user=input("\tEnter username: "),
            password=getpass("\tEnter password: "),
        ) as connection:
            print(connection)
            cursor = connection.cursor()
            with open(SCRIPT_PATH) as fp:
                sqlLines = fp.readlines()
            for line in sqlLines:
                cursor.execute(line)
            linesAffected = cursor.rowcount
            print(f"\tAFFECTED {linesAffected} LINES")

            if linesAffected != linesDown:
                print("MISMATCH IN NUMBER OF DONWLOADED AND NUMBER OF AFFECTED LINES !")
                print("\tCONFIRM COMMIT ? Y/[N]")

                if input() not in ["y", "Y"]:
                    print("Exiting...")
                    input("Press any key to continiue...")
                    exit(1)

            print(f"Saving to DB {DB_NAME}...")
            connection.commit()

    except Error as e:
        print(e)

    input("DONE, press any key to continue...")
