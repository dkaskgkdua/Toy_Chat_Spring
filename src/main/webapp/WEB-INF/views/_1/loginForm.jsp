<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
    .container{width:50%;border:1px solid lightgray;
               padding:20px;margin-top:20px}
</style>
<meta charset="UTF-8">
<title>title</title>
</head>
<body>
   <div class ="container">
  <form method ="post" action = "login_ok.do" name = "myform" id ="myform"> 
 	<table border = 1>
 		<tr>
 			<td>이름</td>
 			<td><input type=text name=name></td>
 		</tr>
 		<tr>
 			<td colspan="2"><input type="submit" value="로그인"></td>
 		</tr>
 	</table>
    </form>
    </div>
</body>
</html>