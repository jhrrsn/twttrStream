import bottle
from pymongo import Connection
from time import time

		
##
## Set up connection to MongoDB
connection = Connection()
db = connection.twitterstream

##
## Set up bottle site paths & associated scripts
@bottle.route('/')
def home_page():
	## Calculate current time
	time_full = time()
	time_round = "{0:.0f}".format(time_full)
	t1 = float(time_round)-1
	
	## Pull last 100 seconds
	cursor = db.posts.find({"time" : {"$gte" : t1-70}}).sort("time", -1).limit(70)
	
	## Write number of tweets to array
	t0 = t1-61
	print t0
	print t1
	print "--------------"
	timestamps = range(int(t0), int(t1))
	print timestamps
	print "--------------"
	tweets = []
	for i in range(int(t1) - int(t0)):
		tweets.append(0)
	for doc in cursor:
		try:
			tweetIndex = timestamps.index(doc["time"])
			tweets[tweetIndex] = doc["tweets"]
		except:
			print "Not in range."
	
	for tweet in tweets:
		print tweet
	
	return bottle.template('home', {'tweets' : tweets})

@bottle.route('/refresh/', method='POST')
def refresh():
	bottle.redirect('/')


bottle.debug(True)
bottle.run(host = 'localhost', port = 8080)