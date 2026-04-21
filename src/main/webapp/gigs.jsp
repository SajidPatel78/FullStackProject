<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Browse student gigs on SkillNest — hire affordable, talented students for coding, design, writing and more.">
    <title>SkillNest — Student Gigs Marketplace</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=4.0">
    <style>
        /* ─── LAYOUT ─────────────────────────────────── */
        .gigs-page { max-width: 1200px; margin: 0 auto; padding: 0 20px 80px; }

        /* ─── NAV BAR ─────────────────────────────────── */
        .gigs-nav {
            display: flex; align-items: center; padding: 18px 0; gap: 16px;
            border-bottom: 1px solid rgba(255,255,255,0.06); margin-bottom: 0;
        }
        .nav-logo { font-size: 1.4rem; font-weight: 700; text-decoration: none; color: white; display: flex; align-items: center; gap: 6px; }
        .nav-links { display: flex; gap: 22px; margin-left: 28px; }
        .nav-links a { color: var(--text-muted); text-decoration: none; font-size: 0.9rem; transition: color 0.2s; }
        .nav-links a:hover { color: white; }
        .nav-right { margin-left: auto; display: flex; gap: 12px; align-items: center; }

        /* ─── HERO ────────────────────────────────────── */
        .gigs-hero {
            padding: 60px 0 40px;
            text-align: center;
        }
        .gigs-hero h1 { font-size: clamp(2rem, 5vw, 3.2rem); font-weight: 800; margin: 0 0 14px; line-height: 1.2; }
        .gigs-hero p  { color: var(--text-muted); font-size: 1.1rem; margin: 0 0 32px; max-width: 560px; margin-left: auto; margin-right: auto; }

        /* Hero search bar */
        .hero-search {
            display: flex; max-width: 560px; margin: 0 auto 44px;
            background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.12);
            border-radius: 50px; overflow: hidden; padding: 6px 6px 6px 20px;
            gap: 8px; align-items: center;
            box-shadow: 0 4px 30px rgba(0,0,0,0.3), 0 0 0 0 var(--glow-purple);
            transition: box-shadow 0.3s;
        }
        .hero-search:focus-within { box-shadow: 0 4px 30px rgba(0,0,0,0.3), 0 0 0 3px rgba(139,92,246,0.3); }
        .hero-search input {
            flex: 1; background: none; border: none; outline: none;
            color: white; font-family: 'Outfit', sans-serif; font-size: 1rem;
        }
        .hero-search input::placeholder { color: var(--text-muted); }
        .hero-search button {
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            border: none; color: white; padding: 11px 24px; border-radius: 50px;
            font-family: 'Outfit', sans-serif; font-size: 0.95rem; font-weight: 600;
            cursor: pointer; white-space: nowrap; transition: opacity 0.2s;
        }
        .hero-search button:hover { opacity: 0.9; }

        /* Popular tags */
        .popular-tags { display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; margin-bottom: 20px; }
        .pop-tag {
            padding: 6px 16px; border-radius: 20px; font-size: 0.82rem; cursor: pointer;
            background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.1);
            color: var(--text-muted); text-decoration: none; transition: all 0.2s;
        }
        .pop-tag:hover { background: rgba(139,92,246,0.12); border-color: rgba(139,92,246,0.3); color: white; }

        /* ─── CATEGORY ICONS ROW ──────────────────────── */
        .category-row {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
            gap: 14px; margin: 40px 0;
        }
        .cat-card {
            padding: 20px 12px; border-radius: 14px; text-align: center;
            background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07);
            cursor: pointer; text-decoration: none; transition: all 0.25s ease;
            display: flex; flex-direction: column; align-items: center; gap: 8px;
        }
        .cat-card:hover {
            background: rgba(139,92,246,0.12); border-color: rgba(139,92,246,0.3);
            transform: translateY(-3px);
        }
        .cat-card.active { background: rgba(139,92,246,0.15); border-color: var(--accent-purple); }
        .cat-icon { font-size: 2rem; }
        .cat-name { font-size: 0.82rem; font-weight: 600; color: var(--text-muted); }
        .cat-count { font-size: 0.72rem; color: var(--accent-purple); }

        /* ─── SECTION LABEL ───────────────────────────── */
        .section-bar {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 22px; flex-wrap: wrap; gap: 12px;
        }
        .section-bar h2 { font-size: 1.3rem; font-weight: 700; margin: 0; }
        .sort-row { display: flex; gap: 8px; align-items: center; }
        .sort-btn {
            padding: 7px 16px; border-radius: 20px; font-size: 0.82rem; cursor: pointer;
            background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.09);
            color: var(--text-muted); font-family: 'Outfit', sans-serif; transition: all 0.2s;
        }
        .sort-btn:hover, .sort-btn.active {
            background: rgba(139,92,246,0.12); border-color: rgba(139,92,246,0.3); color: white;
        }

        /* ─── GIG CARD GRID ───────────────────────────── */
        .gigs-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(270px, 1fr));
            gap: 22px;
        }

        .gig-card {
            border-radius: 16px; overflow: hidden; transition: all 0.3s ease;
            display: flex; flex-direction: column; cursor: pointer;
            text-decoration: none; color: inherit;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.07);
        }
        .gig-card:hover { transform: translateY(-5px); box-shadow: 0 14px 45px rgba(0,0,0,0.4); border-color: rgba(139,92,246,0.2); }

        /* Coloured category banner */
        .gig-banner {
            height: 140px; display: flex; align-items: center; justify-content: center;
            font-size: 3.5rem; position: relative; overflow: hidden;
        }
        .banner-coding      { background: linear-gradient(135deg, #0f172a, #1e3a5f); }
        .banner-design      { background: linear-gradient(135deg, #1a0533, #4a1469); }
        .banner-writing     { background: linear-gradient(135deg, #1a1205, #4a3505); }
        .banner-engineering { background: linear-gradient(135deg, #051a14, #0a4a32); }
        .banner-business    { background: linear-gradient(135deg, #050f2e, #0a1f6e); }
        .banner-other       { background: linear-gradient(135deg, #1a0a1a, #3d1752); }

        .gig-card-body { padding: 16px; flex: 1; }
        .gig-seller { display: flex; align-items: center; gap: 9px; margin-bottom: 10px; }
        .gig-avatar {
            width: 30px; height: 30px; border-radius: 50%; flex-shrink: 0;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.82rem; color: white;
        }
        .gig-seller-name { font-size: 0.85rem; font-weight: 600; }
        .gig-seller-level { font-size: 0.72rem; color: var(--accent-cyan); }
        .gig-title {
            font-size: 0.95rem; font-weight: 600; line-height: 1.45; color: var(--text-main);
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
            margin-bottom: 10px;
        }
        .gig-rating { display: flex; align-items: center; gap: 5px; font-size: 0.82rem; color: #fbbf24; margin-bottom: 4px; }
        .gig-review-count { color: var(--text-muted); font-weight: 400; }

        .gig-card-footer {
            padding: 12px 16px; border-top: 1px solid rgba(255,255,255,0.06);
            display: flex; align-items: center; justify-content: space-between;
        }
        .gig-starting { font-size: 0.72rem; color: var(--text-muted); }
        .gig-price { font-size: 1.05rem; font-weight: 700; color: white; }

        /* Category badge on card */
        .gig-cat-badge {
            position: absolute; top: 10px; right: 10px;
            padding: 3px 10px; border-radius: 12px; font-size: 0.7rem; font-weight: 700;
            backdrop-filter: blur(6px); background: rgba(0,0,0,0.4);
        }

        /* ─── EMPTY STATE ─────────────────────────────── */
        .empty-gigs { text-align: center; padding: 80px 20px; }
        .empty-gigs .icon { font-size: 3rem; margin-bottom: 16px; }
        .empty-gigs h3 { margin: 0 0 10px; font-size: 1.3rem; }
        .empty-gigs p  { color: var(--text-muted); margin: 0 0 28px; }

        /* ─── DIVIDER ─────────────────────────────────── */
        .divider { height: 1px; background: rgba(255,255,255,0.06); margin: 36px 0; }

        @media (max-width: 768px) {
            .gigs-hero h1 { font-size: 1.9rem; }
            .category-row { grid-template-columns: repeat(3, 1fr); }
            .gigs-grid { grid-template-columns: 1fr 1fr; }
            .nav-links { display: none; }
        }
        @media (max-width: 480px) {
            .gigs-grid { grid-template-columns: 1fr; }
            .category-row { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="gigs-page">

    <!-- ─── TOP NAV ────────────────────────────────────── -->
    <nav class="gigs-nav">
        <a href="index.jsp" class="nav-logo"><i class="fa-solid fa-meteor"></i> SkillNest</a>
        <div class="nav-links">
            <a href="gigs">Browse Gigs</a>
            <a href="challenges">Challenges</a>
            <a href="leaderboard">Leaderboard</a>
        </div>
        <div class="nav-right">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="create-gig.jsp" class="btn-neon btn-cyan" style="text-decoration:none; padding:8px 18px; font-size:0.88rem; border-radius:8px;">+ Create Gig</a>
                    <a href="feed" class="btn-solid" style="text-decoration:none; padding:8px 18px; font-size:0.88rem; border-radius:8px;">Dashboard</a>
                </c:when>
                <c:otherwise>
                    <a href="login.jsp" style="color:var(--text-muted); text-decoration:none; font-size:0.9rem;">Sign In</a>
                    <a href="register.jsp" class="btn-solid" style="text-decoration:none; padding:8px 18px; font-size:0.88rem; border-radius:8px;">Join Free</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <!-- ─── HERO ───────────────────────────────────────── -->
    <div class="gigs-hero">
        <h1>Find Talent. <span class="text-gradient">Built by Students.</span></h1>
        <p>Hire talented students for coding, design, writing & more — at prices that actually make sense for students.</p>

        <form action="gigs" method="get">
            <c:if test="${not empty queryCategory}">
                <input type="hidden" name="category" value="${queryCategory}">
            </c:if>
            <div class="hero-search">
                <input type="text" name="q" placeholder='Try "React website", "logo design", "essay writing"…'
                       value="${querySearch}" autocomplete="off">
                <button type="submit">Search</button>
            </div>
        </form>

        <div class="popular-tags">
            <a href="gigs?q=website" class="pop-tag"><i class="fa-solid fa-globe"></i> Website</a>
            <a href="gigs?q=logo" class="pop-tag"><i class="fa-solid fa-palette"></i> Logo Design</a>
            <a href="gigs?q=python" class="pop-tag">🐍 Python Script</a>
            <a href="gigs?q=essay" class="pop-tag"><i class="fa-solid fa-file-signature"></i> Essay Editing</a>
            <a href="gigs?q=mobile+app" class="pop-tag"><i class="fa-solid fa-mobile-screen"></i> Mobile App</a>
            <a href="gigs?q=resume" class="pop-tag"><i class="fa-regular fa-file-lines"></i> Resume</a>
            <a href="gigs?q=tutor" class="pop-tag"><i class="fa-solid fa-graduation-cap"></i> Tutoring</a>
        </div>
    </div>

    <!-- ─── CATEGORY CARDS ──────────────────────────────── -->
    <div class="category-row">
        <a href="gigs" class="cat-card ${empty queryCategory ? 'active' : ''}">
            <span class="cat-icon"><i class="fa-solid fa-globe"></i></span>
            <span class="cat-name">All Gigs</span>
        </a>
        <a href="gigs?category=Coding" class="cat-card ${queryCategory == 'Coding' ? 'active' : ''}">
            <span class="cat-icon"><i class="fa-solid fa-laptop-code"></i></span>
            <span class="cat-name">Coding</span>
        </a>
        <a href="gigs?category=Design" class="cat-card ${queryCategory == 'Design' ? 'active' : ''}">
            <span class="cat-icon"><i class="fa-solid fa-palette"></i></span>
            <span class="cat-name">Design</span>
        </a>
        <a href="gigs?category=Writing" class="cat-card ${queryCategory == 'Writing' ? 'active' : ''}">
            <span class="cat-icon"><i class="fa-solid fa-pen-nib"></i></span>
            <span class="cat-name">Writing</span>
        </a>
        <a href="gigs?category=Engineering" class="cat-card ${queryCategory == 'Engineering' ? 'active' : ''}">
            <span class="cat-icon"><i class="fa-solid fa-wrench"></i></span>
            <span class="cat-name">Engineering</span>
        </a>
        <a href="gigs?category=Business" class="cat-card ${queryCategory == 'Business' ? 'active' : ''}">
            <span class="cat-icon"><i class="fa-solid fa-chart-pie"></i></span>
            <span class="cat-name">Business</span>
        </a>
        <a href="gigs?category=Other" class="cat-card ${queryCategory == 'Other' ? 'active' : ''}">
            <span class="cat-icon"><i class="fa-solid fa-wand-magic-sparkles"></i></span>
            <span class="cat-name">Other</span>
        </a>
    </div>

    <div class="divider"></div>

    <!-- ─── RESULTS BAR ─────────────────────────────────── -->
    <div class="section-bar">
        <h2>
            <c:choose>
                <c:when test="${not empty querySearch}">"${querySearch}"</c:when>
                <c:when test="${not empty queryCategory}">${queryCategory} Gigs</c:when>
                <c:otherwise>All Gigs</c:otherwise>
            </c:choose>
            <c:if test="${not empty gigs}">
                <span style="color:var(--text-muted); font-size:0.85rem; font-weight:400; margin-left:10px;">${gigs.size()} found</span>
            </c:if>
        </h2>
        <form action="gigs" method="get" style="display:flex; gap:8px;">
            <c:if test="${not empty queryCategory}"><input type="hidden" name="category" value="${queryCategory}"></c:if>
            <c:if test="${not empty querySearch}"><input type="hidden" name="q" value="${querySearch}"></c:if>
            <div class="sort-row">
                <button type="submit" name="sort" value="latest"     class="sort-btn ${empty querySort || querySort == 'latest' ? 'active' : ''}">Latest</button>
                <button type="submit" name="sort" value="rating"     class="sort-btn ${querySort == 'rating' ? 'active' : ''}">Top Rated</button>
                <button type="submit" name="sort" value="price_low"  class="sort-btn ${querySort == 'price_low' ? 'active' : ''}">$ Low→High</button>
                <button type="submit" name="sort" value="price_high" class="sort-btn ${querySort == 'price_high' ? 'active' : ''}">$ High→Low</button>
            </div>
        </form>
    </div>

    <!-- ─── GIGS GRID ────────────────────────────────────── -->
    <div class="gigs-grid">
        <c:choose>
            <c:when test="${empty gigs}">
                <div class="empty-gigs" style="grid-column: 1/-1">
                    <div class="icon"><i class="fa-solid fa-binoculars"></i></div>
                    <h3>No Gigs Found</h3>
                    <p>
                        <c:choose>
                            <c:when test="${not empty querySearch}">No results for "<strong>${querySearch}</strong>". Try a different keyword.</c:when>
                            <c:otherwise>No gigs yet in this category. Be the first to create one!</c:otherwise>
                        </c:choose>
                    </p>
                    <c:if test="${not empty sessionScope.user}">
                        <a href="create-gig.jsp" class="btn-solid" style="text-decoration:none; padding:13px 30px; font-size:1rem;"><i class="fa-solid fa-rocket"></i> Create First Gig</a>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="gig" items="${gigs}">
                    <c:set var="catLower" value="${gig.category.toLowerCase()}" />
                    <a href="gig?id=${gig.id}" class="gig-card">

                        <!-- Banner -->
                        <div class="gig-banner banner-${catLower}">
                            <span>${gig.category == 'Coding' ? '<i class="fa-solid fa-laptop-code"></i>' : gig.category == 'Design' ? '<i class="fa-solid fa-palette"></i>' : gig.category == 'Writing' ? '<i class="fa-solid fa-pen-nib"></i>' : gig.category == 'Engineering' ? '<i class="fa-solid fa-wrench"></i>' : gig.category == 'Business' ? '<i class="fa-solid fa-chart-pie"></i>' : '<i class="fa-solid fa-wand-magic-sparkles"></i>'}</span>
                            <span class="gig-cat-badge">${gig.category}</span>
                        </div>

                        <!-- Body -->
                        <div class="gig-card-body">
                            <div class="gig-seller">
                                <div class="gig-avatar">${gig.username.substring(0,1).toUpperCase()}</div>
                                <div>
                                    <div class="gig-seller-name">${gig.username}</div>
                                    <div class="gig-seller-level"><i class="fa-solid fa-book-open"></i> ${gig.userCollege}</div>
                                </div>
                            </div>
                            <div class="gig-title">${gig.title}</div>
                            <div class="gig-rating">
                                <c:choose>
                                    <c:when test="${gig.averageRating > 0}">
                                        <i class="fa-solid fa-star"></i> ${gig.averageRating}
                                        <span class="gig-review-count">(${gig.reviewCount})</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:var(--text-muted);"><i class="fa-solid fa-wand-magic-sparkles"></i> New</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Footer -->
                        <div class="gig-card-footer">
                            <div>
                                <div class="gig-starting">Starting at</div>
                                <div class="gig-price">$${gig.price}</div>
                            </div>
                            <span style="font-size:0.8rem; color:var(--accent-cyan);">View Gig →</span>
                        </div>
                    </a>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div><!-- /.gigs-grid -->

    <!-- ─── SELL CTA ─────────────────────────────────────── -->
    <c:if test="${not empty sessionScope.user}">
        <div class="divider" style="margin-top: 60px;"></div>
        <div style="text-align:center; padding: 40px 20px;">
            <div style="font-size:2rem; margin-bottom: 10px;"><i class="fa-solid fa-money-bill-wave"></i></div>
            <h3 style="margin: 0 0 8px; font-size:1.4rem;">Have a Skill to Offer?</h3>
            <p style="color:var(--text-muted); margin: 0 0 22px;">Create your first gig and start earning from other students today.</p>
            <a href="create-gig.jsp" class="btn-solid" style="text-decoration:none; padding:13px 34px; font-size:1rem;"><i class="fa-solid fa-rocket"></i> Create a Gig</a>
        </div>
    </c:if>

</div><!-- /.gigs-page -->
</body>
</html>
