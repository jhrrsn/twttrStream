import pycurl, json
import pymongo
from datetime import datetime


# Set up stream parameters
STREAM_URL = "https://stream.twitter.com/1/statuses/filter.json"
WORDS = "locations=-0.489,51.28,0.236,51.686" 
USER = "PDEPrototyping"
PASS = "PD3Pr0t0typ1ng"

# Make some prefilled attributes for our document schema
today = datetime.now()
print today.year
min = {}
minhour = {}
hour = {}

for i in range(0, 60):
	min[str(i)] = []
	
for i in range(0, 24):
	minhour[str(i)] = min

for i in range(0, 24):
	hour[str(i)] = 0

# Set up the document schema. Includes metadata about the day & stream parameters
metadata = dict({"day" : int(today.day), "month" : int(today.month), "year" : int(today.year), "terms" : WORDS })
schema = dict({"metadata" : metadata, "tot_by_hour" : hour, "locs_by_minute" : minhour })

# Connect to MongoDB database
from pymongo import Connection
connection = Connection()
db = connection.twitterstream

# Insert our pre-allocated document
db.tweets.update({"metadata" : metadata}, schema, True)

# Define tweet event function
def on_tweet(data):
	try:
		tweet = json.loads(data)
		coords = tweet["coordinates"]["coordinates"]
		now = datetime.now()
		query = {"metadata" : {"year" : now.year, "terms" : WORDS, "day" : now.day, "month" : now.month}} # Find today's document
		update_vol = { '$inc': {'tot_by_hour.%d' % (now.hour) : 1}} # Increase the hourly total by one
		update_loc = { '$push': {'locs_by_minute.%d.%d' % (now.hour, now.minute) : coords}} # Increase the hourly total by one
		db.tweets.update(query, update_vol, True)
		db.tweets.update(query, update_loc, True)
		print str(now.hour)
		print coords
	except:
		print "null data"

# Perform & maintain connection to stream
conn = pycurl.Curl()
conn.setopt(pycurl.POST, 1)
conn.setopt(pycurl.POSTFIELDS, WORDS)
conn.setopt(pycurl.HTTPHEADER, ["Connection: keep-alive", "Keep-Alive: 3000"])
conn.setopt(pycurl.USERPWD, "%s:%s" % (USER, PASS))
conn.setopt(pycurl.URL, STREAM_URL)
conn.setopt(pycurl.WRITEFUNCTION, on_tweet)
conn.perform()