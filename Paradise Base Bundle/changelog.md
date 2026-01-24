<meta charset="utf-8">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&family=Roboto+Mono:wght@300;500&display=swap" rel="stylesheet">

<style>
/* ===== Project Paradise HTML/CSS Logo ===== */
.pp-logo{
  width: 260px;  /* wider for full text */
  height: 140px;
  border-radius: 16px;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
  padding: 12px 20px;

   /* Neon gradient frame */
  background:
    linear-gradient(145deg, rgba(153,50,204,.6), rgba(255,204,0,.3)) padding-box,
    linear-gradient(145deg, #ff5ea3, #ffd700, #66e0ff, #ff5ea3) border-box;
  border: 3px solid transparent;
  box-shadow:
    0 0 20px rgba(153,50,204,.6),
    0 0 35px rgba(255,204,0,.4);
  overflow: hidden;
}

/* Striped synthwave "sun" inside the badge */
.pp-logo::before{
  content: "";
  position: absolute;
  inset: 18% 18% 42% 18%;             /* top portion of the circle */
  border-radius: 50%;
  background:
    radial-gradient(circle at 50% 30%, rgba(255,255,255,.25), transparent 55%),
    repeating-linear-gradient(
      to bottom,
      rgba(255, 215, 0, .9) 0 2px,
      rgba(255, 170, 0, .85) 2px 6px,
      transparent 6px 10px
    );
  mix-blend-mode: screen;
  opacity: .9;
  filter: blur(.2px);
}

/* Ground/horizon glow */
.pp-logo::after{
  content: "";
  position: absolute;
  left: -10%; right: -10%;
  bottom: 15%;
  height: 20%;
  border-radius: 50%;
  background: radial-gradient(60% 80% at 50% 0%, rgba(153,50,204,.45), rgba(0,0,0,0) 70%);
  filter: blur(6px);
}

.pp-text{
  font-family: 'Orbitron', sans-serif;
  font-size: 500px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 2px;
  text-align: center;
  background: linear-gradient(180deg, #fff, #ffe27a 55%, #ff6fb3);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;

  /* neon glow */
  text-shadow:
    0 0 6px #ff5ea3,
    0 0 14px #ff5ea3,
    0 0 20px #ffd700,
    0 0 28px #ffd700;
}

@keyframes logoPulse {
  0%,100% { transform: scale(1); filter: brightness(1); }
  50%     { transform: scale(1.04); filter: brightness(1.1); }
}
.pp-logo{ animation: logoPulse 3.2s ease-in-out infinite; }

/* Accessibility: reduce motion if preferred */
@media (prefers-reduced-motion: reduce){
  .pp-logo{ animation: none; }
}

/* =================== CSS Loading Bar Stuff =================== */
#preloader{
  position:fixed; inset:0; z-index:9999;
  display:flex; flex-direction:column; align-items:center; justify-content:center;
  background: radial-gradient(circle at center, rgba(153,50,204,0.15), rgba(0,0,21,0.95));
  backdrop-filter: blur(2px);
  animation: preloaderHide 4.6s forwards; /* 4s bar + 0.6s pad */
}
#preloader .brand{
  font-family:'Orbitron',sans-serif; color:#e6d4ff;
  letter-spacing:4px; text-transform:uppercase; margin-bottom:18px;
  text-shadow:0 0 8px #9932cc, 0 0 16px #ffcc00;
}
#preloader .bar{
  width:min(520px,80vw); height:14px; border-radius:999px; overflow:hidden;
  background:rgba(230,212,255,.12);
  border:1px solid rgba(153,50,204,.45);
  box-shadow:0 0 20px rgba(153,50,204,.3) inset, 0 0 20px rgba(255,204,0,.15);
}
#preloader .bar-fill{
  height:100%; width:0%;
  background:linear-gradient(90deg,#9932cc,#ffcc00,#ffd700);
  box-shadow:0 0 10px #ffcc00, 0 0 18px #ffd700;
  animation: barFill 4s forwards; /* progress to 100% */
}
@keyframes barFill{ from{width:0%} to{width:100%} }
@keyframes preloaderHide{
  0%,87% { opacity:1; visibility:visible; }
  100%   { opacity:0; visibility:hidden; }
}
#preloader .pct{
  font: 600 14px/1 'Roboto Mono', monospace;
  color:#ffd700; text-shadow:0 0 8px #ffcc00;
  height:1em; /* avoid layout shift */
}
#preloader .pct::after{
  content:"0%";
  animation:pctText 4s steps(100,end) forwards; /* match barFill duration */
}
/* ?? 0?100% at 1% increments */
@keyframes pctText{
  0%{content:"0%"} 1%{content:"1%"} 2%{content:"2%"} 3%{content:"3%"} 4%{content:"4%"} 5%{content:"5%"}
  6%{content:"6%"} 7%{content:"7%"} 8%{content:"8%"} 9%{content:"9%"} 10%{content:"10%"}
  11%{content:"11%"} 12%{content:"12%"} 13%{content:"13%"} 14%{content:"14%"} 15%{content:"15%"}
  16%{content:"16%"} 17%{content:"17%"} 18%{content:"18%"} 19%{content:"19%"} 20%{content:"20%"}
  21%{content:"21%"} 22%{content:"22%"} 23%{content:"23%"} 24%{content:"24%"} 25%{content:"25%"}
  26%{content:"26%"} 27%{content:"27%"} 28%{content:"28%"} 29%{content:"29%"} 30%{content:"30%"}
  31%{content:"31%"} 32%{content:"32%"} 33%{content:"33%"} 34%{content:"34%"} 35%{content:"35%"}
  36%{content:"36%"} 37%{content:"37%"} 38%{content:"38%"} 39%{content:"39%"} 40%{content:"40%"}
  41%{content:"41%"} 42%{content:"42%"} 43%{content:"43%"} 44%{content:"44%"} 45%{content:"45%"}
  46%{content:"46%"} 47%{content:"47%"} 48%{content:"48%"} 49%{content:"49%"} 50%{content:"50%"}
  51%{content:"51%"} 52%{content:"52%"} 53%{content:"53%"} 54%{content:"54%"} 55%{content:"55%"}
  56%{content:"56%"} 57%{content:"57%"} 58%{content:"58%"} 59%{content:"59%"} 60%{content:"60%"}
  61%{content:"61%"} 62%{content:"62%"} 63%{content:"63%"} 64%{content:"64%"} 65%{content:"65%"}
  66%{content:"66%"} 67%{content:"67%"} 68%{content:"68%"} 69%{content:"69%"} 70%{content:"70%"}
  71%{content:"71%"} 72%{content:"72%"} 73%{content:"73%"} 74%{content:"74%"} 75%{content:"75%"}
  76%{content:"76%"} 77%{content:"77%"} 78%{content:"78%"} 79%{content:"79%"} 80%{content:"80%"}
  81%{content:"81%"} 82%{content:"82%"} 83%{content:"83%"} 84%{content:"84%"} 85%{content:"85%"}
  86%{content:"86%"} 87%{content:"87%"} 88%{content:"88%"} 89%{content:"89%"} 90%{content:"90%"}
  91%{content:"91%"} 92%{content:"92%"} 93%{content:"93%"} 94%{content:"94%"} 95%{content:"95%"}
  96%{content:"96%"} 97%{content:"97%"} 98%{content:"98%"} 99%{content:"99%"} 100%{content:"100%"}
}
/* Reveal the app after the same delay (no sibling selector required) */
#app{ opacity:0; }
@keyframes appShow{ to{opacity:1} }
#app{ animation: appShow 1s forwards; animation-delay: 4.6s; }

