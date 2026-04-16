<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - The Cosmic Skilling Hub</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=2.0">
    <style>
        .hero-section {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
            flex-direction: column;
            text-align: center;
            padding: 20px;
        }

        .hero-content {
            z-index: 10;
            max-width: 800px;
        }

        .hero-title {
            font-size: 4.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            line-height: 1.1;
            letter-spacing: -1px;
        }

        .hero-subtitle {
            font-size: 1.25rem;
            color: var(--text-muted);
            margin-bottom: 40px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.6;
        }

        .hero-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
        }

        /* Nav for index */
        .landing-nav {
            position: absolute;
            top: 20px;
            left: 0;
            right: 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 40px;
            z-index: 20;
        }

        .nav-links-top { display: flex; gap: 20px; align-items: center; }

        /* Floating Cards Effect */
        .floating-cards {
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            z-index: 1;
            pointer-events: none;
        }
        
        .f-card {
            position: absolute;
            animation: float 6s ease-in-out infinite;
        }
        
        .f-card-1 { top: 20%; left: 15%; animation-delay: 0s; transform: rotate(-5deg); }
        .f-card-2 { top: 60%; right: 15%; animation-delay: -2s; transform: rotate(5deg); }
        
        @keyframes float {
            0% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(2deg); }
            100% { transform: translateY(0px) rotate(0deg); }
        }
    </style>
</head>
<body>

    <nav class="landing-nav">
        <div class="logo-area">
            <span class="logo-icon">☄️</span> <span style="font-weight: 700; font-size: 1.5rem;">SkillNest</span>
        </div>
        <div class="nav-links-top">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="feed" class="nav-item">Enter Dashboard</a>
                </c:when>
                <c:otherwise>
                    <a href="login.jsp" class="nav-item">Login</a>
                    <a href="register.jsp" class="btn-solid">Get Started</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <div class="hero-section">
        
        <div class="floating-cards">
            <!-- Mock visual card 1 -->
            <div class="glass-card f-card f-card-1" style="padding: 20px; width: 250px;">
                <div style="display:flex; align-items:center; gap: 10px; margin-bottom: 10px;">
                    <div style="width: 30px; height: 30px; border-radius: 50%; background: linear-gradient(135deg, var(--accent-cyan), var(--accent-purple));"></div>
                    <div>
                        <div style="font-weight: 600; font-size: 0.9rem;">Meghna Roy</div>
                        <div style="font-size: 0.7rem; color: var(--text-muted);">Level 8</div>
                    </div>
                </div>
                <div style="font-size: 0.85rem; color: var(--text-muted);">
                    Just finished Node.js backend for my new project! 🚀
                </div>
            </div>

            <!-- Mock visual card 2 -->
            <div class="glass-card f-card f-card-2" style="padding: 20px; width: 250px; background: rgba(139,92,246,0.1);">
                <span class="badge badge-green" style="margin-bottom: 10px; display: inline-block;">SERVICE</span>
                <div style="font-weight: 600; font-size: 1.1rem; margin-bottom: 5px;">React UI Fixes</div>
                <div style="font-size: 1.3rem; font-weight: bold; color: var(--accent-cyan);">$25.00</div>
            </div>
        </div>

        <div class="hero-content">
            <h1 class="hero-title">Your <span class="text-gradient">Cosmic</span> Hub for Freelancing & Up-skilling</h1>
            <p class="hero-subtitle">
                SkillNest is the ultimate platform where students connect, showcase projects, complete daily challenges, and earn through freelance gigs. Master your craft and level up your XP!
            </p>
            <div class="hero-buttons">
                <a href="register.jsp" class="btn-solid" style="font-size: 1.1rem; padding: 15px 30px;">Launch Your Journey</a>
                <a href="services" class="btn-neon btn-cyan" style="font-size: 1.1rem; padding: 15px 30px;">Explore the Feed</a>
            </div>
        </div>
    </div>

</body>
</html>
