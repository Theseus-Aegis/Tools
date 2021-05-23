import logging
import os

import mysql.connector
from mysql.connector import Error
from mysql.connector import errorcode

# from dotenv import load_dotenv
# load_dotenv()
#endregion

# db_host = os.environ['DIGITAL_OCEAN_HOST']
# db_name = os.environ['DATABASE_NAME']
# db_user = os.environ['DO_DB_USER']
# db_pass = os.environ['DO_DB_PASSWORD']
# db_port = os.environ['DO_DB_PORT']

db_host = "host"
db_name = "name"
db_user = "user"
db_pass = "password"
db_port = "port"

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s]: %(message)s",
                    handlers=[logging.FileHandler("filler.log"), logging.StreamHandler()])

def connect_db():
    return mysql.connector.connect(host=db_host, database=db_name, port=db_port, user=db_user, password=db_pass)

connection = connect_db()

def get_from_db(query):
    if is_single_query(query):
        query += ";"
    else:
        return [["Currupted query"]]
    
    global connection
    if not connection.is_connected():
        connection = connect_db()
    
    try:
        cursor = connection.cursor(buffered=True)
        cursor.execute(query)
        result = cursor.fetchall()
        logging.debug("Query executed successfully: ** %s " % (query.replace("\n", " ")))
        cursor.close()
    except mysql.connector.Error as error:
        logging.error("Failed performing query {}".format(error))
        return str(error)
    return result

def is_single_query(query):
    return ";" not in query
