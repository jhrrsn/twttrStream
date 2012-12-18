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
        		font-size : 16px;
        		text-transform:none;
        	}
        	
        	.date
        	{
        		display : inline-block;
        		margin:0 auto;
        		width: 200px;
        		border : 0px;
        		margin-bottom : 10px;
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
        	}
        	
        	.tag.selected
        	{
        		background-color : #00acf3;
        	}
        	
        	h1 
        	{
        		font-size : 28px;
        		margin : 0px;
        		margin-bottom : 30px;
        		margin-top: 20px;
        	}
        	
        	h3
        	{
        		font-weight : lighter;
        		font-size: 13px;
        	}
        	
        	.twitterblue
        	{
        		color : #00acf3;
        	}
        	
        	.darkblue
        	{
        		color : #0076a7;
        	}
        	
        	.bbcred
        	{
        		color : #900000;
        		text-decoration:none;
        	}
        	
        	#go
        	{
        		color : #00acf3;
        		font-size : 100px;
        		font-weight : bold;
        	}
        	
        	#go.multi_article
        	{
        		color : #00acf3;
        		font-size: 20px;
        		padding-top : 40px;
        		padding-bottom : 40px;
        	}
        </style>
        <script type="text/javascript">
        var searchTerms;
        	// When a 'tag' div is clicked, toggle the 'selected' class.
        	// Update the 'searchTerms' variable to hold the value of each selected 'tag'.
        	$(function() {
				$('.tag').click(function(){
					$(this).toggleClass("selected");
					searchTerms = $("div.tag.selected").text();
					if ($('div.tag.selected').parent().children(".date").text().split(" ").length > 4) {
						$('#go').text("Please select tags from only one article.");
						$('#go').addClass("multi_article");
					} else {
						$('#go').text("GO");
						$('#go').removeClass("multi_article");
					};
				});
				
				// When 'GO' is clicked, submit the form and pass the 'searchTerms' variable back to Bottle.
				$('#go').click(function(){
					if (!$('#go').hasClass("multi_article")) {
						var article_date = $('div.tag.selected').parent().children(".date").text()
						console.log(searchTerms);
						searchTerms += article_date;
						$("input#terms").val(searchTerms);
						console.log($("input#terms").val());
						$('form#search').submit();
					}		
				});
			});
        </script>
    </head>
    <body align="center" marginwidth="0" marginheight="0">
    	<div>
			<br>
			<h1 class = "darkblue">TWITTER KEYWORD SEARCH: <small>BBC NEWS EDITION</small></h1>
			<h3><small>GEOGRAPHICAL COVERAGE:</small> <b>UK & IRELAND</b></h3>
			<h3><small>NEWS SOURCE:</small> <a href="http://www.bbc.co.uk/news/uk/" class="bbcred"><b>BBC NEWS (UK)</b></a></h3>
			<img src="https://twitter.com/images/resources/twitter-bird-light-bgs.png" width="100" height="100">
			<br>
			<h3> <b>Instructions</b> </h3>
			<b>1.</b> <small>scroll down to find an interesting news story</small><br>
			<b>2.</b> <small>click to select tags that might be relevant to the story</small><br>
			<b>3.</b> <small>hit the big blue go button at the bottom of the page</small><br>
			<p> <br>
			<p>
			
			%for entry in entries:
			<div class = "entry">
				<p>
				<a href={{entry[3]}} class="bbcred"><b>{{entry[0]}}</b></a>
				<br>
				<div class = "date"> <small>{{entry[2]}}</small> </div>
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