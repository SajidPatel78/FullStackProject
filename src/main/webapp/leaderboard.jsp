<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillNest - Leaderboard</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=4.0">
    <style>
        .leaderboard-page {
            max-width: 900px;
            margin: 0 auto;
            padding: 30px 20px;
            min-height: 100vh;
        }

        .page-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 35px;
        }
        .page-header a { color: var(--text-muted); text-decoration: none; font-weight: 500; transition: color 0.3s; }
        .page-header a:hover { color: white; }
        .page-header h1 { margin: 0; flex: 1; text-align: center; font-size: 2rem; }

        /* Top 3 Podium */
        .podium {
            display: flex;
            justify-content: center;
            align-items: flex-end;
            gap: 20px;
            margin-bottom: 45px;
            padding: 20px 0 0;
        }
        .podium-slot {
            text-align: center;
            padding: 25px 20px;
            border-radius: 20px 20px 0 0;
            position: relative;
            transition: all 0.3s;
            min-width: 150px;
        }
        .podium-slot:hover { transform: translateY(-3px); }

        .podium-1 {
            background: linear-gradient(180deg, rgba(251,191,36,0.12), rgba(245,158,11,0.04));
            border: 1px solid rgba(251,191,36,0.2);
            border-bottom: 3px solid #fbbf24;
            padding-bottom: 35px;
            order: 2;
        }
        .podium-2 {
            background: linear-gradient(180deg, rgba(203,213,225,0.08), rgba(148,163,184,0.03));
            border: 1px solid rgba(203,213,225,0.15);
            border-bottom: 3px solid #94a3b8;
            padding-bottom: 25px;
            order: 1;
        }
        .podium-3 {
            background: linear-gradient(180deg, rgba(217,119,6,0.1), rgba(146,64,14,0.04));
            border: 1px solid rgba(217,119,6,0.15);
            border-bottom: 3px solid #d97706;
            padding-bottom: 20px;
            order: 3;
        }

        .podium-crown {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        .podium-avatar {
            width: 65px; height: 65px; border-radius: 50%;
            margin: 0 auto 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; font-weight: 700; color: white;
        }
        .podium-1 .podium-avatar {
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            box-shadow: 0 4px 25px rgba(251,191,36,0.3);
        }
        .podium-2 .podium-avatar {
            background: linear-gradient(135deg, #cbd5e1, #94a3b8);
            width: 55px; height: 55px; font-size: 1.5rem;
        }
        .podium-3 .podium-avatar {
            background: linear-gradient(135deg, #d97706, #92400e);
            width: 55px; height: 55px; font-size: 1.5rem;
        }

        .podium-name { font-weight: 600; font-size: 1.05rem; margin-bottom: 4px; }
        .podium-college { font-size: 0.78rem; color: var(--text-muted); margin-bottom: 10px; }
        .podium-xp {
            font-size: 1.1rem; font-weight: 700; color: var(--accent-cyan);
        }
        .podium-level {
            font-size: 0.78rem; color: var(--text-muted); margin-top: 2px;
        }

        /* Your Rank Card */
        .your-rank-card {
            padding: 25px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 35px;
            background: linear-gradient(135deg, rgba(6,182,212,0.08), rgba(139,92,246,0.06));
            border: 1px solid rgba(6,182,212,0.15);
            flex-wrap: wrap;
            gap: 15px;
        }
        .your-rank-left { display: flex; align-items: center; gap: 15px; }
        .your-rank-number {
            width: 50px; height: 50px; border-radius: 14px;
            background: linear-gradient(135deg, var(--accent-cyan), var(--accent-purple));
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem; font-weight: 700; color: white;
        }
        .your-rank-info h3 { margin: 0; font-size: 1.1rem; }
        .your-rank-info p { margin: 2px 0 0; color: var(--text-muted); font-size: 0.85rem; }
        .your-rank-right { display: flex; align-items: center; gap: 25px; }
        .your-rank-stat { text-align: center; }
        .your-rank-val { font-size: 1.5rem; font-weight: 700; }
        .your-rank-label { font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; }

        /* Full Rankings Table */
        .rankings-label {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .rankings-label .count {
            background: rgba(139,92,246,0.2);
            color: var(--accent-purple);
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 0.85rem;
        }

        .ranking-item {
            display: flex;
            align-items: center;
            padding: 18px 22px;
            margin-bottom: 8px;
            transition: all 0.25s ease;
            gap: 18px;
        }
        .ranking-item:hover {
            transform: translateX(4px);
            background: rgba(255,255,255,0.04);
        }

        .rank-pos {
            width: 36px; height: 36px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.95rem; font-weight: 700;
            flex-shrink: 0;
        }
        .rank-pos-1 { background: linear-gradient(135deg, #fbbf24, #f59e0b); color: #1a1a2e; }
        .rank-pos-2 { background: linear-gradient(135deg, #cbd5e1, #94a3b8); color: #1a1a2e; }
        .rank-pos-3 { background: linear-gradient(135deg, #d97706, #92400e); color: white; }
        .rank-pos-default { background: rgba(255,255,255,0.06); color: var(--text-muted); }
        .rank-pos-self { background: linear-gradient(135deg, var(--accent-cyan), var(--accent-purple)); color: white; }

        .rank-avatar {
            width: 42px; height: 42px; border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 1.1rem; color: white;
            flex-shrink: 0;
        }

        .rank-user-info { flex: 1; }
        .rank-username { font-weight: 600; font-size: 1rem; }
        .rank-college { font-size: 0.8rem; color: var(--text-muted); }

        .rank-stats { display: flex; gap: 25px; align-items: center; }
        .rank-stat-item { text-align: center; }
        .rank-xp { font-size: 1.1rem; font-weight: 700; color: var(--accent-cyan); }
        .rank-level-badge {
            padding: 4px 10px; border-radius: 10px; font-size: 0.8rem; font-weight: 600;
            background: rgba(139,92,246,0.15); color: var(--accent-purple);
            border: 1px solid rgba(139,92,246,0.2);
        }

        .rank-progress-mini {
            width: 80px; height: 5px; background: rgba(255,255,255,0.08);
            border-radius: 3px; overflow: hidden;
        }
        .rank-progress-fill { height: 100%; border-radius: 3px; background: linear-gradient(90deg, var(--accent-cyan), var(--accent-purple)); }

        /* Empty State */
        .empty-state { text-align: center; padding: 60px 30px; }
        .empty-state-icon { font-size: 3rem; margin-bottom: 15px; }
        .empty-state h3 { margin: 0 0 10px 0; }
        .empty-state p { color: var(--text-muted); margin: 0; }

        @media (max-width: 768px) {
            .podium { flex-direction: column; align-items: center; }
            .podium-slot { order: unset !important; border-radius: 16px; min-width: 90%; }
            .your-rank-card { flex-direction: column; text-align: center; }
            .your-rank-left { flex-direction: column; }
            .rank-stats { gap: 15px; }
        }
    </style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="leaderboard-page">

        <!-- Page Header -->
        <div class="page-header">
            <a href="feed">← Back to Feed</a>
            <h1><i class="fa-solid fa-trophy"></i> <span class="text-gradient">Leaderboard</span></h1>
            <div style="width: 120px;"></div>
        </div>

        <!-- Top 3 Podium -->
        <c:if test="${not empty leaderboard && leaderboard.size() >= 3}">
            <div class="podium">
                <!-- 2nd Place -->
                <div class="podium-slot podium-2">
                    <div class="podium-crown">🥈</div>
                    <div class="podium-avatar">${leaderboard[1].username.substring(0,1).toUpperCase()}</div>
                    <div class="podium-name">${leaderboard[1].username}</div>
                    <div class="podium-college">${leaderboard[1].collegeName}</div>
                    <div class="podium-xp">${leaderboard[1].xp} XP</div>
                    <div class="podium-level">Level ${leaderboard[1].level}</div>
                </div>
                <!-- 1st Place -->
                <div class="podium-slot podium-1">
                    <div class="podium-crown">👑</div>
                    <div class="podium-avatar">${leaderboard[0].username.substring(0,1).toUpperCase()}</div>
                    <div class="podium-name">${leaderboard[0].username}</div>
                    <div class="podium-college">${leaderboard[0].collegeName}</div>
                    <div class="podium-xp">${leaderboard[0].xp} XP</div>
                    <div class="podium-level">Level ${leaderboard[0].level}</div>
                </div>
                <!-- 3rd Place -->
                <div class="podium-slot podium-3">
                    <div class="podium-crown">🥉</div>
                    <div class="podium-avatar">${leaderboard[2].username.substring(0,1).toUpperCase()}</div>
                    <div class="podium-name">${leaderboard[2].username}</div>
                    <div class="podium-college">${leaderboard[2].collegeName}</div>
                    <div class="podium-xp">${leaderboard[2].xp} XP</div>
                    <div class="podium-level">Level ${leaderboard[2].level}</div>
                </div>
            </div>
        </c:if>

        <!-- Your Rank -->
        <c:if test="${not empty sessionScope.user}">
            <div class="glass-card your-rank-card">
                <div class="your-rank-left">
                    <div class="your-rank-number">#${yourRank > 0 ? yourRank : '—'}</div>
                    <div class="your-rank-info">
                        <h3>Your Rank</h3>
                        <p>${sessionScope.user.username} • ${sessionScope.user.collegeName}</p>
                    </div>
                </div>
                <div class="your-rank-right">
                    <div class="your-rank-stat">
                        <div class="your-rank-val text-gradient">${sessionScope.user.xp}</div>
                        <div class="your-rank-label">Total XP</div>
                    </div>
                    <div class="your-rank-stat">
                        <div class="your-rank-val" style="color: var(--accent-purple);">${sessionScope.user.level}</div>
                        <div class="your-rank-label">Level</div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Full Rankings -->
        <div class="rankings-label">
            <i class="fa-solid fa-chart-pie"></i> Full Rankings
            <c:if test="${not empty leaderboard}">
                <span class="count">${leaderboard.size()} users</span>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${not empty leaderboard}">
                <c:forEach var="user" items="${leaderboard}" varStatus="status">
                    <div class="glass-card ranking-item">
                        <div class="rank-pos ${status.index == 0 ? 'rank-pos-1' : status.index == 1 ? 'rank-pos-2' : status.index == 2 ? 'rank-pos-3' : (user.id == sessionScope.user.id ? 'rank-pos-self' : 'rank-pos-default')}">
                            ${status.index + 1}
                        </div>
                        <div class="rank-avatar" style="${status.index == 0 ? 'background: linear-gradient(135deg, #fbbf24, #f59e0b);' : status.index == 1 ? 'background: linear-gradient(135deg, #cbd5e1, #94a3b8);' : status.index == 2 ? 'background: linear-gradient(135deg, #d97706, #92400e);' : ''}">
                            ${user.username.substring(0,1).toUpperCase()}
                        </div>
                        <div class="rank-user-info">
                            <div class="rank-username">
                                ${user.username}
                                <c:if test="${user.id == sessionScope.user.id}">
                                    <span style="font-size: 0.75rem; color: var(--accent-cyan); margin-left: 5px;">(You)</span>
                                </c:if>
                            </div>
                            <div class="rank-college">${user.collegeName}</div>
                        </div>
                        <div class="rank-stats">
                            <div class="rank-stat-item">
                                <div class="rank-xp">${user.xp} XP</div>
                                <div class="rank-progress-mini">
                                    <div class="rank-progress-fill" style="width: ${user.xp % 500 * 100 / 500}%;"></div>
                                </div>
                            </div>
                            <span class="rank-level-badge">Lv. ${user.level}</span>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="glass-card empty-state">
                    <div class="empty-state-icon"><i class="fa-solid fa-trophy"></i></div>
                    <h3>No Rankings Yet</h3>
                    <p>Start earning XP to be the first on the leaderboard!</p>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</body>
</html>
