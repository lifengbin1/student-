function login()
{
	var url = "/Student/LoginServlet?type=login&ope_name=";
	url += $("#ope_name").val() + "&ope_pwd=" + $("#ope_pwd").val();
	$.post(url, null, function(rs)
	{
		if (rs == "success")
			window.open("/Student/pages/index.jsp", "_self");
		else
			alert(rs);
	});
}

function logout()
{
	$.post("/Student/LoginServlet?type=logout");
	alert("注销成功！");
	window.parent.location.reload();
}

document.onkeydown = function(event)
{
	var e = event || window.event || arguments.callee.caller.arguments[0];
	if (e && e.keyCode == 13)
		login();
};

$(function()
{
	$("#ope_name").focus();
	$("#dou").click(function()
	{
		alert("管理员需要修改个人信息请联系数据库管理人员！");//此功能未完善
	});
});