<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Services</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=3.0">
    <style>
        .services-page { max-width: 900px; margin: 0 auto; padding: 30px 20px; }
        .back-nav { display: flex; align-items: center; gap: 20px; margin-bottom: 20px; }
        .back-nav a { color: var(--text-muted); text-decoration: none; font-weight: 500; }
        .back-nav a:hover { color: white; }

        .filter-row { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 30px; }
        .filter-row .glass-input, .filter-row .glass-select { flex: 1; min-width: 200px; }
        .glass-select { background: rgba(255,255,255,0.05); border: 1px solid var(--card-border); color: var(--text-main); padding: 10px 16px; border-radius: 8px; font-family: 'Outfit', sans-serif; }
        .glass-select option { background: #1B1236; color: white; }

        .srv-card { padding: 25px; margin-bottom: 20px; transition: transform 0.2s; }
        .srv-card:hover { transform: translateY(-3px); }
        .srv-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; }
        .srv-card h4 { margin: 0 0 8px 0; font-size: 1.2rem; padding-right: 80px; }
        .srv-card p { color: var(--text-muted); line-height: 1.5; margin-bottom: 20px; }
        .srv-footer { display: flex; align-items: center; gap: 15px; border-top: 1px solid var(--card-border); padding-top: 15px; flex-wrap: wrap; }
        .srv-price { font-size: 1.3rem; font-weight: 700; color: var(--accent-green); flex: 1; }
        .srv-rating { color: #d97706; font-weight: 500; }

        .review-form { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; }
        .review-form select, .review-form input { background: rgba(255,255,255,0.05); border: 1px solid var(--card-border); color: white; padding: 6px 10px; border-radius: 6px; font-family: 'Outfit', sans-serif; font-size: 0.85rem; }
        .review-form select option { background: #1B1236; }
    </style>
</head>
<body>
    <div class="services-page">
        <div class="back-nav">
            <a href="feed">← Back to Feed</a>
            <h2 style="margin:0; flex:1; text-align:center;">💼 Service Marketplace</h2>
            <a href="add-post.jsp" class="btn-solid" style="text-decoration:none;">+ Post Service</a>
        </div>

        <form action="services" method="get" class="filter-row">
            <input type="text" name="searchQuery" class="glass-input" placeholder="🔍 Search services..." value="${querySearch}">
            <select name="category" class="glass-select">
                <option value="">All Categories</option>
                <option value="Coding" ${queryCategory == 'Coding' ? 'selected' : ''}>Coding & Development</option>
                <option value="Design" ${queryCategory == 'Design' ? 'selected' : ''}>Design & Graphics</option>
                <option value="Writing" ${queryCategory == 'Writing' ? 'selected' : ''}>Writing & Translation</option>
                <option value="Engineering" ${queryCategory == 'Engineering' ? 'selected' : ''}>Engineering</option>
                <option value="Business" ${queryCategory == 'Business' ? 'selected' : ''}>Business & Management</option>
                <option value="Other" ${queryCategory == 'Other' ? 'selected' : ''}>Other</option>
            </select>
            <button type="submit" class="btn-solid">Search</button>
        </form>

        <c:choose>
            <c:when test="${empty services}">
                <div class="glass-card" style="text-align: center; color: var(--text-muted); padding: 40px;">
                    <h3 style="margin-top: 0; color: white;">No services found.</h3>
                    <p>Try clearing filters or offer a new service!</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="srv" items="${services}">
                    <div class="glass-card srv-card">
                        <div class="srv-header">
                            <div>
                                <h4>${srv.title}</h4>
                                <div style="display:flex; gap:8px; align-items:center; margin-bottom:5px;">
                                    <span style="color:var(--text-muted); font-size:0.9rem;">By <strong style="color:white;">${srv.username}</strong></span>
                                    <span class="badge badge-pink">${srv.category}</span>
                                </div>
                            </div>
                            <span class="badge badge-green">SERVICE</span>
                        </div>
                        <p>${srv.description}</p>

                        <div class="srv-footer">
                            <div class="srv-price">$${srv.price}</div>
                            <div class="srv-rating">⭐ ${srv.averageRating > 0 ? srv.averageRating : 'New'}</div>

                            <c:if test="${not empty sessionScope.user and srv.userId != sessionScope.user.id}">
                                <c:choose>
                                    <c:when test="${srv.bookedByCurrentUser}">
                                        <span class="badge badge-green" style="padding:6px 12px;">✓ Taken</span>
                                        <form action="messages" method="get" style="margin:0;">
                                            <input type="hidden" name="toUserId" value="${srv.userId}">
                                            <button type="submit" class="btn-neon" style="padding:6px 12px; font-size:0.85rem;">Message</button>
                                        </form>
                                        <c:if test="${not srv.reviewedByCurrentUser}">
                                            <form action="review" method="post" class="review-form" style="margin:0;">
                                                <input type="hidden" name="serviceId" value="${srv.id}">
                                                <select name="rating" required>
                                                    <option value="">Rate...</option>
                                                    <option value="5">⭐⭐⭐⭐⭐</option>
                                                    <option value="4">⭐⭐⭐⭐</option>
                                                    <option value="3">⭐⭐⭐</option>
                                                    <option value="2">⭐⭐</option>
                                                    <option value="1">⭐</option>
                                                </select>
                                                <input type="text" name="comment" placeholder="Short review...">
                                                <button type="submit" class="btn-solid" style="padding:6px 12px; font-size:0.85rem;">Submit</button>
                                            </form>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="messages" method="get" style="margin:0;">
                                            <input type="hidden" name="toUserId" value="${srv.userId}">
                                            <button type="submit" class="btn-neon" style="padding:6px 12px; font-size:0.85rem;">Contact</button>
                                        </form>
                                        <form action="book" method="post" style="margin:0;">
                                            <input type="hidden" name="serviceId" value="${srv.id}">
                                            <button type="submit" class="btn-solid" style="padding:6px 12px; font-size:0.85rem;">Book Service</button>
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
</body>
</html>
