<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
<style>
body {
	font-family: Arial, Helvetica, sans-serif;
}

/* Full-width input fields */
input[type=text], input[type=password] {
	width: 100%;
	padding: 12px 20px;
	margin: 8px 0;
	display: inline-block;
	border: 1px solid #ccc;
	box-sizing: border-box;
}

/* Set a style for all buttons */
button {
	background-color: #4CAF50;
	color: white;
	padding: 14px 20px;
	margin: 8px 0;
	border: none;
	cursor: pointer;
	width: 100%;
}

button:hover {
	opacity: 0.8;
}

/* Extra styles for the cancel button */
.cancelbtn {
	width: auto;
	padding: 10px 18px;
	background-color: #f44336;
}

/* Center the image and position the close button */
.imgcontainer {
	text-align: center;
	margin: 24px 0 12px 0;
	position: relative;
}

img.avatar {
	width: 30%;
	border-radius: 50%;
}

.container {
	padding: 16px;
}

span.psw {
	float: right;
	padding-top: 16px;
}

/* The Modal (background) */
.modal {
	display: none; /* Hidden by default */
	position: fixed; /* Stay in place */
	z-index: 1; /* Sit on top */
	left: 0;
	top: 0;
	width: 100%; /* Full width */
	height: 100%; /* Full height */
	overflow: auto; /* Enable scroll if needed */
	background-color: rgb(0, 0, 0); /* Fallback color */
	background-color: rgba(0, 0, 0, 0.4); /* Black w/ opacity */
	padding-top: 60px;
}

/* Modal Content/Box */
.modal-content {
	background-color: #fefefe;
	margin: 5% auto 15% auto;
	/* 5% from the top, 15% from the bottom and centered */
	border: 1px solid #888;
	width: 50%; /* Could be more or less, depending on screen size */
}

/* The Close Button (x) */
.close {
	position: absolute;
	right: 25px;
	top: 0;
	color: #000;
	font-size: 35px;
	font-weight: bold;
}

.close:hover, .close:focus {
	color: red;
	cursor: pointer;
}

/* Add Zoom Animation */
.animate {
	-webkit-animation: animatezoom 0.6s;
	animation: animatezoom 0.6s
}

@
-webkit-keyframes animatezoom {
	from {-webkit-transform: scale(0)
}

to {
	-webkit-transform: scale(1)
}

}
@
keyframes animatezoom {
	from {transform: scale(0)
}

to {
	transform: scale(1)
}

}

/* Change styles for span and cancel button on extra small screens */
@media screen and (max-width: 300px) {
	span.psw {
		display: block;
		float: none;
	}
	.cancelbtn {
		width: 100%;
	}
}

#message {
	margin-left: 10%;
}
</style>

<script>
	$(function() {
		var checkid = false;
		$("#id").on(
				'keyup',
				function() {
					$("#message").empty();
					var pattern = /^\w{4,12}$/;
					var id = $("#id").val();
					if (!pattern.test(id)) {
						$("#message").css('color', 'red').html(
								"영문자 숫자 _로 4~12자 가능합니다.");
						checkid = false;
						return;
					}

					$.ajax({
						url : "idcheck.net",
						data : {
							"id" : id
						},
						success : function(rdata) {
							if (rdata == -1) {
								$("#message").css('color', 'green').html(
										"사용 가능한 아이디 입니다.");
								checkid = true;
							} else {
								$("#message").css('color', 'blue').html(
										"사용중인 아이디 입니다.");
								checkid = false;
							}
						}//if
					})
				})
		// 회원가입 유효성 검사
		$('.modal-content').submit(function() {
			if ($('#id').val() == "") {
				alert("ID를 입력하세요");
				$('#id').focus();
				return false;
			}
			if (idCheck == false) {
				alert("ID 중복되었습니다.");
				return false;
			}

			if ($('#password').val() == "") {
				alert("비밀번호를 입력하세요");
				$('#password').focus();
				return false;
			}

		});
		$('input[type=file]').on('change', preview);
		function preview(e) {
			var file = e.target.files[0]; //File객체 리스트에서 첫번째 File객체를 가져온다.

			//file.type : 파일의 형식(MIME타입 - 예) text/html)
			if (!file.type.match('image.*')) { //파일타입이 image인지 확인한다.
				alert("확장자는 이미지 확장자만 가능합니다.");
				return;
			}
			var reader = new FileReader();

			//DataURL 형식으로 파일을 읽어온다.
			// 읽어온 결과는 reader 객체의 result 속성에 저장된다.
			reader.readAsDataURL(file);

			// 읽기에 성공 했을 때 실행되는 이벤트 핸들러
			reader.onload = function(e) {
				//result : 읽기 결과가 저장된다.
				//reader.result 또는 e.target.result
				$("img").attr('src', e.target.result);
			} //reader.onload end
		}
	})
</script>
</head>
<body>
	<form class="modal-content animate" method="post" action="joinProcess"
		enctype="multipart/form-data">
		<div class="imgcontainer">
			<label> <input type="file" name="uploadfile"
				accept="image/gif, image/jpeg, image/png" style="display: none">
				<img src="resources/img_avatar2.png" alt="Avatar" class="avatar">
			</label>
		</div>
		<div class="container">
			<label for="uname"><b>Username</b><span id="message"></span></label>
			<input type="text" placeholder="Enter Username" name="id" id="id"
				required> <label for="psw"><b>Password</b></label> <input
				type="password" placeholder="Enter Password" name="password"
				required>
			<button type="submit">회원가입</button>
		</div>
	</form>
</body>
</html>