/* =================== YOUR ORIGINAL STYLES =================== */
body {
    background: #000015;
    font-size: 18px;
    color: #e6d4ff;
    font-family: 'Roboto Mono', monospace;
    margin: 0;
    padding: 0;
    text-align: center;
    min-height: 100vh;
    overflow: hidden;
    position: relative;
}
body::before {
    content: '';
    position: absolute;
    top: 0; left: 0; width: 100%; height: 100%;
    background: radial-gradient(circle at center, rgba(153, 50, 204, 0.15), transparent);
    z-index: -1;
}
body::after {
    content: '';
    position: absolute;
    top: 0; left: 0; width: 100%; height: 100%;
    background: url('data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 10 10"%3E%3Ccircle cx="5" cy="5" r="1" fill="rgba(153,50,204,0.2)" /%3E%3C/svg%3E');
    animation: particles 20s linear infinite;
    opacity: 0.3;
    z-index: -1;
}
@keyframes particles {
    0% { background-position: 0 0; }
    100% { background-position: 100px -100px; }
}
@keyframes scan-pulse {
    0% { transform: scale(1); text-shadow: 0 0 5px #9932cc, 0 0 10px #ffcc00; }
    50% { transform: scale(1.02); text-shadow: 0 0 10px #9932cc, 0 0 20px #ffcc00, 0 0 30px #ffd700; }
    100% { transform: scale(1); text-shadow: 0 0 5px #9932cc, 0 0 10px #ffcc00; }
}
h2 {
    font-family: 'Orbitron', sans-serif;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 5px;
    color: #9932cc;
    margin: 70px 0 30px;
    text-shadow: 0 0 5px #9932cc, 0 0 10px #ffcc00;
    animation: scan-pulse 3s infinite ease-in-out;
    position: relative;
    display: inline-block;
    z-index: 1;
}
h2::after {
    content: '';
    position: absolute;
    bottom: -8px; left: 50%; transform: translateX(-50%);
    width: 60%; height: 2px;
    background: linear-gradient(to right, #9932cc, #ffcc00, #ffd700);
    transition: width 0.4s ease;
}
h2:hover::after { width: 100%; }
.card {
    background: linear-gradient(135deg, rgba(30, 15, 50, 0.8), rgba(50, 15, 50, 0.8));
    border-radius: 12px;
    padding: 30px;
    margin: 25px auto;
    max-width: 820px;
    text-align: left;
    border: 1px solid rgba(153, 50, 204, 0.5);
    box-shadow: 0 0 15px rgba(153, 50, 204, 0.3), inset 0 0 10px rgba(255, 204, 0, 0.2);
    transition: all 0.5s ease;
    position: relative;
    transform: perspective(1000px);
    backdrop-filter: blur(5px);
}
.card:hover {
    transform: perspective(1000px) rotateX(3deg) rotateY(3deg);
    box-shadow: 0 0 30px rgba(153, 50, 204, 0.6), inset 0 0 15px rgba(255, 204, 0, 0.4);
}
.card::before {
    content: '';
    position: absolute; top: 0; left: 0; width: 100%; height: 100%;
    background: linear-gradient(45deg, transparent, rgba(255, 204, 0, 0.3), transparent);
    opacity: 0; transition: opacity 0.5s ease;
}
.card:hover::before { opacity: 1; }
.card.features { border-color: #9932cc; }
.card.features:hover { box-shadow: 0 0 30px #9932cc, inset 0 0 15px #9932cc; }
.card.games { border-color: #800080; }
.card.games:hover { box-shadow: 0 0 30px #800080, inset 0 0 15px #800080; }
.card.updates { border-color: #ba55d3; }
.card.updates:hover { box-shadow: 0 0 30px #ba55d3, inset 0 0 15px #ba55d3; }
.card.coming { border-color: #ffcc00; }
.card.coming:hover { box-shadow: 0 0 30px #ffcc00, inset 0 0 15px #ffcc00; }
.card.credits { border-color: #e6d4ff; }
.card.credits:hover { box-shadow: 0 0 30px #e6d4ff, inset 0 0 15px #e6d4ff; }
@keyframes holo-glow {
    0% { box-shadow: 0 0 15px currentColor; }
    50% { box-shadow: 0 0 25px currentColor, inset 0 0 15px currentColor; }
    100% { box-shadow: 0 0 15px currentColor; }
}
.card:hover { animation: holo-glow 2s infinite ease-in-out; }
.scrollbar {
    height: 100%;
    width: 100%;
    overflow-y: auto;
    overflow-x: hidden;
}
#style-1::-webkit-scrollbar { width: 8px; background-color: #000015; }
#style-1::-webkit-scrollbar-thumb { border-radius: 4px; background: linear-gradient(45deg, #9932cc, #ffcc00); }
#style-1::-webkit-scrollbar-track { background: rgba(0, 0, 21, 0.8); }
.links { margin: 60px 0; }
.links a {
    color: #9932cc; font-weight: 500; text-decoration: none; margin: 0 25px;
    text-shadow: 0 0 5px #9932cc; transition: all 0.4s ease;
}
.links a:hover { color: #ffcc00; text-shadow: 0 0 10px #ffcc00, 0 0 20px #ffd700; }
.youtube-thumbnail { display: inline-block; margin: 25px; position: relative; transition: all 0.4s ease; }
.youtube-thumbnail img { border-radius: 10px; border: 3px solid #9932cc; box-shadow: 0 0 15px #9932cc; filter: brightness(1.1); }
.youtube-thumbnail::after {
    content: '?'; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
    font-size: 40px; color: #ffcc00; text-shadow: 0 0 10px #ffcc00; opacity: 0.7; transition: all 0.4s ease;
}
.youtube-thumbnail:hover { transform: scale(1.07); }
.youtube-thumbnail:hover::after { opacity: 1; transform: translate(-50%, -50%) scale(1.2); }
</style>

<body>
  <!-- === PRELOADER (no JS) === -->
  <div id="preloader" aria-live="polite" aria-label="Loading">
    <div class="pp-logo" aria-hidden="true">
      <span class="pp-initials">Project Paradise</span>
    </div>
    <div class="brand">Loading Paradise</div>
    <div class="bar"><div class="bar-fill"></div></div>
    <div class="pct"></div>
  </div>

  <!-- === YOUR PAGE CONTENT WRAPPED IN #app === -->
  <div id="app">
    <div class="scrollbar" id="style-1">
      <div class="content">

        <h2>Features</h2>
        <div class="card features">
            <ul>
                <li>Loads on FFA/SnD</li>
                <li>Wallbang Everything</li>
                <li>Binds</li>
                <li>Meters</li>
                <li>+ More!</li>
            </ul>
        </div>

        <h2>Supported Games</h2>
        <div class="card games">
            <ul>
                <li>World at War</li>
                <li>Modern Warfare 2</li>
                <li>Black Ops 1</li>
                <li>Modern Warfare 3</li>
                <li>Black Ops 2</li>
                <li>Modern Warfare: Remastered</li>
            </ul>
        </div>

        <h2>Updates</h2>
        <div class="card updates">
            <ul>
                <li>New Design</li>
                <li>More Stable</li>
                <li>More Features</li>
            </ul>
        </div>

        <h2>Coming Soon</h2>
        <div class="card coming">
            <ul>
                <li>Modern Warfare</li>
                <li>Ghosts</li>
                <li>BO3</li>
            </ul>
        </div>

        <h2>Credits</h2>
        <div class="card credits">
            <ul>
                <li><b>tgh:</b> Co-Dev, lead the project while I was away, has been a huge help from the beginning.</li>
                <li><b>Optus IV:</b> Co-Dev, has helped fix so many issues and has added a lot of really nice features.</li>
                <li><b>CF4_99:</b> Has helped so much with coding errors / fixed a lot of issues we were running into and has been an amazing help with everything I was getting stuck on.</li>
                <li><b>XeSoftware (Rain):</b> Ported the Subversion v2.1 menu from BO3 to MW2 (Zenith) and is what we used for our base, also some functions and helping with issues</li>
            </ul>
        </div>

        <div class="links">
            <a href="https://www.youtube.com/watch?v=iSUObSdM9d4" target="_blank" class="youtube-thumbnail">
                <img src="https://img.youtube.com/vi/iSUObSdM9d4/maxresdefault.jpg" alt="YouTube Video Thumbnail" width="320" height="180">
            </a>
            <a href="https://discord.com/invite/qbpnQfbVqY" target="_blank">Discord</a>
        </div>

      </div>
    </div>
  </div>
</body>
