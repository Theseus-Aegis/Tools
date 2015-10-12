#!/usr/bin/env python3

import os
import sys

###############################
# Parses Arma 3 output of     #
# weapons with compatible     #
# magazines to SQL statements #
###############################

######## GLOBALS #########
INPUT = "temp\\compatibleMagazines_INPUT.txt"
OUTPUT = "temp\\compatibleMagazines_OUPUT.txt"
SQL_DBTABLE = "apollo.ammotypes"
##########################

def writeToFile(weapon, magazines):
    # Write SQL statements to output file
    with open(OUTPUT, "a") as file:
        for magazine in magazines:
            file.write("INSERT INTO {} (weaponClass, ammoClass) VALUES ('{}', '{}');\n".format(SQL_DBTABLE, weapon, magazine))

def main():
    # Check for input file
    if not os.path.isfile(INPUT):
        print("Input file missing!\n\nYou must first run compatibleMagazinesRetrieve.sqf in Arma 3, then paste the clipboard to file {}.".format(INPUT))
        sys.exit(0)

    # Prepare output file (clean and add SQL truncate statement)
    if not os.path.exists("temp"):
        os.makedirs("temp")

    with open(OUTPUT, "w") as file:
        print("Preparing output file ...\n")
        file.write("TRUNCATE TABLE {};\n\n".format(SQL_DBTABLE))

    # Read input file
    with open(INPUT, "r") as file:
        feed = file.read()
        # Replace characters and form a list
        content = feed.replace(" ", "")[1:-2].replace('"', "").replace("],", "]],").split("],")

        # Counters
        countWeapons = 0
        countMagazines = 0

        print("Adding SQL insert statements ...")
        for item in content:
            # Replace characters and forms a list
            item = item.replace("[", "").replace("]", "").split(",")

            # Select items, write and print
            weapon = item[0]
            magazines = item[1:]
            writeToFile(weapon, magazines)

            # Increase counters
            countWeapons += 1
            countMagazines += len(magazines)

    print("- {} Weapons Added".format(countWeapons))
    print("- {} Magazines Added".format(countMagazines))

    print("\nSQL script written to file {}, paste the contents into MySQL Workbench and run it.".format(OUTPUT))


if __name__ == "__main__":
    sys.exit(main())
