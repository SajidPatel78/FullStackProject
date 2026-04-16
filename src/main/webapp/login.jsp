<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Login</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=2.0">
</head>
<body>
    
    <div class="auth-wrapper">
        <div class="glass-card auth-card">
            <div style="text-align: center; margin-bottom: 20px;">
                <span class="logo-icon">☄️</span> <span style="font-size: 1.5rem; font-weight: bold;">SkillNest</span>
            </div>
            <h2>Welcome Back, Explorer!</h2>
            
            <% if(request.getParameter("registered") != null) { %>
                <div class="badge badge-green" style="display:block; text-align:center; box-sizing:border-box; margin-bottom:20px; padding: 10px;">Registration successful! Please login.</div>
            <% } %>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="badge badge-pink" style="display:block; text-align:center; box-sizing:border-box; margin-bottom:20px; padding: 10px;"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <form id="loginForm" action="login" method="post" onsubmit="return validateLoginForm()">
                <div class="form-group">
                    <label for="email">Email or Username</label>
                    <input type="text" id="email" name="email" class="glass-input" placeholder="Enter Email or Username" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="glass-input" placeholder="••••••••" required>
                </div>
                <button type="submit" class="btn-solid" style="width: 100%; margin-top: 10px;">Launch Dashboard</button>
            </form>
            
            <div style="text-align: center; margin-top: 25px; font-size: 0.95rem; color: var(--text-muted);">
                New to the cosmos? <a href="register.jsp" style="color: var(--accent-cyan); text-decoration: none; font-weight: 600;">Register here</a>
            </div>
        </div>
    </div>

    <script>
        function validateLoginForm() {
            return true; // Bypass validation for demo
        }
    </script>
</body>
</html>
