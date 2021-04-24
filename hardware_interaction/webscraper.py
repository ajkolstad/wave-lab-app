import requests
import time
import mysql.connector
import os
from bs4 import BeautifulSoup
from datetime import datetime
from os.path import join, dirname
from dotenv import load_dotenv

# Gets the depth of the flume that is called by str by web scraping
def depth_flume(str):

    # str is either LWF or DWB
    if(str == 'LWF'):
        url_path = ('https://sea.wave.oregonstate.edu/LWF')
    else:
        url_path = ('https://sea.wave.oregonstate.edu/DWB')
    html_text = requests.get(url_path).text
    soup = BeautifulSoup(html_text, 'lxml')

    # Split html into arrays of strings
    soupArray = soup.prettify().split('\n')

    # The line where all of the current depth values are stored for the websites graph
    line = soupArray[237]

    start = 0
    end = 0

    # Starting from the last(most recent) current depth value to find the while number
    for index, char in enumerate(reversed(line)):
        if char == ',':
            start = int(index)
            break

    for index, char in enumerate(reversed(line)):
        if char in '0123456789':
            end = int(index)
            break

    startInt = len(line) - start
    endInt = len(line) - end

    curDepth = line[startInt : endInt]

    return curDepth

def main():

    # Grab information from config.env    
    dotenv_path = join(dirname(__file__), 'config.env')
    load_dotenv(dotenv_path)    
    
    # Connects to the database
    conn = mysql.connector.connect(
        host = os.getenv('DATABASE_HOST'),
        user = os.getenv('DATABASE_USER'),
        password = os.getenv('DATABASE_PASSWORD'),
        database = os.getenv('DATABASE')
    )
    cursor = conn.cursor()

    # The sql call to insert the depth
    sql = """INSERT INTO depth_data(Ddate, Depth, Depth_Flume_Name) VALUES(%s, %s, %s)"""
    
    # Run infinitly
    while(True):

        # Grab data from LWF and insert into database
        depth_lwf = depth_flume("LWF")
        now = datetime.now()
        cur_date = now.strftime("%Y-%m-%d %H:%M:%S")
        val = (cur_date, depth_lwf, 0)
        cursor.execute(sql, val)
        conn.commit()
        
        # Sleep for 5 minutes
        time.sleep(300)

        # Grab data from DWB and insert into database
        depth_dwb = depth_flume("DWB")
        now = datetime.now()
        cur_date = now.strftime("%Y-%m-%d %H:%M:%S")
        val = (cur_date, depth_dwb, 1)
        cursor.execute(sql, val)
        conn.commit()

        # Sleep for 5 minutes
        time.sleep(300)

if __name__ == "__main__":
    main()