from os import getenv
import json
import sys
import pymssql
import string


with open("issues.json",'r') as f:
    issues=json.load(f)




server = getenv("PYMSSQL_TEST_SERVER")
user = getenv("PYMSSQL_TEST_USERNAME")
password = getenv("PYMSSQL_TEST_PASSWORD")

conn = pymssql.connect(server, user, password, "tdba")
cursor = conn.cursor()
for i in issues["issues"]:
    print(i["key"])
    istr = json.dumps(i)
    istr = string.replace(istr,"'","''")
    execstr = "insert into IssueList (JsonData) VALUES ('%s')" % (istr)
    cursor.execute(execstr)
conn.commit()
#cursor.execute("""
#IF OBJECT_ID('persons', 'U') IS NOT NULL
#    DROP TABLE persons
#CREATE TABLE persons (
#    id INT NOT NULL,
#    name VARCHAR(100),
#    salesrep VARCHAR(100),
#    PRIMARY KEY(id)
#)
#""")
#cursor.executemany(
#    "INSERT INTO persons VALUES (%d, %s, %s)",
#    [(1, 'John Smith', 'John Doe'),
#     (2, 'Jane Doe', 'Joe Dog'),
#     (3, 'Mike T.', 'Sarah H.')])
# you must call commit() to persist your data if you don't set autocommit to True
#conn.commit()

#cursor.execute('SELECT * FROM persons WHERE salesrep=%s', 'John Doe')

cursor.execute('SELECT id, summary FROM issues order by id')
row = cursor.fetchone()
while row:
    print("ID=%d, Summary=%s" % (int(row[0]), row[1]))
    row = cursor.fetchone()

conn.close()
