import bottle
from bson.code import Code
from pymongo import Connection

##
## Set up connection to MongoDB
connection = Connection()
db = connection.twitterstream

## Home page
@bottle.route('/')
def home_page():
	return bottle.template('home')

## Results page
@bottle.post('/results')
def results():
	keyword = bottle.request.forms.get('keyword')
	docs = db.posts.find({'keywords' : keyword.lower()}).sort("time", 1)
	numDocs = docs.count()
	print numDocs
	minTime = 0
	maxTime = 0
	coords = []
	first = True
	for doc in docs:
		if first:
			minTime = doc["time"]
			maxTime = doc["time"]
		else:
			if doc["time"] < minTime:
				minTime = doc["time"]
			elif doc["time"] > maxTime:
				maxTime = doc["time"]
				
		first = False
		loc = [doc["coords"][1], doc["coords"][0]]
		loc.extend([doc["time"]])
		coords.append(loc)
	
	return bottle.template('results', {'keyword' : keyword.upper(), 'results' : numDocs, 'coords' : coords, 'minTime' : minTime, 'maxTime' : maxTime})

bottle.debug(True)
bottle.run(host = 'localhost', port = 8080)