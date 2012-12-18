import bottle
from bson.code import Code
from pymongo import Connection
import feedparser
from nltk.corpus import stopwords
from time import mktime
from datetime import datetime
from readability.readability import Document
import string
import urllib
import time

##
## PARSE BBC NEWS RSS FEED

words_edited = stopwords.words()
words_edited.extend(["BBC", "England", "Britain", "2012", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
s=set(words_edited)

# Call and parse the BBC News feed into a dict.
bbc = feedparser.parse("http://feeds.bbci.co.uk/news/uk/rss.xml")

entries_parsed = []

# Go through each entry, use readability module to extract the article title (not the same as the feed unfortunately) and use NLTK to parse it for uncommon words & names. Create an array of these keywords.
for entry in bbc.entries:
	entry_parsed = []
	html = urllib.urlopen(entry.link).read()
	article_title = Document(html).short_title()
	if ("404" not in article_title):
		entry_parsed.append(article_title)
		nltk_title = filter(lambda w: not w.lower() in s,article_title.split())
		processed_title = []
		for word in nltk_title:
			try: 
				encoded_word = word.encode()
				processed_word = encoded_word.translate(None, string.punctuation)
				if len(processed_word) > 1:
					processed_title.append(processed_word)
			except Exception,e:
				print str(e)
		entry_parsed.append(processed_title)
		dt = datetime.fromtimestamp(mktime(entry.published_parsed))
		entry_parsed.append(dt)
		entry_parsed.append(entry.link.encode())
		entries_parsed.append(entry_parsed)
	

entries_parsed.sort(key=lambda x: time.mktime(x[2].timetuple()), reverse=True)
	
	## [title, keywords[], datetime, link]


##
## SET UP CONNECTION TO MONGODB
connection = Connection()
db = connection.twitterstream


##
## SET UP BOTTLE PAGE FUNCTIONS

## Home page
@bottle.route('/')
def home_page():
	# Pass 10 most recent news stories (with keywords) to the homepage.
	return bottle.template('bbc', {"entries" : entries_parsed[:10]})
	
## Results page
@bottle.post('/search')
def results():
 	search_input = bottle.request.forms.get('keywords')
	input_parsed = search_input.split()
	
	# Split get request into the keywords and article time.
	keywords = input_parsed[:-2]
	raw_time = input_parsed[-2:]
	
	struct_time = time.strptime(raw_time[0] + ' ' + raw_time[1], "%Y-%m-%d %H:%M:%S")
	unix_time = time.mktime(struct_time)

	# Make datetime into Unix time.
	
	# Make each keyword lower case for matching to mongodb.
	keywords_clean = map(lambda x:x.lower(),keywords)
		
	# Make find request to mongodb to find all documents that have *all* of the specified keywords.
	docs = db.posts.find({'keywords' : {"$all" : keywords_clean} }).sort("time", 1)
	numDocs = docs.count()

	# Calculate oldest and newest tweet times from the returned tweets.
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
		
		# For each document returned, extract the coordinates of the tweet, the time of the tweet. the 		id of the tweet and the username of the account it came from & append to an array for the viz. 
		loc = [doc["coords"][1], doc["coords"][0]]
		loc.extend([doc["time"]])
		loc.extend([doc["_id"].encode()])
		loc.extend([doc["name"].encode()])
		coords.append(loc)
		
	
	return bottle.template('bbcresults', {'keyword' : keywords_clean, 'results' : numDocs, 'coords' : coords, 'minTime' : minTime, 'maxTime' : maxTime, 'articleTime' : unix_time})


##
## RUN PAGE
bottle.debug(True)
bottle.run(host = 'localhost', port = 8080)