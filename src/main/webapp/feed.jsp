<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillNest — Dashboard</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=4.0">
    <style>
        /* ═══════════════════════════════════════════════════════
           LAYOUT
        ═══════════════════════════════════════════════════════ */
        body { overflow-x: hidden; }
        .app-layout {
            display: grid;
            grid-template-columns: 240px 1fr 290px;
            min-height: 100vh;
            gap: 0;
        }

        /* ═══════════════════════════════════════════════════════
           LEFT SIDEBAR
        ═══════════════════════════════════════════════════════ */
        .sidebar {
            position: sticky;
            top: 0;
            height: 100vh;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            padding: 24px 12px;
            border-right: 1px solid rgba(255,255,255,0.06);
            background: rgba(15,10,30,0.7);
            backdrop-filter: blur(20px);
            scrollbar-width: none;
        }
        .sidebar::-webkit-scrollbar { display: none; }

        .sidebar-logo {
            display: flex; align-items: center; gap: 8px;
            font-size: 1.2rem; font-weight: 700; padding: 4px 10px 20px;
            text-decoration: none; color: white;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            margin-bottom: 16px;
        }

        .nav-section-label {
            font-size: 0.68rem; text-transform: uppercase; letter-spacing: 1.5px;
            color: rgba(255,255,255,0.25); padding: 0 12px; margin: 16px 0 6px;
        }

        .nav-item {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 12px; border-radius: 10px;
            color: var(--text-muted); text-decoration: none;
            font-size: 0.91rem; font-weight: 500;
            transition: all 0.2s ease; margin-bottom: 2px;
        }
        .nav-item:hover { background: rgba(255,255,255,0.05); color: white; }
        .nav-item.active { background: rgba(139,92,246,0.15); color: white; border: 1px solid rgba(139,92,246,0.2); }
        .nav-item .nav-icon { font-size: 1rem; width: 20px; text-align: center; flex-shrink: 0; }
        .nav-badge {
            margin-left: auto; background: var(--accent-pink); color: white;
            font-size: 0.68rem; font-weight: 700; padding: 2px 7px; border-radius: 12px;
        }

        /* User card at bottom of sidebar */
        .sidebar-user {
            margin-top: auto; padding: 16px; border-radius: 14px;
            background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07);
        }
        .sidebar-user-top { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; }
        .user-avatar-sm {
            width: 40px; height: 40px; border-radius: 50%; flex-shrink: 0;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 1.05rem; color: white;
        }
        .sidebar-username { font-weight: 600; font-size: 0.9rem; }
        .sidebar-level { font-size: 0.75rem; color: var(--accent-cyan); }
        .xp-track { height: 5px; background: rgba(255,255,255,0.08); border-radius: 3px; overflow: hidden; margin: 8px 0 4px; }
        .xp-fill { height: 100%; background: linear-gradient(90deg, var(--accent-cyan), var(--accent-purple)); border-radius: 3px; }
        .xp-label { font-size: 0.7rem; color: var(--text-muted); }

        /* ═══════════════════════════════════════════════════════
           CENTER FEED
        ═══════════════════════════════════════════════════════ */
        .feed-center {
            padding: 24px 28px;
            overflow-y: auto;
            max-height: 100vh;
            scrollbar-width: thin;
            scrollbar-color: rgba(255,255,255,0.1) transparent;
        }
        .feed-center::-webkit-scrollbar { width: 4px; }
        .feed-center::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 2px; }

        /* Top search bar */
        .top-bar {
            display: flex; align-items: center; gap: 12px; margin-bottom: 28px;
        }
        .search-form { flex: 1; position: relative; }
        .search-form .glass-input {
            width: 100%; box-sizing: border-box;
            padding-left: 38px; border-radius: 12px;
        }
        .search-icon { position: absolute; left: 13px; top: 50%; transform: translateY(-50%); color: var(--text-muted); pointer-events: none; }
        .top-bar-avatar {
            width: 38px; height: 38px; border-radius: 50%; flex-shrink: 0;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; color: white; text-decoration: none;
            transition: transform 0.2s;
        }
        .top-bar-avatar:hover { transform: scale(1.08); }

        /* Welcome / Stats strip */
        .welcome-strip {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 24px; flex-wrap: wrap; gap: 14px;
        }
        .welcome-text h1 { font-size: 1.6rem; font-weight: 700; margin: 0 0 3px; }
        .welcome-text p  { color: var(--text-muted); font-size: 0.88rem; margin: 0; }
        .quick-stats { display: flex; gap: 14px; }
        .q-stat {
            text-align: center; padding: 10px 16px; border-radius: 12px;
            background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07);
            min-width: 70px;
        }
        .q-stat-val { font-size: 1.3rem; font-weight: 700; }
        .q-stat-lbl { font-size: 0.68rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; }

        /* Mini dashboard cards */
        .mini-cards { display: grid; grid-template-columns: repeat(2, 1fr); gap: 14px; margin-bottom: 24px; }
        .mini-card {
            padding: 18px; border-radius: 14px;
            background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07);
            transition: all 0.25s;
        }
        .mini-card:hover { border-color: rgba(139,92,246,0.2); transform: translateY(-2px); }
        .mini-card h4 { margin: 0 0 10px; font-size: 0.88rem; color: var(--text-muted); font-weight: 500;
                         display: flex; align-items: center; justify-content: space-between; }
        .mini-card h4 a { font-size: 0.75rem; color: var(--accent-cyan); text-decoration: none; }
        .mini-card h4 a:hover { color: white; }

        /* Challenge card */
        .challenge-mini { background: linear-gradient(135deg, rgba(139,92,246,0.12), rgba(247,42,117,0.06)); border-color: rgba(139,92,246,0.15); }
        .challenge-title { font-size: 0.9rem; font-weight: 600; margin-bottom: 4px; }
        .challenge-xp { font-size: 0.78rem; color: var(--accent-cyan); margin-bottom: 14px; }
        .challenge-action { display: flex; gap: 8px; }
        .btn-challenge-accept {
            flex: 1; text-align: center; padding: 9px; border-radius: 9px; font-size: 0.85rem;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            color: white; border: none; cursor: pointer; font-family: 'Outfit', sans-serif;
            font-weight: 600; transition: opacity 0.2s;
        }
        .btn-challenge-accept:hover { opacity: 0.85; }
        .challenge-done {
            padding: 9px; border-radius: 9px; font-size: 0.85rem; font-weight: 600;
            background: rgba(16,185,129,0.1); color: var(--accent-green);
            border: 1px solid rgba(16,185,129,0.2); text-align: center;
        }

        /* Progress mini card */
        .progress-item { margin-bottom: 10px; }
        .progress-head { display: flex; justify-content: space-between; font-size: 0.82rem; margin-bottom: 4px; }
        .progress-track { height: 5px; background: rgba(255,255,255,0.08); border-radius: 3px; overflow: hidden; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, var(--accent-cyan), var(--accent-purple)); border-radius: 3px; }

        /* ── Create Post Bar ────────────────────────────── */
        .create-bar {
            display: flex; align-items: center; gap: 12px;
            padding: 14px 18px; border-radius: 14px; margin-bottom: 20px;
            background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07);
            cursor: pointer; transition: all 0.2s;
        }
        .create-bar:hover { border-color: rgba(139,92,246,0.25); }
        .create-bar-input {
            flex: 1; background: none; border: none; outline: none;
            color: var(--text-muted); font-family: 'Outfit', sans-serif; font-size: 0.95rem;
            cursor: pointer;
        }
        .create-bar-btns { display: flex; gap: 8px; }
        .create-btn {
            padding: 7px 14px; border-radius: 8px; font-size: 0.82rem; font-weight: 600;
            cursor: pointer; border: none; font-family: 'Outfit', sans-serif; transition: all 0.2s; text-decoration: none;
        }
        .create-btn-gig { background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink)); color: white; }
        .create-btn-note { background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); color: var(--text-muted); }
        .create-btn-note:hover { color: white; border-color: rgba(255,255,255,0.2); }

        /* ── Feed Tabs ─────────────────────────────────── */
        .feed-tabs {
            display: flex; gap: 4px; margin-bottom: 18px;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            padding-bottom: 0;
        }
        .feed-tab {
            padding: 10px 20px; font-size: 0.9rem; font-weight: 500;
            color: var(--text-muted); text-decoration: none; cursor: pointer;
            border-bottom: 2px solid transparent; margin-bottom: -1px; transition: all 0.2s;
        }
        .feed-tab:hover { color: white; }
        .feed-tab.active { color: white; border-bottom-color: var(--accent-purple); }

        /* ── Feed Filter Tags ──────────────────────────── */
        .filter-tags { display: flex; gap: 8px; overflow-x: auto; padding-bottom: 6px; margin-bottom: 20px; scrollbar-width: none; }
        .filter-tags::-webkit-scrollbar { display: none; }
        .ftag {
            padding: 6px 16px; border-radius: 20px; white-space: nowrap; font-size: 0.82rem;
            color: var(--text-muted); text-decoration: none; cursor: pointer;
            background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08);
            transition: all 0.2s;
        }
        .ftag:hover, .ftag.active {
            background: rgba(139,92,246,0.12); border-color: rgba(139,92,246,0.3); color: white;
        }

        /* ═══════════════════════════════════════════════════════
           POST / GIG CARDS
        ═══════════════════════════════════════════════════════ */

        /* GIG card (SERVICE type) */
        .gig-feed-card {
            padding: 0; margin-bottom: 16px; overflow: hidden;
            transition: all 0.25s ease; cursor: pointer;
        }
        .gig-feed-card:hover { transform: translateY(-3px); box-shadow: 0 10px 36px rgba(0,0,0,0.4); }
        .gig-strip { height: 3px; background: linear-gradient(90deg, var(--accent-cyan), var(--accent-purple)); }
        .gig-strip.design     { background: linear-gradient(90deg, #f43f5e, #e879f9); }
        .gig-strip.writing    { background: linear-gradient(90deg, #f59e0b, #ef4444); }
        .gig-strip.engineering{ background: linear-gradient(90deg, #10b981, #06b6d4); }
        .gig-strip.business   { background: linear-gradient(90deg, #3b82f6, #8b5cf6); }

        .gig-card-inner { padding: 20px 22px; }
        .gig-meta { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        .gig-author { display: flex; align-items: center; gap: 10px; }
        .gig-avatar-sm {
            width: 34px; height: 34px; border-radius: 50%; flex-shrink: 0;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-cyan));
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.88rem; color: white;
        }
        .gig-author-name { font-weight: 600; font-size: 0.9rem; }
        .gig-author-college { font-size: 0.74rem; color: var(--text-muted); }
        .gig-cat-chip {
            font-size: 0.72rem; font-weight: 700; padding: 3px 10px; border-radius: 12px;
            text-transform: uppercase; letter-spacing: 0.5px;
        }
        .chip-coding    { background: rgba(6,182,212,0.12);  color: var(--accent-cyan);   }
        .chip-design    { background: rgba(244,63,94,0.12);  color: #f472b6;              }
        .chip-writing   { background: rgba(245,158,11,0.12); color: #fbbf24;              }
        .chip-engineering { background: rgba(16,185,129,0.12); color: var(--accent-green); }
        .chip-business  { background: rgba(59,130,246,0.12); color: #60a5fa;              }
        .chip-other     { background: rgba(139,92,246,0.12); color: var(--accent-purple); }

        .gig-title-feed { font-size: 1.05rem; font-weight: 600; margin: 0 0 6px; line-height: 1.4; text-decoration: none; color: white; }
        .gig-title-feed:hover { color: var(--accent-cyan); }
        .gig-desc-feed { font-size: 0.88rem; color: var(--text-muted); line-height: 1.6; margin: 0 0 16px;
                          display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .gig-footer { display: flex; align-items: center; justify-content: space-between; border-top: 1px solid rgba(255,255,255,0.06); padding-top: 14px; gap: 12px; }
        .gig-price-big { font-size: 1.2rem; font-weight: 700; color: var(--accent-green); }
        .gig-rating { display: flex; align-items: center; gap: 4px; font-size: 0.82rem; color: #fbbf24; }
        .gig-actions { display: flex; gap: 8px; }
        .btn-gig-msg  { padding: 7px 14px; border-radius: 8px; font-size: 0.83rem; font-weight: 600; cursor: pointer; border: 1px solid rgba(6,182,212,0.3); color: var(--accent-cyan); background: rgba(6,182,212,0.06); font-family: 'Outfit', sans-serif; transition: all 0.2s; }
        .btn-gig-msg:hover { background: rgba(6,182,212,0.15); }
        .btn-gig-hire { padding: 7px 14px; border-radius: 8px; font-size: 0.83rem; font-weight: 600; cursor: pointer; border: none; background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink)); color: white; font-family: 'Outfit', sans-serif; transition: all 0.2s; text-decoration: none; display: inline-block; }
        .btn-gig-hire:hover { transform: scale(1.04); }

        /* NOTES card */
        .notes-card { padding: 22px; margin-bottom: 16px; transition: all 0.25s; }
        .notes-card:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(0,0,0,0.3); }
        .notes-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; }
        .notes-author { display: flex; align-items: center; gap: 10px; }
        .notes-avatar {
            width: 36px; height: 36px; border-radius: 50%; flex-shrink: 0;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.9rem; color: white;
        }
        .notes-name { font-weight: 600; font-size: 0.9rem; }
        .notes-meta { font-size: 0.74rem; color: var(--text-muted); }
        .notes-badge { font-size: 0.7rem; font-weight: 700; padding: 3px 9px; border-radius: 10px; background: rgba(139,92,246,0.15); color: var(--accent-purple); border: 1px solid rgba(139,92,246,0.2); }
        .notes-title { font-size: 1.05rem; font-weight: 600; margin: 0 0 8px; }
        .notes-body { font-size: 0.88rem; color: var(--text-muted); line-height: 1.6; margin: 0 0 16px; }
        .notes-footer { display: flex; align-items: center; justify-content: space-between; border-top: 1px solid rgba(255,255,255,0.06); padding-top: 12px; }
        .interact-btns { display: flex; gap: 6px; }
        .ibtn { background: none; border: none; color: var(--text-muted); cursor: pointer; font-size: 0.83rem; padding: 5px 10px; border-radius: 7px; font-family: 'Outfit', sans-serif; transition: all 0.2s; display: flex; align-items: center; gap: 4px; }
        .ibtn:hover { background: rgba(255,255,255,0.06); color: white; }
        .ibtn.liked { color: var(--accent-pink); }
        .ibtn.saved { color: var(--accent-cyan); }

        /* Booked badge */
        .booked-tag { display: inline-flex; align-items: center; gap: 4px; padding: 5px 12px; border-radius: 8px; font-size: 0.79rem; font-weight: 600; background: rgba(16,185,129,0.1); color: var(--accent-green); border: 1px solid rgba(16,185,129,0.2); }
        .own-tag    { display: inline-flex; align-items: center; gap: 4px; padding: 5px 12px; border-radius: 8px; font-size: 0.79rem; font-weight: 600; background: rgba(139,92,246,0.1); color: var(--accent-purple); }

        /* Empty state */
        .feed-empty { text-align: center; padding: 60px 20px; color: var(--text-muted); }
        .feed-empty .icon { font-size: 2.5rem; margin-bottom: 12px; }
        .feed-empty h3 { margin: 0 0 8px; color: white; }
        .feed-empty p { margin: 0 0 20px; font-size: 0.9rem; }

        /* ═══════════════════════════════════════════════════════
           RIGHT SIDEBAR
        ═══════════════════════════════════════════════════════ */
        .right-col {
            position: sticky; top: 0; height: 100vh; overflow-y: auto;
            padding: 24px 20px; border-left: 1px solid rgba(255,255,255,0.06);
            background: rgba(15,10,30,0.6);
            scrollbar-width: none;
        }
        .right-col::-webkit-scrollbar { display: none; }

        .r-widget { margin-bottom: 22px; }
        .r-widget-title { font-size: 0.88rem; font-weight: 600; margin: 0 0 14px; display: flex; align-items: center; justify-content: space-between; color: white; }
        .r-widget-title a { font-size: 0.74rem; color: var(--accent-cyan); text-decoration: none; }
        .r-widget-title a:hover { color: white; }

        /* Suggested users */
        .suggest-item { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; }
        .suggest-avatar {
            width: 36px; height: 36px; border-radius: 50%; flex-shrink: 0;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-cyan));
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.88rem; color: white;
        }
        .suggest-info { flex: 1; }
        .suggest-name { font-weight: 600; font-size: 0.87rem; }
        .suggest-college { font-size: 0.72rem; color: var(--text-muted); }
        .btn-connect { padding: 5px 12px; border-radius: 8px; font-size: 0.78rem; font-weight: 600; cursor: pointer; border: 1px solid rgba(6,182,212,0.3); color: var(--accent-cyan); background: rgba(6,182,212,0.06); font-family: 'Outfit', sans-serif; transition: all 0.2s; }
        .btn-connect:hover { background: rgba(6,182,212,0.15); }

        /* Leaderboard */
        .lb-item { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; }
        .lb-rank { width: 26px; height: 26px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 0.78rem; font-weight: 700; flex-shrink: 0; }
        .lb-1 { background: linear-gradient(135deg, #fbbf24, #f59e0b); color: #1a1a2e; }
        .lb-2 { background: linear-gradient(135deg, #cbd5e1, #94a3b8); color: #1a1a2e; }
        .lb-3 { background: linear-gradient(135deg, #d97706, #92400e); color: white; }
        .lb-n { background: rgba(255,255,255,0.07); color: var(--text-muted); }
        .lb-self { background: linear-gradient(135deg, var(--accent-cyan), var(--accent-purple)); color: white; }
        .lb-info { flex: 1; }
        .lb-name { font-size: 0.87rem; font-weight: 600; }
        .lb-college { font-size: 0.72rem; color: var(--text-muted); }
        .lb-xp { font-size: 0.82rem; font-weight: 700; color: var(--accent-cyan); }

        /* Trending tags */
        .trend-tags { display: flex; flex-wrap: wrap; gap: 7px; }
        .trend-tag { padding: 5px 12px; border-radius: 16px; font-size: 0.78rem; color: var(--text-muted); background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); text-decoration: none; transition: all 0.2s; }
        .trend-tag:hover { background: rgba(139,92,246,0.1); border-color: rgba(139,92,246,0.3); color: white; }

        /* Divider */
        .r-divider { height: 1px; background: rgba(255,255,255,0.06); margin: 20px 0; }

        /* ═══════════════════════════════════════════════════════
           RESPONSIVE
        ═══════════════════════════════════════════════════════ */
        @media (max-width: 1100px) { .app-layout { grid-template-columns: 56px 1fr 260px; } .sidebar { padding: 20px 6px; } .sidebar-logo span:last-child, .nav-section-label, .nav-item span:not(.nav-icon), .sidebar-user .sidebar-username, .sidebar-user .sidebar-level, .xp-track, .xp-label { display: none; } .nav-item { justify-content: center; padding: 12px; } .sidebar-user-top { justify-content: center; } .sidebar-user-top div { display: none; } }
        @media (max-width: 800px) { .app-layout { grid-template-columns: 1fr; } .sidebar, .right-col { display: none; } .feed-center { padding: 16px; } .mini-cards { grid-template-columns: 1fr; } .quick-stats { gap: 8px; } }
    </style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="app-layout">

    <!-- ═══════════════════════════════════════════════════
         LEFT SIDEBAR
    ═══════════════════════════════════════════════════════ -->
    <aside class="sidebar">
        <a href="feed" class="sidebar-logo">
            <span style="font-size:1.4rem;"><i class="fa-solid fa-meteor"></i></span>
            <span>SkillNest</span>
        </a>

        <div class="nav-section-label">Marketplace</div>
        <a href="gigs"         class="nav-item"><span class="nav-icon"><i class="fa-solid fa-briefcase"></i></span> Browse Gigs</a>
        <a href="create-gig.jsp" class="nav-item"><span class="nav-icon"><i class="fa-solid fa-rocket"></i></span> Sell a Skill</a>

        <div class="nav-section-label">Community</div>
        <a href="feed"         class="nav-item active"><span class="nav-icon"><i class="fa-solid fa-house"></i></span> Home Feed</a>
        <a href="messages"     class="nav-item"><span class="nav-icon"><i class="fa-solid fa-comment-dots"></i></span> Messages
            <c:if test="${msgCount > 0}"><span class="nav-badge">${msgCount}</span></c:if>
        </a>
        <a href="challenges"   class="nav-item"><span class="nav-icon"><i class="fa-solid fa-bolt"></i></span> Challenges</a>
        <a href="leaderboard"  class="nav-item"><span class="nav-icon"><i class="fa-solid fa-trophy"></i></span> Leaderboard</a>

        <div class="nav-section-label">Account</div>
        <a href="profile"      class="nav-item"><span class="nav-icon"><i class="fa-solid fa-user"></i></span> My Profile</a>
        <a href="logout"       class="nav-item" style="color:var(--accent-pink);"><span class="nav-icon"><i class="fa-solid fa-arrow-right-from-bracket"></i></span> Logout</a>

        <!-- User Card -->
        <div class="sidebar-user">
            <div class="sidebar-user-top">
                <div class="user-avatar-sm">${sessionScope.user.username.substring(0,1).toUpperCase()}</div>
                <div>
                    <div class="sidebar-username">${sessionScope.user.username}</div>
                    <div class="sidebar-level"><i class="fa-solid fa-bolt"></i> Level ${sessionScope.user.level}</div>
                </div>
            </div>
            <div class="xp-track"><div class="xp-fill" style="width:${sessionScope.user.xp % 500 * 100 / 500}%;"></div></div>
            <div class="xp-label">${sessionScope.user.xp % 500}/500 XP to next level</div>
        </div>
    </aside>

    <!-- ═══════════════════════════════════════════════════
         CENTER FEED
    ═══════════════════════════════════════════════════════ -->
    <main class="feed-center">

        <!-- Top Bar -->
        <div class="top-bar">
            <form action="feed" method="get" class="search-form">
                <c:if test="${not empty activeTab && activeTab != 'all'}">
                    <input type="hidden" name="tab" value="${activeTab}">
                </c:if>
                <span class="search-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
                <input type="text" class="glass-input" name="searchQuery"
                       placeholder="Search gigs, notes, or students…"
                       value="${querySearch}" autocomplete="off">
            </form>
            <a href="create-gig.jsp" class="btn-solid" style="text-decoration:none; padding:9px 18px; font-size:0.88rem; border-radius:10px; white-space:nowrap;">+ New Gig</a>
            <a href="profile" class="top-bar-avatar">${sessionScope.user.username.substring(0,1).toUpperCase()}</a>
        </div>

        <!-- Welcome Strip -->
        <div class="welcome-strip">
            <div class="welcome-text">
                <h1>Hey, <span class="text-gradient">${sessionScope.user.username}</span> <i class="fa-solid fa-hand"></i></h1>
                <p>${sessionScope.user.collegeName} • ${sessionScope.user.xp} XP • Level ${sessionScope.user.level}</p>
            </div>
            <div class="quick-stats">
                <div class="q-stat">
                    <div class="q-stat-val text-gradient">${myGigsCount}</div>
                    <div class="q-stat-lbl">My Gigs</div>
                </div>
                <div class="q-stat">
                    <div class="q-stat-val" style="color:var(--accent-green);">${ordersReceived}</div>
                    <div class="q-stat-lbl">Orders</div>
                </div>
                <div class="q-stat">
                    <div class="q-stat-val" style="color:var(--accent-purple);">${connectionCount}</div>
                    <div class="q-stat-lbl">Connections</div>
                </div>
            </div>
        </div>

        <!-- Mini Cards: Challenge + Skills -->
        <div class="mini-cards">

            <!-- Daily Challenge -->
            <div class="mini-card challenge-mini">
                <h4><i class="fa-solid fa-bolt"></i> Daily Challenge <a href="challenges">View All →</a></h4>
                <c:choose>
                    <c:when test="${not empty todayChallenge}">
                        <div class="challenge-title">${todayChallenge.title}</div>
                        <div class="challenge-xp"><i class="fa-solid fa-gift"></i> +${todayChallenge.xpReward} XP</div>
                        <c:choose>
                            <c:when test="${challengeCompleted}">
                                <div class="challenge-done"><i class="fa-solid fa-circle-check"></i> Challenge Completed!</div>
                            </c:when>
                            <c:when test="${challengeAccepted}">
                                <form action="challenge" method="post" style="margin:0;">
                                    <input type="hidden" name="challengeId" value="${todayChallenge.id}">
                                    <input type="hidden" name="action" value="complete">
                                    <button type="submit" class="btn-challenge-accept"><i class="fa-solid fa-circle-check"></i> Mark Complete</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <form action="challenge" method="post" style="margin:0;">
                                    <input type="hidden" name="challengeId" value="${todayChallenge.id}">
                                    <input type="hidden" name="action" value="accept">
                                    <button type="submit" class="btn-challenge-accept"><i class="fa-solid fa-bolt"></i> Accept Quest</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <div style="color:var(--text-muted); font-size:0.88rem;">No challenge today. Come back tomorrow!</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Skills Progress -->
            <div class="mini-card">
                <h4><i class="fa-solid fa-arrow-trend-up"></i> Skill Progress <a href="challenges">Details →</a></h4>
                <c:choose>
                    <c:when test="${not empty userSkills}">
                        <c:forEach var="skill" items="${userSkills}" end="2">
                            <div class="progress-item">
                                <div class="progress-head">
                                    <span style="font-size:0.82rem;">${skill.skillName}</span>
                                    <span style="font-size:0.8rem; color:var(--accent-cyan);">${skill.progress}%</span>
                                </div>
                                <div class="progress-track"><div class="progress-fill" style="width:${skill.progress}%;"></div></div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="color:var(--text-muted); font-size:0.83rem; line-height:1.6;">
                            Complete challenges to track your progress!<br>
                            <a href="challenges" style="color:var(--accent-purple); text-decoration:none;">View Challenges →</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div><!-- /.mini-cards -->

        <!-- Create Post Bar -->
        <div class="create-bar" onclick="window.location.href='create-gig.jsp'">
            <div class="user-avatar-sm" style="flex-shrink:0;">${sessionScope.user.username.substring(0,1).toUpperCase()}</div>
            <input class="create-bar-input" readonly
                   placeholder="Share your skill, create a gig, or post study notes…"
                   onclick="window.location.href='create-gig.jsp'">
            <div class="create-bar-btns" onclick="event.stopPropagation()">
                <a href="create-gig.jsp" class="create-btn create-btn-gig"><i class="fa-solid fa-rocket"></i> Gig</a>
                <a href="add-post.jsp"   class="create-btn create-btn-note"><i class="fa-solid fa-book-open"></i> Notes</a>
            </div>
        </div>

        <!-- Feed Tabs -->
        <div class="feed-tabs">
            <a href="feed"           class="feed-tab ${activeTab == 'all'   || empty activeTab ? 'active' : ''}"><i class="fa-solid fa-globe"></i> All</a>
            <a href="feed?tab=gigs"  class="feed-tab ${activeTab == 'gigs'  ? 'active' : ''}"><i class="fa-solid fa-briefcase"></i> Gigs</a>
            <a href="feed?tab=notes" class="feed-tab ${activeTab == 'notes' ? 'active' : ''}"><i class="fa-solid fa-book-open"></i> Notes</a>
        </div>

        <!-- Category Filter Tags -->
        <div class="filter-tags">
            <a href="feed?tab=${activeTab}" class="ftag ${empty queryCategory ? 'active' : ''}">All</a>
            <a href="feed?tab=${activeTab}&category=Coding"      class="ftag ${queryCategory == 'Coding'      ? 'active' : ''}"><i class="fa-solid fa-laptop-code"></i> Coding</a>
            <a href="feed?tab=${activeTab}&category=Design"      class="ftag ${queryCategory == 'Design'      ? 'active' : ''}"><i class="fa-solid fa-palette"></i> Design</a>
            <a href="feed?tab=${activeTab}&category=Writing"     class="ftag ${queryCategory == 'Writing'     ? 'active' : ''}"><i class="fa-solid fa-pen-nib"></i> Writing</a>
            <a href="feed?tab=${activeTab}&category=Engineering"  class="ftag ${queryCategory == 'Engineering' ? 'active' : ''}"><i class="fa-solid fa-wrench"></i> Engineering</a>
            <a href="feed?tab=${activeTab}&category=Business"    class="ftag ${queryCategory == 'Business'    ? 'active' : ''}"><i class="fa-solid fa-chart-pie"></i> Business</a>
        </div>

        <!-- ── FEED POSTS ─────────────────────────────────────── -->
        <c:choose>
            <c:when test="${empty posts}">
                <div class="glass-card feed-empty">
                    <div class="icon"><i class="fa-solid fa-binoculars"></i></div>
                    <h3>Nothing here yet</h3>
                    <p>Be the first to post a gig or share study notes!</p>
                    <a href="create-gig.jsp" class="btn-solid" style="text-decoration:none; padding:10px 24px; display:inline-block;"><i class="fa-solid fa-rocket"></i> Create Your First Gig</a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="post" items="${posts}">

                    <c:choose>
                        <%-- ── GIG / SERVICE CARD ─────────────────────────────── --%>
                        <c:when test="${post.postType == 'GIG'}">
                            <c:set var="catL" value="${post.category.toLowerCase()}"/>
                            <div class="glass-card gig-feed-card">
                                <div class="gig-strip ${catL}"></div>
                                <div class="gig-card-inner">
                                    <div class="gig-meta">
                                        <div class="gig-author">
                                            <div class="gig-avatar-sm">${post.username.substring(0,1).toUpperCase()}</div>
                                            <div>
                                                <a href="user-profile?id=${post.userId}" class="gig-author-name" style="text-decoration:none; color:white;">${post.username}</a>
                                                <div class="gig-author-college">${post.userCollege}</div>
                                            </div>
                                        </div>
                                        <span class="gig-cat-chip chip-${catL}">${post.category}</span>
                                    </div>

                                    <a href="gig?id=${post.id}" class="gig-title-feed">${post.title}</a>
                                    <div class="gig-desc-feed">${post.description}</div>

                                    <div class="gig-footer">
                                        <div>
                                            <div class="gig-price-big">$${post.price}</div>
                                            <div class="gig-rating">
                                                <c:choose>
                                                    <c:when test="${post.averageRating > 0}"><i class="fa-solid fa-star"></i> ${post.averageRating}</c:when>
                                                    <c:otherwise><span style="color:var(--text-muted); font-weight:400; font-size:0.78rem;"><i class="fa-solid fa-wand-magic-sparkles"></i> New</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="gig-actions">
                                            <c:choose>
                                                <c:when test="${post.userId == sessionScope.user.id}">
                                                    <span class="own-tag"><i class="fa-solid fa-pencil"></i> Your Gig</span>
                                                </c:when>
                                                <c:when test="${post.bookedByCurrentUser}">
                                                    <span class="booked-tag"><i class="fa-solid fa-circle-check"></i> Ordered</span>
                                                    <form action="messages" method="get" style="margin:0;">
                                                        <input type="hidden" name="toUserId" value="${post.userId}">
                                                        <button type="submit" class="btn-gig-msg"><i class="fa-solid fa-comment-dots"></i> Chat</button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="messages" method="get" style="margin:0;">
                                                        <input type="hidden" name="toUserId" value="${post.userId}">
                                                        <button type="submit" class="btn-gig-msg"><i class="fa-solid fa-comment-dots"></i> Contact</button>
                                                    </form>
                                                    <a href="gig?id=${post.id}" class="btn-gig-hire">View Gig →</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>

                        <%-- ── NOTES CARD ──────────────────────────────────────── --%>
                        <c:otherwise>
                            <div class="glass-card notes-card">
                                <div class="notes-header">
                                    <div class="notes-author">
                                        <div class="notes-avatar">${post.username.substring(0,1).toUpperCase()}</div>
                                        <div>
                                            <a href="user-profile?id=${post.userId}" class="notes-name" style="text-decoration:none; color:white;">${post.username}</a>
                                            <div class="notes-meta">${post.userCollege} • ${post.category}</div>
                                        </div>
                                    </div>
                                    <span class="notes-badge"><i class="fa-solid fa-book-open"></i> Notes</span>
                                </div>

                                <div class="notes-title">${post.title}</div>
                                <div class="notes-body">${post.description}</div>

                                <div class="notes-footer">
                                    <div class="interact-btns">
                                        <form action="interact" method="post" style="margin:0;">
                                            <input type="hidden" name="action" value="${post.likedByCurrentUser ? 'unlike' : 'like'}">
                                            <input type="hidden" name="postId" value="${post.id}">
                                            <input type="hidden" name="returnUrl" value="feed?tab=${activeTab}">
                                            <button type="submit" class="ibtn ${post.likedByCurrentUser ? 'liked' : ''}">
                                                ${post.likedByCurrentUser ? '<i class="fa-solid fa-heart" style="color: #e23670;"></i>' : '<i class="fa-regular fa-heart"></i>'} ${post.likesCount}
                                            </button>
                                        </form>
                                        <form action="interact" method="post" style="margin:0;">
                                            <input type="hidden" name="action" value="${post.savedByCurrentUser ? 'unsave' : 'save'}">
                                            <input type="hidden" name="postId" value="${post.id}">
                                            <input type="hidden" name="returnUrl" value="feed?tab=${activeTab}">
                                            <button type="submit" class="ibtn ${post.savedByCurrentUser ? 'saved' : ''}">
                                                ${post.savedByCurrentUser ? '<i class="fa-solid fa-bookmark"></i>' : '<i class="fa-regular fa-bookmark"></i>'} Save
                                            </button>
                                        </form>
                                        <c:if test="${post.userId != sessionScope.user.id}">
                                            <form action="messages" method="get" style="margin:0;">
                                                <input type="hidden" name="toUserId" value="${post.userId}">
                                                <button type="submit" class="ibtn"><i class="fa-solid fa-comment-dots"></i> Message</button>
                                            </form>
                                        </c:if>
                                    </div>
                                    <c:if test="${post.userId == sessionScope.user.id}">
                                        <span style="font-size:0.75rem; color:var(--text-muted);">Your post</span>
                                    </c:if>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </c:forEach>
            </c:otherwise>
        </c:choose>
        <!-- /.feed posts -->

    </main>

    <!-- ═══════════════════════════════════════════════════
         RIGHT COLUMN
    ═══════════════════════════════════════════════════════ -->
    <aside class="right-col">

        <!-- Trending Tags -->
        <div class="r-widget">
            <div class="r-widget-title"><i class="fa-solid fa-fire"></i> Trending Skills</div>
            <div class="trend-tags">
                <a href="gigs?q=React"       class="trend-tag">#React</a>
                <a href="gigs?q=Python"      class="trend-tag">#Python</a>
                <a href="gigs?q=Figma"       class="trend-tag">#Figma</a>
                <a href="gigs?q=NodeJS"      class="trend-tag">#NodeJS</a>
                <a href="gigs?q=Flutter"     class="trend-tag">#Flutter</a>
                <a href="gigs?q=Logo"        class="trend-tag">#LogoDesign</a>
                <a href="gigs?q=Data"        class="trend-tag">#DataScience</a>
                <a href="gigs?q=Resume"      class="trend-tag">#Resume</a>
                <a href="gigs?q=Tutor"       class="trend-tag">#Tutoring</a>
            </div>
        </div>

        <div class="r-divider"></div>

        <!-- Suggested Users -->
        <div class="r-widget">
            <div class="r-widget-title"><i class="fa-solid fa-user-group"></i> Suggested <a href="leaderboard">See all</a></div>
            <c:choose>
                <c:when test="${not empty suggestedUsers}">
                    <c:forEach var="s" items="${suggestedUsers}">
                        <div class="suggest-item">
                            <div class="suggest-avatar">${s.username.substring(0,1).toUpperCase()}</div>
                            <div class="suggest-info">
                                <a href="user-profile?id=${s.id}" class="suggest-name" style="text-decoration:none; color:white;">${s.username}</a>
                                <div class="suggest-college">${s.collegeName}</div>
                            </div>
                            <form action="connect" method="post" style="margin:0;">
                                <input type="hidden" name="targetUserId" value="${s.id}">
                                <input type="hidden" name="action" value="connect">
                                <button type="submit" class="btn-connect">+ Connect</button>
                            </form>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p style="color:var(--text-muted); font-size:0.83rem;">No suggestions right now.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="r-divider"></div>

        <!-- Leaderboard -->
        <div class="r-widget">
            <div class="r-widget-title"><i class="fa-solid fa-trophy"></i> Leaderboard <a href="leaderboard">Full →</a></div>
            <c:choose>
                <c:when test="${not empty leaderboard}">
                    <c:forEach var="leader" items="${leaderboard}" varStatus="st">
                        <div class="lb-item">
                            <div class="lb-rank ${st.index == 0 ? 'lb-1' : st.index == 1 ? 'lb-2' : st.index == 2 ? 'lb-3' : (leader.id == sessionScope.user.id ? 'lb-self' : 'lb-n')}">${st.index + 1}</div>
                            <div class="lb-info">
                                <div class="lb-name"><a href="user-profile?id=${leader.id}" style="text-decoration:none; color:inherit;">${leader.username}</a><c:if test="${leader.id == sessionScope.user.id}"> <span style="font-size:0.68rem; color:var(--accent-cyan);">(you)</span></c:if></div>
                                <div class="lb-college">Lv.${leader.level}</div>
                            </div>
                            <div class="lb-xp">${leader.xp} XP</div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p style="color:var(--text-muted); font-size:0.83rem;">No rankings yet. Earn XP to appear here!</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="r-divider"></div>

        <!-- Quick Links -->
        <div class="r-widget">
            <div class="r-widget-title"><i class="fa-solid fa-bolt"></i> Quick Actions</div>
            <div style="display:flex; flex-direction:column; gap:8px;">
                <a href="create-gig.jsp" style="display:flex; align-items:center; gap:8px; padding:10px 12px; border-radius:10px; background:rgba(139,92,246,0.08); border:1px solid rgba(139,92,246,0.15); text-decoration:none; color:white; font-size:0.85rem; font-weight:500; transition:all 0.2s;" onmouseover="this.style.background='rgba(139,92,246,0.15)'" onmouseout="this.style.background='rgba(139,92,246,0.08)'"><i class="fa-solid fa-rocket"></i> Create a Gig</a>
                <a href="gigs"           style="display:flex; align-items:center; gap:8px; padding:10px 12px; border-radius:10px; background:rgba(6,182,212,0.06);  border:1px solid rgba(6,182,212,0.12); text-decoration:none; color:white; font-size:0.85rem; font-weight:500; transition:all 0.2s;" onmouseover="this.style.background='rgba(6,182,212,0.12)'" onmouseout="this.style.background='rgba(6,182,212,0.06)'"><i class="fa-solid fa-briefcase"></i> Browse Gigs</a>
                <a href="challenges"     style="display:flex; align-items:center; gap:8px; padding:10px 12px; border-radius:10px; background:rgba(247,42,117,0.06);  border:1px solid rgba(247,42,117,0.12); text-decoration:none; color:white; font-size:0.85rem; font-weight:500; transition:all 0.2s;" onmouseover="this.style.background='rgba(247,42,117,0.12)'" onmouseout="this.style.background='rgba(247,42,117,0.06)'"><i class="fa-solid fa-bolt"></i> Today's Challenge</a>
                <a href="messages"       style="display:flex; align-items:center; gap:8px; padding:10px 12px; border-radius:10px; background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.08); text-decoration:none; color:white; font-size:0.85rem; font-weight:500; transition:all 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.06)'" onmouseout="this.style.background='rgba(255,255,255,0.03)'"><i class="fa-solid fa-comment-dots"></i> Messages</a>
            </div>
        </div>

    </aside>

</div><!-- /.app-layout -->
<jsp:include page="mobile-nav.jsp"/>`n</body>
</html>
