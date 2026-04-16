<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Dashboard</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=2.0">
    <style>
        /* Specific layout for the 3-column dashboard */
        .feed-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
            overflow-y: auto;
            padding-right: 10px;
        }
        
        /* Hide scrollbar for clean look */
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
        }

        .top-search-bar {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 10px;
        }
        .top-search-bar .glass-input {
            flex: 1;
            border-radius: 20px;
            padding: 12px 20px;
        }

        .welcome-header {
            font-size: 1.8rem;
            font-weight: 600;
            margin: 0;
        }

        /* Widgets & Grids */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .widget-card {
            padding: 20px;
        }
        .widget-card h3 {
            margin-top: 0;
            font-size: 1.1rem;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Trending Skills */
        .trending-tags {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            padding-bottom: 5px;
        }
        .tag-pill {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            padding: 8px 16px;
            border-radius: 20px;
            white-space: nowrap;
            font-size: 0.9rem;
            color: var(--text-muted);
            cursor: pointer;
        }
        .tag-pill:hover { background: rgba(255,255,255,0.1); color: white; }

        /* Progress Bar */
        .progress-item {
            margin-bottom: 15px;
        }
        .progress-head {
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        .progress-track {
            height: 6px;
            background: rgba(255,255,255,0.1);
            border-radius: 3px;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--accent-cyan), var(--accent-purple));
            border-radius: 3px;
        }

        /* Create Post */
        .create-post {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        /* Feed Cards */
        .post-card {
            padding: 25px;
            margin-bottom: 20px;
        }
        .post-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        .post-author {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
            color: white;
        }
        .author-name {
            font-weight: 600;
            color: white;
            font-size: 1.1rem;
        }
        .author-meta {
            font-size: 0.8rem;
            color: var(--text-muted);
        }
        .post-body h4 {
            margin: 0 0 10px 0;
            font-size: 1.2rem;
        }
        .post-body p {
            color: var(--text-muted);
            line-height: 1.6;
            margin-bottom: 20px;
        }
        .post-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid var(--card-border);
            padding-top: 15px;
            gap: 15px;
        }
        .interaction-bar {
            display: flex;
            gap: 15px;
        }
        .interact-btn {
            background: none;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 0.9rem;
            transition: color 0.2s;
            font-family: 'Outfit', sans-serif;
        }
        .interact-btn:hover { color: var(--accent-pink); }
        .service-price {
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--accent-green);
        }

        /* Right User List */
        .user-list-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        .user-list-item .avatar {
            width: 32px;
            height: 32px;
            font-size: 0.9rem;
            background: rgba(255,255,255,0.1);
        }
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
                <a href="#" class="nav-item">🏆 Challenges</a>
                <a href="#" class="nav-item">📊 Leaderboard</a>
                <a href="services" class="nav-item">💼 Services</a>
                <a href="profile" class="nav-item">⚙️ Settings</a>
                <a href="logout" class="nav-item" style="color: var(--accent-pink);">🚪 Logout</a>
            </nav>
        </div>
        
        <div class="glass-card" style="padding: 15px; text-align: center; background: rgba(0,0,0,0.2);">
            <div class="avatar" style="margin: 0 auto 10px auto; width: 50px; height: 50px; font-size: 1.5rem;">
                ${sessionScope.user.username.substring(0, 1).toUpperCase()}
            </div>
            <div style="font-weight: 600;">${sessionScope.user.username}</div>
            <div style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 10px;">Level 12 • 8,230 XP</div>
            <div class="progress-track"><div class="progress-fill" style="width: 70%;"></div></div>
        </div>
    </aside>

    <!-- CENTER FEED -->
    <main class="feed-main">
        <div class="top-search-bar">
            <input type="text" class="glass-input" placeholder="🔍 Search for skills, posts, or users...">
            <a href="profile" class="avatar">${sessionScope.user.username.substring(0, 1).toUpperCase()}</a>
        </div>

        <h1 class="welcome-header">Welcome back, <span class="text-gradient">${sessionScope.user.username}</span>!</h1>

        <!-- Trending Skills Widget -->
        <div class="widget-card glass-card">
            <h3 style="margin-bottom: 10px;">Trending Skills <span>→</span></h3>
            <div class="trending-tags">
                <span class="tag-pill">💻 Web Development</span>
                <span class="tag-pill">📊 Data Science</span>
                <span class="tag-pill">🎨 UI/UX Design</span>
                <span class="tag-pill">📱 App Dev</span>
            </div>
        </div>

        <div class="dashboard-grid">
            <!-- Daily Challenge Mock -->
            <div class="widget-card glass-card" style="background: linear-gradient(135deg, rgba(139,92,246,0.1), rgba(247,42,117,0.05));">
                <h3>⚡ Daily Challenge</h3>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 15px;">Build a Todo List App with React</p>
                <button class="btn-neon" style="width: 100%;">Accept Quest</button>
            </div>

            <!-- Progress Mock -->
            <div class="widget-card glass-card">
                <h3>📈 Your Progress <span>→</span></h3>
                <div class="progress-item">
                    <div class="progress-head"><span>JavaScript Basics</span> <span style="color: var(--accent-cyan);">85%</span></div>
                    <div class="progress-track"><div class="progress-fill" style="width: 85%;"></div></div>
                </div>
                <div class="progress-item">
                    <div class="progress-head"><span>UI/UX Design</span> <span style="color: var(--accent-purple);">67%</span></div>
                    <div class="progress-track"><div class="progress-fill" style="width: 67%;"></div></div>
                </div>
            </div>
        </div>

        <!-- Post Creation Input -->
        <div class="widget-card glass-card create-post">
            <div class="avatar" style="width: 35px; height: 35px; font-size: 1rem;">${sessionScope.user.username.substring(0,1).toUpperCase()}</div>
            <input type="text" class="glass-input" style="flex:1;" placeholder="What's on your mind, ${sessionScope.user.username}?">
            <a href="add-post.jsp" class="btn-solid">✨ Create</a>
        </div>

        <!-- Real Feed Loop from Backend -->
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
                                    <div class="author-meta">${post.userCollege} • 10 mins ago</div>
                                </div>
                            </div>
                            <span class="badge ${post.postType == 'SERVICE' ? 'badge-green' : 'badge-purple'}">${post.postType}</span>
                        </div>
                        
                        <div class="post-body">
                            <h4>${post.title}</h4>
                            <p>${post.description}</p>
                            <span class="badge badge-cyan" style="background: rgba(6,182,212,0.1);">${post.category}</span>
                        </div>

                        <div class="post-footer">
                            <c:choose>
                                <c:when test="${post.postType == 'SERVICE'}">
                                    <div class="service-price">$${post.price}</div>
                                    <c:if test="${post.userId != sessionScope.user.id}">
                                        <div style="display:flex; gap:10px;">
                                            <form action="messages" method="get" style="margin:0;">
                                                <input type="hidden" name="toUserId" value="${post.userId}">
                                                <button type="submit" class="btn-neon">Message</button>
                                            </form>
                                            <c:if test="${!post.bookedByCurrentUser}">
                                                <form action="book" method="post" style="margin:0;">
                                                    <input type="hidden" name="serviceId" value="${post.id}">
                                                    <button type="submit" class="btn-solid">Book Service</button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </c:if>
                                </c:when>
                                <c:when test="${post.postType == 'NOTES'}">
                                    <div class="interaction-bar">
                                        <form action="interact" method="post" style="margin:0;">
                                            <input type="hidden" name="action" value="${post.likedByCurrentUser ? 'unlike' : 'like'}">
                                            <input type="hidden" name="postId" value="${post.id}">
                                            <button type="submit" class="interact-btn" style="${post.likedByCurrentUser ? 'color: var(--accent-pink);' : ''}">
                                                💬 ${post.likesCount}
                                            </button>
                                        </form>
                                        <button class="interact-btn">🔄 12</button>
                                        <form action="interact" method="post" style="margin:0;">
                                            <input type="hidden" name="action" value="${post.savedByCurrentUser ? 'unsave' : 'save'}">
                                            <input type="hidden" name="postId" value="${post.id}">
                                            <button type="submit" class="interact-btn" style="${post.savedByCurrentUser ? 'color: var(--accent-cyan);' : ''}">
                                                📑 Save
                                            </button>
                                        </form>
                                    </div>
                                    <div style="color: var(--text-muted); font-size: 0.8rem;">View all comments</div>
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
        
        <div class="widget-card glass-card">
            <h3>Suggested for You <span>•••</span></h3>
            
            <div class="user-list-item">
                <div style="display:flex; gap:10px; align-items:center;">
                    <div class="avatar">N</div>
                    <div>
                        <div style="font-weight:600; font-size:0.9rem;">Nishant Bhatia</div>
                        <div style="color:var(--text-muted); font-size:0.75rem;">Data Analyst</div>
                    </div>
                </div>
                <button class="btn-neon btn-cyan" style="padding: 4px 10px; font-size: 0.8rem;">Connect</button>
            </div>
            
            <div class="user-list-item">
                <div style="display:flex; gap:10px; align-items:center;">
                    <div class="avatar">P</div>
                    <div>
                        <div style="font-weight:600; font-size:0.9rem;">Priya Singh</div>
                        <div style="color:var(--text-muted); font-size:0.75rem;">Web Developer</div>
                    </div>
                </div>
                <button class="btn-neon btn-cyan" style="padding: 4px 10px; font-size: 0.8rem;">Connect</button>
            </div>
            
            <a href="#" style="color: var(--text-muted); font-size: 0.85rem; text-decoration: none;">View All ></a>
        </div>

        <div class="widget-card glass-card">
            <h3>Leaderboard <span>🏆</span></h3>
            
            <div class="user-list-item">
                <div style="display:flex; gap:10px; align-items:center;">
                    <div class="avatar" style="width:25px; height:25px; font-size:0.8rem; background: gold;">1</div>
                    <div style="font-weight:600; font-size:0.9rem;">Rahul Sharma</div>
                </div>
                <div style="color:var(--accent-cyan); font-size:0.85rem; font-weight:bold;">8.4k XP</div>
            </div>
            
            <div class="user-list-item">
                <div style="display:flex; gap:10px; align-items:center;">
                    <div class="avatar" style="width:25px; height:25px; font-size:0.8rem; background: silver;">2</div>
                    <div style="font-weight:600; font-size:0.9rem;">Ananya Patel</div>
                </div>
                <div style="color:var(--accent-cyan); font-size:0.85rem; font-weight:bold;">2.5k XP</div>
            </div>
        </div>
        
    </aside>

</div>

</body>
</html>
