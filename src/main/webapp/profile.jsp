<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.cravix.model.User" %>
<%@ page import="com.cravix.model.CartItem" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");

    int cartCount = 0;
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    if (cart != null) {
        for (CartItem item : cart.values()) {
            cartCount += item.getQuantity();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Cravix — My Profile</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:wght@600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
  :root{
    --bg:#f7f3e8;
    --card:#fffdf7;
    --olive:#5b6b1f;
    --olive-dark:#48561a;
    --olive-soft:#e6ead0;
    --orange:#f0a83a;
    --ink:#2b2a20;
    --muted:#8a8875;
    --line:#ece7d4;
    --danger:#c53b3b;
    --success:#2f7a36;
  }

  *{box-sizing:border-box;margin:0;padding:0}

  body{
    font-family:'Inter',sans-serif;
    background:var(--bg);
    color:var(--ink);
    min-height:100vh;
    position:relative;
    overflow-x:hidden;
  }

  body::before{
    content:"";
    position:fixed;
    bottom:-80px;
    left:-80px;
    width:280px;
    height:280px;
    background:radial-gradient(circle at 30% 30%, #b7c15a 0%, #8a9a3a 60%, transparent 70%);
    border-radius:50%;
    opacity:.45;
    pointer-events:none;
    z-index:0;
  }

  .dots{
    position:fixed;
    bottom:60px;
    right:60px;
    display:grid;
    grid-template-columns:repeat(6,6px);
    gap:10px;
    opacity:.45;
    z-index:0;
  }
  .dots span{
    width:6px;
    height:6px;
    border-radius:50%;
    background:var(--orange);
  }

  .container{
    max-width:1200px;
    margin:0 auto;
    padding:26px 24px 50px;
    position:relative;
    z-index:1;
  }

  .header{
    display:flex;
    align-items:center;
    gap:20px;
    flex-wrap:wrap;
    margin-bottom:26px;
  }

  .logo{
    font-family:'Fraunces',serif;
    font-size:32px;
    font-weight:800;
    color:var(--olive-dark);
    text-decoration:none;
    display:flex;
    align-items:center;
  }

  .logo .c{
    color:var(--olive);
    position:relative;
    margin-right:2px;
  }

  .logo .c::after{
    content:"";
    position:absolute;
    top:-6px;
    right:-3px;
    width:8px;
    height:12px;
    background:var(--olive);
    border-radius:50% 50% 0 50%;
    transform:rotate(35deg);
  }

  .search-pill{
    flex:1;
    max-width:420px;
    background:#fff;
    border-radius:999px;
    padding:12px 18px;
    color:var(--muted);
    box-shadow:0 2px 10px rgba(0,0,0,.04);
    font-size:14px;
  }

  .top-actions{
    margin-left:auto;
    display:flex;
    align-items:center;
    gap:12px;
    flex-wrap:wrap;
  }

  .cart-btn{
    position:relative;
    text-decoration:none;
    background:#fff;
    color:var(--ink);
    padding:10px 16px;
    border-radius:12px;
    font-weight:700;
    box-shadow:0 2px 10px rgba(0,0,0,.04);
  }

  .cart-btn .badge{
    position:absolute;
    top:-6px;
    right:-8px;
    background:var(--orange);
    color:#fff;
    font-size:11px;
    font-weight:700;
    border-radius:999px;
    padding:2px 6px;
  }

  .home-btn,
  .logout-btn{
    text-decoration:none;
    background:#fff;
    color:var(--ink);
    padding:10px 16px;
    border-radius:12px;
    font-weight:700;
    box-shadow:0 2px 10px rgba(0,0,0,.04);
  }

  .page-grid{
    display:grid;
    grid-template-columns:280px 1fr;
    gap:24px;
    align-items:start;
  }

  .sidebar,
  .content-card,
  .quick-card{
    background:var(--card);
    border-radius:18px;
    box-shadow:0 2px 12px rgba(0,0,0,.04);
  }

  .sidebar{
    padding:22px;
  }

  .profile-mini{
    text-align:center;
    padding-bottom:22px;
    border-bottom:1px solid var(--line);
    margin-bottom:20px;
  }

  .avatar{
    width:82px;
    height:82px;
    border-radius:50%;
    margin:0 auto 14px;
    background:linear-gradient(135deg,var(--olive),#889a3a);
    color:#fff;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:30px;
    font-weight:800;
  }

  .profile-mini h3{
    font-family:'Fraunces',serif;
    font-size:24px;
    margin-bottom:6px;
  }

  .profile-mini p{
    color:var(--muted);
    font-size:14px;
    word-break:break-word;
  }

  .side-links{
    display:flex;
    flex-direction:column;
    gap:12px;
  }

  .side-links a{
    text-decoration:none;
    padding:13px 16px;
    border-radius:12px;
    font-weight:600;
    color:var(--ink);
    background:#fff;
    border:1px solid transparent;
    transition:.2s ease;
  }

  .side-links a.active{
    background:var(--olive-soft);
    color:var(--olive-dark);
    border-color:#d9dfbc;
  }

  .side-links a:hover{
    background:#f6f4ec;
  }

  .content-card{
    padding:28px;
  }

  .content-head{
    display:flex;
    justify-content:space-between;
    align-items:flex-start;
    gap:18px;
    flex-wrap:wrap;
    margin-bottom:24px;
  }

  .content-head h1{
    font-family:'Fraunces',serif;
    font-size:36px;
    margin-bottom:8px;
  }

  .content-head p{
    color:var(--muted);
    font-size:14px;
  }

  .role-chip{
    background:var(--olive-soft);
    color:var(--olive-dark);
    padding:10px 16px;
    border-radius:999px;
    font-weight:700;
    font-size:13px;
  }

  .alert{
    padding:14px 16px;
    border-radius:12px;
    margin-bottom:18px;
    font-size:14px;
    font-weight:600;
  }

  .alert.success{
    background:#edf8ef;
    color:var(--success);
    border:1px solid #cfe8d2;
  }

  .alert.error{
    background:#fff0f0;
    color:var(--danger);
    border:1px solid #f1c9c9;
  }

  .form-grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:18px;
  }

  .form-group.full{
    grid-column:1 / -1;
  }

  .form-group label{
    display:block;
    margin-bottom:8px;
    font-size:13px;
    font-weight:700;
    color:var(--ink);
  }

  .form-group input,
  .form-group textarea{
    width:100%;
    border:1px solid var(--line);
    background:#fff;
    border-radius:14px;
    padding:14px 16px;
    font:inherit;
    color:var(--ink);
    outline:none;
    transition:.2s ease;
  }

  .form-group textarea{
    min-height:110px;
    resize:vertical;
  }

  .form-group input:focus,
  .form-group textarea:focus{
    border-color:#c6cf98;
    box-shadow:0 0 0 4px rgba(198,207,152,.2);
  }

  .readonly{
    background:#f5f2e8 !important;
    color:#7c7768;
  }

  .actions{
    margin-top:24px;
    display:flex;
    justify-content:flex-end;
  }

  .save-btn{
    border:none;
    background:var(--olive-dark);
    color:#fff;
    padding:14px 24px;
    border-radius:14px;
    font-size:15px;
    font-weight:700;
    cursor:pointer;
  }

  .save-btn:hover{
    background:#3e4b16;
  }

  .quick-card{
    margin-top:20px;
    padding:22px;
  }

  .quick-card h3{
    font-family:'Fraunces',serif;
    font-size:24px;
    margin-bottom:16px;
  }

  .quick-actions{
    display:grid;
    grid-template-columns:repeat(2,1fr);
    gap:14px;
  }

  .quick-actions a{
    text-decoration:none;
    background:#fff;
    border:1px solid var(--line);
    border-radius:14px;
    padding:18px;
    color:var(--ink);
    transition:.2s ease;
  }

  .quick-actions a:hover{
    transform:translateY(-2px);
    box-shadow:0 6px 16px rgba(0,0,0,.05);
  }

  .quick-actions .title{
    font-weight:700;
    margin-bottom:6px;
  }

  .quick-actions .sub{
    color:var(--muted);
    font-size:13px;
    line-height:1.5;
  }

  @media (max-width: 960px){
    .page-grid{
      grid-template-columns:1fr;
    }
  }

  @media (max-width: 700px){
    .form-grid,
    .quick-actions{
      grid-template-columns:1fr;
    }

    .content-card{
      padding:22px;
    }

    .content-head h1{
      font-size:30px;
    }
  }
</style>
</head>
<body>

<div class="dots">
  <span></span><span></span><span></span><span></span><span></span><span></span>
  <span></span><span></span><span></span><span></span><span></span><span></span>
  <span></span><span></span><span></span><span></span><span></span><span></span>
</div>

<div class="container">

  <header class="header">
    <a href="home" class="logo"><span class="c">C</span>ravix</a>
    <div class="search-pill">Manage your Cravix profile and account details</div>

    <div class="top-actions">
      <a href="cart" class="cart-btn">
        Cart
        <span class="badge"><%= cartCount %></span>
      </a>
      <a href="home" class="home-btn">Home</a>
      <a href="logout" class="logout-btn">Logout</a>
    </div>
  </header>

  <div class="page-grid">

    <aside class="sidebar">
      <div class="profile-mini">
        <div class="avatar">
          <%= user.getFullName() != null && !user.getFullName().isEmpty()
                ? user.getFullName().substring(0,1).toUpperCase()
                : "U" %>
        </div>
        <h3><%= user.getFullName() %></h3>
        <p><%= user.getEmail() %></p>
      </div>

      <div class="side-links">
        <a href="profile" class="active">My Profile</a>
        <a href="order-history">Order History</a>
        <a href="home">Browse Restaurants</a>
        <a href="logout">Logout</a>
      </div>
    </aside>

    <div>
      <section class="content-card">
        <div class="content-head">
          <div>
            <h1>My Profile</h1>
            <p>Update your basic account information used across Cravix.</p>
          </div>
          <div class="role-chip"><%= user.getRole() %></div>
        </div>

        <% if (success != null) { %>
          <div class="alert success"><%= success %></div>
        <% } %>

        <% if (error != null) { %>
          <div class="alert error"><%= error %></div>
        <% } %>

        <form action="profile" method="post">
          <div class="form-grid">
            <div class="form-group">
              <label>Full Name</label>
              <input type="text" name="fullName" value="<%= user.getFullName() != null ? user.getFullName() : "" %>" required>
            </div>

            <div class="form-group">
              <label>Email</label>
              <input type="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" class="readonly" readonly>
            </div>

            <div class="form-group">
              <label>Phone Number</label>
              <input type="text" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" placeholder="Enter your phone number">
            </div>

            <div class="form-group">
              <label>Role</label>
              <input type="text" value="<%= user.getRole() != null ? user.getRole() : "" %>" class="readonly" readonly>
            </div>

            <div class="form-group full">
              <label>Delivery Address</label>
              <textarea name="address" placeholder="Enter your delivery address"><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
            </div>
          </div>

          <div class="actions">
            <button type="submit" class="save-btn">Save Changes</button>
          </div>
        </form>
      </section>

      <section class="quick-card">
        <h3>Quick Actions</h3>
        <div class="quick-actions">
          <a href="order-history">
            <div class="title">View Order History</div>
            <div class="sub">Check all your previous Cravix orders and item details.</div>
          </a>

          <a href="home">
            <div class="title">Browse Restaurants</div>
            <div class="sub">Go back to home and continue ordering your favorite food.</div>
          </a>
        </div>
      </section>
    </div>

  </div>
</div>

</body>
</html>