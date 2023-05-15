#!/usr/bin/env python3

import argparse
import ast
import sys
import os
import csv
from collections import defaultdict
from dataclasses import dataclass, field, fields, astuple
from datetime import datetime, timezone

from mysql.connector import connect

#####################################################
# Refunds specified items in Chronos-Apollo         #
#                                                   #
# Requires mysql-connector-python package installed #
# and a user with following table privileges        #
#   [Delete, Insert, Select, Update]                #
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
    loadout: str = ""  # new loadout


@dataclass
class LoadoutItem:
    classname: str = ""
    quantity: int = 0
    bullet_count: int = None
    is_backpack: bool = None

    def __init__(self, *args, muzzle=False):
        if len(args) > 0:
            self.classname = args[0]

            if type(args[1]) is bool:
                self.is_backpack = args[1]
                self.quantity = 1
            elif len(args) > 1:
                if muzzle:
                    self.quantity = None
                    self.bullet_count = args[1]
                else:
                    self.quantity = args[1]

                if len(args) > 2:
                    self.bullet_count = args[2]

    def find_and_remove(self, classname):
        if classname == self.classname:
            quantity = self.quantity if self.quantity else 1
            self.classname = ""
            self.quantity = 0
            self.bullet_count = None
            return quantity, True

        return 0, False


@dataclass
class LoadoutWeapon:
    classname: str = ""
    suppressor: str = ""
    pointer: str = ""
    optics: str = ""
    muzzle1: list = field(default_factory=list)
    muzzle2: list = field(default_factory=list)
    bipod: str = ""

    def __post_init__(self):
        self.muzzle1 = LoadoutItem(*self.muzzle1, muzzle=True)
        self.muzzle2 = LoadoutItem(*self.muzzle2, muzzle=True)

    def find_and_remove(self, classname):
        if classname == self.classname:
            self.classname += "<FOUND>"
            return 1, False

        for muzzle in [self.muzzle1, self.muzzle2]:
            found = muzzle.find_and_remove(classname)
            if found[0] > 0:
                return found

        return 0, False


@dataclass
class LoadoutContainer:
    classname: str = ""
    contents: list = field(default_factory=list)

    def __post_init__(self):
        loadout_contents = []
        for content in self.contents:
            if content:
                if type(content[0]) is str:
                    loadout_contents.append(LoadoutItem(*content))
                else:
                    for _ in range(content[1]):
                        loadout_contents.append(LoadoutWeapon(*content[0]))

        self.contents = loadout_contents

    def find_and_remove(self, classname):
        if classname == self.classname:
            self.classname += "<FOUND>"
            return 1, False

        for content in self.contents:
            found = content.find_and_remove(classname)
            if found[0] > 0:
                return found

        return 0, False


@dataclass
class LoadoutAssignedItem:
    item_map: str = ""
    item_gps: str = ""
    item_radio: str = ""
    item_compass: str = ""
    item_watch: str = ""
    item_nvg: str = ""

    def find_and_remove(self, classname):
        for f in fields(self):
            if classname == getattr(self, f.name):
                setattr(self, f.name, "")
                return 1, True
        return 0, False


@dataclass
class Loadout:
    primary: LoadoutWeapon
    secondary: LoadoutWeapon
    handgun: LoadoutWeapon
    uniform: LoadoutContainer
    vest: LoadoutContainer
    backpack: LoadoutContainer
    headgear: str
    facewear: str
    binoculars: LoadoutWeapon
    assigned: LoadoutAssignedItem

    def __init__(self, *args):
        self.primary = LoadoutWeapon(*args[0])
        self.secondary = LoadoutWeapon(*args[1])
        self.handgun = LoadoutWeapon(*args[2])
        self.uniform = LoadoutContainer(*args[3])
        self.vest = LoadoutContainer(*args[4])
        self.backpack = LoadoutContainer(*args[5])
        self.headgear = args[6]
        self.facewear = args[7]
        self.binoculars = LoadoutWeapon(*args[8])
        self.assigned = LoadoutAssignedItem(*args[9])

    # return: (quantity, removed)
    def find_and_remove(self, classname):
        for f in fields(self):
            fref = getattr(self, f.name)
            ffind_and_remove = getattr(fref, "find_and_remove", None)
            if f.type == str:
                if classname == fref:
                    setattr(self, f.name, "")
                    return 1, True
            else:
                found = ffind_and_remove(classname)
                if found[0] > 0:
                    return found

        return 0, False


def listit(t):
    return list(map(listit, t)) if isinstance(t, (list, tuple)) else t


def loadout_from_arma(loadout_str):
    if not loadout_str:
        loadout_str = '[[],[],[],[],[],[],"","",[],["","","","","",""]]'
    loadout = loadout_str.replace("true", "True").replace("false", "False")
    loadout = ast.literal_eval(loadout)
    loadout = Loadout(*loadout)
    return loadout


