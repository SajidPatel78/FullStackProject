<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - My Profile</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8f9fa; margin: 0; padding: 0; }
        .hero-nav { background: #131A22; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; color: white; }
        .hero-nav h1 { margin: 0; font-size: 1.5em; color: white; display: flex; align-items: center;}
        .nav-links a { color: #fff; text-decoration: none; margin-left: 20px; font-weight: 500; font-size: 0.9em; opacity: 0.9; }
        .nav-links a:hover { opacity: 1; text-decoration: underline; }
        .post-btn { background-color: #F72A75; color: white; padding: 8px 16px; border-radius: 4px; font-weight: bold; text-decoration: none; border: none; font-size: 0.9em; margin-left: 20px; cursor: pointer; transition: background 0.2s;}
        .post-btn:hover { background-color: #e02065; text-decoration: none;}
        
        .profile-container { max-width: 1000px; margin: 40px auto; padding: 0 20px; }
        
        .profile-header { background: #fff; padding: 40px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); margin-bottom: 30px; text-align: center; border: 1px solid #eaeaea; }
        .profile-header h2 { margin: 0 0 10px 0; color: #111827; font-size: 2em; }
        .profile-header p { margin: 5px 0; color: #4b5563; font-size: 1.1em; }
        
        .stats-row { display: flex; justify-content: center; gap: 40px; margin-top: 30px; padding-top: 20px; border-top: 1px solid #f3f4f6; }
        .stat-box { text-align: center; }
        .stat-val { font-size: 2em; font-weight: 700; color: #2563eb; line-height: 1; margin-bottom: 5px; }
        .stat-label { font-size: 0.9em; color: #6b7280; text-transform: uppercase; letter-spacing: 1px; font-weight: 600; }
        
        .post-card { background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); margin-bottom: 25px; position: relative; border: 1px solid #eaeaea; transition: transform 0.2s; }
        .post-card:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(0,0,0,0.1); }
        .post-badge { position: absolute; top: 25px; right: 25px; padding: 4px 10px; border-radius: 20px; font-size: 0.75em; font-weight: bold; letter-spacing: 0.5px; text-transform: uppercase; }
        .post-badge.service { background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; }
        .post-badge.notes { background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe; }
        
        .post-title { margin: 0 0 10px 0; padding-right: 100px; font-size: 1.3em; color: #111827; }
        .post-desc { color: #4b5563; line-height: 1.6; margin-bottom: 20px; }
        .category-tag { background: #fdf2f8; color: #be185d; padding: 3px 8px; border-radius: 4px; font-size: 0.8em; display: inline-block; margin-bottom: 10px;}
        
        .price-tag { font-size: 1.2em; font-weight: 700; color: #111827; }
        .meta-row { border-top: 1px solid #f3f4f6; padding-top: 15px; margin-top: 15px; display: flex; justify-content: space-between; align-items: center; }
    </style>
</head>
<body>
    <header class="hero-nav">
        <h1>SkillNest</h1>
        <div class="nav-links">
            <a href="feed">Feed</a>
            <a href="services">Services Only</a>
            <a href="profile" style="text-decoration: underline;">Profile</a>
            <a href="logout">Logout</a>
            <a href="add-post.jsp" class="post-btn">Post a Service / Content</a>
        </div>
    </header>
    
    <div class="profile-container">
        <div class="profile-header">
            <h2>${sessionScope.user.username}</h2>
            <p>🏫 <strong>${sessionScope.user.collegeName}</strong></p>
            <p>✉️ <a href="mailto:${sessionScope.user.email}" style="color: #2563eb; text-decoration: none;">${sessionScope.user.email}</a></p>
            
            <div class="stats-row">
                <div class="stat-box">
                    <div class="stat-val">${totalPosts != null ? totalPosts : 0}</div>
                    <div class="stat-label">Total Posts</div>
                </div>
                <div class="stat-box">
                    <div class="stat-val">${totalServices != null ? totalServices : 0}</div>
                    <div class="stat-label">Services</div>
                </div>
                <div class="stat-box">
                    <div class="stat-val">${totalLikes != null ? totalLikes : 0}</div>
                    <div class="stat-label">Likes Rcvd</div>
                </div>
            </div>
        </div>
        
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding: 0 10px;">
            <h3 style="font-size: 1.5em; color: #111827; margin:0;">My Portfolio</h3>
        </div>
        
        <div class="service-list">
            <c:choose>
                <c:when test="${empty myPosts}">
                    <div class="post-card" style="text-align: center; color: #6b7280; padding: 40px;">
                        <h3 style="margin-top: 0;">You haven't posted anything yet.</h3>
                        <p>Share your skills or notes with the community!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 25px;">
                        <c:forEach var="post" items="${myPosts}">
                            <div class="post-card">
                                <div class="post-badge ${post.postType == 'SERVICE' ? 'service' : 'notes'}">
                                    ${post.postType}
                                </div>
                                <h3 class="post-title">${post.title}</h3>
                                <div class="category-tag">${post.category}</div>
                                <p class="post-desc">${post.description}</p>
                                
                                <div class="meta-row">
                                    <c:choose>
                                        <c:when test="${post.postType == 'SERVICE'}">
                                            <div class="price-tag">$${post.price}</div>
                                            <div style="font-weight: 500; color: #d97706;">
                                                ⭐ ${post.averageRating > 0 ? post.averageRating : 'New'}
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div style="color: #6b7280; font-size: 0.9em;">Posted on ${post.createdAt}</div>
                                            <div style="font-weight: 500; color: #ef4444;">❤️ ${post.likesCount} Likes</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
