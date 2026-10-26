<%-- 
    Document   : deleteTask
    Created on : 26 Oct, 2026, 5:21:02 AM
    Author     : SCMS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%
if(session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp");
    return;
}

if(!"POST".equalsIgnoreCase(request.getMethod())) {
    response.sendRedirect("viewTasks.jsp");
    return;
}

try {
    int id = Integer.parseInt(request.getParameter("id"));

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/studyplanner?sslMode=DISABLED",
        "root",
        "windows"
    );

    PreparedStatement ps = con.prepareStatement(
        "DELETE FROM tasks WHERE id=? AND user_id=?"
    );

    ps.setInt(1, id);
    ps.setInt(2, (Integer)session.getAttribute("userId"));

    ps.executeUpdate();

    con.close();

    response.sendRedirect("viewTasks.jsp");
    return;

} catch(Exception e) {
    out.println("<h2>Unable to delete task</h2>");
}
%>

<a href="viewTasks.jsp">Back to Tasks</a>

