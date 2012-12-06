<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>D3 Test - Home</title>
        <script type="text/javascript" src="http://d3js.org/d3.v2.js"></script>
        <style type="text/css">
        	.axis path,
        	.axis line {
        		fill: none;
        		stroke: black;
        		shape-rendering: crispEdges;
        	}
        	
        	.axis text {
        		font-family: sans-serif;
        		font-size: 11px;
        	}     	
        </style>
    </head>
    <body>
    	<h1>Tweet-O-Meter</h1>
    	<h3>Number of geolocated tweets per second in London, UK</h3>
    	   	
    	<script type="text/javascript"> 
    		var w = 700;
    		var h = 100;
    		var barPadding = 1;
    		var padding = 20;
    		
    		var dataset = {{!tweets}};
    		
    		var xScale = d3.scale.ordinal()
							.domain(d3.range(dataset.length))
							.rangeRoundBands([padding, w - padding], 0.05);

			var yScale = d3.scale.linear()
							.domain([0, d3.max(dataset)])
							.range([h - padding, padding])
							.nice();
			
			
			
    		var svg = d3.select("body")
    			.append("svg")
    			.attr("width", w)
    			.attr("height", h);
    			
    		svg.selectAll("circle")
    			.data(dataset)
    			.enter()
    			.append("circle")
    			.attr("cx", function(d, i) {
    				return xScale(i);
    			})
    			.attr("cy", function(d) {
    				return yScale(d);
    			})
    			.attr("r", 2);
    		
    		var yAxis = d3.svg.axis()
    			.scale(yScale)
    			.orient("left")
    			.ticks(4);
    		
    		svg.append("g")
    			.attr("class", "axis")
    			.attr("transform", "translate(" + 20 + ",0)")
    			.call(yAxis)
    		
    		//
    		// UPDATE
    		// d3.select("h3")
//     			.on("click", function() {
//     				
//     				// Refresh data
//     				var dataset = {{!tweets}};
//     				console.log(dataset);
//     				
//     				// Update scales
//     				xScale.domain(d3.range(dataset.length));
// 					yScale.domain([0, d3.max(dataset)]);
// 					
// 					// Select * & move points
// 					var points = svg.selectAll("circle")
// 						.data(dataset);
// 						
// 					points.enter()
// 						.append("circle")
// 						.attr("cx", function(d, i) {
//     						return xScale(i);
// 						})
// 						.attr("cy", function(d) {
// 							return h - yScale(d);
// 						})
// 						.attr("r", 2);
// 						
// 					points.transition()
// 						.duration(500)
// 						.attr("cx", function(d, i) {
//     						return xScale(i);
// 						})
// 						.attr("cy", function(d) {
// 							return h - yScale(d);
// 						})
// 						.attr("r", 2);
//     			})
    	</script>
    	<form action='/refresh/' method='post'>
        <input type="submit" value="Refresh Values" />
    	</form>
    </body>
</html>