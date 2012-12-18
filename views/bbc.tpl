<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>BBC News Keyword Search</title>
		<script type="text/javascript" src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
        <style type="text/css">
        	html, body
        	{
        		font-family : sans-serif;
        		font-size : 14px;
        		margin : 0px;
        		padding : 0px;
        		margin-top: 0px;
        		background-color : #fafafa;
        		text-transform:uppercase;
        	}
        	
        	div
        	{
        		width : 850px;
        		height : 100%;
        		margin:0 auto;
        		background-color : #f0f0f0;
        		border-left : 1px dotted #999999;
        		border-right : 1px dotted #999999;
        	}
        	
        	.entry
        	{
        		width : 70%;
        		margin: 0 auto;
        		margin-bottom: 35px;
        		border : 0px;
        		border-top: 1px dotted #999999;
        		font-weight : lighter;
        		font-size : 14px;
        		text-transform:uppercase;
        	}
        	
        	.tag
        	{
        		display : inline-block;
        		background-color : #d8d8d8;
        		width: 100px;
        		padding: 5px 0;
        		margin : 0px;
        		margin-top : 10px;
        		border : 0px;
        		font-size: 12px;
        		font-weight: normal;
        		text-transform:uppercase;
/*         		color : #00acf3; */
        	}
        	
        	.tag.selected
        	{
        		background-color : #00acf3;
        	}
        	
        	h1 
        	{
        		font-size : 24px;
        		margin : 0px;
        	}
        	
        	h3
        	{
        		font-weight : lighter;
        		font-size: 15px;
        	}
        	
        	.twitterblue
        	{
        		color : #00acf3;
        	}
        	
        	#go
        	{
        		color : #00acf3;
        		font-size : 100px;
        		font-weight : bold;
        	}
        </style>
        <script type="text/javascript">
        var searchTerms;
        
        	$(function() {
				$('.tag').click(function(){
					$(this).toggleClass("selected");
					searchTerms = $("div.tag.selected").text();
				});
				$('#go').click(function(){
					$("input#terms").val(searchTerms);
					console.log($("input#terms").val());
					$('form#search').submit();				
				});
			});
        </script>
    </head>
    <body align="center" marginwidth="0" marginheight="0">
    	<div>
			<br>
			<h1 class = "twitterblue">TWITTER KEYWORD SEARCH: <small>BBC NEWS EDITION</small></h1>
			<h3><small>GEOGRAPHICAL COVERAGE:</small> <b>UK & IRELAND</b></h3>
			<h3><small>NEWS SOURCE:</small> <a href="http://www.bbc.co.uk/news/uk/"><b>BBC NEWS (UK)</b></a></h3>
			<img src="https://twitter.com/images/resources/twitter-bird-light-bgs.png" width="100" height="100">
			<br>
			<h3> Instructions </h3>
			<b>1. <small>scroll down to find an interesting news story</small></b><br>
			<b>2. <small>click to select tags that might be relevant to the story</small></b><br>
			<b>3. <small>hit the big blue go button at the bottom of the page</small></b><br>
			<p> <br>
			<p>
			
			%for entry in entries:
			<div class = "entry">
				<p>
				<a href={{entry[3]}}><b>{{entry[0]}}</b></a>
				<br>
				<small>{{entry[2]}}</small>
				<br>
				% for tag in entry[1]:
				<div class = "tag">
					{{tag}}
				</div>
				%end
			</div>
			%end
			<p>
			<div id = "go">
			GO
			</div>
			<p>
			<form action = "/search" method = "post" style="display:none" id="search">
			<input type = "text" name = "keywords" size = "0" value = "" id="terms">
		</div>
    </body>
</html>