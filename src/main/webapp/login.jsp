<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Login</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <header>
        <h1>SkillNest</h1>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="register.jsp">Register</a>
        </nav>
    </header>
    
    <div class="container">
        <div class="card" style="max-width: 400px; margin: 40px auto;">
            <h2>Login</h2>
            
            <% if(request.getParameter("registered") != null) { %>
                <div class="success-msg">Registration successful! Please login.</div>
            <% } %>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="error-msg"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <form id="loginForm" action="login" method="post" onsubmit="return validateLoginForm()">
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required>
                    <small id="passwordError" style="color: var(--error-color); display: none;">Password must be at least 6 characters</small>
                </div>
                <button type="submit" class="btn" style="width: 100%;">Login</button>
            </form>
            <p style="text-align: center; margin-top: 20px;">
                Don't have an account? <a href="register.jsp">Register here</a>
            </p>
        </div>
    </div>

    <script>
        function validateLoginForm() {
            var isValid = true;
            
            // Password validation
            var password = document.getElementById("password").value;
            var passwordError = document.getElementById("passwordError");
            if (password.length < 6) {
                passwordError.style.display = "block";
                isValid = false;
            } else {
                passwordError.style.display = "none";
            }
            
            return isValid;
        }
    </script>
</body>
</html>
