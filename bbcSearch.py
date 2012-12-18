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

words_edited = stopwords.words()
words_edited.extend(["BBC", "England", "Britain", "2012", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
s=set(words_edited)

bbc = feedparser.parse("http://feeds.bbci.co.uk/news/uk/rss.xml")

entries_parsed = []

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
## Set up connection to MongoDB
connection = Connection()
db = connection.twitterstream

## Home page
@bottle.route('/')
def home_page():
	return bottle.template('bbc', {"entries" : entries_parsed[:10]})
	
## Results page
@bottle.post('/search')
def results():
	keywords = bottle.request.forms.get('keywords')
	keywords_parsed = keywords.split()
	keywords_clean = map(lambda x:x.lower(),keywords_parsed)
	docs = db.posts.find({'keywords' : {"$all" : keywords_clean} }).sort("time", 1)
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
		loc.extend([doc["_id"].encode()])
		loc.extend([doc["name"].encode()])
		coords.append(loc)
	
	return bottle.template('bbcresults', {'keyword' : keywords_clean, 'results' : numDocs, 'coords' : coords, 'minTime' : minTime, 'maxTime' : maxTime})


bottle.debug(True)
bottle.run(host = 'localhost', port = 8080)