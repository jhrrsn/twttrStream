import pycurl, json
import pymongo
from time import time

STREAM_URL = "https://stream.twitter.com/1/statuses/filter.json"
WORDS = "locations=-0.489,51.28,0.236,51.686" 
USER = "PDEPrototyping"
PASS = "PD3Pr0t0typ1ng"

def on_tweet(data):
	try:
		tweet = json.loads(data)
		coords = tweet["coordinates"]["coordinates"]
		time_full = time()
		time_round = "{0:.0f}".format(time_full)
		db.posts.update({"time" : float(time_round)}, {"$inc" : {"tweets" : 1}}, True) # Push number of tweets per second
		db.posts.update({"time" : float(time_round)}, {"$push" : {"coords" : coords}}, True) # Push tweet location
		print "Entry written"
	except:
		print "Bad parsing"

from pymongo import Connection
connection = Connection()
db = connection.twitterstream
conn = pycurl.Curl()
conn.setopt(pycurl.POST, 1)
conn.setopt(pycurl.POSTFIELDS, WORDS)
conn.setopt(pycurl.HTTPHEADER, ["Connection: keep-alive", "Keep-Alive: 3000"])
conn.setopt(pycurl.USERPWD, "%s:%s" % (USER, PASS))
conn.setopt(pycurl.URL, STREAM_URL)
conn.setopt(pycurl.WRITEFUNCTION, on_tweet)
conn.perform()