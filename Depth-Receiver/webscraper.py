import requests
import time
import mysql.connector
from bs4 import BeautifulSoup
from datetime import datetime

def depth_flume(str):
    if(str == 'LWF'):
        url_path = ('https://sea.wave.oregonstate.edu/LWF')
    else:
        url_path = ('https://sea.wave.oregonstate.edu/DWB')
    html_text = requests.get(url_path).text
    soup = BeautifulSoup(html_text, 'lxml')

    soupArray = soup.prettify().split('\n')

    line = soupArray[237]

    start = 0
    end = 0

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
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="wave_lab_database"
    )
    cursor = conn.cursor()
    sql = """INSERT INTO depth_data(Ddate, Depth, Depth_Flume_Name) VALUES(%s, %s, %s)"""
    while(True):
        depth_lwf = depth_flume("LWF")
        now = datetime.now()
        cur_date = now.strftime("%Y-%m-%d %H:%M:%S")
        val = (cur_date, depth_lwf, 0)
        cursor.execute(sql, val)
        conn.commit()
        time.sleep(300)
        depth_dwb = depth_flume("DWB")
        now = datetime.now()
        cur_date = now.strftime("%Y-%m-%d %H:%M:%S")
        val = (cur_date, depth_dwb, 1)
        cursor.execute(sql, val)
        conn.commit()
        time.sleep(300)

if __name__ == "__main__":
    main()