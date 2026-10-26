<%-- 
    Document   : dashboard
    Created on : 26 Oct, 2026, 5:18:11 AM
    Author     : SCMS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%
if(session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp");
    return;
}

int userId = (Integer) session.getAttribute("userId");
String name = (String) session.getAttribute("userName");

int total = 0;
int completed = 0;
int pending = 0;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/studyplanner?sslMode=DISABLED",
        "root",
        "windows"
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT COUNT(*) AS total, " +
        "SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END) AS completed " +
        "FROM tasks WHERE user_id=?"
    );

    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();

    if(rs.next()) {
        total = rs.getInt("total");
        completed = rs.getInt("completed");
        pending = total - completed;
    }

    con.close();

} catch(Exception e) {
    out.println("Unable to load task statistics.");
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">

<h1>Study Planner Dashboard</h1>

<h2>Welcome,
<%=name.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;")%>
</h2>

<div class="stats">
    <p>Total Tasks: <%=total%></p>
    <p>Completed Tasks: <%=completed%></p>
    <p>Pending Tasks: <%=pending%></p>
</div>

<a href="addTask.jsp" class="btn">Add Study Task</a>

<a href="viewTasks.jsp" class="btn">View Study Tasks</a>

<a href="logout.jsp" class="btn">Logout</a>

</div>

</body>
</html>
