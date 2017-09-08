// ================================================ TASK 1 ==============================================================

function insertPoints(dbName, colName, xcount, ycount) {
	db = db.getSisterDB(dbName);
	col = db.getCollection(colName);
	
	col.insert({x: xcount, y: ycount});
}
	
	
function findNearest(dbName, colName, xval, yval) {
	db = db.getSisterDB(dbName);
	col = db.getCollection(colName);
	
	var result;
	var minDist = -1.0;
	col.find().forEach(function(doc) {
		var dist = Math.sqrt(Math.pow(doc.x - xval, 2) + Math.pow(doc.y - yval, 2));
		if (minDist < 0 || dist < minDist) {
			minDist = dist;
			result = doc;
		}
	});
	print("x: " + result.x + ", y: " + result.y);
}

function updateYVals(dbName, colName, threshold, step) {
	db = db.getSisterDB(dbName);
	col = db.getCollection(colName);
	
	col.update({y:{$gt:threshold}}, {$inc:{y:step}}, {multi:true});
}

function removeIfYless(dbName, colName, threshold) {
	db = db.getSisterDB(dbName);
	col = db.getCollection(colName);
	
	col.remove({y:{$lt:threshold}});
}

// ================================================ TASK 2 ==============================================================

function allStatesPopulation(dbName, colName) { 
	db = db.getSisterDB(dbName);
	col = db.getCollection(colName);
	
	col.aggregate({$sort: {state:1}}).forEach(function(doc) {
		print("{" + doc.state + ", " + doc.pop + "}");
	});
}

function oneStatePopulation(dbName, colName, stateName) {
	db = db.getSisterDB(dbName);
	col = db.getCollection(colName);
	
	var res = col.aggregate([{$match: {state:stateName}}, {$group: {_id:"$state", total:{$sum:"$pop"}}}]);
	res.forEach(function(doc) {
		print("{" + doc._id + ", " + doc.total + "}");
	});
}

function allStatePopulationMR(dbName, colName) { 
	db = db.getSisterDB(dbName);
	col = db.getCollection(colName);
	
	col.mapReduce(
		function() {
			emit(this.state, this.pop);
		},
		function(keyState, valuesPop) {
			return Array.sum(valuesPop);
		},
		{ out: "states_population"});
}

function placesInGrid(dbName, colName, lat1, lat2, lon1, lon2) {
	db = db.getSisterDB(dbName);
	col = db.getCollection(colName);

	col.find().forEach(function(doc) {
		if (doc.loc[0] >= lat1 && doc.loc[0] <= lat2 && doc.loc[1] >= lon1 && doc.loc[1] <= lon2)
			print(
				"ZIP: " + doc._id + ", " +
				"city: " + doc.city + ", " +
				"loc: [" + doc.loc + "], " +
				"state: " + doc.state
			);
	
	});
}