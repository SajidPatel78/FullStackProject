<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Register</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <header>
        <h1>SkillNest</h1>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="login.jsp">Login</a>
        </nav>
    </header>
    
    <div class="container">
        <div class="card" style="max-width: 400px; margin: 40px auto;">
            <h2>Register</h2>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="error-msg"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <form id="registerForm" action="register" method="post" onsubmit="return validateRegisterForm()">
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>
                    <small id="emailError" style="color: var(--error-color); display: none;">Invalid email format</small>
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required>
                    <small id="passwordError" style="color: var(--error-color); display: none;">Password must be at least 6 characters</small>
                </div>
                <button type="submit" class="btn" style="width: 100%;">Register</button>
            </form>
            <p style="text-align: center; margin-top: 20px;">
                Already have an account? <a href="login.jsp">Login here</a>
            </p>
        </div>
    </div>

    <script>
        function validateRegisterForm() {
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
            
            // Email validation
            var email = document.getElementById("email").value;
            var emailError = document.getElementById("emailError");
            var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                emailError.style.display = "block";
                isValid = false;
            } else {
                emailError.style.display = "none";
            }

            return isValid;
        }
    </script>
</body>
</html>
