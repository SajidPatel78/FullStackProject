<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Sign in to SkillNest — your cosmic platform for freelancing and up-skilling.">
    <title>SkillNest - Login</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=4.0">
    <style>
        .auth-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        /* Background orbs */
        .orb {
            position: fixed; border-radius: 50%;
            filter: blur(80px); opacity: 0.2; pointer-events: none; z-index: 0;
        }
        .orb-1 { width: 450px; height: 450px; background: var(--accent-purple); top: -150px; right: -100px; }
        .orb-2 { width: 350px; height: 350px; background: var(--accent-cyan);   bottom: -80px; left: -80px; }

        .auth-card {
            width: 100%;
            max-width: 420px;
            padding: 44px 40px;
            position: relative;
            z-index: 1;
            animation: slideUp 0.5s ease;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .auth-logo {
            text-align: center;
            margin-bottom: 28px;
        }
        .auth-logo .logo-icon { font-size: 2.2rem; }
        .auth-logo .logo-text { font-size: 1.6rem; font-weight: 700; vertical-align: middle; margin-left: 8px; }

        .auth-title {
            font-size: 1.8rem;
            font-weight: 700;
            text-align: center;
            margin: 0 0 6px 0;
        }
        .auth-subtitle {
            text-align: center;
            color: var(--text-muted);
            font-size: 0.9rem;
            margin: 0 0 30px 0;
        }

        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-muted);
            font-size: 0.88rem;
            font-weight: 500;
        }
        .form-group .glass-input {
            width: 100%;
            box-sizing: border-box;
            font-size: 1rem;
            padding: 12px 16px;
        }

        /* Password wrapper with show/hide toggle */
        .password-wrapper {
            position: relative;
        }
        .password-wrapper .glass-input {
            padding-right: 46px;
        }
        .toggle-pw {
            position: absolute;
            right: 14px; top: 50%;
            transform: translateY(-50%);
            background: none; border: none;
            color: var(--text-muted);
            cursor: pointer;
            font-size: 1.1rem;
            padding: 0;
            transition: color 0.2s;
        }
        .toggle-pw:hover { color: var(--text-main); }

        /* Remember me row */
        .remember-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }
        .remember-label {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            user-select: none;
            color: var(--text-muted);
            font-size: 0.9rem;
        }
        .remember-label input[type="checkbox"] {
            appearance: none;
            -webkit-appearance: none;
            width: 18px; height: 18px;
            border: 2px solid rgba(255,255,255,0.15);
            border-radius: 5px;
            background: rgba(255,255,255,0.04);
            cursor: pointer;
            position: relative;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }
        .remember-label input[type="checkbox"]:checked {
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            border-color: transparent;
        }
        .remember-label input[type="checkbox"]:checked::after {
            content: '✓';
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-size: 11px;
            font-weight: 700;
        }
        .remember-label:hover input[type="checkbox"]:not(:checked) {
            border-color: var(--accent-purple);
        }

        .cookie-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 0.75rem;
            color: var(--accent-cyan);
            background: rgba(6,182,212,0.08);
            border: 1px solid rgba(6,182,212,0.2);
            padding: 3px 10px;
            border-radius: 20px;
            cursor: default;
        }

        /* Alert messages */
        .alert {
            display: block;
            text-align: center;
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 22px;
        }
        .alert-success {
            background: rgba(16,185,129,0.12);
            border: 1px solid rgba(16,185,129,0.25);
            color: var(--accent-green);
        }
        .alert-error {
            background: rgba(247,42,117,0.1);
            border: 1px solid rgba(247,42,117,0.25);
            color: #f472b6;
        }

        .btn-login {
            width: 100%;
            padding: 14px;
            font-size: 1.05rem;
            letter-spacing: 0.3px;
            border-radius: 12px;
        }

        .auth-footer {
            text-align: center;
            margin-top: 28px;
            font-size: 0.9rem;
            color: var(--text-muted);
        }
        .auth-footer a {
            color: var(--accent-cyan);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }
        .auth-footer a:hover { color: white; }

        /* Cookie info tooltip */
        .cookie-info {
            margin-top: 24px;
            padding: 14px 16px;
            border-radius: 10px;
            background: rgba(255,255,255,0.02);
            border: 1px solid rgba(255,255,255,0.06);
            font-size: 0.8rem;
            color: var(--text-muted);
            line-height: 1.6;
            display: none;
        }
        .cookie-info.visible { display: block; }
        .cookie-info strong { color: var(--text-main); }
    </style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>

    <div class="auth-page">
        <div class="glass-card auth-card">

            <!-- Logo -->
            <div class="auth-logo">
                <a href="index.jsp" style="text-decoration:none; color: inherit;">
                    <span class="logo-icon"><i class="fa-solid fa-meteor"></i></span>
                    <span class="logo-text">SkillNest</span>
                </a>
            </div>

            <!-- Title -->
            <h1 class="auth-title">Welcome Back!</h1>
            <p class="auth-subtitle">Sign in to continue your cosmic journey</p>

            <!-- Success / Error alerts -->
            <% if(request.getParameter("registered") != null) { %>
                <div class="alert alert-success">🎉 Registration successful! Please log in.</div>
            <% } %>
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-error"><i class="fa-solid fa-triangle-exclamation"></i> <%= request.getAttribute("error") %></div>
            <% } %>

            <!-- Login Form -->
            <form id="loginForm" action="login" method="post">

                <div class="form-group">
                    <label for="email">Email or Username</label>
                    <input type="text" id="email" name="email" class="glass-input"
                           placeholder="Enter email or username" required autocomplete="username">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="password-wrapper">
                        <input type="password" id="password" name="password" class="glass-input"
                               placeholder="••••••••" required autocomplete="current-password">
                        <button type="button" class="toggle-pw" id="togglePw" title="Show/hide password">👁</button>
                    </div>
                </div>

                <!-- Remember Me -->
                <div class="remember-row">
                    <label class="remember-label" for="rememberMe">
                        <input type="checkbox" id="rememberMe" name="rememberMe">
                        <span>Remember me for 30 days</span>
                    </label>
                    <span class="cookie-badge" id="cookieInfoBtn" title="Click to learn more">🍪 Cookie</span>
                </div>

                <!-- Cookie explanation (shown on click) -->
                <div class="cookie-info" id="cookieInfo">
                    <strong>🍪 How "Remember Me" works:</strong><br>
                    When checked, a secure token is saved as a browser cookie (expires in <strong>30 days</strong>).
                    On your next visit, SkillNest reads this cookie and automatically signs you in —
                    no password needed. The token is stored in our database and refreshed on each use.
                    When you log out, the token is permanently deleted from both the browser and our server.
                </div>

                <button type="submit" class="btn-solid btn-login" id="loginBtn">
                    <i class="fa-solid fa-rocket"></i> Sign In
                </button>
            </form>

            <!-- Footer -->
            <div class="auth-footer">
                New to the cosmos? <a href="register.jsp">Create an account →</a>
            </div>
        </div>
    </div>

    <script>
        // Show/hide password toggle
        document.getElementById('togglePw').addEventListener('click', function() {
            var pw = document.getElementById('password');
            if (pw.type === 'password') {
                pw.type = 'text';
                this.textContent = '🙈';
            } else {
                pw.type = 'password';
                this.textContent = '👁';
            }
        });

        // Toggle cookie info box
        document.getElementById('cookieInfoBtn').addEventListener('click', function() {
            var info = document.getElementById('cookieInfo');
            info.classList.toggle('visible');
        });

        // Animate the login button on submit
        document.getElementById('loginForm').addEventListener('submit', function() {
            var btn = document.getElementById('loginBtn');
            btn.textContent = '⏳ Signing in...';
            btn.disabled = true;
        });
    </script>
</body>
</html>
