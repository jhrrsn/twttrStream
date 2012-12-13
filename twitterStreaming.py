import pycurl, json
import pymongo
from time import time
from nltk.corpus import stopwords

# Establish stopwords for keyword extraction
stopwords_edited = stopwords.words('english')
stopwords_edited.extend(['lol', 'As', "im", "its", 'ive', 'yeah', 'you', 'i', 'gotta', 'ha', 'haha', 'x', 'u', 'oh', "don't", 'dont', 'xxx', 'get', '2', "that's", 'one', 'see', 'made', 'ever', 'someone', 'come', 'take', '@', '&amp;', ':)', ':(', 'would', 'need', 'know', 'go', 'got', '-', 'de', 'still', 'well', ';)', '!', "can't", 'xx', '?', '.', ',', 'much', 'done', 'ill', 'la', 'way', 'say', ':D', ':-)'])
s=set(stopwords_edited)

STREAM_URL = "https://stream.twitter.com/1/statuses/filter.json"
WORDS = "locations=-7.9, 49.6, 2.2, 61.1" #-0.57,51.25,0.37,51.72 (London)
USER = "PDEPrototyping"
PASS = "PD3Pr0t0typ1ng"

def on_tweet(data):
	try:
		time_full = time()
		time_round = "{0:.0f}".format(time_full)
		
		tweet = json.loads(data)
		
		try:
			# Try to look for direct inclusion of coordinates
			coords = tweet["coordinates"]["coordinates"]
			
		except:
			# If not present, take the centrepoint of the bounding box
			bbox = tweet["place"]["bounding_box"]["coordinates"][0]
			coords = [((bbox[0][0] + bbox[2][0]) / 2), ((bbox[0][1] + bbox[2][1]) / 2)]
			
		# Upsert tweet to correct bin in volume db
		db.volume.update({"time" : float(time_round)}, {"$inc" : {"tweets" : 1}, "$push" : {"coords" : coords}}, True)
		
		nlprocessed = filter(lambda w: not w.lower() in s,tweet["text"].split())
		keywords = []
		
		for word in nlprocessed:
			kword = word.encode('utf-8').lower()
			if '#' in kword:
				kword = kword[1::]
			if ('@' not in kword and '/' not in kword and "'" not in kword):
				keywords.append(kword)

		# Insert tweet to posts db
		db.posts.insert({"_id" : float(tweet["id"]), "time" : float(time_round), "coords" : coords, "text" : tweet["text"].encode('utf-8'), "name" : tweet["user"]["name"].encode('utf-8'), "keywords" : keywords}) 
	
	except Exception,e:
		print str(e)

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