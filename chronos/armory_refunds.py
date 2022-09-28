#!/usr/bin/env python3

import argparse
import sys
import os
import csv
from collections import defaultdict
from dataclasses import dataclass, field

from mysql.connector import connect

#####################################################
# Refunds specified items in Chronos-Apollo         #
#                                                   #
# Requires mysql-connector-python package installed #
#####################################################

# ####### GLOBALS ######## #
DB_NAME = "apollo_test"  # Change to run live
TABLE_ITEMLIST = "item_list"  # All items registered in Chronos
TABLE_EQUIPPED = "infantry"  # Currently equipped inventory of all contractors (key: player_id (= Steam ID))
TABLE_LOCKER = "locker_data"  # Items in lockers of all contractors (key: user_id)
TABLE_BANKACCOUNTS = "bankaccounts"  # Bank account data of all contractors (key: user_id)
TABLE_TRANSACTIONS = "transactions"  # Transaction logs of all contractors (key: transaction_id)

DB_USERS = "drupal"
TABLE_IDS = "field_data_field_player_id"  # References from user_id to player_id

REFUND_PREFIX = "Funds transferred to your account from Theseus Finance Department at 4542 1111111111 with the following note:"
# ######################## #


@dataclass
class Item:
    classname: str = ""
    prettyname: str = ""
    price: int = 0


@dataclass
class Refund:
    uid: int = 0
    total: int = 0  # refund value
    items: list = field(default_factory=list)
    note: list = field(default_factory=list)
    balance: int = 0  # new bank account balance
    inventory: str = ""  # new inventory


