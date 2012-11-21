import MySQLdb
import sys

db=MySQLdb.connect(db="test")
c=db.cursor()
c.execute("""SELECT spam from breakfast""")
for u in  c:
	print u[0]
	
	
