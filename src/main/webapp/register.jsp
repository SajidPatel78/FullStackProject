<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Register</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=2.0">
</head>
<body>
    
    <div class="auth-wrapper">
        <div class="glass-card auth-card" style="max-width: 450px;">
            <div style="text-align: center; margin-bottom: 20px;">
                <span class="logo-icon">☄️</span> <span style="font-size: 1.5rem; font-weight: bold;">SkillNest</span>
            </div>
            <h2>Create an Account</h2>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="badge badge-pink" style="display:block; text-align:center; box-sizing:border-box; margin-bottom:20px; padding: 10px;"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <form id="registerForm" action="register" method="post" onsubmit="return validateRegisterForm()">
                <div class="form-group">
                    <label for="username">Choose a Username</label>
                    <input type="text" id="username" name="username" class="glass-input" placeholder="johndoe123" required>
                </div>
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="glass-input" placeholder="name@example.com" required>
                    <small id="emailError" style="color: #ef4444; display: none; margin-top: 5px; font-size: 0.85em;">Invalid email format</small>
                </div>
                <div class="form-group">
                    <label for="collegeName">College Name</label>
                    <input type="text" id="collegeName" name="collegeName" class="glass-input" placeholder="e.g. Stanford University" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="glass-input" placeholder="••••••••" required>
                    <small id="passwordError" style="color: #ef4444; display: none; margin-top: 5px; font-size: 0.85em;">Password must be at least 6 characters</small>
                </div>
                <button type="submit" class="btn-solid" style="width: 100%; margin-top: 10px;">Join SkillNest</button>
            </form>
            
            <div style="text-align: center; margin-top: 25px; font-size: 0.95rem; color: var(--text-muted);">
                Already have an account? <a href="login.jsp" style="color: var(--accent-pink); text-decoration: none; font-weight: 600;">Login here</a>
            </div>
        </div>
    </div>

    <script>
        function validateRegisterForm() {
            var isValid = true;
            
            var password = document.getElementById("password").value;
            var passwordError = document.getElementById("passwordError");
            if (password.length < 6) {
                passwordError.style.display = "block";
                isValid = false;
            } else {
                passwordError.style.display = "none";
            }
            
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
