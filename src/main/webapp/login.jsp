<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Cravix — Login</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<style>
  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  :root {
    --bg: #f7f3e8;
    --cream: #efeadb;
    --olive: #6b7f2c;
    --olive-dark: #556720;
    --yellow: #e8b530;
    --orange: #f2a63a;
    --brown: #3d2a1a;
    --muted: #7a6f5f;
    --white: #ffffff;
    --border: #ece7d8;
    --danger-bg: #fff1f1;
    --danger-border: #f3c5c5;
    --danger-text: #b33a3a;
  }

  html, body {
    min-height: 100%;
  }

  body {
    font-family: 'Poppins', system-ui, sans-serif;
    background: var(--bg);
    color: var(--brown);
    min-height: 100vh;
    overflow-x: hidden;
    position: relative;
  }

  .shape {
    position: absolute;
    z-index: 0;
    pointer-events: none;
  }

  .shape-cream {
    top: 110px;
    left: -120px;
    width: 620px;
    height: 620px;
    background: var(--cream);
    border-radius: 50%;
  }

  .shape-olive {
    bottom: -140px;
    left: -80px;
    width: 420px;
    height: 320px;
    background: var(--olive);
    border-radius: 50% 50% 45% 55% / 60% 55% 45% 40%;
    opacity: .95;
  }

  .dots-grid {
    position: absolute;
    top: 145px;
    left: 46%;
    z-index: 1;
    display: grid;
    grid-template-columns: repeat(6, 6px);
    gap: 10px;
  }

  .dots-grid span,
  .dots-corner span {
    width: 6px;
    height: 6px;
    background: var(--yellow);
    border-radius: 50%;
  }

  .dots-corner {
    position: absolute;
    bottom: 32px;
    right: 40px;
    z-index: 1;
    display: grid;
    grid-template-columns: repeat(8, 6px);
    gap: 10px;
  }

  .dots-corner span {
    opacity: .8;
  }

  .leaf {
    position: absolute;
    left: 18px;
    bottom: 190px;
    width: 110px;
    height: 160px;
    background: #d9dcc0;
    border-radius: 0 100% 0 100%;
    transform: rotate(-25deg);
    opacity: .55;
    z-index: 1;
  }

  .header {
    position: relative;
    z-index: 5;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 24px 56px;
  }

  .logo {
    display: flex;
    align-items: center;
    text-decoration: none;
  }

  .logo img {
    height: 74px;
    width: auto;
    display: block;
    object-fit: contain;
  }

  .signup-top {
    color: var(--muted);
    font-size: 15px;
  }

  .signup-top a {
    color: var(--olive-dark);
    font-weight: 600;
    text-decoration: none;
    margin-left: 6px;
  }

  .signup-top a:hover {
    text-decoration: underline;
  }

  .container {
    position: relative;
    z-index: 3;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 42px;
    max-width: 1380px;
    margin: 10px auto 0;
    padding: 10px 56px 48px;
    align-items: center;
  }

  .left {
    position: relative;
    padding: 20px 20px 20px 40px;
  }

  .headline {
    font-size: 56px;
    font-weight: 700;
    line-height: 1.05;
    letter-spacing: -1px;
  }

  .headline .green {
    color: var(--olive-dark);
    display: block;
  }

  .accent-line {
    width: 80px;
    height: 4px;
    background: var(--yellow);
    border-radius: 2px;
    margin: 22px 0 22px;
  }

  .tagline {
    color: var(--brown);
    font-size: 16px;
    line-height: 1.7;
    max-width: 340px;
  }

  .bowl-wrap {
    margin-top: 34px;
    position: relative;
    max-width: 440px;
  }

  .blob-orange {
    position: absolute;
    top: -26px;
    left: 36px;
    width: 200px;
    height: 130px;
    background: var(--orange);
    border-radius: 60% 40% 55% 45% / 55% 60% 40% 45%;
    z-index: 0;
  }

  .sparks {
    position: absolute;
    top: -8px;
    right: 42px;
    color: var(--orange);
    font-size: 28px;
    z-index: 2;
    line-height: 1;
  }

  .bowl {
    position: relative;
    z-index: 1;
    width: 100%;
    border-radius: 50%;
    display: block;
    box-shadow: 0 20px 40px -30px rgba(0,0,0,.25);
  }

  .card {
    background: var(--white);
    border-radius: 24px;
    padding: 40px 44px;
    box-shadow: 0 30px 60px -30px rgba(60,45,20,.15);
    position: relative;
    z-index: 4;
  }

  .card-head {
    text-align: center;
    margin-bottom: 26px;
  }

  .avatar {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    background: #f0ecdd;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--olive-dark);
    margin: 0 auto 18px;
  }

  .avatar svg {
    width: 32px;
    height: 32px;
  }

  .card-title {
    font-size: 30px;
    font-weight: 700;
    color: var(--brown);
  }

  .card-sub {
    color: var(--muted);
    font-size: 14px;
    margin-top: 4px;
  }

  .error-box {
    margin-bottom: 18px;
    padding: 12px 14px;
    border-radius: 12px;
    background: var(--danger-bg);
    border: 1px solid var(--danger-border);
    color: var(--danger-text);
    font-size: 14px;
    font-weight: 500;
  }

  .field {
    position: relative;
    margin-bottom: 16px;
  }

  .field .ic {
    position: absolute;
    top: 50%;
    left: 18px;
    transform: translateY(-50%);
    color: var(--olive-dark);
    width: 20px;
    height: 20px;
  }

  .field input {
    width: 100%;
    padding: 16px 18px 16px 52px;
    border: 1px solid var(--border);
    border-radius: 12px;
    font-family: inherit;
    font-size: 15px;
    color: var(--brown);
    background: #fff;
    outline: none;
    transition: border .2s, box-shadow .2s;
  }

  .field input::placeholder {
    color: #b0a89a;
  }

  .field input:focus {
    border-color: var(--olive);
    box-shadow: 0 0 0 3px rgba(107,127,44,.12);
  }

  .password-field input {
    padding-right: 54px;
  }

  .toggle-password {
    position: absolute;
    top: 50%;
    right: 14px;
    transform: translateY(-50%);
    background: transparent;
    border: 0;
    cursor: pointer;
    color: #9a907f;
    width: 26px;
    height: 26px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .toggle-password svg {
    width: 20px;
    height: 20px;
  }

  .btn-primary {
    width: 100%;
    padding: 17px;
    margin-top: 10px;
    background: var(--olive);
    color: #fff;
    border: 0;
    border-radius: 12px;
    font-family: inherit;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: background .2s, transform .1s;
  }

  .btn-primary:hover {
    background: var(--olive-dark);
  }

  .btn-primary:active {
    transform: translateY(1px);
  }

  .signup {
    text-align: center;
    margin-top: 22px;
    color: var(--muted);
    font-size: 14px;
  }

  .signup a {
    color: var(--olive-dark);
    font-weight: 600;
    text-decoration: none;
  }

  .signup a:hover {
    text-decoration: underline;
  }

  .badges {
    position: relative;
    z-index: 3;
    display: flex;
    justify-content: center;
    gap: 40px;
    padding: 12px 20px 34px;
    color: var(--olive-dark);
    font-weight: 500;
    font-size: 15px;
  }

  .badge {
    display: flex;
    align-items: center;
    gap: 10px;
  }

  .badge + .badge {
    border-left: 1px solid #d8d2c1;
    padding-left: 40px;
  }

  .badge svg {
    width: 22px;
    height: 22px;
  }

  @media (max-width: 1100px) {
    .container {
      gap: 24px;
    }

    .headline {
      font-size: 48px;
    }
  }

  @media (max-width: 900px) {
    .container {
      grid-template-columns: 1fr;
      padding: 10px 20px 36px;
      margin-top: 0;
    }

    .left {
      padding: 10px;
      order: 1;
    }

    .card {
      padding: 28px 22px;
      order: 2;
    }

    .header {
      padding: 20px;
      flex-direction: column;
      gap: 12px;
      align-items: flex-start;
    }

    .badges {
      flex-wrap: wrap;
      gap: 20px;
      padding: 10px 20px 28px;
      justify-content: flex-start;
    }

    .badge + .badge {
      border: 0;
      padding-left: 0;
    }

    .headline {
      font-size: 40px;
    }

    .bowl-wrap {
      max-width: 320px;
    }

    .dots-grid {
      left: auto;
      right: 20px;
      top: 120px;
    }

    .dots-corner {
      display: none;
    }
  }
</style>
</head>
<body>

  <div class="shape shape-cream"></div>
  <div class="shape shape-olive"></div>
  <div class="leaf"></div>
  <div class="dots-grid" id="dotsGrid"></div>
  <div class="dots-corner" id="dotsCorner"></div>

  <header class="header">
    <a href="home" class="logo">
      <img src="images/cravix-logo.png" alt="Cravix Logo">
    </a>
    <div class="signup-top">
      New to Cravix?<a href="register.jsp">Create account</a>
    </div>
  </header>

  <main class="container">
    <section class="left">
      <h1 class="headline">Good Food.<span class="green">Delivered.</span></h1>
      <div class="accent-line"></div>
      <p class="tagline">Login and continue your food journey with Cravix.</p>

      <div class="bowl-wrap">
        <div class="blob-orange"></div>
        <div class="sparks">✦</div>
        <img class="bowl"
             alt="Healthy bowl"
             src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80"
             onerror="this.style.display='none'"/>
      </div>
    </section>

    <section class="card">
      <div class="card-head">
        <div class="avatar">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
               stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="8" r="4"/>
            <path d="M4 21c0-4 4-7 8-7s8 3 8 7"/>
          </svg>
        </div>
        <div class="card-title">Welcome Back</div>
        <div class="card-sub">Login to continue your food journey</div>
      </div>

      <%
          String error = (String) request.getAttribute("error");
      %>

      <% if (error != null) { %>
          <div class="error-box"><%= error %></div>
      <% } %>

      <form action="login" method="post">
        <div class="field">
          <svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
               stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="5" width="18" height="14" rx="2"/>
            <path d="M3 7l9 6 9-6"/>
          </svg>
          <input type="email" name="email" placeholder="Email Address" required />
        </div>

        <div class="field password-field">
          <svg class="ic" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
               stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="11" width="18" height="10" rx="2"/>
            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
          </svg>
          <input type="password" id="password" name="password" placeholder="Password" required />
          <button type="button" class="toggle-password" onclick="togglePassword()" aria-label="Show or hide password">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                 stroke-linecap="round" stroke-linejoin="round">
              <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"/>
              <circle cx="12" cy="12" r="3"/>
            </svg>
          </button>
        </div>

        <button type="submit" class="btn-primary">Login</button>

        <div class="signup">
          Don’t have an account? <a href="register.jsp">Sign up</a>
        </div>
      </form>
    </section>
  </main>

  <div class="badges">
    <div class="badge">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
           stroke-linecap="round" stroke-linejoin="round">
        <circle cx="6" cy="18" r="2.5"/>
        <circle cx="17" cy="18" r="2.5"/>
        <path d="M3 6h11l3 6h2a2 2 0 0 1 2 2v4h-2"/>
      </svg>
      Fast Delivery
    </div>

    <div class="badge">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
           stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="9" r="6"/>
        <path d="M8.5 14L7 22l5-3 5 3-1.5-8"/>
      </svg>
      Best Quality
    </div>

    <div class="badge">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
           stroke-linecap="round" stroke-linejoin="round">
        <path d="M12 2l8 4v6c0 5-3.5 9-8 10-4.5-1-8-5-8-10V6l8-4z"/>
        <path d="M9 12l2 2 4-4"/>
      </svg>
      Safe & Secure
    </div>
  </div>

<script>
  const g = document.getElementById('dotsGrid');
  for (let i = 0; i < 42; i++) {
    g.appendChild(document.createElement('span'));
  }

  const c = document.getElementById('dotsCorner');
  for (let i = 0; i < 64; i++) {
    c.appendChild(document.createElement('span'));
  }

  function togglePassword() {
    const passwordInput = document.getElementById('password');
    passwordInput.type = passwordInput.type === 'password' ? 'text' : 'password';
  }
</script>

</body>
</html>