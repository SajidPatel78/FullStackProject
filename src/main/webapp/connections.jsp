<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - My Connections</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=3.0">
    <style>
        .connections-page { max-width: 900px; margin: 0 auto; padding: 30px 20px; }
        .connections-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; margin-top: 20px; }
        .conn-card { padding: 25px; text-align: center; transition: transform 0.2s; }
        .conn-card:hover { transform: translateY(-3px); }
        .conn-avatar { width: 60px; height: 60px; border-radius: 50%; background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink)); display: flex; align-items: center; justify-content: center; font-size: 2rem; font-weight: bold; color: white; margin: 0 auto 15px auto; }
        .conn-card h4 { margin: 0 0 5px 0; font-size: 1.2rem; }
        .conn-card p { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 15px; }
        
        .back-nav { display: flex; align-items: center; gap: 20px; margin-bottom: 20px; }
        .back-nav a { color: var(--text-muted); text-decoration: none; font-weight: 500; }
        .back-nav a:hover { color: white; }
    </style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="connections-page">
        <div class="back-nav">
            <a href="profile">← Back to Profile</a>
        </div>

        <h2 style="font-size: 1.8rem; margin-bottom: 5px;">My Connections</h2>
        <p style="color: var(--text-muted); margin-bottom: 30px;">People you are connected with on SkillNest.</p>

        <c:choose>
            <c:when test="${empty connectionsList}">
                <div class="glass-card" style="text-align: center; padding: 50px;">
                    <i class="fa-solid fa-users-slash" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 15px;"></i>
                    <h3 style="margin-top: 0;">No connections yet.</h3>
                    <p style="color: var(--text-muted);">Go to the feed and connect with other students to build your network!</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="connections-grid">
                    <c:forEach var="conn" items="${connectionsList}">
                        <div class="glass-card conn-card">
                            <div class="conn-avatar">${conn.username.substring(0, 1).toUpperCase()}</div>
                            <h4>${conn.username}</h4>
                            <p>🏫 ${conn.collegeName}</p>
                            <div style="margin-bottom: 15px;">
                                <span class="badge badge-purple" style="font-size: 0.75rem;">Level ${conn.level}</span>
                                <span class="badge badge-green" style="font-size: 0.75rem;">${conn.xp} XP</span>
                            </div>
                            <a href="user-profile?id=${conn.id}" class="btn-outline" style="display: inline-block; padding: 6px 15px; font-size: 0.9rem; text-decoration: none;">View Profile</a>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
<jsp:include page="mobile-nav.jsp"/>`n</body>
</html>
