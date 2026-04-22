<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="${gig.title} — SkillNest Student Gig">
    <title>${gig.title} — SkillNest</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=4.0">
    <style>
        /* ─── LAYOUT ──────────────────────────────────── */
        body { min-height: 100vh; }
        .gig-page { max-width: 1100px; margin: 0 auto; padding: 0 20px 80px; }

        /* NAV */
        .gig-nav {
            display: flex; align-items: center; padding: 16px 0; gap: 14px;
            border-bottom: 1px solid rgba(255,255,255,0.06); margin-bottom: 32px;
        }
        .gig-nav a { color: var(--text-muted); text-decoration: none; font-size: 0.9rem; transition: color 0.2s; }
        .gig-nav a:hover { color: white; }
        .breadcrumb { display: flex; align-items: center; gap: 8px; color: var(--text-muted); font-size: 0.88rem; flex: 1; }
        .breadcrumb span { color: rgba(255,255,255,0.2); }

        /* ─── TWO-COLUMN GRID ──────────────────────────── */
        .gig-layout { display: grid; grid-template-columns: 1fr 340px; gap: 36px; align-items: start; }

        /* ─── LEFT: GIG CONTENT ─────────────────────────── */
        .gig-category-tag {
            display: inline-block; padding: 5px 14px; border-radius: 20px; font-size: 0.8rem;
            font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 14px;
        }
        .tag-coding    { background: rgba(6,182,212,0.12);  color: var(--accent-cyan);   border: 1px solid rgba(6,182,212,0.2);  }
        .tag-design    { background: rgba(244,63,94,0.12);  color: #f472b6;              border: 1px solid rgba(244,63,94,0.2);  }
        .tag-writing   { background: rgba(245,158,11,0.12); color: #fbbf24;              border: 1px solid rgba(245,158,11,0.2); }
        .tag-engineering { background: rgba(16,185,129,0.12); color: var(--accent-green); border: 1px solid rgba(16,185,129,0.2); }
        .tag-business  { background: rgba(59,130,246,0.12); color: #60a5fa;              border: 1px solid rgba(59,130,246,0.2); }
        .tag-other     { background: rgba(139,92,246,0.12); color: var(--accent-purple); border: 1px solid rgba(139,92,246,0.2); }

        .gig-title-main { font-size: clamp(1.4rem, 3vw, 2rem); font-weight: 700; margin: 0 0 18px; line-height: 1.3; }

        /* Seller strip (below title on mobile, sidebar on desktop) */
        .seller-strip {
            display: flex; align-items: center; gap: 14px; padding: 18px 0;
            border-top: 1px solid rgba(255,255,255,0.06);
            border-bottom: 1px solid rgba(255,255,255,0.06);
            margin-bottom: 28px;
        }
        .seller-avatar-lg {
            width: 52px; height: 52px; border-radius: 50%; flex-shrink: 0;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 1.3rem; color: white;
            box-shadow: 0 0 16px var(--glow-pink);
        }
        .seller-details { flex: 1; }
        .seller-name-lg { font-weight: 700; font-size: 1.05rem; }
        .seller-college { font-size: 0.82rem; color: var(--text-muted); margin-top: 2px; }
        .seller-meta { display: flex; gap: 16px; margin-top: 6px; }
        .seller-meta-item { font-size: 0.8rem; color: var(--text-muted); display: flex; align-items: center; gap: 4px; }
        .seller-meta-item strong { color: var(--text-main); }
        .rating-strip { display: flex; align-items: center; gap: 6px; color: #fbbf24; font-size: 0.9rem; font-weight: 600; }
        .rating-strip .rc { color: var(--text-muted); font-weight: 400; font-size: 0.82rem; }

        /* Gig description */
        .gig-section { margin-bottom: 36px; }
        .gig-section h3 { font-size: 1.15rem; font-weight: 700; margin: 0 0 16px; padding-bottom: 10px; border-bottom: 1px solid rgba(255,255,255,0.06); }
        .gig-desc { color: var(--text-muted); font-size: 0.95rem; line-height: 1.8; white-space: pre-wrap; }

        /* Review card */
        .review-card { padding: 20px 22px; margin-bottom: 12px; }
        .review-header { display: flex; align-items: center; gap: 12px; margin-bottom: 10px; }
        .review-avatar {
            width: 38px; height: 38px; border-radius: 50%; flex-shrink: 0;
            background: linear-gradient(135deg, var(--accent-cyan), var(--accent-purple));
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.9rem; color: white;
        }
        .review-author { font-weight: 600; font-size: 0.9rem; }
        .review-date { font-size: 0.76rem; color: var(--text-muted); }
        .review-stars { color: #fbbf24; font-size: 0.9rem; }
        .review-body { color: var(--text-muted); font-size: 0.88rem; line-height: 1.6; }

        /* Leave review form */
        .review-form-wrap { padding: 22px; }
        .review-form-wrap h4 { margin: 0 0 14px; font-size: 1rem; }
        .stars-row { display: flex; gap: 6px; margin-bottom: 12px; }
        .star-btn {
            font-size: 1.5rem; cursor: pointer; opacity: 0.3; transition: opacity 0.15s, transform 0.15s; background: none; border: none; padding: 0;
        }
        .star-btn:hover, .star-btn.on { opacity: 1; transform: scale(1.1); }
        .review-comment { width: 100%; box-sizing: border-box; margin-bottom: 12px; }
        .review-submit { background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink)); border: none; color: white; padding: 10px 22px; border-radius: 8px; cursor: pointer; font-family: 'Outfit', sans-serif; font-size: 0.9rem; font-weight: 600; }

        /* ─── RIGHT: ORDER CARD ─────────────────────────── */
        .order-card { padding: 28px; position: sticky; top: 24px; }
        .order-price-row { display: flex; align-items: flex-end; gap: 6px; margin-bottom: 6px; }
        .order-starting { font-size: 0.78rem; color: var(--text-muted); margin-bottom: 2px; }
        .order-price { font-size: 2.2rem; font-weight: 800; color: white; }
        .order-desc { font-size: 0.88rem; color: var(--text-muted); line-height: 1.6; margin-bottom: 20px; border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 18px; }
        .order-features { list-style: none; padding: 0; margin: 0 0 22px; }
        .order-features li { display: flex; align-items: center; gap: 9px; padding: 7px 0; font-size: 0.88rem; color: var(--text-muted); border-bottom: 1px solid rgba(255,255,255,0.04); }
        .order-features li:last-child { border: none; }
        .order-features li .check { color: var(--accent-green); flex-shrink: 0; }

        .btn-order {
            display: block; width: 100%; box-sizing: border-box; text-align: center;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            color: white; border: none; padding: 15px; border-radius: 12px;
            font-family: 'Outfit', sans-serif; font-size: 1.05rem; font-weight: 700;
            cursor: pointer; transition: all 0.25s; margin-bottom: 12px;
            box-shadow: 0 4px 20px var(--glow-pink);
            text-decoration: none;
        }
        .btn-order:hover { transform: translateY(-2px); box-shadow: 0 8px 28px var(--glow-pink); }
        .btn-order:disabled { opacity: 0.5; cursor: default; transform: none; }

        .btn-msg {
            display: block; width: 100%; box-sizing: border-box; text-align: center;
            background: none; border: 1.5px solid rgba(255,255,255,0.12); color: var(--text-muted);
            padding: 12px; border-radius: 12px; font-family: 'Outfit', sans-serif;
            font-size: 0.95rem; font-weight: 600; cursor: pointer; transition: all 0.25s;
            text-decoration: none;
        }
        .btn-msg:hover { border-color: var(--accent-cyan); color: var(--accent-cyan); background: rgba(6,182,212,0.06); }

        /* Seller mini card inside order panel */
        .seller-mini { display: flex; align-items: center; gap: 12px; margin-top: 22px; padding-top: 18px; border-top: 1px solid rgba(255,255,255,0.06); }
        .seller-mini-avatar {
            width: 40px; height: 40px; border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; color: white; font-size: 0.95rem; flex-shrink: 0;
        }
        .seller-mini-info .name { font-weight: 600; font-size: 0.9rem; }
        .seller-mini-info .college { font-size: 0.76rem; color: var(--text-muted); }

        /* Booked state */
        .booked-badge {
            display: flex; align-items: center; justify-content: center; gap: 8px;
            padding: 14px; border-radius: 12px; font-weight: 600; font-size: 0.95rem;
            background: rgba(16,185,129,0.1); border: 1.5px solid rgba(16,185,129,0.25);
            color: var(--accent-green); margin-bottom: 12px;
        }

        /* More gigs from seller */
        .more-gig {
            display: flex; align-items: center; gap: 12px; padding: 12px;
            border-radius: 10px; text-decoration: none; color: inherit;
            background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.06);
            margin-bottom: 10px; transition: all 0.2s;
        }
        .more-gig:hover { background: rgba(139,92,246,0.08); border-color: rgba(139,92,246,0.2); }
        .more-gig-icon { font-size: 1.5rem; flex-shrink: 0; }
        .more-gig-title { font-size: 0.85rem; font-weight: 600; line-height: 1.4; }
        .more-gig-price { font-size: 0.8rem; color: var(--accent-green); margin-top: 2px; }

        @media (max-width: 840px) {
            .gig-layout { grid-template-columns: 1fr; }
            .order-card { position: static; }
        }
        @media (max-width: 600px) {
            .gig-detail-page { padding: 20px 10px 80px; }
            .gig-hero h1 { font-size: 1.8rem; }
            .gig-hero-meta { flex-wrap: wrap; gap: 10px; }
            .content-card { padding: 25px 20px; }
            .order-card { padding: 25px 20px; }
        }
    </style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="gig-page">

    <!-- NAV -->
    <nav class="gig-nav">
        <div class="breadcrumb">
            <a href="index.jsp"><i class="fa-solid fa-meteor"></i> SkillNest</a>
            <span>/</span>
            <a href="gigs">Gigs</a>
            <span>/</span>
            <a href="gigs?category=${gig.category}">${gig.category}</a>
            <span>/</span>
            <span style="color:var(--text-main); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; max-width:200px;">${gig.title}</span>
        </div>
        <c:if test="${not empty sessionScope.user}">
            <a href="feed" style="color:var(--text-muted);">Dashboard</a>
            <a href="create-gig.jsp" class="btn-solid" style="text-decoration:none; padding:7px 16px; font-size:0.85rem; border-radius:8px;">+ Gig</a>
        </c:if>
        <c:if test="${empty sessionScope.user}">
            <a href="login.jsp" class="btn-solid" style="text-decoration:none; padding:7px 16px; font-size:0.85rem; border-radius:8px;">Sign In</a>
        </c:if>
    </nav>

    <!-- TWO-COLUMN LAYOUT -->
    <div class="gig-layout">

        <!-- ─── LEFT: MAIN CONTENT ──────────────────────── -->
        <div class="gig-left">

            <!-- Category + Title -->
            <div class="gig-category-tag tag-${gig.category.toLowerCase()}">${gig.category}</div>
            <h1 class="gig-title-main">${gig.title}</h1>

            <!-- Seller Strip -->
            <div class="seller-strip">
                <div class="seller-avatar-lg">${gig.username.substring(0,1).toUpperCase()}</div>
                <div class="seller-details">
                    <div class="seller-name-lg">${gig.username}</div>
                    <div class="seller-college">${gig.userCollege}</div>
                    <div class="seller-meta">
                        <c:if test="${gig.averageRating > 0}">
                            <div class="seller-meta-item rating-strip">
                                <i class="fa-solid fa-star"></i> ${gig.averageRating}
                                <span class="rc">(${reviews.size()} review<c:if test="${reviews.size() != 1}">s</c:if>)</span>
                            </div>
                        </c:if>
                        <div class="seller-meta-item"><i class="fa-regular fa-calendar-days"></i> Posted <strong><fmt:formatDate value="${gig.createdAt}" pattern="MMM yyyy"/></strong></div>
                    </div>
                </div>
            </div>

            <!-- Description -->
            <div class="gig-section">
                <h3>About This Gig</h3>
                <div class="gig-desc">${gig.description}</div>
            </div>

            <!-- Reviews Section -->
            <div class="gig-section">
                <h3>Reviews
                    <c:if test="${not empty reviews}">
                        <span style="color:var(--text-muted); font-size:0.85rem; font-weight:400;">(${reviews.size()})</span>
                    </c:if>
                </h3>

                <c:choose>
                    <c:when test="${empty reviews}">
                        <div style="text-align:center; padding:30px; color:var(--text-muted); font-size:0.9rem;">
                            <i class="fa-solid fa-wand-magic-sparkles"></i> No reviews yet — be the first to review this gig!
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="review" items="${reviews}">
                            <div class="glass-card review-card">
                                <div class="review-header">
                                    <div class="review-avatar">${review.username.substring(0,1).toUpperCase()}</div>
                                    <div>
                                        <div class="review-author">${review.username}</div>
                                        <div class="review-date">
                                            <fmt:formatDate value="${review.createdAt}" pattern="dd MMM yyyy"/>
                                        </div>
                                    </div>
                                    <div style="margin-left:auto;">
                                        <div class="review-stars">
                                            <c:forEach begin="1" end="${review.rating}" var="i"><i class="fa-solid fa-star"></i></c:forEach>
                                        </div>
                                    </div>
                                </div>
                                <c:if test="${not empty review.comment}">
                                    <div class="review-body">${review.comment}</div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>

                <!-- Leave a review (if booked, not reviewed, not own gig) -->
                <c:if test="${not empty sessionScope.user and gig.bookedByCurrentUser and not gig.reviewedByCurrentUser and gig.userId != sessionScope.user.id}">
                    <div class="glass-card review-form-wrap" style="margin-top:16px;">
                        <h4><i class="fa-solid fa-star"></i> Leave Your Review</h4>
                        <form action="review" method="post">
                            <input type="hidden" name="serviceId" value="${gig.id}">
                            <input type="hidden" name="returnUrl" value="gig?id=${gig.id}">

                            <!-- Star picker -->
                            <div class="stars-row" id="starRow">
                                <button type="button" class="star-btn" data-val="1" onclick="setStars(1)"><i class="fa-solid fa-star"></i></button>
                                <button type="button" class="star-btn" data-val="2" onclick="setStars(2)"><i class="fa-solid fa-star"></i></button>
                                <button type="button" class="star-btn" data-val="3" onclick="setStars(3)"><i class="fa-solid fa-star"></i></button>
                                <button type="button" class="star-btn" data-val="4" onclick="setStars(4)"><i class="fa-solid fa-star"></i></button>
                                <button type="button" class="star-btn" data-val="5" onclick="setStars(5)"><i class="fa-solid fa-star"></i></button>
                            </div>
                            <input type="hidden" name="rating" id="ratingInput" required>

                            <textarea name="comment" class="glass-textarea review-comment" rows="3"
                                      placeholder="What was great about this gig? What could be improved?"></textarea>
                            <button type="submit" class="review-submit">Submit Review</button>
                        </form>
                    </div>
                </c:if>
            </div>

            <!-- More gigs from this seller -->
            <c:if test="${not empty sellerGigs}">
                <div class="gig-section">
                    <h3>More from ${gig.username}</h3>
                    <c:forEach var="sg" items="${sellerGigs}" end="2">
                        <a href="gig?id=${sg.id}" class="more-gig">
                            <span class="more-gig-icon">${sg.category == 'Coding' ? '<i class="fa-solid fa-laptop-code"></i>' : sg.category == 'Design' ? '<i class="fa-solid fa-palette"></i>' : sg.category == 'Writing' ? '<i class="fa-solid fa-pen-nib"></i>' : sg.category == 'Engineering' ? '<i class="fa-solid fa-wrench"></i>' : sg.category == 'Business' ? '<i class="fa-solid fa-chart-pie"></i>' : '<i class="fa-solid fa-wand-magic-sparkles"></i>'}</span>
                            <div>
                                <div class="more-gig-title">${sg.title}</div>
                                <div class="more-gig-price">$${sg.price}</div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:if>

        </div><!-- /.gig-left -->

        <!-- ─── RIGHT: ORDER CARD ──────────────────────── -->
        <div class="gig-right">
            <div class="glass-card order-card">

                <div class="order-starting">Starting at</div>
                <div class="order-price">$${gig.price}</div>

                <div class="order-desc" style="margin-top:14px;">${gig.description.length() > 120 ? gig.description.substring(0, 120).concat('…') : gig.description}</div>

                <ul class="order-features">
                    <li><span class="check"><i class="fa-solid fa-check"></i></span> ${gig.category} expertise</li>
                    <li><span class="check"><i class="fa-solid fa-check"></i></span> Student-friendly pricing</li>
                    <li><span class="check"><i class="fa-solid fa-check"></i></span> Direct messaging included</li>
                    <li><span class="check"><i class="fa-solid fa-check"></i></span> Review after completion</li>
                </ul>

                <c:choose>
                    <!-- Not logged in -->
                    <c:when test="${empty sessionScope.user}">
                        <a href="login.jsp" class="btn-order">Sign In to Order</a>
                        <a href="login.jsp?from=gig${gig.id}" class="btn-msg"><i class="fa-solid fa-comment-dots"></i> Contact Seller</a>
                    </c:when>

                    <!-- Own gig -->
                    <c:when test="${gig.userId == sessionScope.user.id}">
                        <div style="text-align:center; padding:14px; border-radius:10px; background:rgba(139,92,246,0.08); border:1px solid rgba(139,92,246,0.2); color:var(--accent-purple); font-weight:600; font-size:0.9rem; margin-bottom:12px;">
                            <i class="fa-solid fa-pencil"></i> This is your gig
                        </div>
                        <a href="feed" class="btn-msg">Go to Dashboard</a>
                    </c:when>

                    <!-- Already ordered -->
                    <c:when test="${gig.bookedByCurrentUser}">
                        <div class="booked-badge"><i class="fa-solid fa-circle-check"></i> You've ordered this gig</div>
                        <form action="messages" method="get" style="margin:0;">
                            <input type="hidden" name="toUserId" value="${gig.userId}">
                            <button type="submit" class="btn-order" style="display:block; width:100%; box-sizing:border-box;"><i class="fa-solid fa-comment-dots"></i> Message Seller</button>
                        </form>
                    </c:when>

                    <!-- Available -->
                    <c:otherwise>
                        <form action="book" method="post" style="margin:0;">
                            <input type="hidden" name="serviceId" value="${gig.id}">
                            <input type="hidden" name="returnUrl" value="gig?id=${gig.id}">
                            <button type="submit" class="btn-order"><i class="fa-solid fa-rocket"></i> Order Now — $${gig.price}</button>
                        </form>
                        <form action="messages" method="get" style="margin:0;">
                            <input type="hidden" name="toUserId" value="${gig.userId}">
                            <button type="submit" class="btn-msg"><i class="fa-solid fa-comment-dots"></i> Contact Seller</button>
                        </form>
                    </c:otherwise>
                </c:choose>

                <!-- Seller mini -->
                <div class="seller-mini">
                    <div class="seller-mini-avatar">${gig.username.substring(0,1).toUpperCase()}</div>
                    <div class="seller-mini-info">
                        <div class="name">${gig.username}</div>
                        <div class="college">${gig.userCollege}</div>
                    </div>
                </div>
            </div>
        </div><!-- /.gig-right -->

    </div><!-- /.gig-layout -->
</div><!-- /.gig-page -->

<script>
    // Star picker
    function setStars(val) {
        document.getElementById('ratingInput').value = val;
        document.querySelectorAll('.star-btn').forEach(function(btn) {
            btn.classList.toggle('on', parseInt(btn.dataset.val) <= val);
        });
    }
</script>
</body>
</html>
