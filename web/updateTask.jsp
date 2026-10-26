<%-- 
    Document   : updateTask
    Created on : 26 Oct, 2026, 5:20:34 AM
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
    String subject = request.getParameter("subject");
    String topic = request.getParameter("topic");
    String date = request.getParameter("study_date");
    String status = request.getParameter("status");

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
        "UPDATE tasks SET subject=?,topic=?,study_date=?,status=? " +
        "WHERE id=? AND user_id=?"
    );

    ps.setString(1, subject);
    ps.setString(2, topic);
    ps.setDate(3, java.sql.Date.valueOf(date));
    ps.setString(4, status);
    ps.setInt(5, id);
    ps.setInt(6, (Integer)session.getAttribute("userId"));

    int result = ps.executeUpdate();

    con.close();

    if(result > 0) {
        response.sendRedirect("viewTasks.jsp");
        return;
    } else {
        out.println("<h2>Task Not Found</h2>");
    }

} catch(Exception e) {
    out.println("<h2>Unable to update task</h2>");
}
%>

<a href="viewTasks.jsp">Back to Tasks</a>
