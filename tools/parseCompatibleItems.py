#!/usr/bin/env python3

import os
import sys
import argparse

############################
# Parses Arma 3 output of  #
# weapons with compatible  #
# items to SQL script      #
#                          #
# Requires every weapon to #
# have at least one item   #
############################

######## GLOBALS #########
INPUT = "temp\\compatibleItems.txt" # Usually too many data to fill into clipboard
OUTPUT = "temp\\compatibleItems.sql"
SQL_DBNAME = "apollo"
SQL_TABLENAME_0 = "ammotypes"
SQL_TABLENAME_1 = "attachmenttypes"
SQL_COLNAME_0 = "ammoClass"
SQL_COLNAME_1 = "attachmentClass"
##########################

def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description="Process item type to parse")
    parser.add_argument("-t", "--type", default="0", type=int, choices=[0, 1], required=True, help="item type (0 - magazines, 1 - attachments)")
    args = parser.parse_args()

    # Use type argument to form wanted globals
    itemTypeInt = args.type
    sql_tablename = eval("SQL_TABLENAME_{}".format(itemTypeInt))
    sql_colname = eval("SQL_COLNAME_{}".format(itemTypeInt))
    itemType = "Magazines"
    if itemTypeInt == 1:
        itemType = "Attachments"

    # Check for input file
    if not os.path.isfile(INPUT):
        print("Input file missing!\n\nYou must first run '[TYPE] execVM 'retrieveCompatibleItems.sqf'' in Arma 3, then paste the clipboard to file {}.".format(INPUT))
        sys.exit(0)

    # Check for temp folder and create if it doesn't exist yet
    if not os.path.exists("temp"):
        os.makedirs("temp")

    # Prepare output file (clean and add SQL statements)
    with open(OUTPUT, "w") as file:
        print("Preparing output file ...\n")
        file.write("TRUNCATE TABLE {}.{};\n\nINSERT INTO {}.{}\n    (weaponClass, {})\nVALUES\n".format(SQL_DBNAME, sql_tablename, SQL_DBNAME, sql_tablename, sql_colname))

    with open(INPUT, "r") as file:
        content = file.read()
        # Replace characters and form a list
        data = content.replace(" ", "")[1:-2].replace('"', "").replace("],", "]],").split("],")

        # Initialize counters
        countWeapons = 0
        countItems = 0
        countDuplicates = 0

        print("Adding SQL insert statements ...")
        with open(OUTPUT, "a") as file:
            # Loop through all data
            for subdata in data:
                # Replace characters and form a list
                subdata = subdata.replace("[", "").replace("]", "").split(",")

                # Select items, write and print
                weapon = subdata[0]
                items = subdata[1:] # Everything from including first element to end (of this subdata)

                # Track items added for duplicate removal (SQL)
                itemsAdded = []

                # Loop through items
                for item in items:
                    # Check if lower-cased item was not already added
                    if not item.lower() in itemsAdded:
                        itemsAdded.append(item.lower()) # Add lower-cased item to list of already added
                        file.write("    ('{}', '{}'),\n".format(weapon, item)) # Write to file
                        countItems += 1
                    else:
                        countDuplicates += 1

                countWeapons += 1

    print("- {} Weapons Added".format(countWeapons))
    print("- {} {} Added".format(countItems, itemType))
    print("- {} Duplicates Removed".format(countDuplicates))

    # Finalize output file (remove last comma and write semi-colon in its place)
    with open(OUTPUT, "rb+") as file:
        print("\nFinalizing output file ...\n")
        file.seek(-3, os.SEEK_END)
        file.truncate()
        file.write(";".encode()) # Encode to form a byte-object, because file is open in binary format

    print("SQL script written to {}, run it in your preferred MySQL workspace.".format(OUTPUT))


if __name__ == "__main__":
    sys.exit(main())
