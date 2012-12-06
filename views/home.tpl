<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>D3 Twitter Test</title>
        <script type="text/javascript" src="http://d3js.org/d3.v2.js"></script>
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
        <script type="text/javaScript">
			function timedRefresh(timeoutPeriod) {
			 setTimeout("window.location.reload(true);",timeoutPeriod);
			}
		</script>
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
        	
        	h1 {
        		font-family: sans-serif;
        		font-size: 22px;
        	}
        	
        	hr {
        		stroke: black;
        	}
        </style>
    </head>
    <body onload="timedRefresh(5000);">    	
    	<h1 align="center">Tweet-O-Meter</h1>
    	
    	<hr>
    	
    	<!--                             -->
    	<!--                             -->
    	<!-- Tweet location scatter plot -->
    	<script type="text/javascript" align="center">
    		var w = $("body").width();
    		var h = 400;
    		var verticalPadding = 20;
    		var horizontalPadding = 400;
    		var nSeconds = {{period}};
    		
    		var dataset = {{!coords}};    		
    		
    		var xScale = d3.scale.linear()
				.domain([-0.489, 0.236])
				.range([horizontalPadding, w - horizontalPadding])
				.nice();

			var yScale = d3.scale.linear()
				.domain([51.280, 51.686])
				.range([h - verticalPadding, verticalPadding])
				.nice();
    		
    		var svg = d3.select("body")
    			.append("svg")
    			.attr("width", w)
    			.attr("height", h);
    		
    		svg.selectAll("circle")
    			.data(dataset)
    			.enter()
    			.append("circle")
    			.attr("cx", function(d) {
    				return xScale(d[0]);
    			})
    			.attr("cy", function(d) {
					return yScale(d[1]);
				})
				.attr("r", 1)
				.attr("fill", "steelblue");
    		
    	</script>
    	
    	<hr>
    	
    	<!--                          -->
    	<!--                          -->
    	<!-- Twitter volume line plot -->
    	<script type="text/javascript"> 
    		var w = $("body").width();
    		var h = 100;
    		var padding = 20;
    		var nSeconds = {{period}};

    		var dataset = {{!tweets}};
    		
    		var xScale = d3.scale.linear()
							.domain([0, nSeconds])
							.range([padding, w - padding])
							.nice();

			var yScale = d3.scale.linear()
							.domain([0, d3.max(dataset, function(d) {return d.value;})])
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
					return yScale(d.value);
				});
			
			svg.append("svg:path")
				.attr("d", line(dataset));
			
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
    </body>
</html>