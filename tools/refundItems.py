#!/usr/bin/env python3

import MySQLdb
import sys
import argparse

#############################################
# Refunds specified items in Chronos-Apollo #
#                                           #
# Requires MySQLdb python package installed #
#############################################

######## GLOBALS #########
DB_ITEMS = "apollo"
TABLE_ITEMLIST = "item_list" # All items registered in Chronos
TABLE_EQUIPPED = "infantry" # Currently equipped inventory of all contractors (key: player_id (= Steam ID))
TABLE_LOCKER = "locker_data" # Items in lockers of all contractors (key: user_id)
TABLE_BANKACCOUNTS = "bankaccounts" # Bank account data of all contractors (key: user_id)

DB_USERS = "drupal"
TABLE_IDS = "field_data_field_player_id" # References from user_id to player_id
##########################

def allInventoryToList(rows, items):
    inventory = []
    for row in rows:
        if row[4].lower() in items: # Headgear
            inventory.append([row[0], row[4].lower(), 1])
        if row[5].lower() in items: # Goggles
            inventory.append([row[0], row[5].lower(), 1])
        if row[6].lower() in items: # Uniform
            inventory.append([row[0], row[6].lower(), 1])
        #if [str(row[7]).replace("|", ",")]: # Uniform Items
        if row[15].lower() in items: # Secondary Weapon Attachments
            inventory.append([row[0], row[15].lower(), 1])

    return inventory

def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description="Process item type to parse")
    parser.add_argument("-dbh", "--databasehost", default=False, type=str, required=True, help="database host")
    parser.add_argument("-dbu", "--databaseuser", default=False, type=str, required=True, help="database user")
    parser.add_argument("-dbp", "--databasepassword", default=False, type=str, required=True, help="database password")
    parser.add_argument("-i", "--items", default=False, nargs="+", type=str, required=True, help="items")
    args = parser.parse_args()

    args.items = [item.lower() for item in args.items]

    itemMap = [] # [className, prettyName, price]
    ownershipData = [] # [user_id, item, quantity]

    dbApollo = MySQLdb.connect(host=args.databasehost, user=args.databaseuser, passwd=args.databasepassword, db=DB_ITEMS)
    apolloCur = dbApollo.cursor()

    apolloCur.execute("SELECT * FROM " + TABLE_ITEMLIST + " WHERE className IN (" + str(args.items)[1:-1] + ")")
    for row in apolloCur.fetchall():
        itemMap.append([row[1].lower(), row[2], row[6]])

    print("\nItem data:")
    print(itemMap)

    equippedData = [] # [player_id, item, quantity]
    apolloCur.execute("SELECT * FROM " + TABLE_EQUIPPED)
    equippedData = allInventoryToList(apolloCur.fetchall(), args.items)

    print("\nEquipped data:")
    print(equippedData)

    apolloCur.execute("SELECT * FROM " + TABLE_LOCKER + " WHERE className IN (" + str(args.items)[1:-1] + ") AND quantity > 0")
    for row in apolloCur.fetchall():
        ownershipData.append([row[0], row[1].lower(), row[2]])

    print("\nLocker data:")
    print(ownershipData)

    # Get user data
    userData = [] # [user_id, player_id]

    dbUsers = MySQLdb.connect(host=args.databasehost, user=args.databaseuser, passwd=args.databasepassword, db=DB_USERS)
    usersCur = dbUsers.cursor()

    for item in equippedData:
        usersCur.execute("SELECT * FROM " + TABLE_IDS + " WHERE field_player_id_value = " + str(item[0]))
        for row in usersCur.fetchall():
            ownershipData.append([row[3], item[1], item[2]])

    dbUsers.close()

    print("\nOwnership data:")
    print(ownershipData)

    # Add bank accounts
    for item in ownershipData:
        apolloCur.execute("SELECT * FROM " + TABLE_BANKACCOUNTS + " WHERE id = " + str(item[0]))
        for row in apolloCur.fetchall():
            item.append(row[2])
            itemMapIndex = [x[0] for x in itemMap].index(item[1])
            item.append(itemMap[itemMapIndex][1])
            item.append(itemMap[itemMapIndex][2] * item[2])

    print("\nOwnership data (bank accounts & pretty names & amount):")
    print(ownershipData)

    dbApollo.close()


    print("\nRefund data:")
    for item in ownershipData:
        # ID \n-BankNumber \n-Amount \n-Note
        print(str(item[0]) + "\n- " + item[3] + "\n- " + str(item[5]) + "\n- Refund for " + str(item[2]) + "x " + item[4])


if __name__ == "__main__":
    sys.exit(main())
