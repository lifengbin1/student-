<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>regist page</title>
    <link href="../css/regist.css" rel="stylesheet" type="text/css"/>
    <script language="javascript" type="text/javascript" src="../js/My97DatePicker/WdatePicker.js"></script>
    <script src="../js/jquery-1.8.3.min.js"></script>
    <script src="../js/search.js"></script>
</head>

<body>
<center>

    <form action="/Student/AddStudentServlet"
          enctype="multipart/form-data" method="post">
        <c:if test="${sessionScope.message!=null}">
            <input type="hidden" value="${sessionScope.message}" id="message"/>
        </c:if>
        <c:remove var="message" scope="session"/>
        <div class="window" align="left">

            <div class="tit">
                添加学生
            </div>
            <div class="main">
                <div align="left">
                    学号：
                    <input type="text" name="no"/>
                </div>
                <div align="left">
                    姓名：
                    <input type="text" name="name"/>
                </div>
                <div align="left">
                    性别：
                    <input style="width: 20px; height: 20px" name="sex" type="radio"
                           value="male" checked="checked"/>
                    男 &nbsp;&nbsp;&nbsp;&nbsp;
                    <input style="width: 20px; height: 20px;" name="sex" type="radio"
                           value="female"/>
                    女
                </div>
                <div align="left">
                    生日：
<%--                    <input type="date" name="birth" onClick="WdatePicker()"/>--%>
                    <input type="date" name="birth" />
                </div>

                <div align="left">
                    班级：
                    <select name="cla_id">
                        <c:forEach items="${sessionScope.list_classes}" var="cla">
                            <option value="${cla.id}">
                                    ${cla.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div align="left">
                    账号：
                    <input type="text" name="ope_name"/>
                </div>
                <div align="left">
                    密码：
                    <input type="text" name="ope_pwd"/>
                </div>
                <div align="left">
                    <a>头像：</a>
                    <input style="margin-top: 20px;" type="file" name="pic"/>
                    <br/>
                    <br/>
                    <img src="../images/person.png" width="150" height="150"
                         style="margin-left: 100px;"/>
                </div>
                <br/>
                <div align="right" style="text-align: start;">
                    <input type="submit" value="添加"
                           style="width: 65px; height: 35px; line-height: 35px; overflow: hidden; text-align: center;margin-left: calc(250px / 2 + 65px / 2)"/>
                </div>
            </div>
        </div>
    </form>
    <div class="excel-add-form-wrap">
        <div class="title">EXCEL表格数据添加：</div>
        <form id="excel-form" action="${pageContext.request.contextPath }/ExcelAddStudentServlet" method="post" style="text-align: start;">
            <input id="excel-file-input" type="file" accept=".xls, .xlsx" onchange="fileChange(this)"/><br/>
            <input id="value-input" name="students" readonly/>
            <table id="students-show" border="1" style="margin: 10px 0;">

            </table>
            <input id="yang-btn" type="button" value="提交" onclick="mySubmit()"/>
        </form>
    </div>
    ${message }
    <script type="text/javascript" src="../js/xlsx.core.min.js"></script>
    <script type="text/javascript">
        let file = null;
        let students = null;
        let form = document.getElementById("excel-form");
        let fileInput = document.getElementById("excel-file-input");
        let valueInput = document.getElementById("value-input");
        let fileTypes = [".xls", ".xlsx"];
        let isExcel = false;
        let table = document.getElementById("students-show");
        function fileChange(e){
            let tempFile = e.files[0];
            if(tempFile != undefined){
                let fileType = tempFile.name.substring(tempFile.name.lastIndexOf("."));
                for (let i in fileTypes){
                    if (fileTypes[i] == fileType){
                        isExcel = true;
                        break;
                    }else {
                        isExcel = false;
                    }
                }
                if (isExcel){
                    file = tempFile;
                    let fileReader = new FileReader();
                    fileReader.addEventListener("load", (fe) => {
                        try {
                            var data = fe.target.result;
                            var workbook = XLSX.read(data, {
                                type: "binary"
                            });
                            var fromTo = "";
                            for (var sheet in workbook.Sheets){
                                if (workbook.Sheets.hasOwnProperty(sheet)){
                                    fromTo = workbook.Sheets[sheet]["!ref"];
                                    if (fromTo != undefined){
                                        students = XLSX.utils.sheet_to_json(workbook.Sheets[sheet]);
                                        if(students != null){
                                            let str = "<tr><td>学号</td><td>姓名</td><td>性别</td><td>生日</td><td>班级</td><td>账号</td><td>密码</td></tr>";
                                            for(let j = 0; j < students.length; j++){
                                                let student = students[j];
                                                str += "<tr><td>"+student.stu_no+"</td><td>"+student.stu_name+"</td><td>"+student.stu_sex+"</td><td>"+student.stu_birth+"</td><td>"+student.stu_class+"</td><td>"+student.stu_account+"</td><td>"+student.stu_password+"</td></tr>";
                                            }
                                            table.innerHTML = str;
                                        }else {
                                            myClear();
                                            alert("未找到数据");
                                        }
                                    }
                                }else {
                                    myClear();
                                    alert("未找到数据");
                                }
                            }
                        } catch (err) {
                            myClear();
                            alert("文件错误");
                            console.error(err);
                        }
                    });
                    fileReader.readAsBinaryString(file);
                }else {
                    myClear();
                    alert("仅支持Excel工作表文件");
                }
            }else {
                myClear();
                alert("用户取消操作");
            }
        }
        function mySubmit(){
            valueInput.value = JSON.stringify(students);
            form.submit();
        }
        function myClear(){
            file = null;
            students = null;
            valueInput.value = "";
            fileInput.value = "";
            table.innerHTML = "";
        }
    </script>
</center>
</body>
</html>