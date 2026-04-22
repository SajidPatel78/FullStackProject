<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillNest - Daily Challenges</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=4.0">
    <style>
        /* Page Layout */
        .challenges-page {
            max-width: 1000px;
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

        /* XP Summary Card */
        .xp-summary {
            padding: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 35px;
            background: linear-gradient(135deg, rgba(139,92,246,0.12), rgba(247,42,117,0.06));
            border: 1px solid rgba(139,92,246,0.2);
            flex-wrap: wrap;
            gap: 20px;
        }
        .xp-info h2 { margin: 0 0 6px 0; font-size: 1.4rem; }
        .xp-info p { color: var(--text-muted); margin: 0; font-size: 0.95rem; }
        .xp-badge {
            display: flex; align-items: center; gap: 15px;
        }
        .xp-circle {
            width: 70px; height: 70px; border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink));
            display: flex; align-items: center; justify-content: center;
            flex-direction: column;
            box-shadow: 0 4px 25px var(--glow-pink);
        }
        .xp-circle-val { font-size: 1.3rem; font-weight: 700; line-height: 1; }
        .xp-circle-label { font-size: 0.6rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.8; }
        .xp-total { text-align: right; }
        .xp-total-val { font-size: 2rem; font-weight: 700; color: var(--accent-cyan); }
        .xp-total-label { font-size: 0.8rem; color: var(--text-muted); }

        /* Section Labels */
        .section-label {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-label .count {
            background: rgba(139,92,246,0.2);
            color: var(--accent-purple);
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        /* Challenge Cards */
        .challenge-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 22px;
            margin-bottom: 50px;
        }

        .challenge-card {
            padding: 28px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .challenge-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.4);
        }
        .challenge-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--accent-cyan), var(--accent-purple), var(--accent-pink));
        }
        .challenge-card.completed::before {
            background: linear-gradient(90deg, var(--accent-green), var(--accent-cyan));
        }

        .challenge-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 14px;
        }
        .challenge-category {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            color: var(--accent-purple);
        }
        .challenge-xp {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 700;
            background: rgba(6,182,212,0.12);
            color: var(--accent-cyan);
            border: 1px solid rgba(6,182,212,0.2);
        }
        .challenge-card h3 {
            font-size: 1.15rem;
            margin: 0 0 10px 0;
            font-weight: 600;
            line-height: 1.4;
        }
        .challenge-card p {
            color: var(--text-muted);
            font-size: 0.9rem;
            line-height: 1.6;
            margin: 0 0 20px 0;
        }
        .challenge-date {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .challenge-actions {
            display: flex;
            gap: 10px;
        }
        .challenge-actions .btn-solid,
        .challenge-actions .btn-neon {
            flex: 1;
            text-align: center;
            padding: 10px 16px;
            font-size: 0.9rem;
        }

        .completed-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 18px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            background: rgba(16,185,129,0.12);
            color: var(--accent-green);
            border: 1px solid rgba(16,185,129,0.25);
            width: 100%;
            justify-content: center;
        }

        .accepted-status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.78rem;
            font-weight: 600;
            background: rgba(251,191,36,0.12);
            color: #fbbf24;
            border: 1px solid rgba(251,191,36,0.2);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 30px;
        }
        .empty-state-icon { font-size: 3rem; margin-bottom: 15px; }
        .empty-state h3 { margin: 0 0 10px 0; font-size: 1.3rem; }
        .empty-state p { color: var(--text-muted); margin: 0; }

        /* Skills Progress */
        .skills-section {
            margin-top: 10px;
        }
        .skill-card {
            padding: 22px 25px;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .skill-icon {
            width: 45px; height: 45px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            background: linear-gradient(135deg, rgba(139,92,246,0.15), rgba(6,182,212,0.1));
            border: 1px solid rgba(139,92,246,0.15);
            flex-shrink: 0;
        }
        .skill-info { flex: 1; }
        .skill-info-top { display: flex; justify-content: space-between; margin-bottom: 6px; }
        .skill-name { font-weight: 600; font-size: 0.95rem; }
        .skill-pct { color: var(--accent-cyan); font-weight: 700; font-size: 0.9rem; }
        .skill-track { height: 6px; background: rgba(255,255,255,0.08); border-radius: 3px; overflow: hidden; }
        .skill-fill { height: 100%; border-radius: 3px; background: linear-gradient(90deg, var(--accent-cyan), var(--accent-purple)); transition: width 0.8s ease; }
    </style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="challenges-page">

        <!-- Page Header -->
        <div class="page-header">
            <a href="feed">← Back to Feed</a>
            <h1><i class="fa-solid fa-bolt"></i> Daily <span class="text-gradient">Challenges</span></h1>
            <div style="width: 120px;"></div>
        </div>

        <!-- XP Summary -->
        <div class="glass-card xp-summary">
            <div class="xp-info">
                <h2>Welcome, ${sessionScope.user.username}!</h2>
                <p>Complete challenges to earn XP and level up your skills.</p>
            </div>
            <div class="xp-badge">
                <div class="xp-circle">
                    <span class="xp-circle-val">${sessionScope.user.level}</span>
                    <span class="xp-circle-label">Level</span>
                </div>
                <div class="xp-total">
                    <div class="xp-total-val">${sessionScope.user.xp} XP</div>
                    <div class="xp-total-label">${sessionScope.user.xp % 500}/500 to next level</div>
                </div>
            </div>
        </div>

        <!-- Today's Challenge -->
        <div class="section-label"><i class="fa-solid fa-fire"></i> Today's Challenge <span class="count">Active</span></div>

        <div class="challenge-grid">
            <c:choose>
                <c:when test="${not empty todayChallenge}">
                    <div class="glass-card challenge-card ${challengeCompleted ? 'completed' : ''}">
                        <div class="challenge-top">
                            <span class="challenge-category">${todayChallenge.category}</span>
                            <span class="challenge-xp"><i class="fa-solid fa-gift"></i> +${todayChallenge.xpReward} XP</span>
                        </div>
                        <h3>${todayChallenge.title}</h3>
                        <p>${todayChallenge.description}</p>
                        <div class="challenge-date"><i class="fa-regular fa-calendar-days"></i> ${todayChallenge.challengeDate}</div>

                        <c:choose>
                            <c:when test="${challengeCompleted}">
                                <div class="completed-badge"><i class="fa-solid fa-circle-check"></i> Challenge Completed — XP Earned!</div>
                            </c:when>
                            <c:when test="${challengeAccepted}">
                                <div class="challenge-actions">
                                    <div style="display: flex; align-items: center;">
                                        <span class="accepted-status">🟡 In Progress</span>
                                    </div>
                                    <form action="challenge" method="post" style="margin:0; flex:1;">
                                        <input type="hidden" name="challengeId" value="${todayChallenge.id}">
                                        <input type="hidden" name="action" value="complete">
                                        <input type="hidden" name="returnUrl" value="challenges">
                                        <button type="submit" class="btn-solid" style="width:100%;"><i class="fa-solid fa-circle-check"></i> Mark Complete</button>
                                    </form>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="challenge-actions">
                                    <form action="challenge" method="post" style="margin:0; flex:1;">
                                        <input type="hidden" name="challengeId" value="${todayChallenge.id}">
                                        <input type="hidden" name="action" value="accept">
                                        <input type="hidden" name="returnUrl" value="challenges">
                                        <button type="submit" class="btn-solid" style="width:100%;"><i class="fa-solid fa-bolt"></i> Accept Challenge</button>
                                    </form>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="glass-card empty-state" style="grid-column: 1/-1;">
                        <div class="empty-state-icon">🌙</div>
                        <h3>No Challenge Today</h3>
                        <p>Check back tomorrow for a new challenge!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- All Available Challenges -->
        <div class="section-label"><i class="fa-solid fa-clipboard-list"></i> All Challenges
            <c:if test="${not empty allChallenges}">
                <span class="count">${allChallenges.size()}</span>
            </c:if>
        </div>

        <div class="challenge-grid">
            <c:choose>
                <c:when test="${not empty allChallenges}">
                    <c:forEach var="ch" items="${allChallenges}">
                        <div class="glass-card challenge-card ${ch.status == 'COMPLETED' ? 'completed' : ''}">
                            <div class="challenge-top">
                                <span class="challenge-category">${ch.category}</span>
                                <span class="challenge-xp"><i class="fa-solid fa-gift"></i> +${ch.xpReward} XP</span>
                            </div>
                            <h3>${ch.title}</h3>
                            <p>${ch.description}</p>
                            <div class="challenge-date"><i class="fa-regular fa-calendar-days"></i> ${ch.challengeDate}</div>

                            <c:choose>
                                <c:when test="${ch.status == 'COMPLETED'}">
                                    <div class="completed-badge"><i class="fa-solid fa-circle-check"></i> Completed</div>
                                </c:when>
                                <c:when test="${ch.status == 'ACCEPTED'}">
                                    <div class="challenge-actions">
                                        <span class="accepted-status">🟡 In Progress</span>
                                        <form action="challenge" method="post" style="margin:0; flex:1;">
                                            <input type="hidden" name="challengeId" value="${ch.id}">
                                            <input type="hidden" name="action" value="complete">
                                            <input type="hidden" name="returnUrl" value="challenges">
                                            <button type="submit" class="btn-solid" style="width:100%; font-size:0.85rem;">Complete</button>
                                        </form>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="challenge-actions">
                                        <form action="challenge" method="post" style="margin:0; flex:1;">
                                            <input type="hidden" name="challengeId" value="${ch.id}">
                                            <input type="hidden" name="action" value="accept">
                                            <input type="hidden" name="returnUrl" value="challenges">
                                            <button type="submit" class="btn-neon" style="width:100%;">Accept</button>
                                        </form>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="glass-card empty-state" style="grid-column: 1/-1;">
                        <div class="empty-state-icon">📭</div>
                        <h3>No Challenges Available</h3>
                        <p>New challenges are added regularly. Stay tuned!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Skill Progress -->
        <div class="section-label skills-section"><i class="fa-solid fa-arrow-trend-up"></i> Your Skill Progress</div>

        <c:choose>
            <c:when test="${not empty userSkills}">
                <c:forEach var="skill" items="${userSkills}">
                    <div class="glass-card skill-card">
                        <div class="skill-icon">
                            <c:choose>
                                <c:when test="${skill.skillName == 'Coding'}"><i class="fa-solid fa-laptop-code"></i></c:when>
                                <c:when test="${skill.skillName == 'Design'}"><i class="fa-solid fa-palette"></i></c:when>
                                <c:when test="${skill.skillName == 'Writing'}"><i class="fa-solid fa-file-signature"></i></c:when>
                                <c:when test="${skill.skillName == 'Engineering'}"><i class="fa-solid fa-wrench"></i></c:when>
                                <c:otherwise><i class="fa-solid fa-chart-pie"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="skill-info">
                            <div class="skill-info-top">
                                <span class="skill-name">${skill.skillName}</span>
                                <span class="skill-pct">${skill.progress}%</span>
                            </div>
                            <div class="skill-track"><div class="skill-fill" style="width: ${skill.progress}%;"></div></div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="glass-card" style="padding: 30px; text-align: center; color: var(--text-muted);">
                    <p style="margin:0;">Complete challenges and create posts to build your skill progress!</p>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
<jsp:include page="mobile-nav.jsp"/>`n</body>
</html>
