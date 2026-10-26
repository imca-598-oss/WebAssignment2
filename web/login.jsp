<%-- 
    Document   : login
    Created on : 26 Oct, 2026, 5:17:30 AM
    Author     : SCMS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="java.sql.*,java.security.*,java.util.Base64" %>

<!DOCTYPE html>
<html>
<head>
    <title>Student Login</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">

<h2>Student Login</h2>

<form method="post">

    Email:
    <input type="email" name="email" required>

    Password:
    <input type="password" name="password" required>

    <input type="submit" value="Login">

</form>

<%
if("POST".equalsIgnoreCase(request.getMethod())) {

    String email = request.getParameter("email");
    String password = request.getParameter("password");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/studyplanner?sslMode=DISABLED",
            "root",
            "windows"
        );

        PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM users WHERE email=?"
        );

        ps.setString(1, email);

        ResultSet rs = ps.executeQuery();

        boolean valid = false;

        if(rs.next()) {
            String[] parts = rs.getString("password").split(":");

            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] savedHash = Base64.getDecoder().decode(parts[1]);

            javax.crypto.spec.PBEKeySpec spec =
                new javax.crypto.spec.PBEKeySpec(
                    password.toCharArray(), salt, 100000, 256
                );

            javax.crypto.SecretKeyFactory factory =
                javax.crypto.SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

            byte[] enteredHash =
                factory.generateSecret(spec).getEncoded();

            valid = MessageDigest.isEqual(savedHash, enteredHash);
        }

        if(valid) {
            session.setAttribute("userId", rs.getInt("id"));
            session.setAttribute("userName", rs.getString("name"));

            con.close();
            response.sendRedirect("dashboard.jsp");
            return;
        } else {
            out.println("<p>Invalid Email or Password</p>");
        }

        con.close();

    } catch(Exception e) {
        out.println("<p>Login failed. Please try again.</p>");
    }
}
%>

<p>Don't have an account?</p>
<a href="register.jsp">Register</a>

</div>

</body>
</html>
