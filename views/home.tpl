<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Twitter Keyword Search</title>
		<script type="text/javascript" src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
        <style type="text/css">
        	html, body
        	{
        		font-family : sans-serif;
        		font-size : 12px;
        		margin : 0px;
        		padding : 0px;
        		margin-top: 0px;
        		background-color : #fafafa;
        	}
        	
        	div
        	{
        		width : 850px;
        		height : 800px;
        		margin:0 auto;
        		background-color : #f0f0f0;
        		border-left : 1px dotted #999999;
        		border-right : 1px dotted #999999;
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
        </style>
    </head>
    <body align="center" marginwidth="0" marginheight="0">
    	<div>
			<br>
			<h1>The Fantastical, Historical & Geographical Twitter Keyword Profiler</h1>
			<h3>Geographical Coverage: <b>United Kingdom</b></h3>
			<img src="https://twitter.com/images/resources/twitter-bird-light-bgs.png" width="100" height="100">
			
			<br>
			Enter a <b>keyword</b> and hit <b>return.</b>
			<p>
			<form action = "/results" method = "post">
			<input type = "text" name = "keyword" size = "12" value = "">
		</div>
    </body>
</html>