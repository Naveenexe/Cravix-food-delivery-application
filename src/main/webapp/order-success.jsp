<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.cravix.model.CartItem" %>
<%@ page import="com.cravix.model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer lastOrderId = (Integer) session.getAttribute("lastOrderId");
    List<CartItem> lastOrderItems = (List<CartItem>) session.getAttribute("lastOrderItems");
    BigDecimal subtotal = (BigDecimal) session.getAttribute("lastOrderSubtotal");
    BigDecimal deliveryFee = (BigDecimal) session.getAttribute("lastDeliveryFee");
    BigDecimal packagingFee = (BigDecimal) session.getAttribute("lastPackagingFee");
    BigDecimal total = (BigDecimal) session.getAttribute("lastOrderTotal");
    String deliveryAddress = (String) session.getAttribute("lastOrderAddress");
    String paymentMode = (String) session.getAttribute("lastPaymentMode");

    if (lastOrderId == null) {
        response.sendRedirect("home");
        return;
    }

    if (lastOrderItems == null) lastOrderItems = new ArrayList<>();
    if (subtotal == null) subtotal = BigDecimal.ZERO;
    if (deliveryFee == null) deliveryFee = BigDecimal.ZERO;
    if (packagingFee == null) packagingFee = BigDecimal.ZERO;
    if (total == null) total = BigDecimal.ZERO;
    if (deliveryAddress == null) deliveryAddress = "Not available";
    if (paymentMode == null) paymentMode = "COD";

    int totalItems = 0;
    String restaurantName = "Cravix Restaurant";
    for (CartItem item : lastOrderItems) {
        totalItems += item.getQuantity();
        if (item.getRestaurantName() != null && !item.getRestaurantName().trim().isEmpty()) {
            restaurantName = item.getRestaurantName();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>Cravix — Order Placed</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:wght@600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root{
    --bg:#f7f3e8;
    --card:#ffffff;
    --olive:#5b6b1f;
    --olive-dark:#48561a;
    --olive-soft:#e6ead0;
    --orange:#f0a83a;
    --ink:#2b2a20;
    --muted:#7a7867;
    --line:#ece7d4;
  }
  *{box-sizing:border-box;margin:0;padding:0}
  body{
    font-family:'Inter',sans-serif;
    background:var(--bg);
    color:var(--ink);
    min-height:100vh;
    position:relative;
    overflow-x:hidden;
    padding-bottom:60px;
  }
  body::before,body::after{
    content:"";position:fixed;z-index:0;pointer-events:none;
  }
  body::before{
    bottom:-80px;left:-80px;width:280px;height:280px;
    background:radial-gradient(circle at 30% 30%, #b7c15a 0%, #8a9a3a 60%, transparent 70%);
    border-radius:50%;opacity:.55;
  }
  body::after{
    top:20%;right:-60px;width:220px;height:220px;
    background:radial-gradient(circle, #f0a83a55, transparent 70%);
    border-radius:50%;
  }
  .dots{position:fixed;bottom:40px;right:60px;display:grid;grid-template-columns:repeat(6,6px);gap:10px;opacity:.5;z-index:0}
  .dots span{width:6px;height:6px;border-radius:50%;background:var(--orange)}

  header{
    position:relative;z-index:2;
    display:flex;align-items:center;gap:24px;
    padding:22px 60px;
    flex-wrap:wrap;
  }
  .logo{font-family:'Fraunces',serif;font-size:32px;font-weight:800;color:var(--olive-dark);display:flex;align-items:center}
  .logo .c{color:var(--olive);position:relative;margin-right:2px}
  .logo .c::after{content:"";position:absolute;top:-6px;right:-3px;width:8px;height:12px;background:var(--olive);border-radius:50% 50% 0 50%;transform:rotate(35deg)}
  .search{
    flex:1;max-width:520px;background:#fff;border-radius:999px;
    display:flex;align-items:center;padding:12px 20px;gap:12px;
    box-shadow:0 2px 10px rgba(0,0,0,.04);
  }
  .search input{border:none;outline:none;flex:1;font-size:14px;background:transparent;color:var(--ink)}
  .search svg{color:var(--olive)}
  .loc{display:flex;align-items:center;gap:6px;font-weight:600;font-size:14px;color:var(--ink)}
  .cart{
    position:relative;
    text-decoration:none;
    color:inherit;
  }
  .cart .badge{
    position:absolute;top:-6px;right:-8px;background:var(--orange);color:#fff;
    font-size:11px;font-weight:700;border-radius:999px;padding:2px 6px
  }
  .avatar{
    margin-left:auto;
    display:flex;
    align-items:center;
    gap:10px;
    flex-wrap:wrap;
  }
  .user-chip{
    background:#fff;
    padding:10px 16px;
    border-radius:999px;
    font-weight:700;
    box-shadow:0 2px 10px rgba(0,0,0,.04);
  }
  .nav-btn{
    text-decoration:none;
    background:#fff;
    color:#333;
    padding:10px 16px;
    border-radius:12px;
    font-weight:700;
    box-shadow:0 2px 10px rgba(0,0,0,.04);
  }

  main{position:relative;z-index:1;max-width:1080px;margin:10px auto 0;padding:0 24px;display:flex;flex-direction:column;gap:24px}

  .panel{background:#fff;border-radius:20px;padding:36px;box-shadow:0 4px 20px rgba(0,0,0,.03)}

  .success{text-align:center;padding:44px 36px}
  .check-wrap{
    width:130px;height:130px;margin:0 auto 20px;
    border:1.5px dashed #c9cfa3;border-radius:50%;
    display:flex;align-items:center;justify-content:center;position:relative;
  }
  .check-inner{
    width:96px;height:96px;border-radius:50%;
    background:var(--olive-soft);
    display:flex;align-items:center;justify-content:center;
  }
  .check-inner svg{color:var(--olive-dark);width:44px;height:44px}
  .leaf-l,.leaf-r{position:absolute;top:50%;font-size:26px;color:#c9cfa3}
  .leaf-l{left:-38px;transform:translateY(-50%) rotate(-20deg)}
  .leaf-r{right:-38px;transform:translateY(-50%) rotate(20deg)}

  .success h1{font-family:'Fraunces',serif;font-size:34px;font-weight:700;margin-bottom:10px}
  .success .sub{color:var(--muted);font-size:15px;line-height:1.6}
  .success .sub b{color:var(--ink)}

  .meta{
    margin:28px 0 22px;background:var(--olive-soft);border-radius:14px;
    padding:18px 24px;display:grid;grid-template-columns:repeat(4,1fr);gap:16px;
  }
  .meta .item{display:flex;align-items:center;gap:12px}
  .meta .icon{width:38px;height:38px;border-radius:50%;background:#fff;display:flex;align-items:center;justify-content:center;color:var(--olive-dark);flex-shrink:0}
  .meta .lbl{font-size:12px;color:var(--muted)}
  .meta .val{font-size:14px;font-weight:600;color:var(--ink)}

  .note{color:var(--muted);font-size:14px;margin-bottom:22px}
  .actions{display:flex;gap:14px;justify-content:center;flex-wrap:wrap}
  .btn{
    text-decoration:none;
    padding:14px 36px;border-radius:12px;font-size:15px;font-weight:600;
    cursor:pointer;border:1.5px solid transparent;display:inline-flex;align-items:center;gap:10px;transition:.2s
  }
  .btn.primary{background:var(--olive-dark);color:#fff}
  .btn.primary:hover{background:var(--olive)}
  .btn.ghost{background:#fff;color:var(--olive-dark);border-color:var(--olive-dark)}
  .btn.ghost:hover{background:var(--olive-soft)}

  .order-details{display:grid;grid-template-columns:1.2fr 1fr;gap:40px}
  .section-head{display:flex;align-items:center;gap:12px;margin-bottom:20px}
  .section-head .ico{width:36px;height:36px;background:var(--olive-soft);border-radius:10px;display:flex;align-items:center;justify-content:center;color:var(--olive-dark)}
  .section-head h3{font-family:'Fraunces',serif;font-size:20px;font-weight:700}

  .item-row{display:flex;align-items:center;gap:14px;padding:10px 0}
  .item-row img{width:56px;height:56px;border-radius:12px;object-fit:cover}
  .item-row .info{flex:1}
  .item-row .name{font-weight:600;font-size:15px}
  .item-row .qty{font-size:13px;color:var(--muted);margin-top:2px}
  .item-row .price{font-weight:600;font-size:15px}

  .summary{border-left:1px dashed var(--line);padding-left:40px;display:flex;flex-direction:column;justify-content:center}
  .sum-row{display:flex;justify-content:space-between;padding:9px 0;font-size:14px;color:var(--ink)}
  .sum-row .lbl{color:var(--muted)}
  .sum-total{display:flex;justify-content:space-between;align-items:center;border-top:1px dashed var(--line);padding-top:16px;margin-top:10px}
  .sum-total .lbl{font-family:'Fraunces',serif;font-weight:700;font-size:18px}
  .sum-total .val{font-family:'Fraunces',serif;font-weight:800;font-size:24px}

  .support{display:flex;align-items:center;justify-content:space-between;padding:20px 28px;gap:20px;flex-wrap:wrap}
  .support .l{display:flex;align-items:center;gap:14px}
  .support .l .ico{width:44px;height:44px;background:var(--olive-soft);border-radius:50%;display:flex;align-items:center;justify-content:center;color:var(--olive-dark)}
  .support .title{font-weight:600;font-size:15px}
  .support .sub{font-size:13px;color:var(--muted);margin-top:2px}

  @media (max-width:860px){
    header{padding:16px 20px;flex-wrap:wrap}
    .search{order:3;width:100%;max-width:none}
    .order-details{grid-template-columns:1fr}
    .summary{border-left:none;border-top:1px dashed var(--line);padding-left:0;padding-top:20px}
    .meta{grid-template-columns:repeat(2,1fr)}
  }
</style>
</head>
<body>
<div class="dots">
  <span></span><span></span><span></span><span></span><span></span><span></span>
  <span></span><span></span><span></span><span></span><span></span><span></span>
  <span></span><span></span><span></span><span></span><span></span><span></span>
</div>

<header>
  <div class="logo"><span class="c">C</span>ravix</div>

  <div class="search">
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/>
    </svg>
    <input placeholder="Search for restaurants or cuisines...">
  </div>

  <div class="loc">📍 <%= restaurantName %></div>

  <a href="cart" class="cart">
    🛍️
    <span class="badge"><%= totalItems %></span>
  </a>

  <div class="avatar">
    <div class="user-chip">Hi, <%= user.getFullName() %></div>
    <a href="order-history" class="nav-btn">My Orders</a>
    <a href="home" class="nav-btn">Home</a>
  </div>
</header>

<main>
  <section class="panel success">
    <div class="check-wrap">
      <span class="leaf-l">🌿</span>
      <span class="leaf-r">🌿</span>
      <div class="check-inner">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
          <path d="M20 6 9 17l-5-5"/>
        </svg>
      </div>
    </div>

    <h1>Order Placed Successfully!</h1>
    <p class="sub">Thank you for choosing <b>Cravix</b>.<br>Your delicious meal is on its way!</p>

    <div class="meta">
      <div class="item">
        <div class="icon">#</div>
        <div>
          <div class="lbl">Order ID</div>
          <div class="val">#CRX<%= lastOrderId %></div>
        </div>
      </div>

      <div class="item">
        <div class="icon">⏱</div>
        <div>
          <div class="lbl">Estimated Delivery</div>
          <div class="val">30–40 min</div>
        </div>
      </div>

      <div class="item">
        <div class="icon">💳</div>
        <div>
          <div class="lbl">Payment Mode</div>
          <div class="val"><%= paymentMode %></div>
        </div>
      </div>

      <div class="item">
        <div class="icon">📍</div>
        <div>
          <div class="lbl">Delivery Address</div>
          <div class="val"><%= deliveryAddress %></div>
        </div>
      </div>
    </div>

    <p class="note">You will receive an order confirmation on your registered mobile number.</p>

    <div class="actions">
      <a href="order-history" class="btn primary">View My Orders</a>
      <a href="home" class="btn ghost">Back to Home</a>
    </div>
  </section>

  <section class="panel">
    <div class="order-details">

      <div>
        <div class="section-head">
          <div class="ico">🛍️</div>
          <h3>Order Details</h3>
        </div>

        <% if (lastOrderItems.isEmpty()) { %>
            <p style="color:#777;">No order items available.</p>
        <% } else { %>
            <% for (CartItem item : lastOrderItems) { %>
                <div class="item-row">
                  <img src="<%= item.getImagePath() != null ? item.getImagePath() : "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&h=200&fit=crop" %>" alt="">
                  <div class="info">
                    <div class="name"><%= item.getItemName() %></div>
                    <div class="qty">Qty: <%= item.getQuantity() %></div>
                  </div>
                  <div class="price">₹<%= item.getTotalPrice() %></div>
                </div>
            <% } %>
        <% } %>
      </div>

      <div class="summary">
        <div class="sum-row"><span class="lbl">Item Total (<%= totalItems %> items)</span><span class="val">₹<%= subtotal %></span></div>
        <div class="sum-row"><span class="lbl">Delivery Fee</span><span class="val">₹<%= deliveryFee %></span></div>
        <div class="sum-row"><span class="lbl">Packaging Fee</span><span class="val">₹<%= packagingFee %></span></div>

        <div class="sum-total">
          <span class="lbl">Total Amount</span>
          <span class="val">₹<%= total %></span>
        </div>
      </div>

    </div>
  </section>

  <section class="panel support">
    <div class="l">
      <div class="ico">🎧</div>
      <div>
        <div class="title">Need help with your order?</div>
        <div class="sub">Contact Cravix support for any delivery or payment issue.</div>
      </div>
    </div>
    <a href="order-history" class="btn ghost">Order History</a>
  </section>
</main>
</body>
</html>