def loadout_to_arma(loadout):
    loadout_list = listit(astuple(loadout))
    loadout_str = str(loadout_list).replace(" ", "").replace("'", "\"").replace(",None", "").replace("<FOUND>", "")
    loadout_str = loadout_str.replace("[\"\",0]", "[]").replace("[\"\",[]]", "[]").replace("[[]]", "[]")  # empty items and containers
    loadout_str = loadout_str.replace("[\"\",\"\",\"\",\"\",[],[],\"\"]", "[]")  # empty weapons
    return loadout_str


def test():
    loadout_str = '[[],[],[],[],[],["B_Bergen_dgtl_F",[["B_AssaultPack_blk",true],["RegItem",5],["Mag",5,30]]],"","",[],["ItemMap","","ItemRadioAcreFlagged","ItemCompass","ItemWatch",""]]'
    # loadout_str = '[["arifle_ARX_blk_F","","","optic_Hamr",["30Rnd_65x39_caseless_green_mag_Tracer",20],["10Rnd_50BW_Mag_F",6],""],[],[],["tacs_Uniform_Plaid_JP_LP_BP_BB",[["ACE_fieldDressing",6],["tac_medical_painkillers",2],["ACE_tourniquet",2],["ACRE_PRC152",1]]],["CUP_Vest_RUS_6B45_Sh117",[["ACRE_PRC152",1],["ACE_bodyBag",1],["ACE_bloodIV",2],["ACE_bloodIV_250",3],["30Rnd_65x39_caseless_green",1,1],["30Rnd_65x39_caseless_green_mag_Tracer",1,4],["30Rnd_65x39_caseless_green",1,2],["30Rnd_65x39_caseless_green",1,9],["30Rnd_65x39_caseless_green",1,12],["30Rnd_65x39_caseless_green_mag_Tracer",1,10],["30Rnd_65x39_caseless_green_mag_Tracer",2,8]]],["B_Messenger_Black_F",[["ACE_EntrenchingTool",1],["ACE_bloodIV_500",1],["ACE_surgicalKit",1],["ACE_splint",1],["ACE_elasticBandage",5],["10Rnd_50BW_Mag_F",1,5],["30Rnd_65x39_caseless_green_mag_Tracer",1,9],["30Rnd_65x39_caseless_green_mag_Tracer",1,5],["30Rnd_65x39_caseless_green_mag_Tracer",1,10]]],"CUP_H_RUS_6B47_v2_Summer","",[],["ItemMap","","","ItemCompass","ItemWatch",""]]'
    # loadout_str = '[["arifle_ARX_blk_F","","","optic_Hamr",[],["10Rnd_50BW_Mag_F",6],""],[],[],["tacs_Uniform_Plaid_JP_LP_BP_BB",[["ACE_fieldDressing",6],["tac_medical_painkillers",2],["ACE_tourniquet",2],["ACRE_PRC152",1]]],["CUP_Vest_RUS_6B45_Sh117",[["ACRE_PRC152",1],["ACE_bodyBag",1],["ACE_bloodIV",2],["ACE_bloodIV_250",3],["30Rnd_65x39_caseless_green",1,1],["30Rnd_65x39_caseless_green_mag_Tracer",1,4],["30Rnd_65x39_caseless_green",1,2],["30Rnd_65x39_caseless_green",1,9],["30Rnd_65x39_caseless_green",1,12],["30Rnd_65x39_caseless_green_mag_Tracer",1,10],["30Rnd_65x39_caseless_green_mag_Tracer",2,8]]],["B_Messenger_Black_F",[["ACE_EntrenchingTool",1],["ACE_bloodIV_500",1],["ACE_surgicalKit",1],["ACE_splint",1],["ACE_elasticBandage",5],["10Rnd_50BW_Mag_F",1,5],["30Rnd_65x39_caseless_green_mag_Tracer",1,9],["30Rnd_65x39_caseless_green_mag_Tracer",1,5],["30Rnd_65x39_caseless_green_mag_Tracer",1,10]]],"CUP_H_RUS_6B47_v2_Summer","",[],["ItemMap","","","ItemCompass","ItemWatch",""]]'
    # loadout_str = '[[],[],[],[],[],["B_Bergen_dgtl_F",[[["CUP_sgun_AA12","","","",["CUP_20Rnd_B_AA12_HE",20],[],""],1],["B_AssaultPack_blk",true]]],"","",[],["ItemMap","","ItemRadioAcreFlagged","ItemCompass","ItemWatch",""]]'

    loadout = loadout_from_arma(loadout_str)
    # print(loadout)
    # print()
    # print(loadout.backpack)
    # print()

    search = "30Rnd_65x39_caseless_green_mag_Tracer"
    # search = "arifle_ARX_blk_F"
    # search = "ACE_elasticBandage"
    # search = "CUP_20Rnd_B_AA12_HE"
    while (found := loadout.find_and_remove(search))[0] > 0:
        print("found", found)
    print("\nloadout", loadout)

    parsed = loadout_to_arma(loadout)
    print("\nparsed", parsed)

    return 0


