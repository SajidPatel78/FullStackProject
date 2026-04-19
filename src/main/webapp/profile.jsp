<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - My Profile</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=3.0">
    <style>
        .profile-page { max-width: 900px; margin: 0 auto; padding: 30px 20px; }
        .profile-banner { padding: 40px; text-align: center; margin-bottom: 30px; position: relative; overflow: hidden; }
        .profile-banner::before { content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(135deg, rgba(139,92,246,0.2), rgba(247,42,117,0.1)); z-index: 0; }
        .profile-banner > * { position: relative; z-index: 1; }
        .profile-avatar { width: 80px; height: 80px; border-radius: 50%; background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink)); display: flex; align-items: center; justify-content: center; font-size: 2.5rem; font-weight: bold; color: white; margin: 0 auto 15px auto; border: 3px solid rgba(255,255,255,0.2); }
        .profile-banner h2 { margin: 0 0 5px 0; font-size: 2rem; }
        .profile-banner .meta { color: var(--text-muted); font-size: 0.95rem; margin-bottom: 5px; }

        .stats-row { display: flex; justify-content: center; gap: 40px; margin-top: 25px; padding-top: 20px; border-top: 1px solid var(--card-border); }
        .stat-box { text-align: center; }
        .stat-val { font-size: 2rem; font-weight: 700; line-height: 1; margin-bottom: 5px; }
        .stat-label { font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; font-weight: 600; }

        .portfolio-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        .port-card { padding: 25px; transition: transform 0.2s; }
        .port-card:hover { transform: translateY(-3px); }
        .port-card h4 { margin: 0 0 8px 0; font-size: 1.15rem; padding-right: 80px; }
        .port-card p { color: var(--text-muted); line-height: 1.5; font-size: 0.9rem; margin-bottom: 15px; }
        .port-meta { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--card-border); padding-top: 12px; }

        .back-nav { display: flex; align-items: center; gap: 20px; margin-bottom: 20px; }
        .back-nav a { color: var(--text-muted); text-decoration: none; font-weight: 500; }
        .back-nav a:hover { color: white; }
    </style>
</head>
<body>
    <div class="profile-page">
        <div class="back-nav">
            <a href="feed">← Back to Feed</a>
            <a href="add-post.jsp" class="btn-solid" style="margin-left:auto; text-decoration:none;">+ Create Post</a>
        </div>

        <div class="glass-card profile-banner">
            <div class="profile-avatar">${sessionScope.user.username.substring(0, 1).toUpperCase()}</div>
            <h2>${sessionScope.user.username}</h2>
            <p class="meta">🏫 ${sessionScope.user.collegeName}</p>
            <p class="meta">✉️ ${sessionScope.user.email}</p>
            <p style="margin-top:10px;">
                <span class="badge badge-purple">Level ${sessionScope.user.level}</span>
                <span class="badge badge-green" style="margin-left:5px;">${sessionScope.user.xp} XP</span>
            </p>

            <div class="stats-row">
                <div class="stat-box">
                    <div class="stat-val text-gradient">${totalPosts != null ? totalPosts : 0}</div>
                    <div class="stat-label">Posts</div>
                </div>
                <div class="stat-box">
                    <div class="stat-val text-gradient">${totalServices != null ? totalServices : 0}</div>
                    <div class="stat-label">Services</div>
                </div>
                <div class="stat-box">
                    <div class="stat-val text-gradient">${totalLikes != null ? totalLikes : 0}</div>
                    <div class="stat-label">Likes</div>
                </div>
            </div>
        </div>

        <h3 style="font-size: 1.4rem; margin-bottom: 20px;">📂 My Portfolio</h3>

        <div class="portfolio-grid">
            <c:choose>
                <c:when test="${empty myPosts}">
                    <div class="glass-card" style="text-align: center; color: var(--text-muted); padding: 40px; grid-column: 1 / -1;">
                        <h3 style="margin-top: 0; color: white;">You haven't posted anything yet.</h3>
                        <p>Share your skills or notes with the community!</p>
                        <a href="add-post.jsp" class="btn-solid" style="text-decoration:none; display:inline-block; margin-top:15px;">Create Your First Post</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="post" items="${myPosts}">
                        <div class="glass-card port-card" style="position:relative;">
                            <span class="badge ${post.postType == 'SERVICE' ? 'badge-green' : 'badge-purple'}" style="position:absolute; top:20px; right:20px;">
                                ${post.postType}
                            </span>
                            <h4>${post.title}</h4>
                            <span class="badge badge-pink" style="margin-bottom:10px; display:inline-block;">${post.category}</span>
                            <p>${post.description}</p>
                            <div class="port-meta">
                                <c:choose>
                                    <c:when test="${post.postType == 'SERVICE'}">
                                        <span style="font-weight: 700; color: var(--accent-green); font-size: 1.1rem;">$${post.price}</span>
                                        <span style="color: #d97706;">⭐ ${post.averageRating > 0 ? post.averageRating : 'New'}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: var(--text-muted); font-size: 0.85rem;">${post.createdAt}</span>
                                        <span style="color: var(--accent-pink);">❤️ ${post.likesCount}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
