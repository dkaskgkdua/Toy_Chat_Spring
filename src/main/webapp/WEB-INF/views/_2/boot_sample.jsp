<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<script
	src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link
	href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
<script
	src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

<meta charset='UTF-8'>
<meta name="robots" content="noindex">
<link rel="shortcut icon" type="image/x-icon"
	href="//production-assets.codepen.io/assets/favicon/favicon-8ea04875e70c4b0bb41da869e81236e54394d63638a1ef12fa558a4a835f1164.ico" />
<link rel="mask-icon" type=""
	href="//production-assets.codepen.io/assets/favicon/logo-pin-f2d2b6d2c61838f7e76325261b7195c27224080bc099486ddd6dccb469b8e8e6.svg"
	color="#111" />
<link rel="canonical"
	href="https://codepen.io/emilcarlsson/pen/ZOQZaV?limit=all&page=74&q=contact+" />
<link
	href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,600,700,300'
	rel='stylesheet' type='text/css'>

<script src="https://use.typekit.net/hoy3lrg.js"></script>
<script>
	//
	$(function() {
		var ws;
		ws = new WebSocket("ws://localhost:8088/chattest/boot.do?id=${name}&filename=${filename}");
		
		function send() {
			if($("#write").val() == '') {
				alert("메시지를 입력하세요");
				$("#write").focus();
				return false;
			}
			var text=$("#write").val();
			//서버와 연결이 되면 이제부터 데이터를 주고 받을 수 있다.
			// send 메서드를 이용해서 데이터를 서버로 보낼 수 있다.
			ws.send(text); //웹 소켓으로 text를 보낸다. 보내는 형식(내용, 보낸사람)
			text="";
			$("#write").val('');
		}
		function writeResponse(rtext) {
			var rtextArray = rtext.split('&');
			alert(rtextArray);
			var appendText = "<li class= 'replies'>"
		 		+ "<img src=resources/upload"+rtextArray[1]+">"
		 		+ "<sup>"+rtextArray[0]+"</sup>"
		 		+ "<p>"+rtextArray[2]+"</p>"
				+ "</li>";
			$(".messages").children('ul').append(appendText);
		}
		
		//admin4&/2020-0-7/bbs20200728040818.png&admin4님이 입장하셨습니다.in
		
		$(".exit").click(function() {
			send("${name}님이 퇴장하셨습니다.out");
			ws.close();
		})
		$(window).on('keyup', function(e) {
			if(e.which ==13) {
				//var message= newMessage();
				var message = $("#write").val();
				if(message) {
					send(message);
				}
				return false;
			}
		})
		
		
		//웹 소켓이 연결되었을 때 호출되는 이벤트
		ws.onopen = function(event) {
			if(event.data === undefined)
				return;
			console.log(event.data);
		};
		
		// 서버에서 전송하는 데이터를 받으려면 message이벤트를 구현하면 된다.
		// 웹 소켓에서 메시지가 날라왔을 때 호출되는 이벤트이다.
		ws.onmessage = function(event) {
			
			writeResponse(event.data);
		};
		
		// 웹 소켓이 닫혔을 때 호출되는 이벤트입니다.
		ws.onclose = function(event) {
			writeResponse(event.data);
			location.href = "logout.net";
		}
	})
</script>
<link rel='stylesheet prefetch'
	href='https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css'>
<link rel='stylesheet prefetch'
	href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.6.2/css/font-awesome.min.css'>
<link rel="stylesheet" href="resources/chat.css">
<style>
#frame .content {
	width: 100%
}

sup {
	/*  position: relative;
    top: -20px;
    right: 30px; */
	top: -10px;
	right: -97%;
	font-size: 3px;
}

.inout {
	text-align: center;
}
</style>
<title>
   boot.jsp
</title>
</head>
<body>
	<div id="frame">
		<div class="content">
			<div class="contact-profile">
				<img src="resources/upload${filename}" alt="" />
				<p id = "name">${name}</p>
				<div class="social-media">
					<i class="fa fa-facebook" aria-hidden="true"></i> <i
						class="fa fa-twitter" aria-hidden="true"></i> <i
						class="fa fa-instagram" aria-hidden="true"></i>
				</div>
			</div>
			<div class="messages">
				<ul>

				</ul>
			</div>
			<div class="message-input">
				<div class="wrap">
					<input type="text" id="write" placeholder="Write your message..." />
					<button class="exit">나가기</button>
				</div>
			</div>
		</div>
	</div>
	<script
		src='//production-assets.codepen.io/assets/common/stopExecutionOnTimeout-b2a7b3fe212eaa732349046d8416e00a9dec26eb7fd347590fbced3ab38af52e.js'></script>

	
</body>
</html>