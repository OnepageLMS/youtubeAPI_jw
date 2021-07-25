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
        	background-color: #fff;
        }
        body { 
        	background-color: #eee;
        }
        .ytp-pause-overlay{
        	display: none;
        }
        article {
			display: flex;
			align-items: center;
			padding: 8px 12px;
			border: 2px solid white;
			border-radius: 8px;
			margin: 0 auto;
		}
		article:hover {
			border: 2px solid #ff9999;
		}
		.thumb {
			height: 70px;
			border-radius: 4px;
		}
		.details {
			padding: 8px 22px;
		}
    </style>
<script type="text/javascript">
function showList(data){
    //$.each(data.items, function (i, item) {

        var thumb = data.items[0].snippet.thumbnails.medium.url;
        var title = data.items[0].snippet.title;
        var desc = data.items[0].snippet.description.substring(0, 100);
        var vid = data.items[0].id;
        
        $('main').append(`
						<article class="item" data-key="\${vid}">

							<img src="\${thumb}" alt="" class="thumb">
							<div class="details">
								<h4>\${title}</h4>
								<p>\${desc}</p>
							</div>

						</article>
					`);
		console.log(2);
   // });
}

function resultsLoop(videoId) {
	var key = 'AIzaSyC0hiwYHhlDC98F1v9ERNXnziHown0nGjg';
	var URL = 'https://www.googleapis.com/youtube/v3/videos';

	// youtube search가 되면, 그 동영상 id를 jsp에서 자바스크립트를 호출해서 options.id값을 설정해주도록 해야함.
	//  
	var options = {
		part: 'contentDetails, snippet',
		id: videoId,
		key: key
	}
	$.getJSON(URL, options, function(data) {
		//console.log(data);
		showList(data);
	});
	console.log(111);
}

/* //CLICK EVENT
$('main').on('click', 'article', function () {
    var id = $(this).attr('data-key');
   	console.log("click id" , id);
    mainVid(id);
}); */

function savePlaylist(event){		
		event.preventDefault(); // avoid to execute the actual submit of the form.

		var form = $('#savePlaylistForm');
		var url = form.attr('action');
		
		$.ajax({
			'type': "POST",
			'url': "http://localhost:8080/myapp/addok",
			'data': form.serialize(),
			success: function(data) {
				alert("saved successfully!");
				console.log("saved succes");
			},
			error: function(error) {
				alert(error);
			},
		});
		return false;
}

</script>

</head>

