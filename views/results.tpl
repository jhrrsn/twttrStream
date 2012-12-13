<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Twitter Keyword Search</title>
        <link rel="stylesheet" href="http://code.jquery.com/ui/1.9.2/themes/base/jquery-ui.css" />
        <script type="text/javascript" src="http://d3js.org/d3.v2.js"></script>
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
        <script type="text/javascript" src="http://code.jquery.com/ui/1.9.2/jquery-ui.js"></script>
        <style type="text/css">
        	html, body
        	{
        		font-family : sans-serif;
        		margin : 0px;
        		padding : 0px;
        		margin-top: 0px;
        		background-color : #fafafa;
        	}
        	
        	#main
        	{
        		width : 62%;
        		margin : 0 auto;
        		background-color : #f0f0f0;
        		border-left : 1px dotted #999999;
        		border-right : 1px dotted #999999;
        	}
        	
        	#sidebar
        	{
				font-weight : bold;
				position:absolute;
				top:120px;
				left:22%;
				width:35%;
        	}
        	
        	#map
        	{
				position:absolute;
				top:0px;
				right:25%;
        	}
        	
        	#controls
        	{
        		position:relative;
        		top:80%;
        		margin:0 auto;
        	}
        	
        	#slider
        	{
        		width : 320px;
        		margin : 0 auto;
        	}
        	#slider-values
        	{
        		font-weight : bold;
        		display: inline-block;
        	}
        	
        	#min
        	{
				display: inline-block;
				color : #00acf3;
				margin-right: 10px;
        	}
        	
        	#max
        	{
        		display: inline-block;
        		color : #00acf3;
        		margin-left: 5px;
        	}
        	
        	svg
        	{
        		background-image:url('http://oi48.tinypic.com/2uiks45.jpg'); /*black: http://oi48.tinypic.com/21l7leg.jpg*/
        		background-size: 100% 100%;
        		margin : 0px;
        		padding : 0px;
        		
        	}
        	
        	.stupidbig
        	{
        		color : #00acf3;
        	}
        </style>
        
        <!-- Slider script (jQuery UI method) -->
		<script type="text/javascript">
				var initTimestamps = function() {
					$( "#min" ).html(formatTime({{minTime}}) + " ");
					$( "#max" ).html(" " + formatTime({{maxTime}}));
				}
				var formatTime = function(uTime) {
					var date = new Date(uTime*1000);
					var day = date.getDate();
					var month_numerical = date.getMonth();
					var month;
					switch(month_numerical) {
						case 0:
						  month = "JAN";
						  break;
						case 1:
						  month = "FEB";
						  break;
						case 2:
						  month = "MAR";
						  break;
						case 3:
						  month = "APR";
						  break;
						case 4:
						  month = "MAY";
						  break;
						case 5:
						  month = "JUN";
						  break;
						case 6:
						  month = "JUL";
						  break;
						case 7:
						  month = "AUG";
						  break;
						case 8:
						  month = "SEP";
						  break;
						case 9:
						  month = "OCT";
						  break;
						case 10:
						  month = "NOV";
						  break;
						case 11:
						  month = "DEC";
						  break;
					}
					var fullYear = date.getFullYear().toString();
					var year = fullYear.substring(2,4)
					var hours = date.getHours();
					if (hours < 10) { hours = "0" + hours; };
					var minutes = date.getMinutes();
					if (minutes < 10) { minutes = "0" + minutes; };
					var formattedTime = hours + ':' + minutes + " <small>ON</small> " + day + " " + month + " '" + year;
					return formattedTime;
				}
				$(function() {
					$( "#slider" ).slider({
						range: true,
						min: 0,
						max: 500,
						values: [ 0, 500 ],
						stop: function( event, ui ) {
							var min = (minTime + (timeRange * ($("#slider").slider("values", 0)/500)));
							var max = (minTime + (timeRange * ($("#slider").slider("values", 1)/500)));
							update(min, max);
							$( "#time" ).val( min + ", " + max );
							$( "#min" ).html(formatTime(min) + "   ");
							$( "#max" ).html("   " + formatTime(max));
						}
					});
				});
				
				$(function(){
					$('div#main').css({'height':$(window).height() + 'px'});
					$('div#sidebar').css({'top':$("svg").height() * 0.22 + 'px'});
					$('body').css({'font-size':Math.floor($(window).height() * 0.02)});
					var bigFont = Math.floor($(window).height() * 0.04);
					$('.stupidbig').css({'font-size': bigFont});
					$('div#min').css({'font-size': bigFont/1.5});
					$('div#max').css({'font-size': bigFont/1.5});
				});
		</script>		
    </head>
    <body align="center" onload="initTimestamps();">
    	<div id="main">  	
			<!-- Sidebar information -->
			
			<div id="sidebar">
				<br>
				<img src="https://twitter.com/images/resources/twitter-bird-light-bgs.png" width="50" height="50">
				<br>
				THE NUMBER OF TWEETS WITH THE KEYWORD
				<p>
				<div class="stupidbig"> {{keyword}} </div>
				<p>
				IS
				<p>
				<div class="stupidbig" id="background"> {{results}} </div>
			</div>
			
			
			<!-- D3 script (map) -->
			
			<div id="map"> 
				<script type="text/javascript">
				var w = $("div#main").width() * 0.47 ;
				var h = w * 1.375;
				var coords = {{!coords}};
				var maxTime = {{maxTime}};
				var minTime = {{minTime}};
				var maxDisplay = maxTime;
				var minDisplay = minTime;
				var timeRange = maxTime - minTime;
	
				var xScale = d3.scale.linear()
					.domain([-11.6, 2.6])
					.range([0, w])
					.clamp(true);
	
				var yScale = d3.scale.linear()
					.domain([49.5, 61.3])
					.range([h+9, 14])
					.clamp(true);
				
				var svg = d3.select("div#map")
					.append("svg")
					.attr("width", w)
					.attr("height", h);
					
				svg.selectAll("circle")
					.data(coords)
					.enter()
					.append("circle")
					.attr("cx", function(d) {
						return xScale(d[1]);
					})
					.attr("cy", function(d) {
						return yScale(d[0]);
					})
					.attr("r", 1)
					.attr("fill", "#00acf3")
					.attr("lat", function(d) {return d[0];})
					.attr("lon", function(d) {return d[1];});
										
					
				var update = function(minT, maxT) {
				
					var points = svg.selectAll("circle");

					points.data(coords)
						.transition()
						.duration(1000)
						.attr("cx", function(d) {
							return xScale(d[1]);
						})
						.attr("cy", function(d) {
							return yScale(d[0]);
						})
						.attr("r", 1)
						.attr("fill", function(d) {
							if (d[2] < minT || d[2] > maxT) {
								return "lightgrey";
							} else {
								return "#00acf3";
							}
						});
					}
				</script>
			</div>
			
			
			<!-- Controls -->
			
			<div id="controls">
				<br>
				<div id="slider-values">
					<div id="min" class="stupidbig"></div> 
				TO 
					<div id="max" class="stupidbig"></div>
				</div>
				<p>
				<div id="slider"></div>
				<p>
				<FORM><INPUT TYPE="button" VALUE="Search Again" onClick="window.location.href='/'"></FORM>
			</div>
			
    	</div>
    </body>
</html>