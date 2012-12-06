import pymongo
from time import *
from pymongo import Connection
connection = Connection()
db = connection.twitterstream

def print_tweet():
	global t0
	time_full = time()
	time_round = "{0:.0f}".format(time_full)
	t1 = float(time_round)-1
	stime = gmtime(float(t0))
	if t1 == t0+1:
		try:
			record = db.posts.find_one({"time" : t1})['tweets']
			print dt_string(stime) + str(record)
		except:
			print dt_string(stime) + "0"
		t0 = t1

def dt_string(stime):
	if stime[5] < 10:
		dt = str(stime[2]) + "/" + str(stime[1]) + "/" + str(stime[0]) + " " + str(stime[3]) + ":" + str(stime[4]) + ":" + str(0) + str(stime[5]) + " |"
	else:
		dt = str(stime[2]) + "/" + str(stime[1]) + "/" + str(stime[0]) + " " + str(stime[3]) + ":" + str(stime[4]) + ":" + str(stime[5]) + " |"
	return dt
	

time_full = time()
time_round = "{0:.0f}".format(time_full)
t0 = float(time_round)-1
while True:
	print_tweet()
