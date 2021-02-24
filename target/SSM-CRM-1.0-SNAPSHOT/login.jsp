<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script>
		$(function () {

			if(window.top!=window){
				window.top.location=window.location;
			}

			//清空文本框
			$("#loginAct").val("");

			// 获取焦点
			$("#loginAct").focus();

			//为按钮添加点击事件
			$("#loginBtn").click(function () {
				Login();
			})



		})
		function Login() {

			var loginAct = $.trim($("#loginAct").val());
			var loginpwd = $.trim($("#loginPwd").val());

			var json={
				"loginAct":loginAct,
				"loginpwd":loginpwd
			};
			var jsonstr= JSON.stringify(json);

			if(loginAct=="" || loginpwd ==""){
				$("#msg").html("账号密码不能为空");
				return false;
			}

			$.ajax({
				url:"${pageContext.request.contextPath}/user/userLogin",
				data:jsonstr,
				type:"post",
				contentType:"application/json;charset=utf-8",
				dataType:"json",
				success:function (data) {
						/*
						需要后端传过来一个标志位，判定是否登录成功。
						和一个错误信息，来进行判断是哪里出错了		{"success":true/false,"msg":错误信息}				*/
						if(data.success){
							window.location.href="workbench/index.jsp";

						}else{
							$("#msg").html(data.msg)
						}
				}
			})


		}
	</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
	</div>



	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="${pageContext.request.contextPath}/user/userLogin" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" id="loginAct">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码" id="loginPwd">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: red;"></span>
						
					</div>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>