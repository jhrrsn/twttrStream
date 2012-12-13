from bson.code import Code
from pymongo import Connection

##
## Set up connection to MongoDB
connection = Connection()
db = connection.twitterstream

db.drop_collection("keywords")

map = Code("function () {" \
"  this.keywords.forEach(function(z) {" \
"    emit(z, 1);" \
"  });" \
"}")

reduce = Code("function (key, values) {" \
"  var total = 0;" \
"  for (var i = 0; i < values.length; i++) {" \
"    total += values[i];" \
"  }" \
"  return total;" \
"}")
results = db.posts.map_reduce(map, reduce, "keywords")
for doc in results.find().sort("value", -1).limit(100):
	print doc["_id"] + ": " + str(int(doc["value"]))
