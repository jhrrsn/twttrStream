<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>D3 Test - Home</title>
        <script type="text/javascript" src="http://d3js.org/d3.v2.js"></script>
        <style type="text/css">
        	path {
				stroke: steelblue;
				stroke-width: 1;
				fill: none;
			}
			
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
    		
    		var xScale = d3.scale.linear()
							.domain([0, 60])
							.range([padding, w - padding])
							.nice();

			var yScale = d3.scale.linear()
							.domain([0, d3.max(dataset)])
							.range([h - padding, padding])
							.nice();
			
			
			
    		var svg = d3.select("body")
    			.append("svg")
    			.attr("width", w)
    			.attr("height", h);
    			
    		var line = d3.svg.line()
				.x(function(d, i) { 
					return xScale(i); 
				})
				.y(function(d) {
					return yScale(d); 
				});
			
			svg.append("svg:path").attr("d", line(dataset));
			
			var xAxis = d3.svg.axis()
    			.scale(xScale)
    			.orient("bottom")
    			.ticks(10);

    		var yAxis = d3.svg.axis()
    			.scale(yScale)
    			.orient("left")
    			.ticks(4);
    			
    		svg.append("g")
    			.attr("class", "axis")
    			.attr("transform", "translate(0, " + (h - padding) + ")")
    			.call(xAxis);
    		
    		svg.append("g")
    			.attr("class", "axis")
    			.attr("transform", "translate(" + 20 + ",0)")
    			.call(yAxis);
    	</script>
    	<form action='/refresh/' method='post'>
        <input type="submit" value="Refresh Values" />
    	</form>
    </body>
</html>