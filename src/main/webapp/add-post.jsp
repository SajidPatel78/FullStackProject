<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillNest - Create a Listing</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=4.0">
    <style>
        body { min-height: 100vh; }
        .create-page {
            min-height: 100vh;
            display: flex;
            align-items: flex-start;
            justify-content: center;
            padding: 50px 20px 60px;
            gap: 30px;
        }

        /* ── TYPE SELECTOR ────────────────────── */
        .type-selector {
            display: flex; gap: 14px; margin-bottom: 28px;
        }
        .type-btn {
            flex: 1; padding: 16px 12px; border-radius: 14px; text-align: center; cursor: pointer;
            border: 2px solid rgba(255,255,255,0.08);
            background: rgba(255,255,255,0.03);
            transition: all 0.3s ease;
            position: relative; overflow: hidden;
            user-select: none;
        }
        .type-btn.selected {
            border-color: var(--accent-purple);
            background: rgba(139,92,246,0.1);
            box-shadow: 0 0 18px rgba(139,92,246,0.2);
        }
        .type-btn input[type="radio"] { display: none; }
        .type-icon { font-size: 1.8rem; margin-bottom: 6px; }
        .type-label { font-weight: 600; font-size: 0.95rem; margin-bottom: 4px; }
        .type-sub { font-size: 0.78rem; color: var(--text-muted); line-height: 1.4; }

        /* ── MAIN FORM CARD ──────────────────── */
        .form-card {
            width: 100%; max-width: 620px; padding: 40px 36px;
        }
        .form-card h1 {
            margin: 0 0 6px; font-size: 1.7rem; font-weight: 700;
        }
        .form-card .subtitle {
            color: var(--text-muted); font-size: 0.9rem; margin-bottom: 30px;
        }

        .form-group { margin-bottom: 22px; }
        .form-group label {
            display: block; margin-bottom: 8px; font-size: 0.88rem;
            font-weight: 500; color: var(--text-muted);
        }
        .form-group label span { color: var(--accent-pink); }
        .form-group .glass-input,
        .form-group .glass-select,
        .form-group .glass-textarea {
            width: 100%; box-sizing: border-box; font-size: 0.97rem;
        }
        .glass-select {
            background: rgba(255,255,255,0.05); border: 1px solid var(--card-border);
            color: var(--text-main); padding: 11px 14px; border-radius: 8px;
            font-family: 'Outfit', sans-serif; outline: none; transition: border-color 0.3s;
        }
        .glass-select:focus { border-color: var(--accent-purple); }
        .glass-select option { background: #1B1236; }
        .glass-textarea {
            background: rgba(255,255,255,0.05); border: 1px solid var(--card-border);
            color: var(--text-main); padding: 12px 14px; border-radius: 8px;
            font-family: 'Outfit', sans-serif; resize: vertical; outline: none;
            transition: border-color 0.3s; line-height: 1.6;
        }
        .glass-textarea:focus { border-color: var(--accent-purple); box-shadow: 0 0 10px rgba(139,92,246,0.15); }

        /* Char counter */
        .field-meta { display: flex; justify-content: space-between; margin-top: 5px; font-size: 0.78rem; color: var(--text-muted); }
        .hint { color: var(--text-muted); font-size: 0.8rem; font-style: italic; }

        /* Price section */
        .price-wrapper { position: relative; }
        .price-prefix {
            position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
            color: var(--accent-green); font-weight: 700; font-size: 1.1rem; pointer-events: none;
        }
        .price-wrapper .glass-input { padding-left: 30px; }

        /* Tips sidebar */
        .tips-sidebar {
            width: 260px; flex-shrink: 0; position: sticky; top: 50px;
        }
        .tip-card { padding: 22px; margin-bottom: 16px; }
        .tip-card h3 { margin: 0 0 14px; font-size: 1rem; font-weight: 600; }
        .tip-item { display: flex; gap: 10px; margin-bottom: 12px; }
        .tip-icon { font-size: 1.1rem; flex-shrink: 0; }
        .tip-text { font-size: 0.84rem; color: var(--text-muted); line-height: 1.5; }
        .tip-text strong { color: var(--text-main); }

        /* Category icons */
        .category-icons { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
        .cat-icon-btn {
            padding: 10px; border-radius: 10px; text-align: center; cursor: pointer;
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(255,255,255,0.03);
            transition: all 0.25s; font-size: 0.82rem;
        }
        .cat-icon-btn:hover { border-color: var(--accent-purple); background: rgba(139,92,246,0.1); }

        /* Action row */
        .action-row { display: flex; gap: 14px; margin-top: 32px; }
        .action-row > * { flex: 1; text-align: center; padding: 14px; font-size: 1rem; border-radius: 12px; }

        .alert-error {
            padding: 12px 16px; border-radius: 10px; font-size: 0.9rem; margin-bottom: 22px;
            background: rgba(247,42,117,0.1); border: 1px solid rgba(247,42,117,0.25); color: #f472b6;
        }

        @media (max-width: 900px) {
            .create-page { flex-direction: column-reverse; align-items: center; }
            .tips-sidebar { width: 100%; max-width: 620px; position: static; }
        }
    </style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="create-page">

    <!-- ── MAIN FORM ─────────────────────────────── -->
    <div class="glass-card form-card">

        <div style="margin-bottom: 20px;">
            <a href="services" style="color:var(--text-muted); text-decoration:none; font-size:0.9rem;">← Back to Marketplace</a>
        </div>

        <h1>📦 Create a Listing</h1>
        <p class="subtitle">Share your skills or study materials with the SkillNest community</p>

        <% if(request.getAttribute("error") != null) { %>
            <div class="alert-error"><i class="fa-solid fa-triangle-exclamation"></i> <%= request.getAttribute("error") %></div>
        <% } %>

        <!-- Type Selector -->
        <div class="type-selector" id="typeSelector">
            <label class="type-btn selected" id="btn-service" onclick="selectType('GIG', this)">
                <input type="radio" name="postType" value="GIG" checked>
                <div class="type-icon"><i class="fa-solid fa-briefcase"></i></div>
                <div class="type-label">Freelance Service</div>
                <div class="type-sub">Offer your skill & earn money</div>
            </label>
            <label class="type-btn" id="btn-notes" onclick="selectType('NOTES', this)">
                <input type="radio" name="postType" value="NOTES">
                <div class="type-icon"><i class="fa-solid fa-book-open"></i></div>
                <div class="type-label">Notes / Resources</div>
                <div class="type-sub">Share knowledge with students</div>
            </label>
        </div>

        <form action="post" method="post" id="createForm">
            <input type="hidden" name="postType" id="postTypeHidden" value="GIG">

            <!-- Category -->
            <div class="form-group">
                <label for="category">Category <span>*</span></label>
                <select id="category" name="category" class="glass-select" required>
                    <option value="">— Select a category —</option>
                    <option value="Coding"><i class="fa-solid fa-laptop-code"></i> Coding &amp; Development</option>
                    <option value="Design"><i class="fa-solid fa-palette"></i> Design &amp; Graphics</option>
                    <option value="Writing"><i class="fa-solid fa-pen-nib"></i> Writing &amp; Translation</option>
                    <option value="Engineering"><i class="fa-solid fa-wrench"></i> Engineering &amp; Tech</option>
                    <option value="Business"><i class="fa-solid fa-chart-pie"></i> Business &amp; Management</option>
                    <option value="Other"><i class="fa-solid fa-wand-magic-sparkles"></i> Other</option>
                </select>
            </div>

            <!-- Title -->
            <div class="form-group">
                <label for="title">Title <span>*</span></label>
                <input type="text" id="title" name="title" class="glass-input"
                       placeholder="e.g. I will build a responsive React website for you"
                       required maxlength="100" oninput="updateCounter('title', 'titleCount', 100)">
                <div class="field-meta">
                    <span class="hint">Start with "I will…" for best results</span>
                    <span><span id="titleCount">0</span>/100</span>
                </div>
            </div>

            <!-- Description -->
            <div class="form-group">
                <label for="description">Description <span>*</span></label>
                <textarea id="description" name="description" rows="6" class="glass-textarea"
                          placeholder="Describe exactly what you offer, what the client will receive, your experience, and your timeline…"
                          required maxlength="1000" oninput="updateCounter('description', 'descCount', 1000)"></textarea>
                <div class="field-meta">
                    <span class="hint">Be specific — better descriptions get more bookings</span>
                    <span><span id="descCount">0</span>/1000</span>
                </div>
            </div>

            <!-- Price (service only) -->
            <div class="form-group" id="priceGroup">
                <label for="price">Price (USD) <span>*</span></label>
                <div class="price-wrapper">
                    <span class="price-prefix">$</span>
                    <input type="number" id="price" name="price" step="0.01" min="1" max="9999"
                           class="glass-input" placeholder="25.00" required>
                </div>
                <div class="field-meta">
                    <span class="hint">Student pricing: $5–$200 works best for quick bookings</span>
                </div>
            </div>

            <!-- Delivery time (service only) -->
            <div class="form-group" id="deliveryGroup">
                <label for="deliveryDays">Estimated Delivery</label>
                <select id="deliveryDays" name="deliveryDays" class="glass-select">
                    <option value="1"><i class="fa-solid fa-bolt"></i> 1 Day</option>
                    <option value="2">2 Days</option>
                    <option value="3" selected>3 Days</option>
                    <option value="5">5 Days</option>
                    <option value="7">1 Week</option>
                    <option value="14">2 Weeks</option>
                    <option value="30">1 Month</option>
                </select>
            </div>

            <div class="action-row">
                <button type="submit" class="btn-solid" id="submitBtn"><i class="fa-solid fa-rocket"></i> Publish Listing</button>
                <a href="services" class="btn-neon" style="display:flex; align-items:center; justify-content:center; text-decoration:none;">Cancel</a>
            </div>
        </form>
    </div><!-- /.form-card -->

    <!-- ── TIPS SIDEBAR ───────────────────────────── -->
    <aside class="tips-sidebar">

        <div class="glass-card tip-card">
            <h3><i class="fa-solid fa-lightbulb"></i> Tips for Getting Hired</h3>
            <div class="tip-item">
                <span class="tip-icon"><i class="fa-solid fa-file-signature"></i></span>
                <div class="tip-text"><strong>Write a clear title.</strong> Start with "I will…" and be specific about what you deliver.</div>
            </div>
            <div class="tip-item">
                <span class="tip-icon"><i class="fa-solid fa-sack-dollar"></i></span>
                <div class="tip-text"><strong>Price competitively.</strong> Student budgets are tight. $15–$50 tends to get the most bookings.</div>
            </div>
            <div class="tip-item">
                <span class="tip-icon"><i class="fa-solid fa-stopwatch"></i></span>
                <div class="tip-text"><strong>Set realistic timelines.</strong> It's better to deliver early than to miss a deadline.</div>
            </div>
            <div class="tip-item">
                <span class="tip-icon">🌟</span>
                <div class="tip-text"><strong>Describe your skills.</strong> Mention technologies, tools, or languages you use — buyers search for these.</div>
            </div>
        </div>

        <div class="glass-card tip-card" style="background: linear-gradient(135deg, rgba(6,182,212,0.08), rgba(139,92,246,0.06));">
            <h3><i class="fa-solid fa-trophy"></i> Earn XP Too!</h3>
            <div style="font-size:0.85rem; color:var(--text-muted); line-height:1.7;">
                Every service you post earns you <span style="color:var(--accent-cyan); font-weight:700;">+20 XP</span>.<br>
                Getting booked earns <span style="color:var(--accent-cyan); font-weight:700;">+50 XP</span>.<br>
                Completing daily challenges can earn up to <span style="color:var(--accent-cyan); font-weight:700;">+100 XP</span>.
                <br><br>
                <a href="challenges" style="color:var(--accent-purple); font-weight:600; text-decoration:none;">View today's challenge →</a>
            </div>
        </div>

        <div class="glass-card tip-card">
            <h3>📂 Popular Categories</h3>
            <div class="category-icons">
                <div class="cat-icon-btn" onclick="document.getElementById('category').value='Coding'"><i class="fa-solid fa-laptop-code"></i> Coding</div>
                <div class="cat-icon-btn" onclick="document.getElementById('category').value='Design'"><i class="fa-solid fa-palette"></i> Design</div>
                <div class="cat-icon-btn" onclick="document.getElementById('category').value='Writing'"><i class="fa-solid fa-pen-nib"></i> Writing</div>
                <div class="cat-icon-btn" onclick="document.getElementById('category').value='Engineering'"><i class="fa-solid fa-wrench"></i> Engineering</div>
            </div>
        </div>

    </aside>

</div><!-- /.create-page -->

<script>
    // Type toggle
    function selectType(type, clickedBtn) {
        document.getElementById('postTypeHidden').value = type;
        document.querySelectorAll('.type-btn').forEach(function(b) { b.classList.remove('selected'); });
        clickedBtn.classList.add('selected');

        var isService = (type === 'GIG');
        document.getElementById('priceGroup').style.display    = isService ? 'block' : 'none';
        document.getElementById('deliveryGroup').style.display = isService ? 'block' : 'none';
        document.getElementById('price').required = isService;

        var btn = document.getElementById('submitBtn');
        btn.textContent = isService ? '<i class="fa-solid fa-rocket"></i> Publish Listing' : '<i class="fa-solid fa-book-open"></i> Share Notes';
    }

    // Character counter
    function updateCounter(inputId, countId, max) {
        var len = document.getElementById(inputId).value.length;
        document.getElementById(countId).textContent = len;
    }

    // Animate submit
    document.getElementById('createForm').addEventListener('submit', function() {
        var btn = document.getElementById('submitBtn');
        btn.textContent = '⏳ Publishing…';
        btn.disabled = true;
    });
</script>
</body>
</html>
