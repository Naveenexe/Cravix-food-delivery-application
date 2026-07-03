<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.cravix.model.Orders" %>
<%@ page import="com.cravix.model.OrderItem" %>
<%@ page import="com.cravix.model.User" %>
<%@ page import="com.cravix.model.CartItem" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Orders> orderList = (List<Orders>) request.getAttribute("orderList");
    Map<Integer, List<OrderItem>> orderItemsMap =
            (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");

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
<meta charset="UTF-8" />
<title>Cravix — Order History</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:wght@600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root{
    --bg:#f7f3e8;--card:#fffdf7;--olive:#5b6b1f;--olive-dark:#48561a;
    --olive-soft:#e6ead0;--orange:#f0a83a;--red:#d64545;
    --ink:#2b2a20;--muted:#8a8875;--line:#ece7d4;
  }
  *{box-sizing:border-box;margin:0;padding:0}
  body{
    font-family:'Inter',sans-serif;
    background:var(--bg);
    color:var(--ink);
    min-height:100vh;
    position:relative;
    overflow-x:hidden;
    padding-bottom:40px
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
    opacity:.5;
    pointer-events:none;
    z-index:0
  }
  .dots{
    position:fixed;
    bottom:60px;
    right:60px;
    display:grid;
    grid-template-columns:repeat(6,6px);
    gap:10px;
    opacity:.5;
    z-index:0
  }
  .dots span{
    width:6px;
    height:6px;
    border-radius:50%;
    background:var(--orange)
  }

  header{
    position:relative;
    z-index:2;
    display:flex;
    align-items:center;
    gap:24px;
    padding:22px 60px;
    flex-wrap:wrap;
  }
  .logo{
    font-family:'Fraunces',serif;
    font-size:32px;
    font-weight:800;
    color:var(--olive-dark);
    display:flex;
    align-items:center
  }
  .logo .c{
    color:var(--olive);
    position:relative;
    margin-right:2px
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
    transform:rotate(35deg)
  }

  .search{
    flex:1;
    max-width:520px;
    background:#fff;
    border-radius:999px;
    display:flex;
    align-items:center;
    padding:12px 20px;
    gap:12px;
    box-shadow:0 2px 10px rgba(0,0,0,.04)
  }
  .search input{
    border:none;
    outline:none;
    flex:1;
    font-size:14px;
    background:transparent
  }
  .search svg{color:var(--olive)}

  .loc{
    display:flex;
    align-items:center;
    gap:6px;
    font-weight:600;
    font-size:14px;
    color:var(--ink);
  }
  .cart{
    position:relative;
    text-decoration:none;
    color:inherit;
  }
  .cart .badge{
    position:absolute;
    top:-6px;
    right:-8px;
    background:var(--orange);
    color:#fff;
    font-size:11px;
    font-weight:700;
    border-radius:999px;
    padding:2px 6px
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

  main{
    position:relative;
    z-index:1;
    max-width:1080px;
    margin:10px auto 0;
    padding:0 24px
  }

  .crumbs{
    font-size:13px;
    color:var(--muted);
    margin-bottom:14px
  }
  .crumbs a{
    color:var(--olive);
    text-decoration:none;
    margin-right:4px
  }
  .crumbs span{
    margin:0 6px;
    color:var(--muted)
  }
  .crumbs .cur{
    color:var(--ink);
    font-weight:600
  }

  .page-top{
    display:flex;
    justify-content:space-between;
    align-items:flex-end;
    gap:20px;
    flex-wrap:wrap;
    margin-bottom:24px
  }
  .title-wrap{
    position:relative
  }
  .title-wrap h1{
    font-family:'Fraunces',serif;
    font-size:38px;
    font-weight:700
  }
  .title-wrap .leaf{
    position:absolute;
    top:-4px;
    right:-46px;
    font-size:32px;
    opacity:.5
  }
  .title-wrap p{
    color:var(--muted);
    font-size:14px;
    margin-top:6px
  }

  .order-list{
    display:flex;
    flex-direction:column;
    gap:14px
  }

  .order{
    background:var(--card);
    border-radius:16px;
    padding:20px;
    display:grid;
    grid-template-columns:auto 1.1fr 1.2fr auto;
    gap:24px;
    align-items:center;
    box-shadow:0 2px 10px rgba(0,0,0,.03)
  }

  .food-thumb{
    width:110px;
    height:110px;
    border-radius:14px;
    object-fit:cover;
    background:#ddd;
  }

  .col-info .rest{
    display:flex;
    align-items:center;
    gap:4px;
    font-family:'Fraunces',serif;
    font-size:20px;
    font-weight:700
  }
  .col-info .cuisine{
    color:var(--muted);
    font-size:13px;
    margin-top:2px
  }
  .col-info .items{
    margin-top:14px;
    font-weight:600;
    font-size:14px
  }
  .col-info .date{
    color:var(--muted);
    font-size:13px;
    margin-top:4px
  }

  .col-meta{
    border-left:1px dashed var(--line);
    border-right:1px dashed var(--line);
    padding:0 24px;
    display:flex;
    flex-direction:column;
    gap:14px
  }
  .meta-row{
    display:flex;
    align-items:flex-start;
    gap:12px
  }
  .meta-row .ico{
    width:28px;
    height:28px;
    color:var(--olive-dark);
    flex-shrink:0;
    display:flex;
    align-items:center;
    justify-content:center
  }
  .topbar{
  position:relative;
  z-index:2;
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:20px;
  padding:22px 60px;
  flex-wrap:wrap;
}

.brand-block{
  display:flex;
  align-items:center;
  gap:14px;
}

.site-logo{
  display:flex;
  align-items:center;
}

.site-logo img{
  height:60px;
  width:auto;
  display:block;
  object-fit:contain;
}

.brand-text h2{
  margin:0;
  font-size:24px;
  font-weight:800;
  color:var(--ink);
  line-height:1.1;
}

.brand-text p{
  margin-top:4px;
  font-size:13px;
  color:var(--muted);
  font-weight:500;
}

.header-right{
  margin-left:auto;
  display:flex;
  align-items:center;
  gap:14px;
  flex-wrap:wrap;
}

.cart-btn{
  position:relative;
  text-decoration:none;
  background:#fff;
  color:inherit;
  padding:10px;
  border-radius:12px;
  box-shadow:0 2px 10px rgba(0,0,0,.04);
  display:flex;
  align-items:center;
  justify-content:center;
  font-size:20px;
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

.logout-btn{
  background:var(--olive-dark);
  color:#fff;
}
  .meta-row .lbl{
    font-size:12px;
    color:var(--muted)
  }
  .meta-row .val{
    font-size:14px;
    font-weight:600;
    margin-top:2px
  }

  .col-status{
    display:flex;
    flex-direction:column;
    align-items:flex-end;
    gap:10px;
    min-width:170px
  }
  .price{
    font-family:'Fraunces',serif;
    font-size:24px;
    font-weight:800
  }

  .status{
    display:flex;
    align-items:center;
    gap:8px;
    font-size:13px;
    font-weight:700
  }
  .status.placed{color:#0b7a3f}
  .status.delivered{color:var(--olive-dark)}
  .status.cancelled{color:var(--red)}
  .status.refunded{color:var(--orange)}

  .status .dot{
    width:18px;
    height:18px;
    border-radius:50%;
    color:#fff;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:11px;
    font-weight:700;
  }
  .status.placed .dot{background:#0b7a3f}
  .status.delivered .dot{background:var(--olive-dark)}
  .status.cancelled .dot{background:var(--red)}
  .status.refunded .dot{background:var(--orange)}

  .view-btn{
    margin-top:6px;
    padding:10px 22px;
    border:1.5px solid var(--olive-dark);
    color:var(--olive-dark);
    background:#fff;
    border-radius:10px;
    font-weight:600;
    font-size:13px;
    cursor:pointer
  }
  .view-btn:hover{background:var(--olive-soft)}

  .items-box{
    display:none;
    margin-top:16px;
    background:#fff;
    border:1px solid var(--line);
    border-radius:14px;
    padding:16px;
  }
  .items-box.show{
    display:block;
  }
  .items-box h4{
    margin-bottom:12px;
    font-size:16px;
    font-family:'Fraunces',serif;
  }
  .item-row{
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:10px 0;
    border-bottom:1px dashed var(--line);
    gap:14px;
  }
  .item-row:last-child{
    border-bottom:none;
  }
  .item-left{
    flex:1;
  }
  .item-name{
    font-weight:600;
    margin-bottom:4px;
  }
  .item-sub{
    color:var(--muted);
    font-size:13px;
  }
  .item-total{
    font-weight:700;
    white-space:nowrap;
  }

  .empty-box{
    background:var(--card);
    border-radius:18px;
    padding:40px;
    text-align:center;
    box-shadow:0 2px 10px rgba(0,0,0,.03);
  }
  .empty-box h2{
    margin-bottom:10px;
    font-family:'Fraunces',serif;
  }
  .empty-box p{
    color:var(--muted);
    margin-bottom:20px;
  }
  .empty-btn{
    display:inline-block;
    text-decoration:none;
    background:var(--olive-dark);
    color:#fff;
    padding:12px 22px;
    border-radius:12px;
    font-weight:700;
  }

  .support{
    background:var(--card);
    border-radius:16px;
    padding:18px 26px;
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:20px;
    margin-top:22px;
    flex-wrap:wrap;
    box-shadow:0 2px 10px rgba(0,0,0,.03)
  }
  .support .l{
    display:flex;
    align-items:center;
    gap:14px
  }
  .support .l .ico{
    width:44px;
    height:44px;
    background:var(--olive-soft);
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    color:var(--olive-dark)
  }
  .support .title{
    font-weight:600;
    font-size:15px
  }
  .support .sub{
    font-size:13px;
    color:var(--muted);
    margin-top:2px
  }
  .contact-btn{
    display:inline-flex;
    align-items:center;
    gap:8px;
    padding:12px 22px;
    border:1.5px solid var(--olive-dark);
    color:var(--olive-dark);
    background:#fff;
    border-radius:10px;
    font-weight:600;
    font-size:14px;
    cursor:pointer
  }

  @media (max-width:900px){
    header{padding:16px 20px;flex-wrap:wrap}
    .search{order:3;width:100%;max-width:none}
    .order{grid-template-columns:1fr;gap:14px}
    .col-meta{border:none;padding:0}
    .col-status{align-items:flex-start}
    .food-thumb{width:100%;height:220px}
  }
</style>
</head>
<body>

<div class="dots">
  <span></span><span></span><span></span><span></span><span></span><span></span>
  <span></span><span></span><span></span><span></span><span></span><span></span>
  <span></span><span></span><span></span><span></span><span></span><span></span>
</div>

<header class="topbar">
  <div class="brand-block">
    <a href="home" class="site-logo">
      <img src="images/cravix-logo.png" alt="Cravix Logo">
    </a>

    <div class="brand-text">
      <h2>Order History</h2>
      <p>Track and view all your past orders</p>
    </div>
  </div>

  <div class="header-right">
    <a href="cart" class="cart-btn">
      🛍️
      <span class="badge"><%= cartCount %></span>
    </a>

    <a href="profile" class="user-chip">Hi, <%= user.getFullName() %></a>
    <a href="home" class="nav-btn">Home</a>
    <a href="logout" class="nav-btn logout-btn">Logout</a>
  </div>
</header>

<main>
  <div class="crumbs">
    <a href="home">Home</a> <span>›</span>
    <span class="cur">Order History</span>
  </div>

  <div class="page-top">
    <div class="title-wrap">
      <h1>Order History</h1>
      <span class="leaf">🌿</span>
      <p>Track and view all your past orders</p>
    </div>
  </div>

  <%
      if (orderList == null || orderList.isEmpty()) {
  %>
      <div class="empty-box">
        <h2>No orders yet</h2>
        <p>You haven’t placed any orders yet. Start ordering your favorite food now.</p>
        <a href="home" class="empty-btn">Browse Restaurants</a>
      </div>
  <%
      } else {
  %>

  <div class="order-list">
    <%
        for (Orders order : orderList) {
            List<OrderItem> items = orderItemsMap.get(order.getOrderId());

            int itemCount = 0;
            String firstImage = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&h=300&fit=crop";
            String itemNames = "";

            if (items != null && !items.isEmpty()) {
                for (int i = 0; i < items.size(); i++) {
                    OrderItem oi = items.get(i);
                    itemCount += oi.getQuantity();

                    if (i == 0 && oi.getMenuItem() != null && oi.getMenuItem().getImagePath() != null
                            && !oi.getMenuItem().getImagePath().trim().isEmpty()) {
                        firstImage = oi.getMenuItem().getImagePath();
                    }

                    if (oi.getMenuItem() != null) {
                        itemNames += oi.getMenuItem().getItemName();
                        if (i != items.size() - 1) {
                            itemNames += ", ";
                        }
                    }
                }
            }

            String status = order.getStatus() != null ? order.getStatus().toLowerCase() : "placed";
    %>

    <div class="order">
      <img class="food-thumb" src="<%= firstImage %>" alt="order item">

      <div class="col-info">
        <div class="rest"><%= order.getRestaurant().getName() %></div>
        <div class="cuisine"><%= itemNames.isEmpty() ? "Food Order" : itemNames %></div>
        <div class="items"><%= itemCount %> item<%= itemCount != 1 ? "s" : "" %></div>
        <div class="date"><%= order.getOrderDate() %></div>
      </div>

      <div class="col-meta">
        <div class="meta-row">
          <div class="ico">#</div>
          <div>
            <div class="lbl">Order ID</div>
            <div class="val">#CRX<%= order.getOrderId() %></div>
          </div>
        </div>

        <div class="meta-row">
          <div class="ico">💳</div>
          <div>
            <div class="lbl">Payment Mode</div>
            <div class="val"><%= order.getPaymentMode() %></div>
          </div>
        </div>

        <div class="meta-row">
          <div class="ico">📍</div>
          <div>
            <div class="lbl">Delivered to</div>
            <div class="val"><%= order.getDeliveryAddress() %></div>
          </div>
        </div>
      </div>

      <div class="col-status">
        <div class="price">₹<%= order.getTotalAmount() %></div>

        <div class="status <%= status %>">
          <%= order.getStatus() %>
          <span class="dot">
            <%
                if ("cancelled".equals(status)) {
                    out.print("✕");
                } else if ("refunded".equals(status)) {
                    out.print("↺");
                } else {
                    out.print("✓");
                }
            %>
          </span>
        </div>

        <button type="button" class="view-btn" onclick="toggleItems('items-<%= order.getOrderId() %>')">
          View Details
        </button>
      </div>
    </div>

    <div id="items-<%= order.getOrderId() %>" class="items-box">
      <h4>Order Items</h4>

      <%
          if (items != null && !items.isEmpty()) {
              for (OrderItem item : items) {
                  BigDecimal lineTotal = item.getPrice().multiply(new BigDecimal(item.getQuantity()));
      %>
          <div class="item-row">
            <div class="item-left">
              <div class="item-name"><%= item.getMenuItem().getItemName() %></div>
              <div class="item-sub">Qty: <%= item.getQuantity() %> × ₹<%= item.getPrice() %></div>
            </div>
            <div class="item-total">₹<%= lineTotal %></div>
          </div>
      <%
              }
          } else {
      %>
          <p style="color:#777;">No items found for this order.</p>
      <%
          }
      %>
    </div>

    <% } %>
  </div>

  <% } %>

  <section class="support">
    <div class="l">
      <div class="ico">🎧</div>
      <div>
        <div class="title">Need help with your orders?</div>
        <div class="sub">Contact Cravix support for any delivery or payment issue.</div>
      </div>
    </div>
    <button class="contact-btn">Contact Support</button>
  </section>
</main>

<script>
  function toggleItems(id) {
    const box = document.getElementById(id);
    if (box) {
      box.classList.toggle('show');
    }
  }
</script>

</body>
</html>