<%-- 
    Document   : logout
    Created on : 26 Oct, 2026, 5:21:30 AM
    Author     : SCMS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
session.invalidate();

response.sendRedirect("index.jsp");
%>
