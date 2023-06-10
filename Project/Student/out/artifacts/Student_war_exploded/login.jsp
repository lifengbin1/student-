<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta charset="utf-8"/>
<title>学生信息管理系统</title>
<script src="js/jquery-1.8.3.min.js" type="text/javascript"></script>
<script src="js/login.js" type="text/javascript"></script>
<link href="css/style.css" rel="stylesheet" type="text/css">
</head>
<body>
	<center id="login-wrap">
		<div class="login">
			<div class="login_head">
				<h3>登录</h3>
			</div>
			<div class="login_window">
				<div class="input-wrap">
					<input required class="input-text" type="text" name="ope_name"
						id="ope_name" autocomplete="off">
					<label class="input-label" for="ope_name">账号</label>
				</div>
				<div class="input-wrap">
					<input required class="input-text" type="password" name="ope_pwd"
						id="ope_pwd" autocomplete="off">
					<label class="input-label" for="ope_pwd">密码</label>
				</div>
				<input
					class="btn"
					type="button" value="登录" onclick="login()">
			</div>
		</div>
	</center>
</body>
</html>