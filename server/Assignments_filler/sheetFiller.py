import os
import logging
import sys
import time

import DB_call
from DB_call import get_from_db
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials

# If modifying these scopes, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/spreadsheets']

# The ID and range of a sample spreadsheet.
SPREADSHEET_ID = '1W-C0ozCqXaphvQe1Cz1IFPYwvgO_MXpn1BLKcdI-n6o'
TEAM_ASSINGMENT_TAB = 'Team Assignments!'
RANGE_READ = 'F33'
refreshRate = 10

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s]: %(message)s",
                    handlers=[logging.FileHandler("filler.log"), logging.StreamHandler()])

def readSheet(service, range, amount=1):
    sheet = service.spreadsheets()
    result = sheet.values().get(spreadsheetId=SPREADSHEET_ID,
                                range=range).execute()
    values = result.get('values', [])
    if not values:
        result=''
    elif amount == 1:
        result = values[0][0]
    elif amount == 2:
        result = values
    else:
        result = values[0]
    return result

def writeSheet(service, data, range, amount):
    if amount == 1:
        values = [[data]]
    if amount == 3:
        values = [[data[0], data[1], data[2]]]
    body = {
        'values': values
    }
    result = service.spreadsheets().values().update(
        spreadsheetId=SPREADSHEET_ID, range=range,
        valueInputOption='USER_ENTERED', body=body).execute()
        
def paintSheet(service, color):
    if color == "red":
        redLevel = 0.9
    elif color == "black":
        redLevel = 0
    body = {"requests": [{
        "updateBorders": {
            "range": { #which cell will get formatted
                "sheetId": 871598544, #the right tab
                "startRowIndex": 32,
                "endRowIndex": 33,
                "startColumnIndex": 5,
                "endColumnIndex": 6
            },
            "top": {
                "style": "SOLID",
                "width": 1,
                "color": {"red": redLevel},
            },
            "bottom": {
                "style": "SOLID_THICK",
                "width": 1,
                "color": {"red": redLevel},
            },
            "left": {
                "style": "SOLID_THICK",
                "width": 1,
                "color": {"red": redLevel},
            },
            "right": {
                "style": "SOLID_THICK",
                "width": 1,
                "color": {"red": redLevel},
            },
        }
    }]}
    result = service.spreadsheets().batchUpdate(spreadsheetId=SPREADSHEET_ID, body=body).execute()

def checker(service):
    isRed = False
    readRange = TEAM_ASSINGMENT_TAB+RANGE_READ
    writtenName = readSheet(service, readRange)
    query = (f"SELECT `nid`,`title` FROM drupal.node where title like \"%{writtenName}%\" ORDER BY nid DESC")
    contractList = get_from_db(query)
    queryLength = len(contractList)
    if queryLength == 0:
        oldNID = 0
        oldContractName = "empty name"
    elif queryLength > 1:
        for sublist in contractList:
            exactName = sublist[1]
            if writtenName == exactName:
                exactIndex = contractList.index(sublist)
                oldNID = contractList[exactIndex][0]
                oldContractName = contractList[exactIndex][1]
                break
        else:
            oldNID = contractList[0][0]
            oldContractName = contractList[0][1]
    else:
        oldNID = contractList[0][0]
        oldContractName = contractList[0][1]
    query = (f"SELECT `created` FROM drupal.comment where nid={oldNID} ORDER BY created DESC")
    oldCommentList = get_from_db(query)
    oldNumberOfComments = len(oldCommentList)
    oldLastUpdated = 1
    if oldNumberOfComments:
        oldLastUpdated = oldCommentList[0][0]
    logging.info("Starting Checker")

    while True:
        #read new contract name from DB
        writtenName = readSheet(service, readRange)
        query = (f"SELECT `nid`,`title` FROM drupal.node where title like \"%{writtenName}%\" ORDER BY nid DESC")
        contractList = get_from_db(query)
        queryLength = len(contractList)
        if queryLength == 0:
            if not isRed:
                paintSheet(service, "red")
                isRed = True
            time.sleep(refreshRate)
            continue
        elif queryLength > 1:
            for sublist in contractList:
                exactName = sublist[1]
                if writtenName == exactName:
                    exactIndex = contractList.index(sublist)
                    newNID = contractList[exactIndex][0]
                    newContractName = contractList[exactIndex][1]
                    nameLog = (f"found exact match among {queryLength} contracts that contain \"{writtenName}\"")
                    break
            else:
                newNID = contractList[0][0]
                newContractName = contractList[0][1]
                nameLog = (f"could not find exact match among {queryLength} contracts that contain \"{writtenName}\", choosing the latest...")
        else:
            newNID = contractList[0][0]
            newContractName = contractList[0][1]
            nameLog = "found single contract and chose it!"

        #check last updated comment and number of comments
        query = (f"SELECT `created` FROM drupal.comment where nid={newNID} ORDER BY created DESC")
        commentList = get_from_db(query)
        newNumberOfComments = len(commentList)
        newLastUpdated = 1
        if newNumberOfComments:
            newLastUpdated = commentList[0][0]
        
        #compare the new and the old data
        if newContractName != oldContractName:
            logging.info(f"New contract name detected! {nameLog}")
            nameChanged = True
            break
        elif newNumberOfComments != oldNumberOfComments:
            logging.info("A comment was added!")
            nameChanged = False
            break
        elif newLastUpdated != oldLastUpdated:
            logging.info("A comment was modified!")
            nameChanged = False
            break
        time.sleep(refreshRate)
    filler(service, nameChanged, isRed, newContractName, newNID)

