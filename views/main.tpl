<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>D3 Twitter Test</title>
        <script type="text/javascript" src="http://d3js.org/d3.v2.js"></script>
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
		
		<script type="text/javascript">
		var xmlhttp;
		if (window.XMLHttpRequest)
		  {// code for IE7+, Firefox, Chrome, Opera, Safari
		  xmlhttp=new XMLHttpRequest();
		  }
		else
		  {// code for IE6, IE5
		  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		  }
		  
		</script>

        <style type="text/css">
        	h1 {
        		font-family: sans-serif;
        		font-size: 22px;
        		font-weight:lighter;
        	}
        	
        	text {
        		font-family: sans-serif;
        		font-size: 12px;
        		font-weight:bold;      	
        	}
        	
        	hr {
        		stroke: black;
        	}
        	
        	svg {
        		background-image:url(http://oi46.tinypic.com/14wbrxd.jpg);
        		background-repeat:no-repeat;
        		background-position:50% 0%;
        		background-size:66.6% 100%;
        	}
        </style>
    </head>
    <body>    	
    	<h1 align="center">Tweets across London over the last {{period}} seconds</h1>
    	
    	<script type="text/javascript">
			var w = $("body").width();
			var h = w/2;
			var vPadding = 0;
			var hPadding = w/6;
			var nSeconds = {{period}};
			var coords = {{!coords}};
			
			var xScale = d3.scale.linear()
				.domain([-0.57, 0.37])
				.range([hPadding, w - hPadding])
				.clamp(true)
				.nice();

			var yScale = d3.scale.linear()
				.domain([51.25, 51.72])
				.range([h - vPadding, vPadding])
				.clamp(true)
				.nice();
			
			var svg = d3.select("body")
				.append("svg")
				.attr("width", w)
				.attr("height", h);
				
			svg.selectAll("circle")
				.data(coords)
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
			
			svg.append("text")
				.attr("class", "ptCount")
				.attr("text-anchor", "middle")
				.attr("x", w * 0.8)
				.attr("y", h - 10)
				.text("TPM: " + coords.length);
    		
    		// Set up method for searching arrays of arrays for matching values
    		var nestedArrayIndex = function (array) { 
				for (var j = 0; j < coords.length; j++) {
					if (coords[j][0] === array[0] && coords[j][1] === array[1]) {
						return(j);
					}
				}
			};
    		
    		// Set up update method, to pull new data from Bottle and call draw method again.
			var update = function() {
				console.log("Updating values...");
				
				$.get("/update",function(data) {
					newData = data.coords;
					for (var i = 0; i < newData.length; i++) {
						if (nestedArrayIndex(newData[i]) === undefined) {
							coords.push(newData[i]);
						}
					}
				});
				
				svg.selectAll("text")
					.text("TPM: " + coords.length);
				
				var points = svg.selectAll("circle")
					.data(coords);
					
				points.enter()
					.append("circle")
					.attr("cx", function(d) {
						return xScale(d[0]);
					})
					.attr("cy", function(d) {
						return yScale(d[1]);
					})
					.attr("r", 3)
					.attr("fill", "lightgreen");
				
				points.exit()
					.attr("fill", "red")
					.attr("r", 3)
					.remove();
				
				points.transition()
					.attr("fill", "steelblue")
					.attr("r", 1)
					.duration(1500);
				
				};
			
			setInterval(update, 1000);	
    	</script>
    </body>
</html>