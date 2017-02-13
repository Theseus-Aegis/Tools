#!/usr/bin/env python3

import os
import sys
import argparse
import MySQLdb
import ast
import json

#############################################
# Converts old Chronos MySQL                #
# inventory to new unitLoadout format       #
#                                           #
# Requires MySQLdb python package installed #
#############################################

######## GLOBALS #########
OUTPUT = "temp/chronosInventory.sql"
MAGAZINES_REF = "temp/magazinesMaxAmmo.txt" # Reference of [ [magazine, magazine, ...], [maxAmmo, maxAmmo, ...] ]

DB_ITEMS = "apollo"
TABLE_ITEMLIST = "item_list" # All items registered in Chronos
TABLE_EQUIPPED = "infantry" # Currently equipped inventory of all contractors (key: player_id (= Steam ID))

PLAYER_ID = 0
HEADGEAR = 4
FACEWAR = 5
UNIFORM = 6
UNIFORM_ITEMS = 7
VEST = 8
VEST_ITEMS = 9
BACKPACK = 10
BACKPACK_ITEMS = 11
ASSIGNED_ITEMS = 12
WEAPONS = 13
RIFLE_ATTACHMENTS = 14
LAUNCHER_ATTACHMENTS = 15
HANDGUN_ATTACHMENTS = 16
LOADED_MAGAZINES = 17

CLASSNAME = 1
CATEGORY = 3
SUBCATEGORY = 4
##########################

def findItemByCategory(itemList, items, category):
    for item in items:
        for row in itemList:
            if (row[CLASSNAME].lower() == item.lower() and row[CATEGORY].lower() == category.lower()):
                return item
    return ""

def findItemBySubCategory(itemList, items, subCategory):
    for item in items:
        for row in itemList:
            if (row[CLASSNAME].lower() == item.lower() and row[SUBCATEGORY].lower() == subCategory.lower()):
                return item
    return ""

def getMagazineMaxAmmo(magazinesRef, magazine):
    index = magazinesRef[0].index(magazine.lower())
    return magazinesRef[1][index]

def createWeapon(itemList, magazinesRef, weapons, attachments, magazines, category):
    weapons = weapons.split("|")
    attachments = attachments.split("|")
    magazines = magazines.split("|")

    weapon = findItemByCategory(itemList, weapons, category)

    if (weapon == ""):
        return []

    magazine = findItemBySubCategory(itemList, magazines, "Magazine")
    magazineGL = findItemBySubCategory(itemList, magazines, "Launchable")
    weaponData = [
        findItemByCategory(itemList, weapons, category),
        findItemBySubCategory(itemList, attachments, "Barrel-attachment"),
        findItemBySubCategory(itemList, attachments, "Side attachment"),
        findItemBySubCategory(itemList, attachments, "Optic"),
        [] if magazine == "" else [magazine, getMagazineMaxAmmo(magazinesRef, magazine)],
        [] if magazineGL == "" else [magazineGL, getMagazineMaxAmmo(magazinesRef, magazine)],
        findItemBySubCategory(itemList, attachments, "Bipod"),
    ]
    return weaponData

def createContainer(itemList, magazinesRef, container, containerItems):
    if (container == ""):
        return []

    containerItems = containerItems.replace("|", ",")[0:-1]
    containerItems = ast.literal_eval("[" + containerItems + "]")
    for index, item in enumerate(containerItems):
        if item[0].lower() in magazinesRef[0]:
            containerItems[index] = [item[0], item[1], getMagazineMaxAmmo(magazinesRef, item[0])]

    containerData = [
        container,
        containerItems
    ]
    return containerData

def createBinocular(itemList, assignedItems):
    binocular = findItemByCategory(itemList, assignedItems.split("|"), "Optic")
    if (binocular == ""):
        return []
    return [binocular, "", "", "", [], [], ""]

def createAssignedItems(itemList, assignedItems):
    assignedItems = assignedItems.split("|")
    assignedItems = [
        "itemmap" if "itemmap" in assignedItems else "",
        "itemgps" if "itemgps" in assignedItems else "",
        "",
        "itemwatch" if "itemwatch" in assignedItems else "",
        "itemcompass" if "itemcompass" in assignedItems else "",
        findItemByCategory(itemList, assignedItems, "Night vision")
    ]
    return assignedItems

def createLoadout(itemList, magazinesRef, row):
    loadout = [
        createWeapon(itemList, magazinesRef, row[WEAPONS], row[RIFLE_ATTACHMENTS], row[LOADED_MAGAZINES], "Rifle"),
        createWeapon(itemList, magazinesRef, row[WEAPONS], row[LAUNCHER_ATTACHMENTS], row[LOADED_MAGAZINES], "Pistol"),
        createWeapon(itemList, magazinesRef, row[WEAPONS], row[HANDGUN_ATTACHMENTS], row[LOADED_MAGAZINES], "Launcher"),
        createContainer(itemList, magazinesRef, row[UNIFORM], row[UNIFORM_ITEMS]),
        createContainer(itemList, magazinesRef, row[VEST], row[VEST_ITEMS]),
        createContainer(itemList, magazinesRef, row[BACKPACK], row[BACKPACK_ITEMS]),
        row[HEADGEAR],
        row[FACEWAR],
        createBinocular(itemList, row[ASSIGNED_ITEMS]),
        createAssignedItems(itemList, row[ASSIGNED_ITEMS])
    ]
    return loadout;


def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description="Convert old Chronos inventory to unitLoadout format")
    parser.add_argument("-dbh", "--databasehost", default=False, type=str, required=True, help="database host")
    parser.add_argument("-dbu", "--databaseuser", default=False, type=str, required=True, help="database user")
    parser.add_argument("-dbp", "--databasepassword", default=False, type=str, required=True, help="database password")
    args = parser.parse_args()

    itemList = []
    loadouts = []
    magazinesRef = []

    if os.path.isfile(MAGAZINES_REF):
        with open(MAGAZINES_REF, "r") as file:
            magazinesRef = json.loads(file.read())
            magazinesRef[0] = [magazine.lower() for magazine in magazinesRef[0]]

    db = MySQLdb.connect(host=args.databasehost, user=args.databaseuser, passwd=args.databasepassword, db=DB_ITEMS)
    dbCur = db.cursor()

    dbCur.execute("SELECT * FROM " + TABLE_ITEMLIST)
    for row in dbCur.fetchall():
        itemList.append(row)

    dbCur.execute("SELECT * FROM " + TABLE_EQUIPPED)
    for row in dbCur.fetchall():
        loadouts.append([row[PLAYER_ID], createLoadout(itemList, magazinesRef, row)]);

    db.close()

    with open(OUTPUT, "w", newline="\n") as file:
        file.write("INSERT INTO {}.{}\n    (playerID, loadout)\nVALUES\n".format(DB_ITEMS, TABLE_EQUIPPED))
        for loadout in loadouts:
            file.write("    ('{}', '{}')".format(loadout[0], json.dumps(loadout[1], separators=(',', ':'))))
            if (loadout != loadouts[-1]):
                file.write(",\n")
            else:
                file.write(";\n")


if __name__ == "__main__":
    sys.exit(main())