<body>
	<div class="container">
		<section id="video">
		
		</section>
		
			<form id="savePlaylistForm" onsubmit="return validation(event)" >
				<input type="hidden" name="youtubeID" id="youtubeID">
				<input type="hidden" name="start_s" id="start_s">
				<input type="hidden" name="end_s" id="end_s">
				video title: <textarea rows="2" cols="50" name="title" id="title" style="margin-bottom: 10px;"> </textarea> <br> 
				<button onclick="getCurrentPlayTime1()" type="button"> start time </button> : <input type="text" id="start_hh" maxlength="2" size="2"> 시 <input type="text" id="start_mm" maxlength="2" size="2"> 분 <input type="text" id="start_ss" maxlength="5" size="5"> 초 <button onclick="seekTo1()" type="button"> 위치이동 </button><span id=warning1 style="color:red;"></span> <br>
				<button onclick="getCurrentPlayTime2()" type="button"> end time </button> : <input type="text" id="end_hh" max="" maxlength="2" size="2"> 시 <input type="text" id="end_mm" max="" maxlength="2" size="2"> 분 <input type="text" id="end_ss" maxlength="5" size="5"> 초 <button onclick="seekTo2()" type="button"> 위치이동 </button> <span id=warning2 style="color:red;"></span> <br>
				playlist num: <input type="text" name="playlistID" required>
				
				<button type="submit" > submit </button>
				<!-- id="btn-submit" disabled="disabled" -->
			</form>
			
		
		<form action="list" method="post">
			Choose playlist No: <input type="text" name="playlistID"> 
			<button type="submit"> submit </button>
		</form>
		
		<p> show list of videos that are in playlistID == ${list[0].playlistID } </p>
		
		
		<c:set var="i" value="${1}" /> 
		<c:forEach items="${list }" var="u">
			<%-- <c:out value="${u.youtubeID }"/>
			<c:out value="${u.start_ss }"/>
			<c:out value="${u.end_ss }"/> --%>
			
			<!-- html로 유투브 영상을 만드려고 할 시에는 소수점은 안되고 온전한 초 단위로만 구간 설정이 안된다.   -->
			<c:set var="start" value="${Math.round (u.start_ss)}" />
			<c:set var="end" value="${Math.round (u.end_ss)}" />
			<%-- <div>
				<iframe width="560" height="315" src="https://www.youtube.com/embed/${u.youtubeID}?start=${start }&end=${end}" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen>
				</iframe>
				<!-- <script>
					resultsLoop(${u.youtubeID});
				</script> -->
				<img style="width: 100px; height: auto;" src="https://img.youtube.com/vi/${u.youtubeID}/0.jpg"/>
				
			</div> --%>
			<c:out value="${i}" /> 
			<c:set var="i" value="${i+1}" />
			
			<script>
					//console.log("look:::" + `${u.youtubeID}`);
					resultsLoop(`${u.youtubeID}`);
			</script>
			<main>
				
			</main>
		</c:forEach>
		
	</div>
	
	<script>
		var pt;
		var limit; // for validity check: end time should be less than total duration.
		var start_time, end_time;
		
		$(document).ready(function () {
			var key = 'AIzaSyC0hiwYHhlDC98F1v9ERNXnziHown0nGjg';
			var URL = 'https://www.googleapis.com/youtube/v3/videos';

			// youtube search가 되면, 그 동영상 id를 jsp에서 자바스크립트를 호출해서 options.id값을 설정해주도록 해야함.
			//  
			var options = {
				part: 'contentDetails, snippet',
				id: 'wzAWI9h3q18',
				key: key
			}

			getVidPT();

			function getVidPT() {
				$.getJSON(URL, options, function(data) {
					console.log(data);
					pt = data.items[0].contentDetails.duration;

					// https://stackoverflow.com/questions/22148885/converting-youtube-data-api-v3-video-duration-format-to-seconds-in-javascript-no
			        var regex = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/;
			        var regex_result = regex.exec(pt); //Can be anything like PT2M23S / PT2M / PT28S / PT5H22M31S / PT3H/ PT1H6M /PT1H6S
			        var hours = parseInt(regex_result[1] || 0);
			        var minutes = parseInt(regex_result[2] || 0);
			        var seconds = parseInt(regex_result[3] || 0) - 1;

			        document.getElementById("end_hh").value = hours;
			        document.getElementById("end_mm").value = minutes;
		        	document.getElementById("end_ss").value = seconds;
		        	
			        var total_seconds = hours * 60 * 60 + minutes * 60 + seconds;

					// validty check: 
			        limit = parseInt(total_seconds);
			        console.log(limit);

					document.getElementById("title").value = data.items[0].snippet.title;

					// 시작 시간을 여기서 정함...수정 요망: 
			        document.getElementById("start_ss").value = 22;
			        
			        //$("end_s").attr("max", total_seconds);
			        document.getElementById("youtubeID").value = options.id;

					//resultsLoop(data);
				})
			}
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
			// 2. options.id, startSeconds, endSeconds should come from DB later. 
			player.loadVideoById({'videoId': 'wzAWI9h3q18', 'startSeconds': 22.9092, 'endSeconds': 29.1089});
		} 

		var playtime1, playtime2;
		
		// 3. get player.playerInfo.currentTime
		function getCurrentPlayTime1(){	
			var d = Number(player.getCurrentTime());
			var h = Math.floor(d / 3600);
			var m = Math.floor(d % 3600 / 60);
			var s = d % 3600 % 60;
		
			document.getElementById("start_ss").value = parseFloat(s).toFixed(2);
			document.getElementById("start_hh").value = h;/* .toFixed(2); */
			document.getElementById("start_mm").value = m;/* .toFixed(2); */

			document.getElementById("start_s").value = parseFloat(d).toFixed(2);
			start_time = parseFloat(d).toFixed(2);
			start_time *= 1.00;
			console.log("check:", typeof start_time);
		}
		function getCurrentPlayTime2(){
			var d = Number(player.getCurrentTime());
			var h = Math.floor(d / 3600);
			var m = Math.floor(d % 3600 / 60);
			var s = d % 3600 % 60;
		
			document.getElementById("end_ss").value = parseFloat(s).toFixed(2);
			document.getElementById("end_hh").value = h;/* .toFixed(2); */
			document.getElementById("end_mm").value = m;/* .toFixed(2); */

			document.getElementById("end_s").value = parseFloat(d).toFixed(2);
			end_time = parseFloat(d).toFixed(2);
			end_time *= 1.00;
			console.log("check", typeof end_time);
		}
		/* window.onclick = function() {
			console.log("start", start_time);
			console.log("end", end_time);
			console.log(typeof start_time);
			console.log(typeof end_time);
			console.log(typeof limit);
			//alert("여봐라 ");
		} */
		function validation(event){
			document.getElementById("warning1").innerHTML = "";
			document.getElementById("warning2").innerHTML = "";	

			// 사용자가 input에서 수기로 시간을 변경했을 시에 필요. 
			var start_hh = $('#start_hh').val();
			var start_mm = $('#start_mm').val();
			var start_ss = $('#start_ss').val();

			start_time = start_hh * 3600.00 + start_mm * 60.00 + start_ss * 1.00;
			$('#start_s').val(start_time); 

			var end_hh = $('#end_hh').val();
			var end_mm = $('#end_mm').val();
			var end_ss = $('#end_ss').val();
			
			end_time = end_hh * 3600.00 + end_mm * 60.00 + end_ss * 1.00;
			$('#end_s').val(end_time);

			console.log("start= ", start_time);
			console.log("end= ", end_time);
			
			if(start_time > end_time) {
				document.getElementById("warning1").innerHTML = "start time cannot exceed end time";
				document.getElementById("start_ss").focus();
				return false;
			}
			if(end_time > limit){
				//console.log("value of x: "+ x);
				document.getElementById("warning2").innerHTML = "Please insert again";
				document.getElementById("end_ss").focus();
				return false;
			}
			else {
				return savePlaylist(event);
			}
		}
		function seekTo1(){
			// 사용자가 input에서 수기로 시간을 변경했을 시에 필요. 
			var start_hh = $('#start_hh').val();
			var start_mm = $('#start_mm').val();
			var start_ss = $('#start_ss').val();

			start_time = start_hh * 3600.00 + start_mm * 60.00 + start_ss * 1.00;
			player.seekTo(start_time);	
		}	
		function seekTo2(){
			var end_hh = $('#end_hh').val();
			var end_mm = $('#end_mm').val();
			var end_ss = $('#end_ss').val();
			
			end_time = end_hh * 3600.00 + end_mm * 60.00 + end_ss * 1.00;
			player.seekTo(end_time);	
		}		
	</script>
</body>
</html>
