<%-- 
    Document   : editTask
    Created on : 26 Oct, 2026, 5:20:05 AM
    Author     : SCMS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%
if(session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String subject = "";
String topic = "";
String date = "";
String status = "";
int id = 0;

try {
    id = Integer.parseInt(request.getParameter("id"));

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/studyplanner?sslMode=DISABLED",
        "root",
        "windows"
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM tasks WHERE id=? AND user_id=?"
    );

    ps.setInt(1, id);
    ps.setInt(2, (Integer)session.getAttribute("userId"));

    ResultSet rs = ps.executeQuery();

    if(rs.next()) {
        subject = rs.getString("subject");
        topic = rs.getString("topic");
        date = rs.getDate("study_date").toString();
        status = rs.getString("status");
    } else {
        con.close();
        response.sendRedirect("viewTasks.jsp");
        return;
    }

    con.close();

} catch(Exception e) {
    response.sendRedirect("viewTasks.jsp");
    return;
}

subject = subject.replace("&","&amp;").replace("\"","&quot;")
                 .replace("<","&lt;").replace(">","&gt;");

topic = topic.replace("&","&amp;").replace("\"","&quot;")
             .replace("<","&lt;").replace(">","&gt;");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Task</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">

<h2>Edit Study Task</h2>

<form action="updateTask.jsp" method="post">

    <input type="hidden" name="id" value="<%=id%>">

    Subject:
    <input type="text" name="subject"
           value="<%=subject%>" required>

    Topic:
    <input type="text" name="topic"
           value="<%=topic%>" required>

    Study Date:
    <input type="date" name="study_date"
           value="<%=date%>" required>

    Status:
    <select name="status">
        <option value="Pending"
            <% if(status.equals("Pending")) out.print("selected"); %>>
            Pending
        </option>

        <option value="Completed"
            <% if(status.equals("Completed")) out.print("selected"); %>>
            Completed
        </option>
    </select>

    <input type="submit" value="Update Task">

</form>

<a href="viewTasks.jsp">Back to Tasks</a>

</div>

</body>
</html>
