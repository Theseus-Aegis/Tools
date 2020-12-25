#!/usr/bin/env python3

import argparse
import sys
import os
import csv
from collections import defaultdict

import numpy as np


def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description="Armory diff")
    parser.add_argument("old", type=str, help="old armory sheet (CSV)")
    parser.add_argument("new", type=str, help="new armory sheet (CSV)")
    parser.add_argument("locker", type=str, help="locker_data database table (CSV)")
    args = parser.parse_args()

    if not os.path.exists(args.old):
        parser.error(f"error! file '{args.old}' does not exist")
    if not os.path.exists(args.new):
        parser.error(f"error! file '{args.new}' does not exist")
    if not os.path.exists(args.locker):
        parser.error(f"error! file '{args.locker}' does not exist")

    old = []
    new = []
    with open(args.old) as f:
        csvread = csv.reader(f, delimiter=',')
        next(csvread, None)  # Header
        for row in csvread:
            if row[0]:
                old.append([row[0].lower(), row[1], int(row[5])])  # classname, name, price
    with open(args.new) as f:
        csvread = csv.reader(f, delimiter=',')
        next(csvread, None)  # Header
        for row in csvread:
            if row[0]:
                new.append([row[0].lower(), int(row[5])])  # classname, price

    locker = []
    with open(args.locker) as f:
        csvread = csv.reader(f, delimiter=',')
        next(csvread, None)  # Header
        for row in csvread:
            if row[1]:
                locker.append([int(row[0]), row[1].lower(), int(row[2])])  # uid, classname, count

    npnew = np.array(new)  # for column index

    rem = []
    remprice = 0
    for oldclass, name, price in old:
        if oldclass and oldclass not in npnew[:, 0]:
            rem.append([oldclass, name, price])
            remprice += price

    counts = defaultdict(lambda: [0, []])  # uid => [total, [item names]]

    totalclasses = []
    totalitems = []
    for remclass, name, price in rem:
        for uid, classname, count in locker:
            if remclass == classname and count != 0:
                counts[uid][0] += count * price
                counts[uid][1].append(name)
                totalclasses.append(f"loadout LIKE '%{remclass}%'")
                totalitems.append(remclass)

    # uid => [total, [items]]
    totalsum = 0
    for key, value in counts.items():
        print(f"{key} ({value[0]}$): Refund for removal of {', '.join(value[1])}.")
        totalsum += value[0]

    print(f"\nTotal refunds: {totalsum}$")

    totalclasses = "\n#OR ".join(set(totalclasses))
    print(f"\nItems to remove {len(set(totalitems))}:\n{totalclasses}\n{set(totalitems)}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
