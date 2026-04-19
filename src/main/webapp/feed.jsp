<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Dashboard</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=3.0">
    <style>
        .feed-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
            overflow-y: auto;
            padding-right: 10px;
        }
        .feed-main::-webkit-scrollbar { width: 6px; }
        .feed-main::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }
        
        .right-widgets {
            width: 300px;
            display: flex;
            flex-direction: column;
            gap: 20px;
            position: sticky;
            top: 20px;
            height: calc(100vh - 40px);
            overflow-y: auto;
        }
        .right-widgets::-webkit-scrollbar { width: 4px; }
        .right-widgets::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }

        .top-search-bar { display: flex; align-items: center; gap: 15px; margin-bottom: 10px; }
        .top-search-bar .glass-input { flex: 1; border-radius: 20px; padding: 12px 20px; }
        .welcome-header { font-size: 1.8rem; font-weight: 600; margin: 0; }
        .dashboard-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .widget-card { padding: 20px; }
        .widget-card h3 { margin-top: 0; font-size: 1.1rem; margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center; }

        .trending-tags { display: flex; gap: 10px; overflow-x: auto; padding-bottom: 5px; }
        .tag-pill { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); padding: 8px 16px; border-radius: 20px; white-space: nowrap; font-size: 0.9rem; color: var(--text-muted); cursor: pointer; text-decoration: none; }
        .tag-pill:hover { background: rgba(255,255,255,0.1); color: white; }

        .progress-item { margin-bottom: 15px; }
        .progress-head { display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 5px; }
        .progress-track { height: 6px; background: rgba(255,255,255,0.1); border-radius: 3px; overflow: hidden; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, var(--accent-cyan), var(--accent-purple)); border-radius: 3px; }

        .create-post { display: flex; gap: 15px; align-items: center; }
        
        .post-card { padding: 25px; }
        .post-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px; }
        .post-author { display: flex; gap: 12px; align-items: center; }
        .avatar { width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink)); display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 1.2rem; color: white; flex-shrink: 0; }
        .author-name { font-weight: 600; color: white; font-size: 1.1rem; }
        .author-meta { font-size: 0.8rem; color: var(--text-muted); }
        .post-body h4 { margin: 0 0 10px 0; font-size: 1.2rem; }
        .post-body p { color: var(--text-muted); line-height: 1.6; margin-bottom: 20px; }
        .post-footer { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--card-border); padding-top: 15px; gap: 15px; }
        .interaction-bar { display: flex; gap: 15px; }
        .interact-btn { background: none; border: none; color: var(--text-muted); cursor: pointer; display: flex; align-items: center; gap: 6px; font-size: 0.9rem; transition: color 0.2s; font-family: 'Outfit', sans-serif; padding: 5px 8px; border-radius: 6px; }
        .interact-btn:hover { background: rgba(255,255,255,0.05); color: var(--accent-pink); }
        .service-price { font-size: 1.2rem; font-weight: bold; color: var(--accent-green); }

        .user-list-item { display: flex; align-items: center; justify-content: space-between; margin-bottom: 15px; }
        .user-list-item .avatar { width: 32px; height: 32px; font-size: 0.9rem; }

        .xp-display { color: var(--accent-cyan); font-size: 0.85rem; font-weight: bold; }
        .rank-badge { width: 25px; height: 25px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.75rem; font-weight: bold; color: #111; }
        .rank-1 { background: linear-gradient(135deg, #fbbf24, #f59e0b); }
        .rank-2 { background: linear-gradient(135deg, #cbd5e1, #94a3b8); }
        .rank-3 { background: linear-gradient(135deg, #d97706, #92400e); }
        .rank-other { background: rgba(255,255,255,0.1); color: var(--text-muted); }
    </style>
</head>
<body>

<div class="app-layout">
    
    <!-- LEFT SIDEBAR -->
    <aside class="sidebar glass-card" style="padding: 20px 10px; justify-content: space-between;">
        <div>
            <div class="logo-area" style="margin-bottom: 20px;">
                <span class="logo-icon">☄️</span> SkillNest
            </div>
            <nav class="nav-menu">
                <a href="feed" class="nav-item active">🏠 Home</a>
                <a href="feed" class="nav-item">🔭 Explorer</a>
                <a href="challenges" class="nav-item">🏆 Challenges</a>
                <a href="leaderboard" class="nav-item">📊 Leaderboard</a>
                <a href="services" class="nav-item">💼 Services</a>
                <a href="profile" class="nav-item">⚙️ Settings</a>
                <a href="logout" class="nav-item" style="color: var(--accent-pink);">🚪 Logout</a>
            </nav>
        </div>
        
        <!-- Real User Profile from Session -->
        <div class="glass-card" style="padding: 15px; text-align: center; background: rgba(0,0,0,0.2);">
            <div class="avatar" style="margin: 0 auto 10px auto; width: 50px; height: 50px; font-size: 1.5rem;">
                ${sessionScope.user.username.substring(0, 1).toUpperCase()}
            </div>
            <div style="font-weight: 600;">${sessionScope.user.username}</div>
            <div style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 5px;">
                Level ${sessionScope.user.level} • <span class="xp-display">${sessionScope.user.xp} XP</span>
            </div>
            <div style="font-size: 0.75rem; color: var(--text-muted); margin-bottom: 8px;">
                🔗 ${connectionCount} Connections
            </div>
            <div class="progress-track"><div class="progress-fill" style="width: ${sessionScope.user.xp % 500 * 100 / 500}%;"></div></div>
            <div style="font-size: 0.7rem; color: var(--text-muted); margin-top: 3px;">${sessionScope.user.xp % 500}/500 XP to next level</div>
        </div>
    </aside>

    <!-- CENTER FEED -->
    <main class="feed-main">
        <div class="top-search-bar">
            <form action="feed" method="get" style="display:flex; flex:1; gap:10px;">
                <input type="text" class="glass-input" name="searchQuery" placeholder="🔍 Search for skills, posts, or users..." value="${querySearch}" style="flex:1;">
                <button type="submit" class="btn-solid" style="padding: 10px 20px;">Search</button>
            </form>
            <a href="profile" class="avatar" style="text-decoration:none;">${sessionScope.user.username.substring(0, 1).toUpperCase()}</a>
        </div>

        <h1 class="welcome-header">Welcome back, <span class="text-gradient">${sessionScope.user.username}</span>!</h1>

        <!-- Trending Skills (Filter Tags) -->
        <div class="widget-card glass-card">
            <h3 style="margin-bottom: 10px;">Trending Skills <span>→</span></h3>
            <div class="trending-tags">
                <a href="feed?category=Coding" class="tag-pill">💻 Web Development</a>
                <a href="feed?category=Design" class="tag-pill">🎨 UI/UX Design</a>
                <a href="feed?category=Writing" class="tag-pill">📊 Data Science</a>
                <a href="feed?category=Engineering" class="tag-pill">📱 App Dev</a>
                <a href="feed" class="tag-pill">🔥 All</a>
            </div>
        </div>

        <div class="dashboard-grid">
            <!-- Daily Challenge (REAL from DB) -->
            <div class="widget-card glass-card" style="background: linear-gradient(135deg, rgba(139,92,246,0.1), rgba(247,42,117,0.05));">
                <h3>⚡ Daily Challenge <a href="challenges" style="font-size:0.75rem; color:var(--accent-cyan); text-decoration:none; font-weight:500;">View All →</a></h3>
                <c:choose>
                    <c:when test="${not empty todayChallenge}">
                        <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 5px;">${todayChallenge.title}</p>
                        <p style="color: var(--accent-cyan); font-size: 0.8rem; margin-bottom: 15px;">🎁 +${todayChallenge.xpReward} XP</p>
                        <c:choose>
                            <c:when test="${challengeCompleted}">
                                <div style="text-align:center; padding:8px; border-radius:8px; background:rgba(16,185,129,0.12); color:var(--accent-green); font-weight:600; font-size:0.9rem; border:1px solid rgba(16,185,129,0.25);">✅ Completed!</div>
                            </c:when>
                            <c:when test="${challengeAccepted}">
                                <form action="challenge" method="post" style="margin:0;">
                                    <input type="hidden" name="challengeId" value="${todayChallenge.id}">
                                    <input type="hidden" name="action" value="complete">
                                    <button type="submit" class="btn-solid" style="width: 100%;">✅ Mark Complete</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <form action="challenge" method="post" style="margin:0;">
                                    <input type="hidden" name="challengeId" value="${todayChallenge.id}">
                                    <input type="hidden" name="action" value="accept">
                                    <button type="submit" class="btn-neon" style="width: 100%;">Accept Quest</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <p style="color: var(--text-muted); font-size: 0.9rem;">No challenge today. Check back tomorrow!</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Skill Progress (REAL from DB) -->
            <div class="widget-card glass-card">
                <h3>📈 Your Progress <span>→</span></h3>
                <c:choose>
                    <c:when test="${not empty userSkills}">
                        <c:forEach var="skill" items="${userSkills}" end="2">
                            <div class="progress-item">
                                <div class="progress-head">
                                    <span>${skill.skillName}</span>
                                    <span style="color: var(--accent-cyan);">${skill.progress}%</span>
                                </div>
                                <div class="progress-track"><div class="progress-fill" style="width: ${skill.progress}%;"></div></div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="color: var(--text-muted); font-size: 0.85rem;">Create posts to start tracking your skills!</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Create Post -->
        <div class="widget-card glass-card create-post">
            <div class="avatar" style="width: 35px; height: 35px; font-size: 1rem;">${sessionScope.user.username.substring(0,1).toUpperCase()}</div>
            <input type="text" class="glass-input" style="flex:1;" placeholder="What's on your mind, ${sessionScope.user.username}?" onclick="window.location.href='add-post.jsp'" readonly>
            <a href="add-post.jsp" class="btn-solid" style="text-decoration:none;">✨ Create</a>
        </div>

        <!-- REAL Feed from Database -->
        <c:choose>
            <c:when test="${empty posts}">
                <div class="glass-card" style="text-align: center; color: var(--text-muted); padding: 40px;">
                    <h3 style="margin-top: 0; color: white;">No posts found.</h3>
                    <p>Be the first adventurer to share knowledge!</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="post" items="${posts}">
                    <div class="glass-card post-card">
                        <div class="post-header">
                            <div class="post-author">
                                <div class="avatar">${post.username.substring(0,1).toUpperCase()}</div>
                                <div>
                                    <div class="author-name">${post.username}</div>
                                    <div class="author-meta">${post.userCollege} • ${post.category}</div>
                                </div>
                            </div>
                            <span class="badge ${post.postType == 'SERVICE' ? 'badge-green' : 'badge-purple'}">${post.postType}</span>
                        </div>
                        
                        <div class="post-body">
                            <h4>${post.title}</h4>
                            <p>${post.description}</p>
                        </div>

                        <div class="post-footer">
                            <c:choose>
                                <c:when test="${post.postType == 'SERVICE'}">
                                    <div class="service-price">$${post.price}</div>
                                    <c:if test="${post.userId != sessionScope.user.id}">
                                        <div style="display:flex; gap:10px;">
                                            <form action="messages" method="get" style="margin:0;">
                                                <input type="hidden" name="toUserId" value="${post.userId}">
                                                <button type="submit" class="btn-neon" style="padding:6px 12px; font-size:0.85rem;">Message</button>
                                            </form>
                                            <c:if test="${!post.bookedByCurrentUser}">
                                                <form action="book" method="post" style="margin:0;">
                                                    <input type="hidden" name="serviceId" value="${post.id}">
                                                    <button type="submit" class="btn-solid" style="padding:6px 12px; font-size:0.85rem;">Book Service</button>
                                                </form>
                                            </c:if>
                                            <c:if test="${post.bookedByCurrentUser}">
                                                <span class="badge badge-green" style="padding:6px 12px;">✓ Booked</span>
                                            </c:if>
                                        </div>
                                    </c:if>
                                </c:when>
                                <c:when test="${post.postType == 'NOTES'}">
                                    <div class="interaction-bar">
                                        <form action="interact" method="post" style="margin:0;">
                                            <input type="hidden" name="action" value="${post.likedByCurrentUser ? 'unlike' : 'like'}">
                                            <input type="hidden" name="postId" value="${post.id}">
                                            <input type="hidden" name="returnUrl" value="feed">
                                            <button type="submit" class="interact-btn" style="${post.likedByCurrentUser ? 'color: var(--accent-pink);' : ''}">
                                                ${post.likedByCurrentUser ? '❤️' : '🤍'} ${post.likesCount}
                                            </button>
                                        </form>
                                        <form action="interact" method="post" style="margin:0;">
                                            <input type="hidden" name="action" value="${post.savedByCurrentUser ? 'unsave' : 'save'}">
                                            <input type="hidden" name="postId" value="${post.id}">
                                            <input type="hidden" name="returnUrl" value="feed">
                                            <button type="submit" class="interact-btn" style="${post.savedByCurrentUser ? 'color: var(--accent-cyan);' : ''}">
                                                ${post.savedByCurrentUser ? '🔖' : '📑'} Save
                                            </button>
                                        </form>
                                    </div>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </main>

    <!-- RIGHT WIDGETS -->
    <aside class="right-widgets">
        
        <!-- Suggested Users (REAL from DB) -->
        <div class="widget-card glass-card">
            <h3>Suggested for You <span>•••</span></h3>
            <c:choose>
                <c:when test="${not empty suggestedUsers}">
                    <c:forEach var="suggested" items="${suggestedUsers}">
                        <div class="user-list-item">
                            <div style="display:flex; gap:10px; align-items:center;">
                                <div class="avatar">${suggested.username.substring(0,1).toUpperCase()}</div>
                                <div>
                                    <div style="font-weight:600; font-size:0.9rem;">${suggested.username}</div>
                                    <div style="color:var(--text-muted); font-size:0.75rem;">${suggested.collegeName}</div>
                                </div>
                            </div>
                            <form action="connect" method="post" style="margin:0;">
                                <input type="hidden" name="targetUserId" value="${suggested.id}">
                                <input type="hidden" name="action" value="connect">
                                <button type="submit" class="btn-neon btn-cyan" style="padding: 4px 10px; font-size: 0.8rem;">Connect</button>
                            </form>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p style="color: var(--text-muted); font-size: 0.85rem;">No suggestions yet. Invite more students!</p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Leaderboard (REAL from DB) -->
        <div class="widget-card glass-card">
            <h3>Leaderboard <a href="leaderboard" style="font-size:0.75rem; color:var(--accent-cyan); text-decoration:none; font-weight:500;">View All →</a></h3>
            <c:choose>
                <c:when test="${not empty leaderboard}">
                    <c:forEach var="leader" items="${leaderboard}" varStatus="status">
                        <div class="user-list-item">
                            <div style="display:flex; gap:10px; align-items:center;">
                                <div class="rank-badge ${status.index == 0 ? 'rank-1' : status.index == 1 ? 'rank-2' : status.index == 2 ? 'rank-3' : 'rank-other'}">
                                    ${status.index + 1}
                                </div>
                                <div style="font-weight:600; font-size:0.9rem;">${leader.username}</div>
                            </div>
                            <div class="xp-display">
                                <c:choose>
                                    <c:when test="${leader.xp >= 1000}">${leader.xp / 1000}.${(leader.xp % 1000) / 100}k XP</c:when>
                                    <c:otherwise>${leader.xp} XP</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p style="color: var(--text-muted); font-size: 0.85rem;">Be the first on the leaderboard!</p>
                </c:otherwise>
            </c:choose>
        </div>
        
    </aside>

</div>

</body>
</html>
