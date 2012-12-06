import pymongo
from time import *
from pymongo import Connection
import matplotlib
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure
import matplotlib.mlab as mlab

# Connect to MongoDB.
connection = Connection()
db = connection.twitterstream

#
# Define function to get the total number of tweets every second.
def get_total():
	global t0, draw
	draw = False
	time_full = time()
	time_round = "{0:.0f}".format(time_full)
	t1 = float(time_round)-1
	stime = gmtime(float(t0))
	if t1 == t0+1:
		draw = True
		try:
			record = db.posts.find_one({"time" : t1})['tweets']
			entry = {"dt" : dt_string(stime), "ntweets" : record}
			totals.append(entry)
		except:
			entry = {"dt" : dt_string(stime), "ntweets" : 0}
			totals.append(entry)
		t0 = t1


#
# Define function to return a string representing the date and time.
def dt_string(stime):
	if stime[5] < 10:
		dt = str(stime[2]) + "/" + str(stime[1]) + "/" + str(stime[0]) + " " + str(stime[3]) + ":" + str(stime[4]) + ":" + str(0) + str(stime[5]) + " |"
	else:
		dt = str(stime[2]) + "/" + str(stime[1]) + "/" + str(stime[0]) + " " + str(stime[3]) + ":" + str(stime[4]) + ":" + str(stime[5]) + " |"
	return dt

#
# Define plotting function
def plot_tweets():
	print "Plotted!"

#
# Set initial t0 value
time_full = time()
time_round = "{0:.0f}".format(time_full)
t0 = float(time_round)-1

#
# Set up array to hold values
totals = []


#
# Call functions
while True:
	get_total()
	if draw:
		plot_tweets()


