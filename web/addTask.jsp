<%-- 
    Document   : addTask
    Created on : 26 Oct, 2026, 5:18:40 AM
    Author     : SCMS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%
if(session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp");
    return;
}

if("POST".equalsIgnoreCase(request.getMethod())) {

    String subject = request.getParameter("subject");
    String topic = request.getParameter("topic");
    String date = request.getParameter("study_date");
    String status = request.getParameter("status");

    try {
        if(!"Pending".equals(status) && !"Completed".equals(status)) {
            throw new Exception("Invalid status");
        }

        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/studyplanner?sslMode=DISABLED",
            "root",
            "windows"
        );

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO tasks(user_id,subject,topic,study_date,status) " +
            "VALUES(?,?,?,?,?)"
        );

        ps.setInt(1, (Integer)session.getAttribute("userId"));
        ps.setString(2, subject);
        ps.setString(3, topic);
        ps.setDate(4, java.sql.Date.valueOf(date));
        ps.setString(5, status);

        ps.executeUpdate();
        con.close();

        response.sendRedirect("viewTasks.jsp");
        return;

    } catch(Exception e) {
        out.println("<p>Unable to add task.</p>");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Task</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">

<h2>Add Study Task</h2>

<form method="post">

    Subject:
    <input type="text" name="subject" required>

    Topic:
    <input type="text" name="topic" required>

    Study Date:
    <input type="date" name="study_date" required>

    Status:
    <select name="status">
        <option value="Pending">Pending</option>
        <option value="Completed">Completed</option>
    </select>

    <input type="submit" value="Add Task">
    <input type="reset" value="Clear">

</form>

<a href="dashboard.jsp">Back to Dashboard</a>

</div>

</body>
</html>

