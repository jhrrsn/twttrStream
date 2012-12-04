<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>D3 Test - Home</title>
        <script type="text/javascript" src="http://d3js.org/d3.v2.js"></script>
    </head>
    <body>
    	<h1>Start Small.</h1>
    	<p>
    	<script type="text/javascript"> 
    		var w = 700;
    		var h = 100;
    		var barPadding = 1;
    		
    		var dataset = {{!nums}};
    		
    		var svg = d3.select("body")
    			.append("svg")
    			.attr("width", w)
    			.attr("height", h);
    			
    		svg.selectAll("rect")
    			.data(dataset)
    			.enter()
    			.append("rect")
    			.attr("x", function(d, i) {
					return i * (w / dataset.length);
				})
				.attr("y", function (d) {
					return h - d * 4;
				})
				.attr("width", w / dataset.length - barPadding)
				.attr("height", function(d) {
					return d * 4;
				});
    	</script>
    </body>
</html>