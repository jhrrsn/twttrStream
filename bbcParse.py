import feedparser
from nltk.corpus import stopwords
from time import mktime
from datetime import datetime
import time
from readability.readability import Document
import string
import urllib

words_edited = stopwords.words()
words_edited.extend(["BBC", "England", "Britain", "2012", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
s=set(words_edited)

bbc = feedparser.parse("http://feeds.bbci.co.uk/news/uk/rss.xml")

entries_parsed = []

for entry in bbc.entries:
	entry_parsed = []
	html = urllib.urlopen(entry.link).read()
	article_title = Document(html).short_title()
	
	# 1) Append full article title to 'entry_parsed' array.
	entry_parsed.append(article_title)
	
	# 2) Remove common english stopwords from title (i.e. 'this', 'it', 'they', 'and'), return an array of 'keywords'.
	nltk_title = filter(lambda w: not w.lower() in s,article_title.split())
	
	# 3) Go through each keyword, change it from unicode to system encoding, remove punctuation and append cleaned keyword to 'processed_title' array.
	processed_title = []
	for word in nltk_title:
		try: 
			encoded_word = word.encode()
			processed_title.append(encoded_word.translate(None, string.punctuation))
		except Exception,e:
			print str(e)
	
	# 4) Add the cleaned keyword array to the 'entry_parsed' array.
	entry_parsed.append(processed_title)
	
	# 5) Construct datetime object and append to 'entry_parsed' array.
	dt = datetime.fromtimestamp(mktime(entry.published_parsed))
	entry_parsed.append(dt)
	
	# 6) Append entry URL to 'entry_parsed' array.
	entry_parsed.append(entry.link.encode())
	
	# 7) Append the completed entry (entry_parsed) to the master array (entries_parsed).
	entries_parsed.append(entry_parsed)
	
	
####
entries_parsed.sort(key=lambda x: time.mktime(x[2].timetuple()))

for entry in entries_parsed:
	print entry[2];