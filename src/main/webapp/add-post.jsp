<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Create Post</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8f9fa; margin: 0; padding: 0; }
        .hero-nav { background: #131A22; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; color: white; }
        .hero-nav h1 { margin: 0; font-size: 1.5em; color: white; display: flex; align-items: center;}
        .nav-links a { color: #fff; text-decoration: none; margin-left: 20px; font-weight: 500; font-size: 0.9em; opacity: 0.9; }
        .nav-links a:hover { opacity: 1; text-decoration: underline; }
        .post-btn { background-color: #F72A75; color: white; padding: 8px 16px; border-radius: 4px; font-weight: bold; text-decoration: none; border: none; font-size: 0.9em; margin-left: 20px; cursor: pointer; transition: background 0.2s;}
        .post-btn:hover { background-color: #e02065; text-decoration: none;}
        
        .form-container { max-width: 600px; margin: 50px auto; }
        .form-card { background: #fff; padding: 40px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); border: 1px solid #eaeaea; }
        .form-card h2 { margin-top: 0; color: #111827; font-size: 1.8em; margin-bottom: 25px; }
        
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #374151; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 12px; border: 1px solid #d1d5db; border-radius: 6px; font-family: 'Inter', sans-serif; font-size: 1em; box-sizing: border-box; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { outline: none; border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
        
        .btn-primary { background-color: #F72A75; color: white; padding: 12px 20px; border-radius: 6px; font-weight: 600; text-decoration: none; border: none; font-size: 1em; cursor: pointer; transition: 0.2s; flex: 1; text-align: center; }
        .btn-primary:hover { background-color: #e02065; }
        .btn-secondary { background-color: #f3f4f6; color: #374151; padding: 12px 20px; border-radius: 6px; font-weight: 600; text-decoration: none; border: 1px solid #d1d5db; font-size: 1em; cursor: pointer; transition: 0.2s; flex: 1; text-align: center; }
        .btn-secondary:hover { background-color: #e5e7eb; }
    </style>
    <script>
        function togglePriceField() {
            var postType = document.getElementById("postType").value;
            var priceGroup = document.getElementById("priceGroup");
            var priceInput = document.getElementById("price");
            
            if (postType === "SERVICE") {
                priceGroup.style.display = "block";
                priceInput.required = true;
            } else {
                priceGroup.style.display = "none";
                priceInput.required = false;
                priceInput.value = "";
            }
        }
    </script>
</head>
<body>
    <header class="hero-nav">
        <h1>SkillNest</h1>
        <div class="nav-links">
            <a href="feed">Feed</a>
            <a href="services">Services Only</a>
            <a href="profile">Profile</a>
            <a href="logout">Logout</a>
            <a href="add-post.jsp" class="post-btn">Post a Service / Content</a>
        </div>
    </header>
    
    <div class="form-container">
        <div class="form-card">
            <h2>Post a Project or Service</h2>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="error-msg" style="color: #ef4444; margin-bottom: 20px; font-weight: 500;"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <form action="post" method="post">
                <div class="form-group">
                    <label for="postType">What do you want to post?</label>
                    <select id="postType" name="postType" required onchange="togglePriceField()">
                        <option value="SERVICE">A Service (Offer Freelance Work)</option>
                        <option value="NOTES">Notes / Study Material</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="category">Category</label>
                    <select id="category" name="category" required>
                        <option value="Coding">Coding & Development</option>
                        <option value="Design">Design & Graphics</option>
                        <option value="Writing">Writing & Translation</option>
                        <option value="Engineering">Engineering & Tech</option>
                        <option value="Business">Business & Management</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="title">Title of your Post</label>
                    <input type="text" id="title" name="title" placeholder="e.g. I will build a responsive website" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Detailed Description</label>
                    <textarea id="description" name="description" rows="5" placeholder="Describe what you are offering or sharing..." required></textarea>
                </div>
                
                <div class="form-group" id="priceGroup">
                    <label for="price">Price ($ USD)</label>
                    <input type="number" id="price" name="price" step="0.01" min="0" placeholder="e.g. 50.00" required>
                </div>
                
                <div style="display: flex; gap: 15px; margin-top: 30px;">
                    <button type="submit" class="btn-primary">Publish Post</button>
                    <a href="profile" class="btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
