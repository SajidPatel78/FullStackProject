<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Messages</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        .chat-container {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            display: flex;
            flex-direction: column;
            height: 60vh;
            max-width: 600px;
            margin: 20px auto;
        }
        .chat-history {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            border-bottom: 1px solid #eee;
        }
        .chat-message {
            margin-bottom: 15px;
            max-width: 80%;
        }
        .chat-message.sent {
            margin-left: auto;
            text-align: right;
        }
        .chat-message.received {
            margin-right: auto;
            text-align: left;
        }
        .message-content {
            padding: 10px 15px;
            border-radius: 20px;
            display: inline-block;
        }
        .sent .message-content {
            background: var(--primary-color);
            color: white;
            border-bottom-right-radius: 5px;
        }
        .received .message-content {
            background: #f1f0f0;
            color: #333;
            border-bottom-left-radius: 5px;
        }
        .message-meta {
            font-size: 0.75em;
            color: #888;
            margin-top: 5px;
        }
        .chat-input {
            padding: 20px;
            display: flex;
            gap: 10px;
        }
    </style>
</head>
<body>
    <header>
        <h1>SkillNest</h1>
        <nav>
            <a href="feed">Feed</a>
            <a href="profile">Profile</a>
            <a href="logout">Logout</a>
        </nav>
    </header>
    
    <div class="container">
        <h2 style="text-align: center;">Conversation</h2>
        <c:choose>
            <c:when test="${empty toUserId}">
                <div class="card" style="text-align: center;">
                    <p>Select a user from a post to start a conversation.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="chat-container">
                    <div class="chat-history" id="chatHistory">
                        <c:choose>
                            <c:when test="${empty conversation}">
                                <p style="text-align: center; color: #888; padding-top: 50px;">No messages yet. Say hi!</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="msg" items="${conversation}">
                                    <div class="chat-message ${msg.senderId == sessionScope.user.id ? 'sent' : 'received'}">
                                        <div class="message-content">${msg.content}</div>
                                        <div class="message-meta">${msg.senderName} • ${msg.createdAt}</div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <form class="chat-input" action="messages" method="post">
                        <input type="hidden" name="toUserId" value="${toUserId}">
                        <input type="text" name="content" required placeholder="Type a message..." value="${param.context}" style="flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 20px;">
                        <button type="submit" class="btn" style="border-radius: 20px; padding: 10px 20px;">Send</button>
                    </form>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        // Scroll to bottom of chat automatically
        var chatHistory = document.getElementById("chatHistory");
        if (chatHistory) {
            chatHistory.scrollTop = chatHistory.scrollHeight;
        }
    </script>
</body>
</html>
