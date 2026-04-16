<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Services</title>
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
        
        .filter-bar { background: #1e2835; padding: 10px 40px; display: flex; gap: 15px; flex-wrap: wrap; align-items: center; justify-content: center; }
        .filter-bar input, .filter-bar select { padding: 8px 12px; border-radius: 4px; border: 1px solid #444; background: #fff; font-family: 'Inter', sans-serif; font-size: 0.9em; min-width: 200px; }
        .filter-bar button { background: #3b82f6; color: white; border: none; padding: 8px 20px; border-radius: 4px; font-weight: 600; cursor: pointer; transition: 0.2s;}
        .filter-bar button:hover { background: #2563eb; }
        
        .feed-container { max-width: 800px; margin: 40px auto; padding: 0 20px; }
        .post-card { background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); margin-bottom: 25px; position: relative; border: 1px solid #eaeaea; transition: transform 0.2s; }
        .post-card:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(0,0,0,0.1); }
        .post-badge { position: absolute; top: 25px; right: 25px; padding: 4px 10px; border-radius: 20px; font-size: 0.75em; font-weight: bold; letter-spacing: 0.5px; text-transform: uppercase; }
        .post-badge.service { background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; }
        
        .author-info { color: #555; font-size: 0.9em; margin-bottom: 15px; display: flex; align-items: center; gap: 10px;}
        .author-info strong { color: #1f2937; }
        .category-tag { background: #fdf2f8; color: #be185d; padding: 3px 8px; border-radius: 4px; font-size: 0.8em; margin-left: auto; }
        
        .post-title { margin: 0 0 10px 0; padding-right: 100px; font-size: 1.3em; color: #111827; }
        .post-desc { color: #4b5563; line-height: 1.6; margin-bottom: 20px; }
        
        .post-actions { display: flex; gap: 15px; align-items: center; border-top: 1px solid #f3f4f6; padding-top: 20px; }
        .price-tag { font-size: 1.2em; font-weight: 700; color: #111827; flex: 1; }
        .action-btn { background: #f3f4f6; color: #374151; padding: 8px 16px; border-radius: 4px; border: 1px solid #e5e7eb; font-weight: 600; cursor: pointer; text-decoration: none; font-size: 0.9em; display: inline-flex; align-items: center; justify-content: center; transition: 0.2s;}
        .action-btn:hover { background: #e5e7eb; }
        .action-btn.primary { background: #2563eb; color: white; border-color: #2563eb; }
        .action-btn.primary:hover { background: #1d4ed8; border-color: #1d4ed8; }
        .action-btn.success { background: #10b981; color: white; border-color: #10b981; }
        .action-btn.success:hover { background: #059669; }
    </style>
</head>
<body>
    <header class="hero-nav">
        <h1>SkillNest</h1>
        <div class="nav-links">
            <a href="feed">Feed</a>
            <a href="services" style="text-decoration: underline;">Services Only</a>
            <a href="profile">Profile</a>
            <a href="logout">Logout</a>
            <a href="add-post.jsp" class="post-btn">Post a Service / Content</a>
        </div>
    </header>
    
    <div class="filter-bar">
        <form action="services" method="get" style="display:flex; gap:10px; flex-wrap:wrap; width:100%; max-width:800px; justify-content:center;">
            <input type="text" name="searchQuery" placeholder="Search services..." value="${querySearch}">
            <select name="category">
                <option value="">All Categories</option>
                <option value="Coding" ${queryCategory == 'Coding' ? 'selected' : ''}>Coding & Development</option>
                <option value="Design" ${queryCategory == 'Design' ? 'selected' : ''}>Design & Graphics</option>
                <option value="Writing" ${queryCategory == 'Writing' ? 'selected' : ''}>Writing & Translation</option>
                <option value="Engineering" ${queryCategory == 'Engineering' ? 'selected' : ''}>Engineering</option>
                <option value="Business" ${queryCategory == 'Business' ? 'selected' : ''}>Business & Management</option>
                <option value="Other" ${queryCategory == 'Other' ? 'selected' : ''}>Other</option>
            </select>
            <button type="submit">Search Services</button>
        </form>
    </div>
    
    <div class="feed-container">
        <div class="service-list">
            <c:choose>
                <c:when test="${empty services}">
                    <div class="post-card" style="text-align: center; color: #6b7280; padding: 40px;">
                        <h3 style="margin-top: 0;">No services found.</h3>
                        <p>Try clearing your filters or offer a new service yourself!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="srv" items="${services}">
                        <div class="post-card">
                            <div class="post-badge service">SERVICE</div>
                            <h3 class="post-title">${srv.title}</h3>
                            <div class="author-info">
                                <span>By <strong>${srv.username}</strong></span>
                                <span class="category-tag">${srv.category}</span>
                            </div>
                            <p class="post-desc">${srv.description}</p>
                            
                            <div class="post-actions">
                                <div class="price-tag">$${srv.price} USD</div>
                                <div style="font-weight: 500; font-size: 1.1em; color: #d97706; margin-right: auto; margin-left: 20px;">
                                    ⭐ ${srv.averageRating > 0 ? srv.averageRating : 'New'}
                                </div>
                                <c:if test="${not empty sessionScope.user and srv.userId != sessionScope.user.id}">
                                    <c:choose>
                                        <c:when test="${srv.bookedByCurrentUser}">
                                            <div style="color: #059669; font-weight: bold; margin-right: 10px;">✓ Taken</div>
                                            <form action="messages" method="get" style="margin: 0;">
                                                <input type="hidden" name="toUserId" value="${srv.userId}">
                                                <input type="hidden" name="context" value="Regarding your service: ${srv.title}">
                                                <button type="submit" class="action-btn">Message Student</button>
                                            </form>
                                            <c:if test="${not srv.reviewedByCurrentUser}">
                                                <form action="review" method="post" style="display: flex; gap: 5px; margin: 0; margin-left: 10px;">
                                                    <input type="hidden" name="serviceId" value="${srv.id}">
                                                    <select name="rating" required style="padding: 5px; border-radius: 4px; border: 1px solid #ccc;">
                                                        <option value="">Rate...</option>
                                                        <option value="5">⭐⭐⭐⭐⭐</option>
                                                        <option value="4">⭐⭐⭐⭐</option>
                                                        <option value="3">⭐⭐⭐</option>
                                                        <option value="2">⭐⭐</option>
                                                        <option value="1">⭐</option>
                                                    </select>
                                                    <input type="text" name="comment" placeholder="Short review..." style="padding: 5px; border-radius: 4px; border: 1px solid #ccc; width:100px;">
                                                    <button type="submit" class="action-btn primary" style="padding: 5px 10px;">Submit</button>
                                                </form>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="messages" method="get" style="margin: 0;">
                                                <input type="hidden" name="toUserId" value="${srv.userId}">
                                                <input type="hidden" name="context" value="Regarding your service: ${srv.title}">
                                                <button type="submit" class="action-btn">Contact Student</button>
                                            </form>
                                            <form action="book" method="post" style="margin: 0; margin-left: 10px;">
                                                <input type="hidden" name="serviceId" value="${srv.id}">
                                                <button type="submit" class="action-btn success">Take Service</button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
