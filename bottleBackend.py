import bottle
from pymongo import Connection
from time import time

		
##
## Set up connection to MongoDB
connection = Connection()
db = connection.twitterstream


##
## Define time period
period = 60;


##
## Set up bottle site paths & associated scripts
@bottle.route('/')
def main():
	## Calculate current time
	time_full = time()
	time_round = "{0:.0f}".format(time_full)
	t1 = float(time_round)-1
	
	## Pull last 100 seconds
	cursor = db.volume.find({"time" : {"$gte" : t1-(period+10)}}).sort("time", -1).limit(period+10)
	
	## Write number of tweets to array
	t0 = t1-(period+1)
	print t0
	print t1
	timestamps = range(int(t0), int(t1))
	
	tweets = []
	coords = []
	count = 0
	
	for i in range(int(t0), int(t1)):
		tw = dict({'key' : count, 'value' : 0})
		tweets.append(tw)
		count += 1
	
	for doc in cursor:
		try:
			tweetIndex = timestamps.index(doc['time'])
			for pair in tweets:
				if pair["key"] == tweetIndex:
					pair["value"] = doc['tweets']
					for coord in doc['coords']:
						coords.append(coord)
		except:
			pass
			
	return bottle.template('main', {'coords' : coords, 'period' : period}) #'tweets' : tweets[::-1], 


@bottle.route('/update')
def update():
	## Calculate current time
	time_full = time()
	time_round = "{0:.0f}".format(time_full)
	t1 = float(time_round)-1
	
	## Pull last 100 seconds
	cursor = db.volume.find({"time" : {"$gte" : t1-(period+10)}}).sort("time", -1).limit(period+10)
	
	## Write number of tweets to array
	t0 = t1-(period+1)
	timestamps = range(int(t0), int(t1))
	
	tweets = []
	coords = []
	count = 0
	
	for i in range(int(t0), int(t1)):
		tw = dict({'key' : count, 'value' : 0})
		tweets.append(tw)
		count += 1
	
	for doc in cursor:
		try:
			tweetIndex = timestamps.index(doc['time'])
			for pair in tweets:
				if pair["key"] == tweetIndex:
					pair["value"] = doc['tweets']
					for coord in doc['coords']:
						coords.append(coord)
								
		except:
			pass
				
	return({'coords' : coords}) #'tweets' : tweets, 

bottle.debug(True)
bottle.run(host = 'localhost', port = 8080)