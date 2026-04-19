<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Create Post</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=3.0">
    <style>
        .form-page { display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 20px; }
        .form-card { width: 100%; max-width: 550px; padding: 40px; }
        .form-card h2 { margin-top: 0; text-align: center; font-size: 1.8rem; margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: var(--text-muted); font-weight: 500; font-size: 0.9rem; }
        .form-group select, .form-group textarea { width: 100%; box-sizing: border-box; }
        .glass-select { background: rgba(255,255,255,0.05); border: 1px solid var(--card-border); color: var(--text-main); padding: 10px 16px; border-radius: 8px; font-family: 'Outfit', sans-serif; font-size: 1rem; outline: none; transition: border-color 0.3s; }
        .glass-select:focus { border-color: var(--accent-purple); }
        .glass-select option { background: #1B1236; color: white; }
        .glass-textarea { background: rgba(255,255,255,0.05); border: 1px solid var(--card-border); color: var(--text-main); padding: 12px 16px; border-radius: 8px; font-family: 'Outfit', sans-serif; font-size: 1rem; outline: none; resize: vertical; transition: border-color 0.3s; width: 100%; box-sizing: border-box; }
        .glass-textarea:focus { border-color: var(--accent-purple); box-shadow: 0 0 10px var(--glow-pink); }
        .btn-row { display: flex; gap: 15px; margin-top: 30px; }
        .btn-row > * { flex: 1; text-align: center; }
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
    <div class="form-page">
        <div class="glass-card form-card">
            <div style="text-align: center; margin-bottom: 15px;">
                <span class="logo-icon">☄️</span> <span style="font-size: 1.3rem; font-weight: bold;">SkillNest</span>
            </div>
            <h2>Post a Project or Service</h2>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="badge badge-pink" style="display:block; text-align:center; padding: 10px; margin-bottom:20px;"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <form action="post" method="post">
                <div class="form-group">
                    <label for="postType">What do you want to post?</label>
                    <select id="postType" name="postType" class="glass-select" required onchange="togglePriceField()" style="width:100%;">
                        <option value="SERVICE">A Service (Offer Freelance Work)</option>
                        <option value="NOTES">Notes / Study Material</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="category">Category</label>
                    <select id="category" name="category" class="glass-select" required style="width:100%;">
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
                    <input type="text" id="title" name="title" class="glass-input" placeholder="e.g. I will build a responsive website" required style="width:100%; box-sizing:border-box;">
                </div>
                
                <div class="form-group">
                    <label for="description">Detailed Description</label>
                    <textarea id="description" name="description" rows="5" class="glass-textarea" placeholder="Describe what you are offering or sharing..." required></textarea>
                </div>
                
                <div class="form-group" id="priceGroup">
                    <label for="price">Price ($ USD)</label>
                    <input type="number" id="price" name="price" step="0.01" min="0" class="glass-input" placeholder="e.g. 50.00" required style="width:100%; box-sizing:border-box;">
                </div>
                
                <div class="btn-row">
                    <button type="submit" class="btn-solid">🚀 Publish Post</button>
                    <a href="feed" class="btn-neon" style="display:flex; align-items:center; justify-content:center; text-decoration:none;">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
