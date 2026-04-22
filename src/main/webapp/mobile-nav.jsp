<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String currentURI = request.getRequestURI();
    boolean isFeed = currentURI.endsWith("feed") || currentURI.endsWith("feed.jsp");
    boolean isGigs = currentURI.endsWith("gigs") || currentURI.endsWith("gigs.jsp") || currentURI.endsWith("gig") || currentURI.endsWith("gig.jsp");
    boolean isChallenges = currentURI.endsWith("challenges") || currentURI.endsWith("challenges.jsp");
    boolean isLeaderboard = currentURI.endsWith("leaderboard") || currentURI.endsWith("leaderboard.jsp");
    boolean isProfile = currentURI.endsWith("profile") || currentURI.endsWith("profile.jsp") || currentURI.endsWith("user-profile") || currentURI.endsWith("connections");
%>
<nav class="mobile-bottom-nav">
    <div class="mobile-nav-items">
        <a href="feed" class="mobile-nav-item <%= isFeed ? "active" : "" %>">
            <i class="fa-solid fa-house"></i>
            <span>Feed</span>
        </a>
        <a href="gigs" class="mobile-nav-item <%= isGigs ? "active" : "" %>">
            <i class="fa-solid fa-briefcase"></i>
            <span>Gigs</span>
        </a>
        <a href="create-gig.jsp" class="mobile-nav-item" style="position: relative; top: -15px;">
            <div style="width: 50px; height: 50px; border-radius: 50%; background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink)); display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 15px var(--glow-pink);">
                <i class="fa-solid fa-plus" style="color: white; font-size: 1.5rem;"></i>
            </div>
            <span style="margin-top: 5px;">Sell</span>
        </a>
        <a href="challenges" class="mobile-nav-item <%= isChallenges ? "active" : "" %>">
            <i class="fa-solid fa-bolt"></i>
            <span>Quests</span>
        </a>
        <a href="profile" class="mobile-nav-item <%= isProfile ? "active" : "" %>">
            <i class="fa-solid fa-user"></i>
            <span>Profile</span>
        </a>
    </div>
</nav>
