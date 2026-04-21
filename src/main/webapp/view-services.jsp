<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="SkillNest Marketplace — hire talented students or sell your skills. Web dev, design, writing, and more.">
    <title>SkillNest - Student Freelance Marketplace</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=4.0">
    <style>
        /* ── PAGE LAYOUT ────────────────────────────── */
        body { min-height: 100vh; }
        .marketplace-page { max-width: 1200px; margin: 0 auto; padding: 30px 20px 60px; }

        /* ── TOP NAV BAR ────────────────────────────── */
        .top-bar {
            display: flex; align-items: center; gap: 16px; margin-bottom: 35px; flex-wrap: wrap;
        }
        .top-bar-left { display: flex; align-items: center; gap: 14px; }
        .top-bar-left a { color: var(--text-muted); text-decoration: none; font-weight: 500; transition: color 0.2s; font-size: 0.95rem; }
        .top-bar-left a:hover { color: white; }
        .page-title { font-size: 1.7rem; font-weight: 700; margin: 0; }
        .top-bar-right { margin-left: auto; display: flex; gap: 12px; }

        /* ── HERO BANNER ────────────────────────────── */
        .marketplace-hero {
            padding: 40px 50px;
            margin-bottom: 35px;
            border-radius: 20px;
            background: linear-gradient(135deg, rgba(139,92,246,0.18) 0%, rgba(6,182,212,0.1) 50%, rgba(247,42,117,0.08) 100%);
            border: 1px solid rgba(139,92,246,0.2);
            display: flex; align-items: center; justify-content: space-between; gap: 30px; flex-wrap: wrap;
        }
        .hero-text h2 { margin: 0 0 8px; font-size: 1.8rem; font-weight: 700; }
        .hero-text p  { margin: 0; color: var(--text-muted); font-size: 1rem; max-width: 420px; line-height: 1.6; }
        .hero-cta { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; margin-top: 20px; }
        .hero-badges { display: flex; gap: 20px; }
        .hero-badge { text-align: center; }
        .hero-badge-val { font-size: 1.6rem; font-weight: 700; color: var(--accent-cyan); }
        .hero-badge-lbl { font-size: 0.78rem; color: var(--text-muted); }

        /* ── CATEGORY PILLS ─────────────────────────── */
        .category-bar {
            display: flex; gap: 10px; overflow-x: auto; padding-bottom: 4px; margin-bottom: 28px;
            scrollbar-width: none;
        }
        .category-bar::-webkit-scrollbar { display: none; }
        .cat-pill {
            display: flex; align-items: center; gap: 8px;
            padding: 9px 20px; border-radius: 30px; white-space: nowrap;
            font-size: 0.9rem; font-weight: 500; cursor: pointer; text-decoration: none;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            color: var(--text-muted);
            transition: all 0.25s ease;
        }
        .cat-pill:hover, .cat-pill.active {
            background: rgba(139,92,246,0.15);
            border-color: rgba(139,92,246,0.35);
            color: white;
        }

        /* ── SEARCH + SORT ROW ──────────────────────── */
        .search-sort-row {
            display: flex; gap: 12px; align-items: center; margin-bottom: 28px; flex-wrap: wrap;
        }
        .search-wrapper {
            flex: 1; position: relative; min-width: 200px;
        }
        .search-wrapper .glass-input { width: 100%; box-sizing: border-box; padding-left: 42px; border-radius: 12px; }
        .search-icon { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); font-size: 1rem; color: var(--text-muted); pointer-events: none; }
        .glass-select {
            background: rgba(255,255,255,0.05); border: 1px solid var(--card-border);
            color: var(--text-main); padding: 10px 14px; border-radius: 10px;
            font-family: 'Outfit', sans-serif; font-size: 0.9rem; outline: none;
        }
        .glass-select option { background: #1B1236; }

        /* ── RESULTS META ───────────────────────────── */
        .results-meta {
            font-size: 0.9rem; color: var(--text-muted); margin-bottom: 20px;
            display: flex; align-items: center; justify-content: space-between;
        }
        .results-meta strong { color: var(--text-main); }

        /* ── SERVICE CARD GRID ──────────────────────── */
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(310px, 1fr));
            gap: 24px;
        }

        .srv-card {
            padding: 0; overflow: hidden; transition: all 0.3s ease;
            display: flex; flex-direction: column; position: relative;
        }
        .srv-card:hover { transform: translateY(-6px); box-shadow: 0 16px 50px rgba(0,0,0,0.45); }

        /* Card top colour strip per category */
        .srv-strip {
            height: 4px; width: 100%;
            background: linear-gradient(90deg, var(--accent-cyan), var(--accent-purple));
        }
        .srv-strip.design   { background: linear-gradient(90deg, #f43f5e, #e879f9); }
        .srv-strip.writing  { background: linear-gradient(90deg, #f59e0b, #ef4444); }
        .srv-strip.engineering { background: linear-gradient(90deg, #10b981, #06b6d4); }
        .srv-strip.business { background: linear-gradient(90deg, #3b82f6, #8b5cf6); }

        .srv-body { padding: 22px 22px 0; flex: 1; }
        .srv-top  { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 14px; }
        .srv-author { display: flex; align-items: center; gap: 10px; }
        .srv-avatar {
            width: 36px; height: 36px; border-radius: 50%; flex-shrink: 0;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.95rem; color: white;
        }
        .srv-author-name { font-weight: 600; font-size: 0.9rem; }
        .srv-author-college { font-size: 0.75rem; color: var(--text-muted); }
        .srv-category-badge {
            font-size: 0.72rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.5px; padding: 4px 10px; border-radius: 12px;
            flex-shrink: 0;
        }
        .cat-coding    { background: rgba(6,182,212,0.12);  color: var(--accent-cyan);   border: 1px solid rgba(6,182,212,0.2);  }
        .cat-design    { background: rgba(244,63,94,0.12);  color: #f472b6;              border: 1px solid rgba(244,63,94,0.2);  }
        .cat-writing   { background: rgba(245,158,11,0.12); color: #fbbf24;              border: 1px solid rgba(245,158,11,0.2); }
        .cat-engineering { background: rgba(16,185,129,0.12); color: var(--accent-green); border: 1px solid rgba(16,185,129,0.2); }
        .cat-business  { background: rgba(59,130,246,0.12); color: #60a5fa;              border: 1px solid rgba(59,130,246,0.2); }
        .cat-other     { background: rgba(139,92,246,0.12); color: var(--accent-purple); border: 1px solid rgba(139,92,246,0.2); }

        .srv-title { font-size: 1.05rem; font-weight: 600; margin: 0 0 8px; line-height: 1.4; }
        .srv-desc  { font-size: 0.88rem; color: var(--text-muted); line-height: 1.6; margin: 0 0 18px;
                     display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .srv-rating {
            display: flex; align-items: center; gap: 5px;
            font-size: 0.85rem; color: #fbbf24; font-weight: 600; margin-bottom: 16px;
        }
        .srv-rating .review-count { color: var(--text-muted); font-weight: 400; font-size: 0.8rem; }

        .srv-footer-card {
            padding: 14px 22px;
            margin-top: auto;
            border-top: 1px solid var(--card-border);
            display: flex; align-items: center; justify-content: space-between; gap: 10px;
        }
        .srv-price-tag { font-size: 1.25rem; font-weight: 700; color: var(--accent-green); }
        .srv-price-label { font-size: 0.75rem; color: var(--text-muted); margin-bottom: 2px; }
        .srv-actions { display: flex; gap: 8px; }
        .btn-contact {
            background: none; border: 1px solid var(--accent-cyan); color: var(--accent-cyan);
            padding: 7px 14px; border-radius: 8px; font-family: 'Outfit', sans-serif;
            font-size: 0.85rem; font-weight: 600; cursor: pointer; transition: all 0.25s;
        }
        .btn-contact:hover { background: var(--accent-cyan); color: #0a0a1a; }
        .btn-book {
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            border: none; color: white; padding: 7px 16px; border-radius: 8px;
            font-family: 'Outfit', sans-serif; font-size: 0.85rem; font-weight: 600;
            cursor: pointer; transition: all 0.25s;
        }
        .btn-book:hover { transform: scale(1.04); box-shadow: 0 4px 15px var(--glow-pink); }

        /* Booked state */
        .booked-chip {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 6px 13px; border-radius: 8px; font-size: 0.82rem; font-weight: 600;
            background: rgba(16,185,129,0.12); color: var(--accent-green);
            border: 1px solid rgba(16,185,129,0.25);
        }

        /* My service tag */
        .own-chip {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 6px 13px; border-radius: 8px; font-size: 0.82rem; font-weight: 500;
            background: rgba(139,92,246,0.1); color: var(--accent-purple);
            border: 1px solid rgba(139,92,246,0.2);
        }

        /* ── INLINE REVIEW FORM ─────────────────────── */
        .review-panel {
            padding: 12px 22px 16px; border-top: 1px solid var(--card-border);
            background: rgba(255,255,255,0.02);
        }
        .review-panel p { margin: 0 0 8px; font-size: 0.82rem; color: var(--text-muted); }
        .review-row { display: flex; gap: 8px; flex-wrap: wrap; }
        .review-row select, .review-row input {
            background: rgba(255,255,255,0.05); border: 1px solid var(--card-border);
            color: white; padding: 6px 10px; border-radius: 7px;
            font-family: 'Outfit', sans-serif; font-size: 0.83rem;
        }
        .review-row select option { background: #1B1236; }

        /* ── EMPTY STATE ────────────────────────────── */
        .empty-state {
            text-align: center; padding: 70px 30px; grid-column: 1 / -1;
        }
        .empty-icon { font-size: 3.5rem; margin-bottom: 16px; }
        .empty-state h3 { margin: 0 0 10px; font-size: 1.4rem; }
        .empty-state p  { color: var(--text-muted); margin: 0 0 24px; }

        @media (max-width: 768px) {
            .marketplace-hero { padding: 28px 24px; flex-direction: column; }
            .hero-badges { justify-content: flex-start; }
            .services-grid { grid-template-columns: 1fr; }
            .top-bar { flex-direction: column; align-items: flex-start; }
            .top-bar-right { margin-left: 0; }
        }
    </style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="marketplace-page">

    <!-- Top Nav -->
    <div class="top-bar">
        <div class="top-bar-left">
            <a href="feed">← Feed</a>
            <span style="color: rgba(255,255,255,0.15);">|</span>
            <h1 class="page-title"><i class="fa-solid fa-briefcase"></i> Student Marketplace</h1>
        </div>
        <div class="top-bar-right">
            <c:if test="${not empty sessionScope.user}">
                <a href="add-service.jsp" class="btn-neon btn-cyan" style="text-decoration:none; padding:9px 20px; font-size:0.9rem;">+ Sell a Skill</a>
                <a href="add-post.jsp" class="btn-solid" style="text-decoration:none; padding:9px 20px; font-size:0.9rem;">+ Post Service</a>
            </c:if>
        </div>
    </div>

    <!-- Hero Banner -->
    <div class="marketplace-hero">
        <div class="hero-text">
            <h2>Find Talented Students. <span class="text-gradient">Get Work Done.</span></h2>
            <p>Browse services offered by real students from colleges across India. Hire affordable talent or monetise your own skills — all in one place.</p>
            <div class="hero-cta">
                <a href="add-post.jsp" class="btn-solid" style="text-decoration:none; padding:12px 28px;"><i class="fa-solid fa-rocket"></i> Start Selling</a>
                <a href="#services-list" class="btn-neon btn-cyan" style="text-decoration:none; padding:12px 28px;">Browse Services</a>
            </div>
        </div>
        <div class="hero-badges">
            <div class="hero-badge">
                <div class="hero-badge-val">1,200+</div>
                <div class="hero-badge-lbl">Services Listed</div>
            </div>
            <div class="hero-badge">
                <div class="hero-badge-val">500+</div>
                <div class="hero-badge-lbl">Student Sellers</div>
            </div>
            <div class="hero-badge">
                <div class="hero-badge-val">$5–$200</div>
                <div class="hero-badge-lbl">Starting Price</div>
            </div>
        </div>
    </div>

    <!-- Category Quick-filter Pills -->
    <div class="category-bar">
        <a href="services" class="cat-pill ${empty queryCategory ? 'active' : ''}"><i class="fa-solid fa-globe"></i> All Categories</a>
        <a href="services?category=Coding"      class="cat-pill ${queryCategory == 'Coding'      ? 'active' : ''}"><i class="fa-solid fa-laptop-code"></i> Coding & Dev</a>
        <a href="services?category=Design"      class="cat-pill ${queryCategory == 'Design'      ? 'active' : ''}"><i class="fa-solid fa-palette"></i> Design</a>
        <a href="services?category=Writing"     class="cat-pill ${queryCategory == 'Writing'     ? 'active' : ''}"><i class="fa-solid fa-pen-nib"></i> Writing</a>
        <a href="services?category=Engineering" class="cat-pill ${queryCategory == 'Engineering' ? 'active' : ''}"><i class="fa-solid fa-wrench"></i> Engineering</a>
        <a href="services?category=Business"    class="cat-pill ${queryCategory == 'Business'    ? 'active' : ''}"><i class="fa-solid fa-chart-pie"></i> Business</a>
        <a href="services?category=Other"       class="cat-pill ${queryCategory == 'Other'       ? 'active' : ''}"><i class="fa-solid fa-wand-magic-sparkles"></i> Other</a>
    </div>

    <!-- Search + Sort -->
    <form action="services" method="get" id="services-list">
        <div class="search-sort-row">
            <c:if test="${not empty queryCategory}">
                <input type="hidden" name="category" value="${queryCategory}">
            </c:if>
            <div class="search-wrapper">
                <span class="search-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
                <input type="text" name="searchQuery" class="glass-input"
                       placeholder="Search services, skills, or student names…"
                       value="${querySearch}" autocomplete="off">
            </div>
            <select name="sort" class="glass-select">
                <option value="latest"><i class="fa-solid fa-stopwatch"></i> Latest</option>
                <option value="price_low" ${querySort == 'price_low' ? 'selected' : ''}><i class="fa-solid fa-money-bill-wave"></i> Price: Low to High</option>
                <option value="price_high" ${querySort == 'price_high' ? 'selected' : ''}><i class="fa-solid fa-sack-dollar"></i> Price: High to Low</option>
                <option value="rating" ${querySort == 'rating' ? 'selected' : ''}><i class="fa-solid fa-star"></i> Top Rated</option>
            </select>
            <button type="submit" class="btn-solid" style="padding: 10px 22px; border-radius: 10px;">Search</button>
        </div>
    </form>

    <!-- Results Count -->
    <div class="results-meta">
        <span>
            <c:choose>
                <c:when test="${not empty services}">
                    Showing <strong>${services.size()}</strong> service<c:if test="${services.size() != 1}">s</c:if>
                    <c:if test="${not empty queryCategory}"> in <strong>${queryCategory}</strong></c:if>
                    <c:if test="${not empty querySearch}"> for "<strong>${querySearch}</strong>"</c:if>
                </c:when>
                <c:otherwise>No services found</c:otherwise>
            </c:choose>
        </span>
        <c:if test="${not empty sessionScope.user}">
            <a href="profile" style="color:var(--text-muted); font-size:0.85rem; text-decoration:none;">My Services →</a>
        </c:if>
    </div>

    <!-- Services Grid -->
    <div class="services-grid">
        <c:choose>
            <c:when test="${empty services}">
                <div class="glass-card empty-state">
                    <div class="empty-icon"><i class="fa-solid fa-binoculars"></i></div>
                    <h3>No Services Found</h3>
                    <p>Try a different search or category — or be the first to offer this service!</p>
                    <a href="add-post.jsp" class="btn-solid" style="text-decoration:none; display:inline-block; padding:12px 28px;">
                        <i class="fa-solid fa-rocket"></i> Post Your First Service
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="srv" items="${services}">
                    <c:set var="catClass" value="${srv.category == 'Coding' ? 'coding' : srv.category == 'Design' ? 'design' : srv.category == 'Writing' ? 'writing' : srv.category == 'Engineering' ? 'engineering' : srv.category == 'Business' ? 'business' : 'other'}" />
                    <div class="glass-card srv-card">

                        <!-- Category colour strip -->
                        <div class="srv-strip ${catClass}"></div>

                        <div class="srv-body">
                            <!-- Author row -->
                            <div class="srv-top">
                                <div class="srv-author">
                                    <div class="srv-avatar">${srv.username.substring(0,1).toUpperCase()}</div>
                                    <div>
                                        <div class="srv-author-name">${srv.username}</div>
                                        <div class="srv-author-college">${srv.userCollege}</div>
                                    </div>
                                </div>
                                <span class="srv-category-badge cat-${catClass}">${srv.category}</span>
                            </div>

                            <!-- Title & description -->
                            <div class="srv-title">${srv.title}</div>
                            <div class="srv-desc">${srv.description}</div>

                            <!-- Rating -->
                            <div class="srv-rating">
                                <c:choose>
                                    <c:when test="${srv.averageRating > 0}">
                                        <i class="fa-solid fa-star"></i> ${srv.averageRating}
                                        <span class="review-count">(${srv.reviewCount} review<c:if test="${srv.reviewCount != 1}">s</c:if>)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:var(--text-muted); font-weight:400;"><i class="fa-solid fa-wand-magic-sparkles"></i> New Listing</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Price + Actions -->
                        <div class="srv-footer-card">
                            <div>
                                <div class="srv-price-label">Starting at</div>
                                <div class="srv-price-tag">$${srv.price}</div>
                            </div>

                            <div class="srv-actions">
                                <c:choose>
                                    <!-- Own service -->
                                    <c:when test="${not empty sessionScope.user and srv.userId == sessionScope.user.id}">
                                        <span class="own-chip"><i class="fa-solid fa-pencil"></i> Your Service</span>
                                    </c:when>

                                    <!-- Not logged in -->
                                    <c:when test="${empty sessionScope.user}">
                                        <a href="login.jsp" class="btn-book" style="text-decoration:none;">Hire →</a>
                                    </c:when>

                                    <!-- Already booked -->
                                    <c:when test="${srv.bookedByCurrentUser}">
                                        <span class="booked-chip"><i class="fa-solid fa-circle-check"></i> Booked</span>
                                        <form action="messages" method="get" style="margin:0;">
                                            <input type="hidden" name="toUserId" value="${srv.userId}">
                                            <button type="submit" class="btn-contact"><i class="fa-solid fa-comment-dots"></i> Chat</button>
                                        </form>
                                    </c:when>

                                    <!-- Available to book -->
                                    <c:otherwise>
                                        <form action="messages" method="get" style="margin:0;">
                                            <input type="hidden" name="toUserId" value="${srv.userId}">
                                            <button type="submit" class="btn-contact"><i class="fa-solid fa-comment-dots"></i> Contact</button>
                                        </form>
                                        <form action="book" method="post" style="margin:0;">
                                            <input type="hidden" name="serviceId" value="${srv.id}">
                                            <button type="submit" class="btn-book">Hire →</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Leave a review (only if booked and not yet reviewed) -->
                        <c:if test="${not empty sessionScope.user and srv.bookedByCurrentUser and not srv.reviewedByCurrentUser and srv.userId != sessionScope.user.id}">
                            <div class="review-panel">
                                <p><i class="fa-solid fa-comment-dots"></i> Rate this service</p>
                                <form action="review" method="post">
                                    <input type="hidden" name="serviceId" value="${srv.id}">
                                    <div class="review-row">
                                        <select name="rating" required>
                                            <option value=""><i class="fa-solid fa-star"></i> Stars...</option>
                                            <option value="5"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i> Excellent</option>
                                            <option value="4"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i> Good</option>
                                            <option value="3"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i> Average</option>
                                            <option value="2"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i> Poor</option>
                                            <option value="1"><i class="fa-solid fa-star"></i> Terrible</option>
                                        </select>
                                        <input type="text" name="comment" placeholder="Brief review…" style="flex:1; min-width:110px;">
                                        <button type="submit" class="btn-book" style="padding:6px 14px;">Submit</button>
                                    </div>
                                </form>
                            </div>
                        </c:if>

                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div><!-- /.services-grid -->

</div><!-- /.marketplace-page -->
</body>
</html>
