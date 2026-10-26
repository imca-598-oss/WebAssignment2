<%-- 
    Document   : viewTasks
    Created on : 26 Oct, 2026, 5:19:30 AM
    Author     : SCMS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%
if(session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Tasks</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<h1>My Study Tasks</h1>

<div class="table-container">

<table border="1">
<tr>
    <th>ID</th>
    <th>Subject</th>
    <th>Topic</th>
    <th>Study Date</th>
    <th>Status</th>
    <th>Actions</th>
</tr>

<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/studyplanner?sslMode=DISABLED",
        "root",
        "windows"
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM tasks WHERE user_id=? ORDER BY study_date"
    );

    ps.setInt(1, (Integer)session.getAttribute("userId"));

    ResultSet rs = ps.executeQuery();

    while(rs.next()) {
        int id = rs.getInt("id");

        String subject = rs.getString("subject")
            .replace("&","&amp;").replace("<","&lt;").replace(">","&gt;");

        String topic = rs.getString("topic")
            .replace("&","&amp;").replace("<","&lt;").replace(">","&gt;");
%>

<tr>
    <td><%=id%></td>
    <td><%=subject%></td>
    <td><%=topic%></td>
    <td><%=rs.getDate("study_date")%></td>
    <td><%=rs.getString("status")%></td>

    <td>
        <a href="editTask.jsp?id=<%=id%>">Edit</a>

        <form action="deleteTask.jsp" method="post"
              onsubmit="return confirm('Delete this task?');">
            <input type="hidden" name="id" value="<%=id%>">
            <input type="submit" value="Delete">
        </form>
    </td>
</tr>

<%
    }

    con.close();

} catch(Exception e) {
    out.println("<tr><td colspan='6'>Unable to load tasks</td></tr>");
}
%>

</table>

</div>

<br>
<a href="dashboard.jsp" class="btn">Back to Dashboard</a>

</body>
</html>
