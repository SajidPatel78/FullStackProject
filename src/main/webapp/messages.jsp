<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Messages</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=3.0">
    <style>
        .msg-page { max-width: 700px; margin: 0 auto; padding: 30px 20px; }
        .back-nav a { color: var(--text-muted); text-decoration: none; font-weight: 500; }
        .back-nav a:hover { color: white; }
        
        .chat-box { display: flex; flex-direction: column; height: 65vh; }
        .chat-history { flex: 1; padding: 20px; overflow-y: auto; }
        .chat-history::-webkit-scrollbar { width: 4px; }
        .chat-history::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }
        
        .chat-msg { margin-bottom: 15px; max-width: 80%; }
        .chat-msg.sent { margin-left: auto; text-align: right; }
        .chat-msg.received { margin-right: auto; text-align: left; }
        .msg-bubble { padding: 10px 16px; border-radius: 16px; display: inline-block; font-size: 0.95rem; line-height: 1.4; }
        .sent .msg-bubble { background: linear-gradient(135deg, var(--accent-purple), var(--accent-pink)); color: white; border-bottom-right-radius: 4px; }
        .received .msg-bubble { background: rgba(255,255,255,0.08); color: var(--text-main); border-bottom-left-radius: 4px; }
        .msg-meta { font-size: 0.7rem; color: var(--text-muted); margin-top: 4px; }
        
        .chat-input { padding: 15px; display: flex; gap: 10px; border-top: 1px solid var(--card-border); }
        .chat-input .glass-input { flex: 1; border-radius: 20px; }
    </style>
</head>
<body>
    <div class="msg-page">
        <div class="back-nav" style="margin-bottom:20px;">
            <a href="feed">← Back to Feed</a>
        </div>
        
        <h2 style="text-align:center; margin-bottom:20px;">💬 Conversation</h2>
        
        <c:choose>
            <c:when test="${empty toUserId}">
                <div class="glass-card" style="text-align: center; padding: 40px; color: var(--text-muted);">
                    <p>Select a user from a post to start a conversation.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="glass-card chat-box">
                    <div class="chat-history" id="chatHistory">
                        <c:choose>
                            <c:when test="${empty conversation}">
                                <p style="text-align: center; color: var(--text-muted); padding-top: 50px;">No messages yet. Say hi! 👋</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="msg" items="${conversation}">
                                    <div class="chat-msg ${msg.senderId == sessionScope.user.id ? 'sent' : 'received'}">
                                        <div class="msg-bubble">${msg.content}</div>
                                        <div class="msg-meta">${msg.senderName} • ${msg.createdAt}</div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <form class="chat-input" action="messages" method="post">
                        <input type="hidden" name="toUserId" value="${toUserId}">
                        <input type="text" name="content" class="glass-input" required placeholder="Type a message..." value="${param.context}">
                        <button type="submit" class="btn-solid" style="border-radius: 20px; padding: 10px 20px;">Send</button>
                    </form>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        var chatHistory = document.getElementById("chatHistory");
        if (chatHistory) { chatHistory.scrollTop = chatHistory.scrollHeight; }
    </script>
</body>
</html>
