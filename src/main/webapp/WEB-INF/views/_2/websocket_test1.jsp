<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="http://code.jquery.com/jquery-latest.js"></script>
</head>
<body>
	<div>
		<input type="text" id="sender" value="${name}"
			   style="display:none;">
		<input type="text" id="messageinput">
	</div>
	<div>
		<button type="button">Open</button>
		<button type="button">Send</button>
		<button type="button">Close</button>
	</div>
	
	<div id="messages"></div>
	
	<script>
	$(function() {
		var ws;
		$('button:eq(1)').prop('disabled', true);
		$('button:eq(2)').prop('disabled', true);
		
		function send() {
			if($("#messageinput").val() == '') {
				alert("메시지를 입력하세요");
				$("#messageinput").focus();
				return false;
			}
			var text=$("#messageinput").val() +","+$("#sender").val();
			//서버와 연결이 되면 이제부터 데이터를 주고 받을 수 있다.
			// send 메서드를 이용해서 데이터를 서버로 보낼 수 있다.
			ws.send(text); //웹 소켓으로 text를 보낸다. 보내는 형식(내용, 보낸사람)
			text="";
			$("#messageinput").val('');
		}
		function writeResponse(rtext) {
			$("#messages").append("<div></div>");
			$("#messages").find("div").last().text(rtext);
		}
		
		$('button:eq(0)').click(function() {
			if(ws!==undefined && ws.readyState !== WebSocket.CLOSED) {
				writeResponse("WebSocket is already opened");
				return;
			}
			//웹 소켓이 동작하기 위해서 제일 먼저 서버와 연결이 되어야 한다.
			//HTML5에서 제공하는 WebSocket 객체를 통해 서버 연결을 수행한다.
			// 프로토콜은 ws를 사용한다.
			// 웹소켓 객체 만드는 코드
			ws = new WebSocket("ws://localhost:8088/mychat/echo.do");
			$(this).prop('disabled', true);
			$('button:eq(1)').prop('disabled', false);
			$('button:eq(2)').prop('disabled', false);
			//웹 소켓이 연결되었을 때 호출되는 이벤트
			ws.onopen=function(event) {
				console.log('연결이 되었습니다.');
			}
			// 서버에서 전송하는 데이터를 받으려면 message이벤트를 구현하면 된다.
			// 웹 소켓에서 메시지가 날라왔을 때 호출되는 이벤트이다.
			ws.onmessage=function(event) {
				writeResponse(event.data);
			};
			
			//웹 소켓이 닫혔을 때 호출되는 이벤트입니다.
			ws.onclose=function(event) {
				writeResponse("Connection closed");
				$('button:eq(0)').prop('disabled', false);
				$('button:eq(1)').prop('disabled', true);
				$('button:eq(2)').prop('disabled', true);
			}
		});
		$('button:eq(2)').click(function(){
            ws.close();
         });
         
         $('button:eq(1)').click(send);
	})
	</script>
</body>
</html>