def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description="Armory Refunds")
    parser.add_argument("old", type=str, help="old armory sheet (CSV)")
    parser.add_argument("-dbh", "--databasehost", default="localhost", type=str, help="database host")
    parser.add_argument("-dbu", "--databaseuser", default=False, type=str, required=True, help="database user")
    parser.add_argument("-dbp", "--databasepassword", default=False, type=str, required=True, help="database password")
    parser.add_argument("-x", "--execute", default=False, action="store_true", help="execute (default: dry run)")
    args = parser.parse_args()

    if not os.path.exists(args.old):
        parser.error(f"error! file '{args.old}' does not exist")

    players = dict()  # playerid => uid
    old_item_list = dict()  # classname => Item
    item_list = dict()  # classname => Item
    refunds = defaultdict(Refund)  # uid => Refund
    inventory_unremovable = defaultdict(list)  # classname => [playerids]

    # assemble old items and save their data (prices)
    with open(args.old) as f:
        csvread = csv.reader(f, delimiter=',')
        next(csvread, None)  # Header
        for row in csvread:
            if row[0]:
                old_item_list[row[0].lower()] = Item(row[0].lower(), row[1], int(row[5]))  # classname, name, price

    # get playerid to uid mapping
    with connect(host=args.databasehost, database=DB_USERS, user=args.databaseuser, password=args.databasepassword) as conn:
        cursor = conn.cursor()

        cursor.execute(f"SELECT entity_id, field_player_id_value FROM {TABLE_IDS}")
        for (uid, playerid) in cursor:
            players[playerid] = uid

    # find removed items and assemble all data
    with connect(host=args.databasehost, database=DB_NAME, user=args.databaseuser, password=args.databasepassword) as conn:
        cursor = conn.cursor()

        cursor.execute(f"SELECT className, prettyName, price FROM {TABLE_ITEMLIST}")
        for (classname, prettyname, price) in cursor:
            classname = classname.lower()
            item_list[classname] = Item(classname, prettyname, int(price))

        # locker
        cursor.execute(f"SELECT uid, className, quantity FROM {TABLE_LOCKER}")
        for (uid, classname, quantity) in cursor:
            classname = classname.lower()
            if classname not in item_list and quantity > 0:
                refunds[uid].uid = uid
                if classname in old_item_list:
                    refunds[uid].total += quantity * old_item_list[classname].price
                    refunds[uid].items.append(old_item_list[classname])
                    refunds[uid].note.append(f"{quantity}x {old_item_list[classname].prettyname}")
                else:
                    refunds[uid].items.append(Item(classname, "", 0))
                    print(f"warning: '{classname}' owned by {uid} not found in old item list - it will be removed without refund")
                    input("    confirm?")

        # inventory
        cursor.execute(f"SELECT playerID, loadout FROM {TABLE_EQUIPPED}")
        for (playerid, loadout) in cursor:
            uid = players[playerid]
            for old_item in old_item_list.values():
                loadout = loadout.lower().replace(" ", "")  # remove any spacing
                if old_item.classname not in item_list.keys() and old_item.classname in loadout:
                    item_index_offset = -1
                    item_index = - 1  # index of classname start (without quote)
                    quantity = 0
                    while (item_index := loadout.find(old_item.classname, item_index + 1)) != -1:
                        quantity_index = loadout.find(",", item_index) + 1  # index of quantity start
                        if quantity_index - item_index - 2 > len(old_item.classname):
                            print(f"warning: unable to remove '{old_item.classname}' from {uid} ({playerid}) - item will be refunded, but not removed!")
                            input("    confirm?")
                            inventory_unremovable[old_item.classname].append(playerid)
                            item_index_offset = item_index
                        else:
                            item_index_end = quantity_index - 2  # index of classname end (without quotes)
                            quantity_index_end = loadout.find("]", quantity_index)  # index of quantity end

                            quantity += int(loadout[quantity_index:quantity_index_end])
                            loadout = loadout[:item_index] + loadout[item_index_end:]
                            item_index = item_index_offset

                    refunds[uid].uid = uid
                    refunds[uid].total += quantity * old_item.price
                    refunds[uid].items.append(old_item)
                    refunds[uid].note.append(f"{quantity}x {old_item.prettyname}")
                    refunds[uid].inventory = loadout

        # process new balances
        cursor.execute(f"SELECT id, balance FROM {TABLE_BANKACCOUNTS}")
        for (uid, balance) in cursor:
            if uid in refunds:
                refunds[uid].balance = balance + refunds[uid].total

    # notes and total
    print()
    totalsum = 0
    for refund in refunds.values():
        if refund.total > 0:
            print(f"{refund.uid} ({refund.total}$): Refund for removal of {', '.join(refund.note)}.")
            totalsum += refund.total

    print(f"\nTotal refunds: {totalsum}$\n")

    # remove locker items
    with connect(host=args.databasehost, database=DB_NAME, user=args.databaseuser, password=args.databasepassword) as conn:
        cursor = conn.cursor()

        query = f"FROM {TABLE_LOCKER} WHERE"
        for refund in refunds.values():
            for item in refund.items:
                query += f" (uid={refund.uid} AND className='{item.classname}') OR"
        query = query[:-3]

        if args.execute:
            cursor.execute(f"DELETE {query}")
            conn.commit()
        else:
            print(query)

    # remove inventory items
    print()
    with connect(host=args.databasehost, database=DB_NAME, user=args.databaseuser, password=args.databasepassword) as conn:
        cursor = conn.cursor()

        query = ""
        for refund in refunds.values():
            if refund.inventory:
                query += f"UPDATE {TABLE_EQUIPPED} SET loadout = {refund.inventory} WHERE uid={refund.uid};\n"

        if args.execute:
            cursor.execute(query)
            conn.commit()
        else:
            print(query)

    # refund
    with connect(host=args.databasehost, database=DB_NAME, user=args.databaseuser, password=args.databasepassword) as conn:
        cursor = conn.cursor()

        query = ""
        for refund in refunds.values():
            if refund.total > 0:
                query += f"UPDATE {TABLE_BANKACCOUNTS} SET balance = {refund.balance} WHERE uid={refund.uid};\n"
                query += f"INSERT INTO {TABLE_TRANSACTIONS} (transactionInitiator, transactionReceiver, type, description, cost, balance, category)\n"
                refund_note = ", ".join(refund.note)
                query += f"    VALUES (0, {refund.uid}, 'Money Transfer', '{REFUND_PREFIX} {refund_note}', {refund.total}, {refund.balance}, 'Transfer');\n"

        if args.execute:
            cursor.execute(query)
            conn.commit()
        else:
            print(query)

    # final notes
    if len(inventory_unremovable) > 0:
        print("Remaining manual work!")

        for classname, playerids in inventory_unremovable.items():
            print(f"'{classname}' must be manually removed from inventories:")
            for playerid in playerids:
                print(f"    {playerid}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
