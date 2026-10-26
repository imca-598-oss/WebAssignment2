<%-- 
    Document   : register
    Created on : 26 Oct, 2026, 5:17:02 AM
    Author     : SCMS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="java.sql.*,java.security.*,java.util.Base64" %>

<!DOCTYPE html>
<html>
<head>
    <title>Student Registration</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">

<h2>Student Registration</h2>

<form method="post">

    Name:
    <input type="text" name="name" required>

    Email:
    <input type="email" name="email" required>

    Password:
    <input type="password" name="password" required>

    <input type="submit" value="Register">

</form>

<%
if("POST".equalsIgnoreCase(request.getMethod())) {

    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/studyplanner?sslMode=DISABLED",
            "root",
            "windows"
        );

        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);

        javax.crypto.SecretKeyFactory factory =
            javax.crypto.SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

        javax.crypto.spec.PBEKeySpec spec =
            new javax.crypto.spec.PBEKeySpec(
                password.toCharArray(), salt, 100000, 256
            );

        String storedPassword =
            Base64.getEncoder().encodeToString(salt) + ":" +
            Base64.getEncoder().encodeToString(
                factory.generateSecret(spec).getEncoded()
            );

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO users(name,email,password) VALUES(?,?,?)"
        );

        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, storedPassword);

        ps.executeUpdate();

        out.println("<p>Registration Successful!</p>");
        out.println("<a href='login.jsp'>Login Now</a>");

        con.close();

    } catch(Exception e) {
        out.println("<p>Registration failed. Check your details or database.</p>");
    }
}
%>

<p>Already registered?</p>
<a href="login.jsp">Login</a>

</div>

</body>
</html>
