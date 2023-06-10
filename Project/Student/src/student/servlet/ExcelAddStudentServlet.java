package student.servlet;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import entity.*;
import impl.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/ExcelAddStudentServlet")
public class ExcelAddStudentServlet extends HttpServlet {
    public ExcelAddStudentServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");

        String studentsString = req.getParameter("students");

        if (!"".equals(studentsString)){
            OperatorImpl operatorImpl = new OperatorImpl();
            RoleImpl roleImpl = new RoleImpl();
            ClassesImpl classesImpl = new ClassesImpl();
            StudentImpl studentImpl = new StudentImpl();
            SubjectImpl subjectImpl = new SubjectImpl();
            ScoreImpl scoreImpl = new ScoreImpl();

            String msg = "";
            JSONArray jsonArray = JSON.parseArray(studentsString);
            for (Object o : jsonArray){
                try {
                    ExcelStudent excelStudent = JSON.toJavaObject(JSON.parseObject(o.toString()), ExcelStudent.class);
                    System.out.println(JSON.toJSONString(excelStudent));
                    Student student = new Student();
                    Operator operator = new Operator();
                    Role role = new Role();
                    operator.setName(excelStudent.getStu_account());
                    operator.setPwd(excelStudent.getStu_password());
                    operator.setRole(roleImpl.query("rol_id", "3").get(0));
                    operator = operatorImpl.add(operator);
                    student.setOperator(operator);
                    student.setBirth(excelStudent.getStu_birth());
                    student.setNo(excelStudent.getStu_no());
                    student.setSex(excelStudent.getStu_sex());
                    student.setName(excelStudent.getStu_name());
                    student.setClasses(classesImpl.query("cla_name", excelStudent.getStu_class()).get(0));
                    int i = studentImpl.excelAdd(student);
                    if (i == 1) {
                        msg += "添加学生"+student.getName()+"成功！";
                    } else {
                        msg += "添加学生"+student.getName()+"失败！";
                    }
                    req.getSession().setAttribute("message", msg);

                    // 为学生添加课程成绩记录信息
                    List<Subject> list_subject = subjectImpl.query("stu_id", student
                            .getId()
                            + "");
                    List<Cla2Sub> list_cla2sub = new Cla2SubImpl().query("stu_id",
                            student.getId() + "");
                    for (int x = 0; x < list_subject.size(); x++) {
                        Score score = new Score();
                        score.setStudent(student);
                        score.setSubject(list_subject.get(x));
                        score.setCla2sub(list_cla2sub.get(x));
                        scoreImpl.add(score);
                    }

                } catch (Exception e){
                    e.printStackTrace();
                }
            }

        }
        resp.sendRedirect("pages/add_student.jsp");
    }
}
