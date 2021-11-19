import datetime
import glob

RPT_DIR = "C:/Theseus/Arma 3/Servers/Contracts/profiles/"
KEYWORD = "Player Traits: "

# Get latest .rpt
rptFiles = glob.glob(f"{RPT_DIR}*.rpt")
rptFiles.sort(reverse=True)

# Get list of keyword matches
results = []
with open(rptFiles[0], "r") as rpt_obj:
    for line in rpt_obj:
        if KEYWORD in line:
            results.append(line.rstrip())

if results:
    # Write to output file with timestamp
    with open("loggedTraits.log", "a") as logfile:
        for result in results:
            result = result.split(KEYWORD, 1)[1]
            logfile.write(f"{datetime.date.today()} {result}\n")
