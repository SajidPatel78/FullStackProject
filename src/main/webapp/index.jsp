<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="SkillNest - The ultimate cosmic platform where students connect, showcase projects, complete daily challenges, and earn through freelance gigs.">
    <title>SkillNest - The Cosmic Skilling Hub</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=4.0">
    <style>
        /* ===== LANDING PAGE GLOBALS ===== */
        html { scroll-behavior: smooth; }

        .landing-nav {
            position: fixed;
            top: 0; left: 0; right: 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 50px;
            z-index: 100;
            transition: all 0.4s ease;
            background: transparent;
        }
        .landing-nav.scrolled {
            background: rgba(7, 7, 17, 0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255,255,255,0.06);
            padding: 12px 50px;
        }
        .nav-links-top { display: flex; gap: 30px; align-items: center; }
        .nav-links-top a { color: var(--text-muted); text-decoration: none; font-weight: 500; font-size: 0.95rem; transition: color 0.3s; }
        .nav-links-top a:hover { color: white; }

        /* ===== HERO ===== */
        .hero-section {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
            flex-direction: column;
            text-align: center;
            padding: 100px 20px 60px;
        }
        .hero-content { z-index: 10; max-width: 850px; }
        .hero-tag {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 30px;
            background: rgba(139, 92, 246, 0.15);
            border: 1px solid rgba(139, 92, 246, 0.3);
            color: var(--accent-purple);
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 30px;
            animation: fadeInDown 0.8s ease;
        }
        .hero-title {
            font-size: 4.5rem;
            font-weight: 700;
            margin-bottom: 24px;
            line-height: 1.08;
            letter-spacing: -2px;
            animation: fadeInUp 0.8s ease 0.1s both;
        }
        .hero-subtitle {
            font-size: 1.2rem;
            color: var(--text-muted);
            margin-bottom: 45px;
            max-width: 620px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.7;
            animation: fadeInUp 0.8s ease 0.2s both;
        }
        .hero-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            animation: fadeInUp 0.8s ease 0.3s both;
        }
        .hero-buttons .btn-solid,
        .hero-buttons .btn-neon {
            font-size: 1.1rem;
            padding: 16px 36px;
            border-radius: 12px;
        }
        .hero-stats-row {
            display: flex;
            justify-content: center;
            gap: 50px;
            margin-top: 60px;
            animation: fadeInUp 0.8s ease 0.5s both;
        }
        .hero-stat { text-align: center; }
        .hero-stat-val { font-size: 2rem; font-weight: 700; }
        .hero-stat-label { font-size: 0.85rem; color: var(--text-muted); margin-top: 4px; }

        /* Floating Cards */
        .floating-cards { position: absolute; top: 0; left: 0; right: 0; bottom: 0; z-index: 1; pointer-events: none; }
        .f-card { position: absolute; opacity: 0.6; animation: float 8s ease-in-out infinite; }
        .f-card-1 { top: 18%; left: 8%; animation-delay: 0s; }
        .f-card-2 { top: 55%; right: 8%; animation-delay: -3s; }
        .f-card-3 { bottom: 15%; left: 20%; animation-delay: -5s; }
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-25px) rotate(2deg); }
        }

        /* Glowing orbs */
        .orb {
            position: absolute; border-radius: 50%; filter: blur(80px); opacity: 0.25; pointer-events: none; z-index: 0;
        }
        .orb-1 { width: 500px; height: 500px; background: var(--accent-purple); top: -100px; right: -150px; }
        .orb-2 { width: 400px; height: 400px; background: var(--accent-cyan); bottom: -50px; left: -100px; }
        .orb-3 { width: 300px; height: 300px; background: var(--accent-pink); top: 40%; left: 50%; transform: translateX(-50%); }

        /* ===== SECTION COMMON ===== */
        .section { padding: 100px 20px; position: relative; }
        .section-inner { max-width: 1200px; margin: 0 auto; }
        .section-header { text-align: center; margin-bottom: 60px; }
        .section-header h2 { font-size: 2.8rem; font-weight: 700; margin-bottom: 16px; letter-spacing: -1px; }
        .section-header p { color: var(--text-muted); font-size: 1.1rem; max-width: 600px; margin: 0 auto; line-height: 1.7; }
        .section-divider {
            width: 60px; height: 4px; border-radius: 2px; margin: 20px auto 0;
            background: linear-gradient(90deg, var(--accent-cyan), var(--accent-purple));
        }

        /* ===== FEATURES ===== */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
        }
        .feature-card {
            padding: 35px 30px;
            text-align: center;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
        }
        .feature-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--accent-cyan), var(--accent-purple), var(--accent-pink));
            opacity: 0;
            transition: opacity 0.4s;
        }
        .feature-card:hover { transform: translateY(-8px); }
        .feature-card:hover::before { opacity: 1; }
        .feature-icon {
            width: 70px; height: 70px; border-radius: 20px; margin: 0 auto 20px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2rem;
            background: linear-gradient(135deg, rgba(139,92,246,0.15), rgba(247,42,117,0.08));
            border: 1px solid rgba(139,92,246,0.2);
        }
        .feature-card h3 { font-size: 1.25rem; margin-bottom: 12px; font-weight: 600; }
        .feature-card p { color: var(--text-muted); font-size: 0.95rem; line-height: 1.6; }

        /* ===== HOW IT WORKS ===== */
        .steps-grid { display: flex; gap: 30px; align-items: stretch; }
        .step-card {
            flex: 1; padding: 35px 30px; text-align: center; position: relative; transition: all 0.3s;
        }
        .step-card:hover { transform: translateY(-5px); }
        .step-number {
            width: 50px; height: 50px; border-radius: 50%; margin: 0 auto 20px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem; font-weight: 700; color: white;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            box-shadow: 0 4px 20px var(--glow-pink);
        }
        .step-card h3 { font-size: 1.15rem; margin-bottom: 10px; font-weight: 600; }
        .step-card p { color: var(--text-muted); font-size: 0.92rem; line-height: 1.6; }
        .step-arrow {
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; color: var(--accent-purple); min-width: 40px; margin-top: -20px;
        }

        /* ===== STATS BAR ===== */
        .stats-bar {
            padding: 60px 20px;
            background: linear-gradient(135deg, rgba(139,92,246,0.08), rgba(6,182,212,0.05));
            border-top: 1px solid var(--card-border);
            border-bottom: 1px solid var(--card-border);
        }
        .stats-row {
            display: flex; justify-content: center; gap: 80px;
            max-width: 900px; margin: 0 auto;
        }
        .stat-item { text-align: center; }
        .stat-number {
            font-size: 3rem; font-weight: 700; line-height: 1;
            background: linear-gradient(135deg, var(--accent-cyan), var(--accent-pink));
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .stat-desc { color: var(--text-muted); font-size: 0.95rem; margin-top: 8px; font-weight: 500; }

        /* ===== TESTIMONIALS ===== */
        .testimonials-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px; }
        .testimonial-card { padding: 30px; transition: all 0.3s; }
        .testimonial-card:hover { transform: translateY(-5px); }
        .testimonial-stars { color: #fbbf24; font-size: 1rem; margin-bottom: 15px; }
        .testimonial-text { color: var(--text-muted); font-size: 0.95rem; line-height: 1.7; margin-bottom: 20px; font-style: italic; }
        .testimonial-author { display: flex; align-items: center; gap: 12px; }
        .testimonial-avatar {
            width: 42px; height: 42px; border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-cyan));
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 1.1rem; color: white; flex-shrink: 0;
        }
        .testimonial-name { font-weight: 600; font-size: 0.95rem; }
        .testimonial-role { font-size: 0.8rem; color: var(--text-muted); }

        /* ===== CTA ===== */
        .cta-section {
            text-align: center;
            padding: 100px 20px;
            position: relative;
            overflow: hidden;
        }
        .cta-card {
            padding: 60px 40px;
            max-width: 750px;
            margin: 0 auto;
            position: relative;
            z-index: 2;
            background: linear-gradient(135deg, rgba(139,92,246,0.12), rgba(247,42,117,0.06));
            border: 1px solid rgba(139,92,246,0.2);
        }
        .cta-card h2 { font-size: 2.5rem; font-weight: 700; margin-bottom: 16px; letter-spacing: -1px; }
        .cta-card p { color: var(--text-muted); font-size: 1.1rem; margin-bottom: 35px; max-width: 500px; margin-left: auto; margin-right: auto; line-height: 1.6; }

        /* ===== FOOTER ===== */
        .site-footer {
            padding: 60px 20px 30px;
            border-top: 1px solid var(--card-border);
        }
        .footer-inner {
            max-width: 1200px; margin: 0 auto;
            display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 40px;
        }
        .footer-brand { }
        .footer-brand .logo-area { padding: 0; margin-bottom: 15px; }
        .footer-brand p { color: var(--text-muted); font-size: 0.9rem; line-height: 1.6; max-width: 280px; }
        .footer-col h4 { font-size: 1rem; font-weight: 600; margin-bottom: 18px; color: white; }
        .footer-col a { display: block; color: var(--text-muted); text-decoration: none; font-size: 0.9rem; margin-bottom: 10px; transition: color 0.3s; }
        .footer-col a:hover { color: var(--accent-cyan); }
        .footer-bottom {
            text-align: center; padding-top: 30px; margin-top: 40px;
            border-top: 1px solid var(--card-border);
            color: var(--text-muted); font-size: 0.85rem;
            max-width: 1200px; margin-left: auto; margin-right: auto;
        }

        /* ===== ANIMATIONS ===== */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .reveal { opacity: 0; transform: translateY(40px); transition: all 0.8s ease; }
        .reveal.visible { opacity: 1; transform: translateY(0); }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 1024px) {
            .features-grid, .testimonials-grid { grid-template-columns: repeat(2, 1fr); }
            .steps-grid { flex-wrap: wrap; }
            .step-arrow { display: none; }
            .footer-inner { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 768px) {
            .hero-title { font-size: 2.8rem; letter-spacing: -1px; }
            .hero-subtitle { font-size: 1rem; }
            .hero-stats-row { gap: 30px; flex-wrap: wrap; }
            .features-grid, .testimonials-grid { grid-template-columns: 1fr; }
            .stats-row { flex-wrap: wrap; gap: 40px; }
            .landing-nav { padding: 15px 20px; }
            .nav-links-top { gap: 15px; }
            .section-header h2 { font-size: 2rem; }
            .footer-inner { grid-template-columns: 1fr; }
            .cta-card h2 { font-size: 1.8rem; }
        }
    </style>
</head>
<body>

    <!-- ===== NAVIGATION ===== -->
    <nav class="landing-nav" id="mainNav">
        <div class="logo-area" style="padding: 0;">
            <span class="logo-icon">☄️</span> <span style="font-weight: 700; font-size: 1.5rem;">SkillNest</span>
        </div>
        <div class="nav-links-top">
            <a href="#features">Features</a>
            <a href="#how-it-works">How it Works</a>
            <a href="#testimonials">Community</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="feed" class="btn-solid" style="text-decoration:none; padding: 10px 24px;">Enter Dashboard</a>
                </c:when>
                <c:otherwise>
                    <a href="login.jsp" style="color: var(--text-main);">Login</a>
                    <a href="register.jsp" class="btn-solid" style="text-decoration:none; padding: 10px 24px;">Get Started Free</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <!-- ===== HERO SECTION ===== -->
    <section class="hero-section">
        <!-- Glowing Orbs -->
        <div class="orb orb-1"></div>
        <div class="orb orb-2"></div>
        <div class="orb orb-3"></div>

        <!-- Floating Cards -->
        <div class="floating-cards">
            <div class="glass-card f-card f-card-1" style="padding: 20px; width: 250px;">
                <div style="display:flex; align-items:center; gap: 10px; margin-bottom: 12px;">
                    <div style="width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, var(--accent-cyan), var(--accent-purple)); display:flex; align-items:center; justify-content:center; font-weight:700; color:white; font-size:0.85rem;">M</div>
                    <div>
                        <div style="font-weight: 600; font-size: 0.9rem;">Meghna Roy</div>
                        <div style="font-size: 0.7rem; color: var(--text-muted);">⚡ Level 8 • 2,400 XP</div>
                    </div>
                </div>
                <div style="font-size: 0.85rem; color: var(--text-muted);">
                    Just shipped Node.js backend for my new project! 🚀
                </div>
            </div>

            <div class="glass-card f-card f-card-2" style="padding: 20px; width: 250px; background: rgba(139,92,246,0.08);">
                <span class="badge badge-green" style="margin-bottom: 10px; display: inline-block;">SERVICE</span>
                <div style="font-weight: 600; font-size: 1.1rem; margin-bottom: 5px;">React UI Fixes</div>
                <div style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 8px;">Professional UI bug fixing & responsive design</div>
                <div style="font-size: 1.3rem; font-weight: bold; color: var(--accent-cyan);">$25.00</div>
            </div>

            <div class="glass-card f-card f-card-3" style="padding: 18px; width: 220px; background: rgba(6,182,212,0.06);">
                <div style="font-weight: 600; font-size: 0.9rem; margin-bottom: 8px;">⚡ Daily Challenge</div>
                <div style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 10px;">Build a Todo App with React</div>
                <div class="badge badge-purple" style="display:inline-block;">+100 XP</div>
            </div>
        </div>

        <div class="hero-content">
            <span class="hero-tag">🌟 The Future of Student Collaboration</span>
            <h1 class="hero-title">Your <span class="text-gradient">Cosmic</span> Hub for Freelancing & Up‑skilling</h1>
            <p class="hero-subtitle">
                SkillNest is the ultimate platform where students connect, showcase projects, complete daily challenges, and earn through freelance gigs. Master your craft and level up your XP!
            </p>
            <div class="hero-buttons">
                <a href="register.jsp" class="btn-solid" style="text-decoration:none;">🚀 Launch Your Journey</a>
                <a href="#features" class="btn-neon btn-cyan" style="text-decoration:none;">Explore Features</a>
            </div>
            <div class="hero-stats-row">
                <div class="hero-stat">
                    <div class="hero-stat-val text-gradient">500+</div>
                    <div class="hero-stat-label">Active Students</div>
                </div>
                <div class="hero-stat">
                    <div class="hero-stat-val text-gradient">1,200+</div>
                    <div class="hero-stat-label">Services Posted</div>
                </div>
                <div class="hero-stat">
                    <div class="hero-stat-val text-gradient">50K+</div>
                    <div class="hero-stat-label">XP Earned</div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== FEATURES SECTION ===== -->
    <section class="section" id="features">
        <div class="section-inner">
            <div class="section-header reveal">
                <h2>Everything You Need to <span class="text-gradient">Level Up</span></h2>
                <p>Powerful tools designed for students who want to learn, earn, and connect in one cosmic platform.</p>
                <div class="section-divider"></div>
            </div>

            <div class="features-grid">
                <div class="glass-card feature-card reveal">
                    <div class="feature-icon">💼</div>
                    <h3>Freelance Marketplace</h3>
                    <p>Offer your skills as services — from web development to graphic design. Set your price, get booked, and start earning.</p>
                </div>
                <div class="glass-card feature-card reveal">
                    <div class="feature-icon">⚡</div>
                    <h3>Daily Challenges</h3>
                    <p>Accept daily coding, design, and writing challenges. Complete them to earn XP and climb the leaderboard ranks.</p>
                </div>
                <div class="glass-card feature-card reveal">
                    <div class="feature-icon">🏆</div>
                    <h3>XP & Leaderboard</h3>
                    <p>Every action earns XP — posting, connecting, completing challenges. Level up and compete for the top spot.</p>
                </div>
                <div class="glass-card feature-card reveal">
                    <div class="feature-icon">📝</div>
                    <h3>Share Notes & Projects</h3>
                    <p>Post study notes, project showcases, and resources. Get likes and saves from the community.</p>
                </div>
                <div class="glass-card feature-card reveal">
                    <div class="feature-icon">🔗</div>
                    <h3>Social Connections</h3>
                    <p>Connect with peers from your college and beyond. Build your professional network while still in school.</p>
                </div>
                <div class="glass-card feature-card reveal">
                    <div class="feature-icon">💬</div>
                    <h3>Direct Messaging</h3>
                    <p>Chat directly with service providers, collaborators, and fellow students. Seamless real-time communication.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== STATS BAR ===== -->
    <div class="stats-bar">
        <div class="stats-row reveal">
            <div class="stat-item">
                <div class="stat-number" id="counter1">0</div>
                <div class="stat-desc">Services Listed</div>
            </div>
            <div class="stat-item">
                <div class="stat-number" id="counter2">0</div>
                <div class="stat-desc">Challenges Completed</div>
            </div>
            <div class="stat-item">
                <div class="stat-number" id="counter3">0</div>
                <div class="stat-desc">Connections Made</div>
            </div>
            <div class="stat-item">
                <div class="stat-number" id="counter4">0</div>
                <div class="stat-desc">Colleges Represented</div>
            </div>
        </div>
    </div>

    <!-- ===== HOW IT WORKS ===== -->
    <section class="section" id="how-it-works">
        <div class="section-inner">
            <div class="section-header reveal">
                <h2>How <span class="text-gradient">SkillNest</span> Works</h2>
                <p>Get started in 4 simple steps and begin your cosmic journey to mastery.</p>
                <div class="section-divider"></div>
            </div>

            <div class="steps-grid">
                <div class="glass-card step-card reveal">
                    <div class="step-number">1</div>
                    <h3>Create Your Account</h3>
                    <p>Sign up in seconds with your college email. Set up your explorer profile and join the SkillNest universe.</p>
                </div>
                <div class="step-arrow reveal">→</div>
                <div class="glass-card step-card reveal">
                    <div class="step-number">2</div>
                    <h3>Post & Explore</h3>
                    <p>Share services, notes, or projects. Browse the feed to discover what other students are building and offering.</p>
                </div>
                <div class="step-arrow reveal">→</div>
                <div class="glass-card step-card reveal">
                    <div class="step-number">3</div>
                    <h3>Connect & Collaborate</h3>
                    <p>Follow peers, send messages, book services, and work together on exciting projects.</p>
                </div>
                <div class="step-arrow reveal">→</div>
                <div class="glass-card step-card reveal">
                    <div class="step-number">4</div>
                    <h3>Level Up & Earn</h3>
                    <p>Complete challenges, rack up XP, climb the leaderboard, and earn money from your freelance skills.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== TESTIMONIALS ===== -->
    <section class="section" id="testimonials">
        <div class="section-inner">
            <div class="section-header reveal">
                <h2>Loved by <span class="text-gradient">Students</span> Everywhere</h2>
                <p>Here's what our community members have to say about their SkillNest experience.</p>
                <div class="section-divider"></div>
            </div>

            <div class="testimonials-grid">
                <div class="glass-card testimonial-card reveal">
                    <div class="testimonial-stars">⭐⭐⭐⭐⭐</div>
                    <p class="testimonial-text">"SkillNest completely changed how I approach freelancing. I went from zero clients to consistent bookings in just two weeks. The XP system keeps me motivated daily!"</p>
                    <div class="testimonial-author">
                        <div class="testimonial-avatar">A</div>
                        <div>
                            <div class="testimonial-name">Arjun Mehta</div>
                            <div class="testimonial-role">CS Student • Level 12</div>
                        </div>
                    </div>
                </div>
                <div class="glass-card testimonial-card reveal">
                    <div class="testimonial-stars">⭐⭐⭐⭐⭐</div>
                    <p class="testimonial-text">"The daily challenges pushed me to learn things I would have never tried on my own. I've grown so much as a designer since joining this platform."</p>
                    <div class="testimonial-author">
                        <div class="testimonial-avatar" style="background: linear-gradient(135deg, var(--accent-pink), var(--accent-purple));">S</div>
                        <div>
                            <div class="testimonial-name">Sneha Iyer</div>
                            <div class="testimonial-role">Design Major • Level 9</div>
                        </div>
                    </div>
                </div>
                <div class="glass-card testimonial-card reveal">
                    <div class="testimonial-stars">⭐⭐⭐⭐⭐</div>
                    <p class="testimonial-text">"I love how I can share my study notes and actually help people. The connections I've made through SkillNest have turned into real collaborations."</p>
                    <div class="testimonial-author">
                        <div class="testimonial-avatar" style="background: linear-gradient(135deg, var(--accent-cyan), var(--accent-green));">R</div>
                        <div>
                            <div class="testimonial-name">Rahul Sharma</div>
                            <div class="testimonial-role">Engineering • Level 7</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== CTA SECTION ===== -->
    <section class="cta-section">
        <div class="orb" style="width:400px; height:400px; background:var(--accent-purple); top: -100px; right: 20%; opacity:0.15;"></div>
        <div class="glass-card cta-card reveal" style="border-radius: 24px;">
            <h2>Ready to Begin Your <span class="text-gradient">Cosmic Journey</span>?</h2>
            <p>Join thousands of students already leveling up their skills, earning through freelance gigs, and building lasting connections.</p>
            <div style="display: flex; gap: 16px; justify-content: center; flex-wrap: wrap;">
                <a href="register.jsp" class="btn-solid" style="text-decoration:none; font-size: 1.1rem; padding: 16px 40px; border-radius: 12px;">🚀 Create Free Account</a>
                <a href="login.jsp" class="btn-neon btn-cyan" style="text-decoration:none; font-size: 1.1rem; padding: 16px 40px; border-radius: 12px;">Sign In</a>
            </div>
        </div>
    </section>

    <!-- ===== FOOTER ===== -->
    <footer class="site-footer">
        <div class="footer-inner">
            <div class="footer-brand">
                <div class="logo-area">
                    <span class="logo-icon">☄️</span> <span style="font-weight: 700; font-size: 1.5rem;">SkillNest</span>
                </div>
                <p>The ultimate cosmic platform for students to learn, earn, and connect. Build your future, one skill at a time.</p>
            </div>
            <div class="footer-col">
                <h4>Platform</h4>
                <a href="register.jsp">Get Started</a>
                <a href="login.jsp">Sign In</a>
                <a href="services">Services</a>
                <a href="#features">Features</a>
            </div>
            <div class="footer-col">
                <h4>Community</h4>
                <a href="leaderboard">Leaderboard</a>
                <a href="challenges">Challenges</a>
                <a href="#testimonials">Testimonials</a>
            </div>
            <div class="footer-col">
                <h4>Resources</h4>
                <a href="#">Help Center</a>
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
            </div>
        </div>
        <div class="footer-bottom">
            <p>© 2026 SkillNest. Crafted with ❤️ for students, by students.</p>
        </div>
    </footer>

    <!-- ===== SCRIPTS ===== -->
    <script>
        // Sticky nav on scroll
        window.addEventListener('scroll', function() {
            var nav = document.getElementById('mainNav');
            if (window.scrollY > 60) {
                nav.classList.add('scrolled');
            } else {
                nav.classList.remove('scrolled');
            }
        });

        // Scroll reveal animations
        function revealOnScroll() {
            var reveals = document.querySelectorAll('.reveal');
            for (var i = 0; i < reveals.length; i++) {
                var windowHeight = window.innerHeight;
                var elementTop = reveals[i].getBoundingClientRect().top;
                var revealPoint = 120;
                if (elementTop < windowHeight - revealPoint) {
                    reveals[i].classList.add('visible');
                }
            }
        }
        window.addEventListener('scroll', revealOnScroll);
        window.addEventListener('load', revealOnScroll);

        // Animated counter
        function animateCounter(el, target, suffix) {
            var current = 0;
            var step = Math.ceil(target / 60);
            var timer = setInterval(function() {
                current += step;
                if (current >= target) {
                    current = target;
                    clearInterval(timer);
                }
                el.textContent = current.toLocaleString() + (suffix || '');
            }, 25);
        }

        var countersStarted = false;
        function checkCounters() {
            if (countersStarted) return;
            var statsBar = document.querySelector('.stats-bar');
            if (!statsBar) return;
            var rect = statsBar.getBoundingClientRect();
            if (rect.top < window.innerHeight - 100) {
                countersStarted = true;
                animateCounter(document.getElementById('counter1'), 1250, '+');
                animateCounter(document.getElementById('counter2'), 3400, '+');
                animateCounter(document.getElementById('counter3'), 8600, '+');
                animateCounter(document.getElementById('counter4'), 120, '+');
            }
        }
        window.addEventListener('scroll', checkCounters);
        window.addEventListener('load', checkCounters);
    </script>

</body>
</html>
