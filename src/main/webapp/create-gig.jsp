<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillNest — Create a Gig</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=4.0">
    <style>
        body { min-height: 100vh; }
        .create-page { min-height: 100vh; display: flex; align-items: flex-start; justify-content: center; padding: 50px 20px 70px; gap: 30px; }

        /* FORM CARD */
        .form-card { width: 100%; max-width: 600px; padding: 42px 38px; }
        .back-link { color: var(--text-muted); text-decoration: none; font-size: 0.88rem; display: inline-block; margin-bottom: 22px; transition: color 0.2s; }
        .back-link:hover { color: white; }
        .form-title { font-size: 1.8rem; font-weight: 700; margin: 0 0 6px; }
        .form-subtitle { color: var(--text-muted); font-size: 0.92rem; margin: 0 0 32px; }

        .form-group { margin-bottom: 22px; }
        .form-group label { display: block; margin-bottom: 8px; font-size: 0.88rem; font-weight: 500; color: var(--text-muted); }
        .form-group label .req { color: var(--accent-pink); }
        .form-group .glass-input, .form-group .glass-select, .form-group .glass-textarea { width: 100%; box-sizing: border-box; }
        .glass-select { background: rgba(255,255,255,0.05); border: 1px solid var(--card-border); color: var(--text-main); padding: 11px 14px; border-radius: 8px; font-family: 'Outfit', sans-serif; font-size: 0.97rem; outline: none; transition: border-color 0.3s; }
        .glass-select:focus { border-color: var(--accent-purple); }
        .glass-select option { background: #1B1236; }
        .glass-textarea { background: rgba(255,255,255,0.05); border: 1px solid var(--card-border); color: var(--text-main); padding: 12px 14px; border-radius: 8px; font-family: 'Outfit', sans-serif; resize: vertical; outline: none; transition: border-color 0.3s; line-height: 1.6; font-size: 0.97rem; }
        .glass-textarea:focus { border-color: var(--accent-purple); }
        .char-row { display: flex; justify-content: space-between; font-size: 0.76rem; color: var(--text-muted); margin-top: 5px; }
        .hint { font-style: italic; }

        /* Price */
        .price-wrap { position: relative; }
        .dollar { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--accent-green); font-weight: 700; font-size: 1.05rem; pointer-events: none; }
        .price-wrap .glass-input { padding-left: 28px; }

        /* Step labels */
        .step-dots { display: flex; gap: 8px; margin-bottom: 28px; }
        .step-dot { width: 8px; height: 8px; border-radius: 50%; background: rgba(255,255,255,0.1); }
        .step-dot.done { background: var(--accent-purple); }
        .step-dot.active { background: var(--accent-cyan); width: 24px; border-radius: 4px; }

        /* Submit */
        .submit-row { display: flex; gap: 14px; margin-top: 32px; }
        .submit-row > * { flex: 1; text-align: center; padding: 14px; border-radius: 12px; font-size: 1rem; }

        .alert-error { padding: 12px 16px; border-radius: 10px; font-size: 0.9rem; margin-bottom: 20px; background: rgba(247,42,117,0.1); border: 1px solid rgba(247,42,117,0.25); color: #f472b6; }

        /* TIPS */
        .tips-col { width: 250px; flex-shrink: 0; position: sticky; top: 50px; }
        .tip-card { padding: 22px; margin-bottom: 16px; }
        .tip-card h4 { margin: 0 0 14px; font-size: 1rem; }
        .tip-item { display: flex; gap: 10px; margin-bottom: 11px; font-size: 0.83rem; color: var(--text-muted); line-height: 1.5; }
        .tip-item span { flex-shrink: 0; }
        .tip-item strong { color: var(--text-main); }

        .example-titles { margin-top: 8px; }
        .ex-title { font-size: 0.8rem; color: var(--text-muted); padding: 6px 10px; border-radius: 7px; background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); margin-bottom: 6px; cursor: pointer; transition: all 0.2s; }
        .ex-title:hover { border-color: rgba(139,92,246,0.3); color: white; background: rgba(139,92,246,0.07); }

        @media (max-width: 880px) {
            .create-page { flex-direction: column-reverse; align-items: center; }
            .tips-col { width: 100%; max-width: 600px; position: static; }
        }
        @media (max-width: 600px) {
            .create-page { padding: 20px 10px 40px; }
            .form-card { padding: 25px 20px; }
            .submit-row { flex-direction: column; }
        }
    </style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="create-page">

    <!-- ── FORM ─────────────────────────────────────────── -->
    <div class="glass-card form-card">
        <a href="gigs" class="back-link">← Back to Gigs</a>

        <!-- Progress dots -->
        <div class="step-dots">
            <div class="step-dot done"></div>
            <div class="step-dot active"></div>
            <div class="step-dot"></div>
        </div>

        <h1 class="form-title"><i class="fa-solid fa-rocket"></i> Create a Gig</h1>
        <p class="form-subtitle">Describe your skill so other students can find and hire you</p>

        <% if(request.getAttribute("error") != null) { %>
            <div class="alert-error"><i class="fa-solid fa-triangle-exclamation"></i> <%= request.getAttribute("error") %></div>
        <% } %>

        <form action="post" method="post" id="gigForm">
            <input type="hidden" name="postType" value="GIG">

            <!-- Category -->
            <div class="form-group">
                <label for="category">Category <span class="req">*</span></label>
                <select id="category" name="category" class="glass-select" required onchange="updateBanner()">
                    <option value="">— Choose your skill area —</option>
                    <option value="Coding"><i class="fa-solid fa-laptop-code"></i> Coding &amp; Development</option>
                    <option value="Design"><i class="fa-solid fa-palette"></i> Design &amp; Creative</option>
                    <option value="Writing"><i class="fa-solid fa-pen-nib"></i> Writing &amp; Content</option>
                    <option value="Engineering"><i class="fa-solid fa-wrench"></i> Engineering &amp; Tech</option>
                    <option value="Business"><i class="fa-solid fa-chart-pie"></i> Business &amp; Marketing</option>
                    <option value="Other"><i class="fa-solid fa-wand-magic-sparkles"></i> Other Skills</option>
                </select>
            </div>

            <!-- Gig Title -->
            <div class="form-group">
                <label for="title">Gig Title <span class="req">*</span></label>
                <input type="text" id="title" name="title" class="glass-input"
                       placeholder='e.g. "I will build a responsive React website for you"'
                       required maxlength="100"
                       oninput="cnt('title','tcnt',100)" autofocus>
                <div class="char-row">
                    <span class="hint">Start with "I will…" — be specific and clear</span>
                    <span><span id="tcnt">0</span>/100</span>
                </div>
            </div>

            <!-- Description -->
            <div class="form-group">
                <label for="description">Describe Your Gig <span class="req">*</span></label>
                <textarea id="description" name="description" class="glass-textarea" rows="7"
                          placeholder="Tell buyers:&#10;• What exactly you will do&#10;• What they will receive&#10;• Your experience &amp; tools&#10;• Estimated delivery time&#10;• Any requirements from them"
                          required maxlength="1000"
                          oninput="cnt('description','dcnt',1000)"></textarea>
                <div class="char-row">
                    <span class="hint">More detail = more bookings</span>
                    <span><span id="dcnt">0</span>/1000</span>
                </div>
            </div>

            <!-- Price -->
            <div class="form-group">
                <label for="price">Your Price (USD) <span class="req">*</span></label>
                <div class="price-wrap">
                    <span class="dollar">$</span>
                    <input type="number" id="price" name="price" class="glass-input"
                           step="1" min="1" max="9999" placeholder="25" required>
                </div>
                <div class="char-row">
                    <span class="hint"><i class="fa-solid fa-lightbulb"></i> $10–$50 gets the most bookings among students</span>
                </div>
            </div>

            <!-- Delivery time -->
            <div class="form-group">
                <label for="deliveryDays">Delivery Timeframe</label>
                <select id="deliveryDays" name="deliveryDays" class="glass-select">
                    <option value="1"><i class="fa-solid fa-bolt"></i> Within 1 Day</option>
                    <option value="2">2 Days</option>
                    <option value="3" selected>3 Days</option>
                    <option value="5">5 Days</option>
                    <option value="7">1 Week</option>
                    <option value="14">2 Weeks</option>
                    <option value="30">Up to 1 Month</option>
                </select>
            </div>

            <!-- Submit -->
            <div class="submit-row">
                <button type="submit" class="btn-solid" id="publishBtn"><i class="fa-solid fa-rocket"></i> Publish Gig</button>
                <a href="gigs" class="btn-neon" style="display:flex; align-items:center; justify-content:center; text-decoration:none;">Cancel</a>
            </div>
        </form>
    </div>

    <!-- ── TIPS ────────────────────────────────────────── -->
    <aside class="tips-col">

        <div class="glass-card tip-card">
            <h4><i class="fa-solid fa-lightbulb"></i> Writing a Great Gig</h4>
            <div class="tip-item"><span><i class="fa-solid fa-file-signature"></i></span> <div><strong>Specific title.</strong> "I will build a React todo app" beats "I will do coding"</div></div>
            <div class="tip-item"><span><i class="fa-solid fa-bullseye"></i></span> <div><strong>Clear deliverables.</strong> List exactly what the buyer gets — file types, number of revisions, etc.</div></div>
            <div class="tip-item"><span><i class="fa-solid fa-sack-dollar"></i></span> <div><strong>Competitive price.</strong> Start lower to get first reviews, then raise it.</div></div>
            <div class="tip-item"><span><i class="fa-solid fa-stopwatch"></i></span> <div><strong>Honest deadlines.</strong> Delivering early earns 5-star reviews.</div></div>
        </div>

        <div class="glass-card tip-card">
            <h4><i class="fa-solid fa-clipboard-list"></i> Title Examples</h4>
            <div class="example-titles">
                <div class="ex-title" onclick="useTitle(this)">I will build a responsive website using HTML, CSS &amp; JS</div>
                <div class="ex-title" onclick="useTitle(this)">I will design a modern logo for your startup</div>
                <div class="ex-title" onclick="useTitle(this)">I will write and edit your college essay</div>
                <div class="ex-title" onclick="useTitle(this)">I will create a Python script to automate your task</div>
                <div class="ex-title" onclick="useTitle(this)">I will tutor you in Data Structures and Algorithms</div>
            </div>
        </div>

        <div class="glass-card tip-card" style="background: linear-gradient(135deg, rgba(6,182,212,0.08), rgba(139,92,246,0.06));">
            <h4><i class="fa-solid fa-bolt"></i> Earn XP Too!</h4>
            <div style="font-size:0.83rem; color:var(--text-muted); line-height:1.75;">
                Creating a gig earns <strong style="color:var(--accent-cyan);">+20 XP</strong><br>
                Getting your first booking earns <strong style="color:var(--accent-cyan);">+50 XP</strong><br>
                Getting a 5-star review earns <strong style="color:var(--accent-cyan);">+30 XP</strong>
            </div>
        </div>

    </aside>
</div>

<script>
    function cnt(fieldId, countId, max) {
        document.getElementById(countId).textContent = document.getElementById(fieldId).value.length;
    }
    function useTitle(el) {
        document.getElementById('title').value = el.textContent.trim();
        cnt('title', 'tcnt', 100);
        document.getElementById('title').focus();
    }
    document.getElementById('gigForm').addEventListener('submit', function() {
        var btn = document.getElementById('publishBtn');
        btn.textContent = '⏳ Publishing…';
        btn.disabled = true;
    });
</script>
</body>
</html>
