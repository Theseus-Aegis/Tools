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

def readSheet(service, range, amount = 1):
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

def checker(service):
    readRange = TEAM_ASSINGMENT_TAB+RANGE_READ
    writtenName = readSheet(service, readRange)
    query = ("SELECT `nid`,`title` FROM drupal.node where title like \"%%%s%%\"" % (writtenName))
    contractList = get_from_db(query)
    oldNID = contractList[0][0]
    oldContractName = contractList[0][1]
    query = ("SELECT `created` FROM drupal.comment where nid=%s ORDER BY created DESC" % (oldNID))
    oldCommentList = get_from_db(query)
    oldLastUpdated = oldCommentList[0][0]
    oldNumberOfComments = len(oldCommentList)
    
    logging.info("Starting Checker")

    while True:
        #read new contract name from DB
        writtenName = readSheet(service, readRange)
        query = ("SELECT `nid`,`title` FROM drupal.node where title like \"%%%s%%\"" % (writtenName))
        contractList = get_from_db(query)
        newNID = contractList[0][0]
        newContractName = contractList[0][1]

        #check last updated comment and number of comments
        query = ("SELECT `created` FROM drupal.comment where nid=%s ORDER BY created DESC" % (newNID))
        commentList = get_from_db(query)
        newLastUpdated = commentList[0][0]
        newNumberOfComments = len(commentList)
        
        #compare the new and the old data
        if (newContractName != oldContractName):
            logging.info("New contract name detected!")
            nameChanged = True
            break
        elif (newNumberOfComments != oldNumberOfComments):
            logging.info("A comment was added!")
            nameChanged = False
            break
        elif (newLastUpdated != oldLastUpdated):
            logging.info("A comment was modified!")
            nameChanged = False
            break
        time.sleep(refreshRate)
    
    filler(service, nameChanged, newContractName, newNID)

def filler(service, nameChanged, contractName, nid):
    logging.info("Running Filler")

    readRange = TEAM_ASSINGMENT_TAB+RANGE_READ

    #fill mission full name
    if nameChanged:
        writeSheet(service, contractName, readRange, 1)
        logging.info("Filled Mission Name : %s" % (contractName))
    
    query = ("SELECT `cid`,`uid`,`subject` FROM drupal.comment where nid=%s ORDER BY cid ASC" % (nid))
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
        query = ("SELECT `field_attendence_value` FROM drupal.field_data_field_attendence where entity_id=%s" % (cid))
        attendence = get_from_db(query)[0][0]
        
        #ignore all comments not marked "yes"
        if attendence != "yes":
            continue
        
        #get user display name
        query = ("SELECT `realname` FROM drupal.realname where uid=%s" % (uid))
        name = get_from_db(query)[0][0]
        
        #check user's rank
        query = ("SELECT `rid` FROM drupal.users_roles where uid=%s" % (uid))
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
        checker(service)

if __name__ == '__main__':
    main()