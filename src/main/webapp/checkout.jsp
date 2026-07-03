<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.cravix.model.CartItem" %>
<%@ page import="com.cravix.model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cart");
        return;
    }

    BigDecimal subtotal = BigDecimal.ZERO;
    int totalItems = 0;
    String restaurantName = "Cravix Restaurant";

    for (CartItem item : cart.values()) {
        subtotal = subtotal.add(item.getTotalPrice());
        totalItems += item.getQuantity();

        if (item.getRestaurantName() != null && !item.getRestaurantName().trim().isEmpty()) {
            restaurantName = item.getRestaurantName();
        }
    }

    BigDecimal deliveryFee = new BigDecimal("30");
    BigDecimal packagingFee = new BigDecimal("20");
    BigDecimal total = subtotal.add(deliveryFee).add(packagingFee);

    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Cravix — Checkout</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  :root {
    --bg: #fbf6ec;
    --card: #ffffff;
    --olive: #55611f;
    --olive-dark: #414a17;
    --olive-soft: #eef1dc;
    --cream: #fff7e6;
    --orange: #f59e2b;
    --text: #1f1f1f;
    --muted: #6b6b6b;
    --border: #ececd9;
    --success: #4b8b3b;
    --danger: #c0392b;
  }
  body {
    font-family: 'Poppins', 'Segoe UI', system-ui, sans-serif;
    background: var(--bg);
    color: var(--text);
    min-height: 100vh;
    padding: 24px 40px 40px;
  }
  a { text-decoration: none; color: inherit; }

  .header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 24px;
    margin-bottom: 28px;
    flex-wrap: wrap;
  }

  .brand-block{
    display:flex;
    align-items:center;
    gap:14px;
  }

  .site-logo{
    display:flex;
    align-items:center;
    flex-shrink:0;
  }

  .site-logo img{
    height:60px;
    width:auto;
    display:block;
    object-fit:contain;
  }

  .brand-text h2{
    font-size:24px;
    font-weight:700;
    color:var(--text);
    margin:0;
    line-height:1.1;
  }

  .brand-text p{
    margin:4px 0 0;
    font-size:13px;
    color:var(--muted);
    font-weight:500;
  }

  .header-right {
    margin-left: auto;
    display: flex;
    align-items: center;
    gap: 16px;
    flex-wrap: wrap;
  }

  .cart-btn{
    position:relative;
    background:#fff;
    border:1px solid var(--border);
    border-radius:12px;
    padding:10px 12px;
    font-size:20px;
    display:flex;
    align-items:center;
    justify-content:center;
  }

  .cart-btn .badge {
    position: absolute;
    top: -8px;
    right: -10px;
    background: var(--orange);
    color: #fff;
    font-size: 11px;
    font-weight: 600;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    display: grid;
    place-items: center;
  }

  .user-chip{
    background:#fff;
    padding:10px 16px;
    border-radius:999px;
    border:1px solid var(--border);
    font-weight:700;
  }

  .nav-btn{
    background:#fff;
    padding:10px 16px;
    border-radius:12px;
    border:1px solid var(--border);
    font-weight:700;
  }

  .logout-btn{
    background:var(--olive);
    color:#fff;
    padding:10px 16px;
    border-radius:12px;
    border:1px solid var(--olive);
    font-weight:700;
  }

  .breadcrumb { font-size: 13px; color: var(--muted); margin-bottom: 8px; }
  .breadcrumb .sep { margin: 0 6px; }
  .breadcrumb .current { color: var(--text); font-weight: 500; }

  .page-title {
    font-size: 40px; font-weight: 700; letter-spacing: -0.5px;
    display: flex; align-items: center; gap: 10px;
  }
  .page-title .leaf { color: #b7c58b; font-size: 22px; }
  .page-sub { color: var(--muted); margin: 6px 0 24px; font-size: 14px; }

  .grid {
    display: grid;
    grid-template-columns: 1fr 400px;
    gap: 24px;
    align-items: start;
  }

  .card {
    background: var(--card);
    border-radius: 18px;
    padding: 22px 24px;
    border: 1px solid var(--border);
    margin-bottom: 20px;
  }
  .card-head {
    display: flex; align-items: center; gap: 12px;
    margin-bottom: 16px;
  }
  .icon-round {
    width: 38px; height: 38px; border-radius: 50%;
    background: var(--olive-soft); color: var(--olive);
    display: grid; place-items: center;
    font-size: 18px;
  }
  .card-title { font-size: 18px; font-weight: 600; }

  .address .name {
    font-weight: 600; display: inline-flex; align-items: center; gap: 8px;
  }
  .tag {
    background: var(--olive-soft); color: var(--olive);
    padding: 2px 10px; border-radius: 6px;
    font-size: 11px; font-weight: 600;
  }
  .address p { color: #444; font-size: 14px; line-height: 1.7; margin-top: 6px; }

  .field-label{
    font-size:14px;
    font-weight:600;
    margin-bottom:8px;
    display:block;
  }
  .input, textarea, select {
    width:100%;
    border:1px solid var(--border);
    border-radius:12px;
    padding:14px 16px;
    font-size:14px;
    font-family:inherit;
    outline:none;
    background:#fff;
  }
  textarea{
    min-height:100px;
    resize:vertical;
  }

  .option {
    border: 1.5px solid var(--border);
    border-radius: 12px;
    padding: 14px 16px;
    display: flex; align-items: center; gap: 14px;
    margin-bottom: 10px;
  }
  .radio {
    width: 20px; height: 20px; border-radius: 50%;
    border: 2px solid #c8c8b8;
    display: grid; place-items: center;
    flex-shrink: 0;
  }
  .option.selected {
    border-color: var(--olive);
    background: #fbfcf3;
  }
  .option.selected .radio { border-color: var(--olive); }
  .option.selected .radio::after {
    content: ""; width: 10px; height: 10px; border-radius: 50%;
    background: var(--olive);
  }
  .opt-title { font-weight: 600; }
  .opt-meta { font-size: 13px; color: var(--muted); margin-top: 2px; }

  .order-item {
    display: flex; align-items: center; gap: 14px;
    padding: 12px 0;
    border-bottom: 1px dashed var(--border);
  }
  .order-item:last-child { border-bottom: none; }
  .thumb {
    width: 58px; height: 58px; border-radius: 12px;
    background: #ddd; flex-shrink: 0;
    background-size: cover; background-position: center;
  }
  .oi-name { font-weight: 600; }
  .oi-qty { font-size: 13px; color: var(--muted); margin-top: 2px; }
  .oi-price { margin-left: auto; font-weight: 600; }

  .summary { position: sticky; top: 20px; }
  .sum-row {
    display: flex; justify-content: space-between;
    padding: 10px 0; font-size: 14px; color: #333;
  }
  .divider { border-top: 1px dashed var(--border); margin: 6px 0; }
  .total-row {
    display: flex; justify-content: space-between;
    align-items: center; padding: 14px 0 6px;
    font-size: 20px; font-weight: 700;
  }
  .place-btn {
    width: 100%; background: var(--olive); color: #fff;
    border: none; padding: 16px; font-size: 16px; font-weight: 600;
    border-radius: 12px; cursor: pointer;
    display: flex; align-items: center; justify-content: center; gap: 10px;
    font-family: inherit;
    transition: background .2s;
  }
  .place-btn:hover { background: var(--olive-dark); }

  .secure-note {
    text-align: center; font-size: 13px; color: var(--muted);
    margin-top: 10px;
    display: flex; align-items: center; justify-content: center; gap: 6px;
  }

  .trust-item {
    display: flex; align-items: center; gap: 14px;
    padding: 12px 0;
  }
  .trust-item + .trust-item { border-top: 1px solid var(--border); }
  .trust-ic {
    width: 40px; height: 40px; border-radius: 50%;
    background: var(--olive-soft); color: var(--olive);
    display: grid; place-items: center; flex-shrink: 0;
  }
  .trust-t { font-weight: 600; font-size: 14px; }
  .trust-s { font-size: 12px; color: var(--muted); margin-top: 2px; }

  .promise {
    background: var(--cream);
    border-radius: 18px;
    padding: 22px;
    position: relative;
    overflow: hidden;
  }
  .promise h4 {
    display: flex; align-items: center; gap: 8px;
    color: #6a5217; font-size: 17px; margin-bottom: 8px;
  }
  .promise p { font-size: 13px; color: #6a5217; line-height: 1.6; }

  .error-box{
    background:#fff1f0;
    border:1px solid #f5c2c0;
    color:var(--danger);
    padding:14px 16px;
    border-radius:12px;
    margin-bottom:16px;
    font-size:14px;
    font-weight:600;
  }

  .perks {
    background: #fff; border-radius: 16px;
    margin-top: 24px; padding: 20px;
    display: grid; grid-template-columns: repeat(4, 1fr);
    border: 1px solid var(--border);
  }
  .perk {
    display: flex; align-items: center; gap: 12px;
    padding: 4px 12px;
    border-right: 1px solid var(--border);
  }
  .perk:last-child { border-right: none; }
  .perk-ic {
    width: 44px; height: 44px; border-radius: 50%;
    background: var(--olive-soft); color: var(--olive);
    display: grid; place-items: center; font-size: 20px;
  }
  .perk-t { font-weight: 600; font-size: 14px; }
  .perk-s { font-size: 12px; color: var(--muted); }

  @media (max-width: 960px) {
    body { padding: 16px; }
    .grid { grid-template-columns: 1fr; }
    .perks { grid-template-columns: repeat(2, 1fr); }
    .perk { border-right: none; }
  }

  @media (max-width: 768px) {
    .brand-block{ width:100%; }
    .header-right{
      margin-left:0;
      width:100%;
      justify-content:flex-start;
    }
  }
</style>
</head>
<body>

<header class="header">
  <div class="brand-block">
    <a href="home" class="site-logo">
      <img src="images/cravix-logo.png" alt="Cravix Logo">
    </a>
    <div class="brand-text">
      <h2>Checkout</h2>
      <p>Review your order and place it</p>
    </div>
  </div>

  <div class="header-right">
    <a href="cart" class="cart-btn">
      🛍️
      <span class="badge"><%= totalItems %></span>
    </a>
    <a href="profile" class="user-chip">Hi, <%= user.getFullName() %></a>
    <a href="home" class="nav-btn">Home</a>
    <a href="logout" class="logout-btn">Logout</a>
  </div>
</header>

<div class="breadcrumb">
  Home <span class="sep">›</span> Cart <span class="sep">›</span>
  <span class="current">Checkout</span>
</div>



<% if (error != null) { %>
    <div class="error-box"><%= error %></div>
<% } %>

<form action="checkout" method="post">
  <div class="grid">

    <div>
      <div class="card address">
        <div class="card-head">
          <div class="icon-round">📍</div>
          <div class="card-title">1. Delivery Address</div>
        </div>

        <div class="name"><%= user.getFullName() %> <span class="tag">HOME</span></div>
        <p style="margin-bottom:14px;">
            <%= user.getEmail() %><br/>
            <%= user.getPhone() %>
        </p>

        <label class="field-label">Delivery Address</label>
        <textarea name="deliveryAddress" required><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
      </div>

      <div class="card">
        <div class="card-head">
          <div class="icon-round">🛵</div>
          <div class="card-title">2. Delivery Options</div>
        </div>

        <div class="option selected">
          <div class="radio"></div>
          <div>
            <div class="opt-title">Standard Delivery</div>
            <div class="opt-meta">30–40 min • ₹30</div>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-head">
          <div class="icon-round">💳</div>
          <div class="card-title">3. Payment Method</div>
        </div>

        <label class="field-label">Select Payment Mode</label>
        <select name="paymentMode" required>
          <option value="COD">Cash on Delivery</option>
          <option value="UPI">UPI</option>
          <option value="CARD">Credit / Debit Card</option>
          <option value="NETBANKING">Net Banking</option>
          <option value="WALLET">Wallet</option>
        </select>
      </div>

      <div class="card">
        <div class="card-head">
          <div class="icon-round">🛍️</div>
          <div class="card-title">4. Order Items</div>
          <a class="nav-btn" href="cart" style="margin-left:auto;">Edit Cart</a>
        </div>

        <% for (CartItem item : cart.values()) { %>
            <%
                String imagePath = item.getImagePath();
                if (imagePath == null || imagePath.trim().isEmpty()) {
                    imagePath = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&auto=format&fit=crop&q=60";
                }
            %>
            <div class="order-item">
              <div class="thumb" style="background-image:url('<%= imagePath %>');"></div>
              <div>
                <div class="oi-name"><%= item.getItemName() %></div>
                <div class="oi-qty">Quantity: <%= item.getQuantity() %></div>
              </div>
              <div class="oi-price">₹<%= item.getTotalPrice() %></div>
            </div>
        <% } %>
      </div>
    </div>

    <div class="summary">
      <div class="card">
        <div class="card-head">
          <div class="icon-round">📋</div>
          <div class="card-title">Order Summary</div>
        </div>

        <div class="sum-row"><span>Item Total (<%= totalItems %> items)</span><span>₹<%= subtotal %></span></div>
        <div class="sum-row"><span>Delivery Fee</span><span>₹<%= deliveryFee %></span></div>
        <div class="sum-row"><span>Packaging Fee</span><span>₹<%= packagingFee %></span></div>

        <div class="divider"></div>

        <div class="total-row"><span>Total Amount</span><span>₹<%= total %></span></div>

        <button type="submit" class="place-btn">Place Order →</button>
        <div class="secure-note">🔒 Your payment details are secure</div>
      </div>

      <div class="card">
        <div class="trust-item">
          <div class="trust-ic">🛡️</div>
          <div>
            <div class="trust-t">Safe & Secure Payments</div>
            <div class="trust-s">100% secure transactions</div>
          </div>
        </div>
        <div class="trust-item">
          <div class="trust-ic">🛵</div>
          <div>
            <div class="trust-t">On-time Delivery</div>
            <div class="trust-s">Quick & reliable delivery</div>
          </div>
        </div>
        <div class="trust-item">
          <div class="trust-ic">✅</div>
          <div>
            <div class="trust-t">Hygienic Packaging</div>
            <div class="trust-s">Food packed with care</div>
          </div>
        </div>
        <div class="trust-item">
          <div class="trust-ic">↩️</div>
          <div>
            <div class="trust-t">Easy Ordering</div>
            <div class="trust-s">Smooth checkout flow</div>
          </div>
        </div>
      </div>

      <div class="promise">
        <h4>👑 Cravix Promise</h4>
        <p>We ensure best quality food, on-time delivery and a great experience every time you order.</p>
      </div>
    </div>

  </div>
</form>

<div class="perks">
  <div class="perk"><div class="perk-ic">🛵</div><div><div class="perk-t">Fast Delivery</div><div class="perk-s">At your doorstep</div></div></div>
  <div class="perk"><div class="perk-ic">🍽️</div><div><div class="perk-t">Best Quality</div><div class="perk-s">Fresh & Tasty</div></div></div>
  <div class="perk"><div class="perk-ic">🛡️</div><div><div class="perk-t">Safe Payment</div><div class="perk-s">100% Secure</div></div></div>
  <div class="perk"><div class="perk-ic">↩️</div><div><div class="perk-t">Easy Checkout</div><div class="perk-s">Smooth ordering</div></div></div>
</div>

</body>
</html>