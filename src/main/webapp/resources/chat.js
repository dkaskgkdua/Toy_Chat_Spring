$(".messages").animate({ scrollTop: $(document).height() }, "fast");

$("#profile-img").click(function() {
	$("#status-options").toggleClass("active");
});

$(".expand-button").click(function() {
  $("#profile").toggleClass("expanded");
	$("#contacts").toggleClass("expanded");
});

$("#status-options ul li").click(function() {
	$("#profile-img").removeClass();
	$("#status-online").removeClass("active");
	$("#status-away").removeClass("active");
	$("#status-busy").removeClass("active");
	$("#status-offline").removeClass("active");
	$(this).addClass("active");
	
	if($("#status-online").hasClass("active")) {
		$("#profile-img").addClass("online");
	} else if ($("#status-away").hasClass("active")) {
		$("#profile-img").addClass("away");
	} else if ($("#status-busy").hasClass("active")) {
		$("#profile-img").addClass("busy");
	} else if ($("#status-offline").hasClass("active")) {
		$("#profile-img").addClass("offline");
	} else {
		$("#profile-img").removeClass();
	};
	
	$("#status-options").removeClass("active");
});

function newMessage() {
	message = $(".message-input input").val();
	if($.trim(message) == '') {
		return false;
	}
	$('<li class="sent"><img src="http://emilcarlsson.se/assets/mikeross.png" alt="" /><p>' + message + '</p></li>').appendTo($('.messages ul'));
	$('.message-input input').val(null);
	$('.contact.active .preview').html('<span>You: </span>' + message);
	$(".messages").animate({ scrollTop: $(document).height() }, "fast");
};

$('.submit').click(function() {
  newMessage();
});

$(window).on('keydown', function(e) {
  if (e.which == 13) {
    newMessage();//화면에 보이는 메시지 전송
    send();//소켓에 보내는 메시지 전송
    return false;
  }
});
	 
	 ws=new WebSocket("ws://localhost:8089/myChat/boot.do" );
	 
     
	 function send(){
         var text=$("#frame > div.content > div.message-input > div > input[type=text]").val()
                +","+$("#sender").val();
         //서버와 연결이 되면 이제부터 데이터를 주고 받을 수 있습니다.
         //send메서드를 이용해서 데이터를 서버로 보낼 수 있습니다.
         ws.send(text);//웹 소켓으로 text를 보냅니다.보내는 형식(내용,보낸사람)
         text="";
     }
     
     function closeSocket(){
         ws.close();
     }
     function writeResponse(text){
    	 
    	 $("#frame > div.content > div.messages > ul")
    	 .append("<li class='replies'>")
    	 .append("<img src='like.png'")
    	 .append("<p>" + text + "</p>");
     }
		 
		 //웹 소켓이 연결되었을 때 호출되는 이벤트
	     ws.onopen=function(event){
	         if(event.data===undefined) return;
	         console.log(event.data);
	         writeResponse(event.data);	         
	     };
	     
	     //서버에서 전송하는 데이터를 받으려면 message이벤트를 구현하면 됩니다.
	     //웹 소켓에서 메시지가 날라왔을 때 호출되는 이벤트입니다.
	     ws.onmessage=function(event){
	    	 alert(event.data);
	         writeResponse(event.data);
	     };
	     
	     //웹 소켓이 닫혔을 때 호출되는 이벤트입니다.
	     ws.onclose=function(event){
	         writeResponse("Connection closed");
	         $this.prop('disabled', false);
	         $('button:eq(1)').prop('disabled', true);
	         $('button:eq(2)').prop('disabled', true)
	     }
	
	
