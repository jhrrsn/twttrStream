import bottle
from pymongo import Connection
		
##
## Set up connection to MongoDB
connection = Connection('localhost', 27017)
testr = connection.test
smplDB = testr.sample

##
## Set up bottle site paths & associated scripts
@bottle.route('/')
def home_page():
	values = smplDB.find_one()["nums"]
	return bottle.template('home', {'nums' : values})

bottle.debug(True)
bottle.run(host = 'localhost', port = 8080)