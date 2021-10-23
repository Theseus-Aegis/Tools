import glob, datetime

rptDir = "C:/Theseus/Arma 3/Servers/Contracts/profiles/"
keyword = "Player Traits: "
outputFile = "C:/Theseus/Tools/loggedTraits.log" # Requires full path

# Get latest .rpt
rptFiles = glob.glob(f"{rptDir}*.rpt")
rptFiles.sort(reverse=True)

# Get list of keyword matches
results = []
with open(rptFiles[0], "r") as rpt_obj:
    for l in rpt_obj:
        if keyword in l:
            results.append(l.rstrip())

# Exit if no results
if results == []:
    exit()

# Write to output file with timestamp
output = open(outputFile, "a")
for result in results:
    result = result.split(keyword, 1)[1]
    output.write(f"{datetime.date.today()} {result}" + "\n")
output.close()
