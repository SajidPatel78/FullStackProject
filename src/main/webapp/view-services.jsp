<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Services</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <header>
        <h1>SkillNest</h1>
        <nav>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="dashboard">Dashboard</a>
                    <a href="logout">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="login.jsp">Login</a>
                    <a href="register.jsp">Register</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </header>
    
    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2>Available Services</h2>
            <c:if test="${not empty sessionScope.user}">
                <a href="add-service.jsp" class="btn">Offer a Service</a>
            </c:if>
        </div>
        
        <div class="service-list">
            <c:choose>
                <c:when test="${empty services}">
                    <div class="card">
                        <p>No services are currently available. Check back later!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px;">
                        <c:forEach var="srv" items="${services}">
                            <div class="service-card">
                                <h3>${srv.title}</h3>
                                <p>${srv.description}</p>
                                <div class="service-meta">
                                    <span class="price">$${srv.price}</span> | Offered by: <strong>${srv.username}</strong>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