def filler(service, nameChanged, isRed, contractName, nid):
    logging.info("Running Filler")

    readRange = TEAM_ASSINGMENT_TAB+RANGE_READ

    #fill mission full name
    if nameChanged:
        writeSheet(service, contractName, readRange, 1)
        if isRed:
            paintSheet(service, "black")
        logging.info(f"Filled Mission Name: {contractName}")
    
    query = (f"SELECT `cid`,`uid`,`subject` FROM drupal.comment where nid={nid} ORDER BY cid ASC")
    commentList = get_from_db(query)
    numberOfComments = len(commentList)
    row = 2
    
    #save a list of the current comments
    nameRange = TEAM_ASSINGMENT_TAB + "B2:B" + str(numberOfComments+1)
    badListOfNames = readSheet(service, nameRange, 2)
    goodListOfNames = []
    for sublist in badListOfNames:
        goodListOfNames.extend(sublist)
    commentsRange = TEAM_ASSINGMENT_TAB + "D2:D" + str(numberOfComments+1)
    listOfComments = readSheet(service, commentsRange, 2)

    logging.info("Filling List...")

    for comment in commentList:
        cid = comment[0]
        uid = comment[1]
        subject = comment[2]
        
        #get user's attendence
        query = (f"SELECT `field_attendence_value` FROM drupal.field_data_field_attendence where entity_id={cid}")
        attendence = get_from_db(query)[0][0]
        
        #ignore all comments not marked "yes"
        if attendence != "yes":
            continue
        
        #get user display name
        query = (f"SELECT `realname` FROM drupal.realname where uid={uid}")
        name = get_from_db(query)[0][0]
        
        #check user's rank
        query = (f"SELECT `rid` FROM drupal.users_roles where uid={uid}")
        rank = get_from_db(query)[0][0]

        #if new mission, delete comment
        #if name changed spot, get the old comment   
        localComment = ""
        if nameChanged:
            pass
        elif name in goodListOfNames:
            index = goodListOfNames.index(name)
            if index < (len(listOfComments)):
                if listOfComments[index] == []:
                    localComment = ""
                else:
                    localComment = listOfComments[index][0]
            else:
                pass

        #if needed, add "recruit"
        if rank == 4:
            if localComment == "":
                localComment = "Recruit"
            elif "Recruit" in localComment:
                pass
            else:
                localComment = "Recruit, " + localComment
            
        #if no roles were filled, use "Rifleman"
        if subject == "(No subject)":
            subject = "Rifleman"

        data = [name, subject, localComment]
        writeRange = TEAM_ASSINGMENT_TAB + 'B' + str(row) + ":D" + str(row)
        writeSheet(service, data, writeRange, 3)
        row = row + 1
    
    #delete leftovers
    logging.info("Deleting leftovers...")
    data = ["", "", ""]
    checkRange = TEAM_ASSINGMENT_TAB + 'B' + str(row) + ":D" + str(row)
    NextCell = readSheet(service, checkRange, 3)
    while NextCell != "":
        writeSheet(service, data, checkRange, 3)
        row = row + 1
        checkRange = TEAM_ASSINGMENT_TAB + 'B' + str(row) + ":D" + str(row)
        NextCell = readSheet(service, checkRange, 3)
    
    logging.info("Successfully filled!")

def main():
    #Setting up the API service
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first time.
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.json', 'w') as token:
            token.write(creds.to_json())

    service = build('sheets', 'v4', credentials=creds, cache_discovery=False)
    readRange = TEAM_ASSINGMENT_TAB+RANGE_READ
    
    while True:
    try:
        checker(service)
    except (KeyboardInterrupt, SystemExit):
        return

if __name__ == '__main__':
    main()
