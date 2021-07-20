<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, intitial-scale=1.0">
	<script src="https://code.jquery.com/jquery-3.3.1.js"
        integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60="
        crossorigin="anonymous">
    </script>
    
    <style>
    	.container {
    		width: 560px;
    		background-color: #fff;
    		margin: 0 auto;
    	}
    	
    	section {
            position: fixed;
            text-align: center;
            width: 560px;
            background-color: #fff; 
        }
        main {
        	/* padding: 350px 10px 20px; */        
        	padding: 20px 10px 20px;
        }
        body { 
        	background-color: #eee;
        }
        main {
        	background-color: #fff;
        }
        .ytp-pause-overlay{
        	display: none;
        }
    </style>
</head>
<body>
	<div class="container">
		<section id="video">
		
		</section>
		
		<main>
			<form action="addok" method="post">
				<input type="hidden" name="youtubeID" id="youtubeID" value="">
				start time:  <input type="text" name="start_s" id="start_s"> <button onclick="getCurrentPlayTime1()" type="button";> current Time</button> <br>
				end time: <input type="text" name="end_s" id="end_s"> <button onclick="getCurrentPlayTime2()" type="button";> current Time</button> <br>
				playlist num: <input type="text" name="playlistID" >
				
				<button type="submit"> submit </button>
			</form>
		</main>
		
		<form action="list" method="post">
			Choose playlist No: <input type="text" name="playlistID"> 
			<button type="submit"> submit </button>
		</form>
		
		<p> show list of videos that are in playlistID == ${list[0].playlistID } </p>
		
		<c:forEach items="${list }" var="u">
			<c:out value="${u.youtubeID }"/>
			<c:out value="${u.start_s }"/>
			<c:out value="${u.end_s }"/>
			
			<c:set var="start" value="${Math.round (u.start_s)}" />
			<c:set var="end" value="${Math.round (u.end_s)}" />
			<div>
				<iframe width="560" height="315" src="https://www.youtube.com/embed/${u.youtubeID}?start=${start }&end=${end}" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen>
				</iframe>
				
			</div>
		</c:forEach>
		
	</div>
	
	<script>
		$(document).ready(function () {
			var key = 'AIzaSyC0hiwYHhlDC98F1v9ERNXnziHown0nGjg';
			var URL = 'https://www.googleapis.com/youtube/v3/videos';

			// youtube search가 되면, 그 동영상 id를 jsp에서 자바스크립트를 호출해서 options.id값을 설정해주도록 해야함.
			//  
			var options = {
				part: 'contentDetails',
				id: 'wzAWI9h3q18',
				key: key
			}

			getVidPT();

			function getVidPT() {
				$.getJSON(URL, options, function(data) {
					console.log(data);
					var pt = data.items[0].contentDetails.duration;

					// https://stackoverflow.com/questions/22148885/converting-youtube-data-api-v3-video-duration-format-to-seconds-in-javascript-no
			        var regex = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/;
			        var regex_result = regex.exec(pt); //Can be anything like PT2M23S / PT2M / PT28S / PT5H22M31S / PT3H/ PT1H6M /PT1H6S
			        var hours = parseInt(regex_result[1] || 0);
			        var minutes = parseInt(regex_result[2] || 0);
			        var seconds = parseInt(regex_result[3] || 0);
			        var total_seconds = hours * 60 * 60 + minutes * 60 + seconds;

			       /*  var start = 10;
			        var end = 15; */
			        document.getElementById("start_s").value = 20;
			        document.getElementById("end_s").value = total_seconds;
			        document.getElementById("youtubeID").value = options.id;
				})
			}
			console.log(options);
			//mainVid(options.id);
			

			/* function mainVid(id) {
				$('#video').html('
					<iframe width="560" height="315" src="https://www.youtube.com/embed/${id}?start=${start}&end=${end}" frameboder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
				');

			} */


			// The below code is not used anymore;
			function mainVid(id) {
				var start = 20;
				var end = 25;
				console.log(`see ==> \${id}`);
				/* console.log("look here => " , options.id , "hehe"); */
				$('#video').html(`
				<iframe width="560" height="315" src="https://www.youtube.com/embed/\${id}?start=\${start}&end=\${end}" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen>
				</iframe>`);
			    console.log(`"https://www.youtube.com/embed/\${id}?start=\${start}&end=\${end}"`);	
			}
				
		});
		
		// 1. ytplayer code: https://developers.google.com/youtube/player_parameters#IFrame_Player_API
		var tag = document.createElement('script');
		  tag.src = "https://www.youtube.com/player_api";
		  var firstScriptTag = document.getElementsByTagName('script')[0];
		  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
		  var player;
		  
		  function onYouTubePlayerAPIReady() {
		    player = new YT.Player('video', {
		      height: '315',
		      width: '560',
		      //videoId: 'wzAWI9h3q18',
		      
		      // rel: 0 will not work due to Youtube policy issues. (as of 2018/9/25) 
		      playerVars: {rel: 0},
		      events: {
			      'onReady' : onPlayerReady,
				}
		    });
		  }

		function onPlayerReady() {
			//event.target.playVideo();
			// 2. options.id, startSeconds, endSeconds should come from DB later. 
			player.loadVideoById({'videoId': 'wzAWI9h3q18', 'startSeconds': 22.9092, 'endSeconds': 49.1089});
		} 
		  
		  
		// 3. get player.playerInfo.currentTime
		function getCurrentPlayTime1(){
			document.getElementById("start_s").value = player.playerInfo.currentTime;
			//alert(vid.currentTime);
		}
		function getCurrentPlayTime2(){
			document.getElementById("end_s").value = player.playerInfo.currentTime;
			//alert(vid.currentTime);
		}

		/* this does not work:
		var ytplayer;
		function getCurrentPlayTime(){
			ytplayer = document.getElementById("video");
			console.log(ytplayer.currentTime);
			//alert(vid.currentTime);
		} */
		
	</script>
</body>
</html>
