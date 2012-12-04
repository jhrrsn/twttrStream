<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>D3 Test - Home</title>
        <script type="text/javascript" src="http://d3js.org/d3.v2.js"></script>
    </head>
    <body>
    	<h1>Start Small</h1>
    	<h3>Click to refresh.</h3>
    	<script type="text/javascript"> 
    		var w = 700;
    		var h = 100;
    		var barPadding = 1;
    		
    		var dataset = {{!nums}};
    		
    		var xScale = d3.scale.ordinal()
							.domain(d3.range(dataset.length))
							.rangeRoundBands([0, w], 0.05);

			var yScale = d3.scale.linear()
							.domain([0, d3.max(dataset)])
							.range([0, h]);
			
			
			
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
    				return h - yScale(d);
    			})
    			.attr("r", 2);
    		
    		//
    		// UPDATE
    		d3.select("h3")
    			.on("click", function() {
    				
    				// Refresh data
    				var dataset = {{!nums}};
    				console.log(dataset);
    				
    				// Update scales
    				xScale.domain(d3.range(dataset.length));
					yScale.domain([0, d3.max(dataset)]);
					
					// Select * & move points
					var points = svg.selectAll("circle")
						.data(dataset);
						
					points.enter()
						.append("circle")
						.attr("cx", function(d, i) {
    						return xScale(i);
						})
						.attr("cy", function(d) {
							return h - yScale(d);
						})
						.attr("r", 2);
						
					points.transition()
						.duration(500)
						.attr("cx", function(d, i) {
    						return xScale(i);
						})
						.attr("cy", function(d) {
							return h - yScale(d);
						})
						.attr("r", 2);
    			})
    	</script>
    </body>
</html>