def main():
    # test()

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

    players = dict()  # playerid => uid and uid => playerid
    old_item_list = dict()  # classname => Item
    item_list = dict()  # classname => Item
    refunds = defaultdict(Refund)  # uid => Refund
    loadout_unremovable = defaultdict(list)  # classname => [playerids]

    # assemble old items and save their data (prices)
    with open(args.old) as f:
        csvread = csv.reader(f, delimiter=',')
        next(csvread, None)  # Header
        for row in csvread:
            if row[0]:
                # Spreadsheet export (no IDs)
                old_item_list[row[0].lower()] = Item(row[0].lower(), row[1], int(row[5]))  # classname, name, price
                # Database export (with IDs)
                # old_item_list[row[1].lower()] = Item(row[1].lower(), row[2], int(row[6]))  # classname, name, price

    # get playerid to uid mapping
    with connect(host=args.databasehost, database=DB_USERS, user=args.databaseuser, password=args.databasepassword) as conn:
        cursor = conn.cursor()

        cursor.execute(f"SELECT entity_id, field_player_id_value FROM {TABLE_IDS}")
        for (uid, playerid) in cursor:
            players[playerid] = uid
            players[uid] = playerid

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
                    input("  confirm? (ctrl+c to cancel)")

        # loadout
        cursor.execute(f"SELECT playerID, loadout FROM {TABLE_EQUIPPED}")
        for (playerid, loadout_orig) in cursor:
            if playerid not in players:
                print(f"warning: {playerid} mapping not found (removed user?) - item will not be removed!")
                input("  confirm? (ctrl+c to cancel)")
                continue

            uid = players[playerid]
            refunds[uid].uid = uid

            loadout_orig = loadout_orig.lower()
            loadout = loadout_from_arma(loadout_orig)

            for old_item in old_item_list.values():
                if old_item.classname not in item_list.keys():
                    while (fnr := loadout.find_and_remove(old_item.classname))[0] > 0:
                        quantity, removed = fnr
                        if not removed:
                            print(f"warning: unable to remove '{old_item.classname}' from {uid} ({playerid}) - item will be refunded, but not removed!")
                            found_index = loadout_orig.find(old_item.classname)
                            print(f"    {loadout_orig[max(0, found_index - 15):found_index + len(old_item.classname) + 100]}")
                            input("  confirm? (ctrl+c to cancel)")
                            loadout_unremovable[old_item.classname].append(playerid)

                        refunds[uid].total += quantity * old_item.price
                        refunds[uid].note.append(f"{quantity}x {old_item.prettyname}")

            loadout = loadout_to_arma(loadout)
            if loadout != loadout_orig:
                print(f"\n{loadout_orig}\nto\n{loadout}\n")
                refunds[uid].loadout = loadout

        # process new balances
        cursor.execute(f"SELECT id, balance FROM {TABLE_BANKACCOUNTS}")
        for (uid, balance) in cursor:
            if uid in refunds:
                refunds[uid].balance = balance + refunds[uid].total

    # notes and total
    print("\n--- TOTALS ---\n")
    totalsum = 0
    for refund in refunds.values():
        if refund.total > 0:
            print(f"{refund.uid} ({refund.total}$): Refund for removal of {', '.join(refund.note)}.")
            totalsum += refund.total

    print(f"\nTotal refunds: {totalsum}$")

    print("\n--- QUERIES ---\n")
    with connect(host=args.databasehost, database=DB_NAME, user=args.databaseuser, password=args.databasepassword) as conn:
        cursor = conn.cursor()
        conn.autocommit = True

        # remove locker items
        query = ""
        for refund in refunds.values():
            for item in refund.items:
                query += f" (uid={refund.uid} AND className='{item.classname}') OR"
        query = query[:-3]

        print(f"DELETE FROM {TABLE_LOCKER} WHERE {query};\n")
        if args.execute and query:  # check query! empty query will delete whole table!
            cursor.execute(f"DELETE FROM {TABLE_LOCKER} WHERE {query};")

        # remove loadout items
        for refund in refunds.values():
            if refund.loadout:
                query = f"UPDATE {TABLE_EQUIPPED} SET loadout = '{refund.loadout}' WHERE playerid={players[refund.uid]};"

                print(query)
                if args.execute:
                    cursor.execute(query)

        # refund
        print()
        for refund in refunds.values():
            if refund.total > 0:
                query = f"UPDATE {TABLE_BANKACCOUNTS} SET balance = {refund.balance} WHERE id={refund.uid};"

                print(query)
                if args.execute:
                    cursor.execute(query)

                refund_note = ", ".join(refund.note)
                date = datetime.now(timezone.utc)
                query = f"INSERT INTO {TABLE_TRANSACTIONS} (transactionInitiator, transactionReceiver, type, description, date, cost, balance, category)\n"
                query += f"  VALUES ({refund.uid}, 0, 'Money Transfer', '{REFUND_PREFIX} {refund_note}', '{date}', {refund.total}, {refund.balance}, 'Transfer');"

                print(query)
                if args.execute:
                    cursor.execute(query)

    # final notes
    if len(loadout_unremovable) > 0:
        print("\n--- NOTES ---\n")
        print("remaining manual work!")

        for classname, playerids in loadout_unremovable.items():
            print(f"'{classname}' must be manually removed from inventories:")
            for playerid in playerids:
                print(f"    {playerid}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
