<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.cravix.model.Restaurant" %>
<%@ page import="com.cravix.model.MenuItem" %>
<%@ page import="com.cravix.model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<MenuItem> menuItemList = (List<MenuItem>) request.getAttribute("menuItemList");

    if (restaurant == null) {
        response.sendRedirect("home");
        return;
    }

    if (menuItemList == null) {
        menuItemList = new ArrayList<>();
    }

    LinkedHashMap<String, List<MenuItem>> categoryMap = new LinkedHashMap<>();
    for (MenuItem item : menuItemList) {
        String category = item.getCategory();
        if (category == null || category.trim().isEmpty()) {
            category = "Recommended";
        }
        categoryMap.computeIfAbsent(category, k -> new ArrayList<>()).add(item);
    }

    String firstCategory = categoryMap.isEmpty() ? "Menu" : categoryMap.keySet().iterator().next();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Cravix — <%= restaurant.getName() %></title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<style>
  :root{
    --cream:#f6f1e4;
    --cream-2:#efe8d4;
    --card:#ffffff;
    --olive:#6b7a2a;
    --olive-dark:#5b6a22;
    --olive-deep:#3d4a15;
    --yellow:#f2b81e;
    --brown:#2b1e10;
    --text:#2b1e10;
    --muted:#8a7f6b;
    --border:#ece4d0;
    --veg:#0a8a3a;
    --nonveg:#d63a2f;
  }

  *{box-sizing:border-box;margin:0;padding:0;}
  html,body{
    background:var(--cream);
    color:var(--text);
    font-family:'Plus Jakarta Sans',sans-serif;
    -webkit-font-smoothing:antialiased;
  }
  body{
    position:relative;
    overflow-x:hidden;
    padding-bottom:40px;
  }

  body::before{
    content:"";
    position:absolute;
    left:-120px;
    bottom:120px;
    width:280px;
    height:220px;
    background:var(--olive);
    border-radius:60% 40% 55% 45%/60% 55% 45% 40%;
    opacity:.9;
    z-index:0;
  }

  body::after{
    content:"";
    position:absolute;
    right:-80px;
    bottom:60px;
    width:220px;
    height:220px;
    background:radial-gradient(circle, var(--yellow) 2px, transparent 3px) 0 0/18px 18px;
    opacity:.55;
    z-index:0;
  }

  .leaf-l{
    position:absolute;
    left:20px;
    bottom:260px;
    width:110px;
    height:180px;
    opacity:.5;
    z-index:0;
  }

  .container{
    max-width:1200px;
    margin:0 auto;
    padding:22px 28px;
    position:relative;
    z-index:2;
  }

  .header{
    display:flex;
    align-items:center;
    gap:22px;
    flex-wrap:wrap;
  }

  .logo{
    display:flex;
    align-items:center;
    gap:2px;
    font-weight:800;
    font-size:34px;
    color:var(--olive-deep);
    letter-spacing:-.5px;
    text-decoration:none;
  }

  .logo .c{
    position:relative;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    width:38px;
    height:38px;
    border:4px solid var(--olive-deep);
    border-right-color:transparent;
    border-radius:50%;
    transform:rotate(-25deg);
    margin-right:4px;
  }

  .logo .c::after{
    content:"";
    position:absolute;
    top:-6px;
    right:2px;
    width:8px;
    height:8px;
    background:var(--yellow);
    border-radius:50%;
    box-shadow:6px 4px 0 -2px var(--yellow),-4px 6px 0 -2px var(--yellow);
  }

  .search{
    flex:1;
    max-width:420px;
    position:relative;
  }

  .search input{
    width:100%;
    height:52px;
    border-radius:999px;
    border:none;
    background:#fff;
    padding:0 20px 0 52px;
    font-size:15px;
    color:var(--text);
    box-shadow:0 6px 18px rgba(60,50,20,.06);
    outline:none;
    font-family:inherit;
  }

  .search svg{
    position:absolute;
    left:20px;
    top:50%;
    transform:translateY(-50%);
    color:var(--muted);
  }

  .location{
    display:flex;
    align-items:center;
    gap:8px;
    font-weight:600;
    color:var(--brown);
  }

  .avatar{
    margin-left:auto;
    display:flex;
    align-items:center;
    gap:12px;
    flex-wrap:wrap;
  }

  .user-chip{
    background:#fff;
    padding:10px 16px;
    border-radius:999px;
    box-shadow:0 6px 18px rgba(60,50,20,.06);
    font-weight:700;
    color:var(--brown);
  }

  .nav-btn{
    text-decoration:none;
    background:#fff;
    color:var(--brown);
    padding:10px 16px;
    border-radius:12px;
    box-shadow:0 6px 18px rgba(60,50,20,.06);
    font-weight:700;
  }

  .logout-btn{
    text-decoration:none;
    background:var(--olive);
    color:#fff;
    padding:10px 16px;
    border-radius:12px;
    font-weight:700;
  }

  .banner{
    margin-top:22px;
    border-radius:20px;
    overflow:hidden;
    padding:22px;
    display:flex;
    gap:22px;
    align-items:center;
    color:#fff;
    background-image:
      linear-gradient(90deg,rgba(20,14,8,.75),rgba(20,14,8,.35)),
      url('<%= restaurant.getImagePath() %>');
    background-size:cover;
    background-position:center;
    position:relative;
  }

  .rest-logo{
    width:130px;
    height:130px;
    background:#3d4a15;
    border:3px solid #fff2;
    border-radius:18px;
    display:flex;
    flex-direction:column;
    align-items:center;
    justify-content:center;
    color:#eadf8a;
    font-weight:800;
    font-size:12px;
    letter-spacing:1px;
    text-align:center;
    flex-shrink:0;
    text-transform:uppercase;
  }

  .rest-logo .leaf{
    font-size:36px;
    margin-bottom:6px;
  }

  .rest-info h1{
    font-size:32px;
    display:flex;
    align-items:center;
    gap:8px;
  }

  .verified{
    width:22px;
    height:22px;
    background:var(--olive);
    border-radius:50%;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    color:#fff;
    font-size:12px;
  }

  .rest-info p{
    color:#e9dfc9;
    margin-top:4px;
    font-size:15px;
  }

  .meta{
    margin-top:10px;
    display:flex;
    align-items:center;
    gap:10px;
    color:#e9dfc9;
    font-size:14px;
    flex-wrap:wrap;
  }

  .rating{
    background:var(--olive);
    color:#fff;
    padding:4px 10px;
    border-radius:6px;
    font-weight:700;
    font-size:13px;
    display:inline-flex;
    align-items:center;
    gap:4px;
  }

  .banner-actions{
    margin-left:auto;
    display:flex;
    gap:10px;
  }

  .icon-btn{
    width:44px;
    height:44px;
    background:#fff;
    border-radius:12px;
    display:flex;
    align-items:center;
    justify-content:center;
    color:var(--brown);
    border:none;
  }

  .perks{
    margin-top:14px;
    background:var(--cream-2);
    border-radius:14px;
    padding:14px 22px;
    display:flex;
    justify-content:space-around;
    align-items:center;
    gap:12px;
    color:var(--brown);
    font-size:14px;
    font-weight:500;
    flex-wrap:wrap;
  }

  .perks > div{
    display:flex;
    align-items:center;
    gap:8px;
    flex:1;
    justify-content:center;
    min-width:220px;
  }

  .perks .sep{
    width:1px;
    height:22px;
    background:#d9cfb4;
    flex:0;
  }

  .perks svg{
    color:var(--olive);
  }

  .tabs{
    margin-top:22px;
    display:flex;
    gap:28px;
    border-bottom:1px solid var(--border);
    padding:0 4px;
  }

  .tab{
    padding:14px 4px;
    color:var(--muted);
    font-weight:600;
    position:relative;
    font-size:15px;
  }

  .tab.active{
    color:var(--brown);
  }

  .tab.active::after{
    content:"";
    position:absolute;
    left:0;
    right:0;
    bottom:-1px;
    height:3px;
    background:var(--olive-deep);
    border-radius:2px;
  }

  .grid{
    margin-top:20px;
    display:grid;
    grid-template-columns:220px 1fr 320px;
    gap:22px;
    align-items:start;
  }

  .sidebar{
    background:#fff;
    border-radius:18px;
    padding:12px;
    box-shadow:0 8px 24px rgba(60,50,20,.05);
  }

  .cat{
    display:flex;
    align-items:center;
    gap:12px;
    padding:12px 14px;
    border-radius:12px;
    color:var(--brown);
    font-weight:600;
    font-size:15px;
  }

  .cat.active{
    background:var(--olive-deep);
    color:#fff;
  }

  .promo{
    margin:14px 8px 4px;
    background:var(--cream-2);
    border-radius:14px;
    padding:18px 16px;
    position:relative;
    overflow:hidden;
  }

  .promo h4{
    font-size:16px;
    color:var(--brown);
    font-weight:800;
  }

  .promo p{
    font-size:12px;
    color:var(--muted);
    margin-top:4px;
  }

  .promo .stamp{
    position:absolute;
    right:10px;
    bottom:10px;
    width:34px;
    height:34px;
    background:var(--olive);
    color:#fff;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    font-weight:700;
  }

  .menu-col h2{
    font-size:22px;
    color:var(--brown);
    font-weight:800;
    display:flex;
    align-items:center;
    gap:8px;
  }

  .menu-col .sub{
    color:var(--muted);
    font-size:13px;
    margin-top:2px;
    margin-bottom:14px;
  }

  .section-title{
    margin-top:22px;
    display:flex;
    align-items:center;
    gap:8px;
    font-size:18px;
    font-weight:800;
    color:var(--brown);
  }

  .item{
    background:#fff;
    border-radius:16px;
    padding:16px;
    display:flex;
    gap:16px;
    margin-top:14px;
    box-shadow:0 6px 18px rgba(60,50,20,.05);
  }

  .item-info{
    flex:1;
    min-width:0;
  }

  .item-title{
    display:flex;
    align-items:center;
    gap:8px;
    font-weight:700;
    color:var(--brown);
    font-size:16px;
  }

  .dot{
    width:14px;
    height:14px;
    border:1.5px solid var(--veg);
    display:inline-flex;
    align-items:center;
    justify-content:center;
    border-radius:3px;
    flex-shrink:0;
  }

  .dot::after{
    content:"";
    width:6px;
    height:6px;
    background:var(--veg);
    border-radius:50%;
  }

  .dot.nv{
    border-color:var(--nonveg);
  }

  .dot.nv::after{
    background:var(--nonveg);
  }

  .item p{
    color:var(--muted);
    font-size:13.5px;
    margin-top:8px;
    line-height:1.5;
  }

  .item-foot{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-top:14px;
    gap:12px;
  }

  .price{
    font-weight:700;
    color:var(--brown);
    font-size:15px;
  }

  .add-btn{
    background:var(--olive);
    color:#fff;
    border:none;
    padding:8px 18px;
    border-radius:8px;
    font-weight:700;
    cursor:pointer;
    font-family:inherit;
    font-size:13px;
    display:inline-flex;
    align-items:center;
    gap:4px;
  }

  .add-btn:hover{
    background:var(--olive-dark);
  }

  .item-img{
    width:150px;
    height:130px;
    border-radius:12px;
    object-fit:cover;
    flex-shrink:0;
  }

  .empty-menu{
    background:#fff;
    border-radius:16px;
    padding:28px;
    color:var(--muted);
    margin-top:16px;
    box-shadow:0 6px 18px rgba(60,50,20,.05);
  }

  .order{
    background:#fff;
    border-radius:18px;
    padding:20px;
    box-shadow:0 8px 24px rgba(60,50,20,.06);
    position:sticky;
    top:20px;
  }

  .order-head{
    display:flex;
    justify-content:space-between;
    align-items:flex-end;
  }

  .order-head h3{
    font-size:19px;
    font-weight:800;
    color:var(--brown);
  }

  .order-head .clear{
    color:var(--yellow);
    font-weight:700;
    font-size:13px;
  }

  .order-items{
    color:var(--muted);
    font-size:13px;
    margin-top:2px;
  }

  .order-placeholder{
    margin-top:20px;
    padding:18px;
    background:var(--cream);
    border-radius:14px;
    color:var(--muted);
    font-size:14px;
    line-height:1.6;
  }

  .divider{
    height:1px;
    background:var(--border);
    margin:18px 0;
    border-top:1px dashed var(--border);
  }

  .fee{
    display:flex;
    justify-content:space-between;
    font-size:14px;
    color:var(--brown);
    margin-top:8px;
  }

  .fee .lbl{
    color:var(--muted);
  }

  .coupon{
    margin-top:16px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    background:var(--cream);
    border-radius:10px;
    padding:12px 14px;
    color:var(--brown);
    font-weight:600;
    font-size:14px;
  }

  .coupon .l{
    display:inline-flex;
    align-items:center;
    gap:8px;
    color:var(--olive);
  }

  .total{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-top:18px;
    font-size:20px;
    font-weight:800;
    color:var(--brown);
  }

  .view-cart{
    margin-top:14px;
    width:100%;
    background:var(--olive);
    color:#fff;
    border:none;
    padding:14px;
    border-radius:12px;
    font-weight:700;
    font-size:15px;
    cursor:pointer;
    font-family:inherit;
  }

  .features{
    margin:32px auto 0;
    max-width:1000px;
    background:#fff;
    border-radius:16px;
    padding:18px 24px;
    display:flex;
    justify-content:space-around;
    flex-wrap:wrap;
    gap:18px;
    box-shadow:0 8px 24px rgba(60,50,20,.05);
    position:relative;
    z-index:2;
  }

  .feature{
    display:flex;
    align-items:center;
    gap:12px;
  }

  .feature .ic{
    width:38px;
    height:38px;
    border-radius:50%;
    background:var(--cream);
    display:flex;
    align-items:center;
    justify-content:center;
    color:var(--olive);
  }

  .feature b{
    display:block;
    color:var(--brown);
    font-size:14px;
  }

  .feature small{
    color:var(--muted);
    font-size:12px;
  }

  @media (max-width:1024px){
    .grid{grid-template-columns:1fr;}
    .sidebar{display:flex;overflow-x:auto;gap:8px;}
    .cat{white-space:nowrap;flex-shrink:0;}
    .order{position:static;}
  }

  @media (max-width:768px){
    .banner{
      flex-direction:column;
      align-items:flex-start;
    }

    .banner-actions{
      margin-left:0;
    }

    .item{
      flex-direction:column-reverse;
    }

    .item-img{
      width:100%;
      height:220px;
    }

    .avatar{
      margin-left:0;
    }
  }
</style>
</head>
<body>

<svg class="leaf-l" viewBox="0 0 100 160" fill="none">
  <path d="M50 10 C20 40 20 100 50 150 C80 100 80 40 50 10 Z" fill="#c9d29a" opacity=".7"/>
  <path d="M50 15 L50 145" stroke="#a9b47a" stroke-width="1.5"/>
</svg>

<div class="container">

  <!-- Header -->
  <div class="header">
    <a href="home" class="logo"><span class="c"></span>ravix</a>

    <div class="search">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <circle cx="11" cy="11" r="8"/>
        <path d="m21 21-4.3-4.3"/>
      </svg>
      <input placeholder="Search inside menu..." />
    </div>

    <div class="location">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/>
        <circle cx="12" cy="10" r="3"/>
      </svg>
      <%= restaurant.getAddress() %>
    </div>

    <div class="avatar">
      <div class="user-chip">Hi, <%= user.getFullName() %></div>
      <a href="home" class="nav-btn">Home</a>
      <a href="logout" class="logout-btn">Logout</a>
    </div>
  </div>

  <!-- Banner -->
  <div class="banner">
    <div class="rest-logo">
      <span class="leaf">🍽️</span>
      <%= restaurant.getName().toUpperCase() %>
    </div>

    <div class="rest-info">
      <h1><%= restaurant.getName() %> <span class="verified">✓</span></h1>
      <p><%= restaurant.getCuisineType() %></p>
      <div class="meta">
        <span class="rating">★ <%= restaurant.getRating() %></span>
        <span>• Fresh food • Fast delivery</span>
      </div>
    </div>

    <div class="banner-actions">
      <button class="icon-btn" title="Save">
        ❤
      </button>
      <button class="icon-btn" title="Share">
        ↗
      </button>
    </div>
  </div>

  <!-- Perks -->
  <div class="perks">
    <div>🚚 Free delivery on orders above ₹199</div>
    <div class="sep"></div>
    <div>🛡 Hygienic packaging</div>
    <div class="sep"></div>
    <div>⭐ Top rated restaurant</div>
  </div>

  <!-- Tabs -->
  <div class="tabs">
    <div class="tab active">Menu</div>
    <div class="tab">Reviews</div>
    <div class="tab">Photos</div>
    <div class="tab">About</div>
  </div>

  <!-- Main Grid -->
  <div class="grid">

    <!-- Sidebar -->
    <div class="sidebar">
      <div class="cat active"><%= firstCategory %></div>

      <%
          boolean firstSkipped = false;
          for (String category : categoryMap.keySet()) {
              if (!firstSkipped) {
                  firstSkipped = true;
                  continue;
              }
      %>
          <div class="cat"><%= category %></div>
      <%
          }
      %>

      <div class="promo">
        <h4>Flat 20% OFF</h4>
        <p>on orders above ₹499</p>
        <div class="stamp">%</div>
      </div>
    </div>

    <!-- Menu Column -->
    <div class="menu-col">

      <%
          if (categoryMap.isEmpty()) {
      %>
          <h2>Menu</h2>
          <div class="sub">No menu items available right now</div>
          <div class="empty-menu">This restaurant doesn’t have menu items added yet.</div>
      <%
          } else {
              boolean firstSection = true;
              for (Map.Entry<String, List<MenuItem>> entry : categoryMap.entrySet()) {
                  String category = entry.getKey();
                  List<MenuItem> items = entry.getValue();

                  if (firstSection) {
      %>
                      <h2><%= category %></h2>
                      <div class="sub">Curated picks from <%= restaurant.getName() %></div>
      <%
                      firstSection = false;
                  } else {
      %>
                      <div class="section-title"><%= category %></div>
      <%
                  }

                  for (MenuItem item : items) {
      %>
                      <div class="item">
                        <div class="item-info">
                          <div class="item-title">
                            <span class="dot"></span>
                            <%= item.getItemName() %>
                          </div>

                          <p>
                            <%= item.getDescription() != null ? item.getDescription() : "Delicious item from " + restaurant.getName() %>
                          </p>

                          <div class="item-foot">
                            <div class="price">₹ <%= item.getPrice() %></div>
                            <button class="add-btn">+ Add</button>
                          </div>
                        </div>

                        <img class="item-img"
                             src="<%= item.getImagePath() != null ? item.getImagePath() : "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&auto=format&fit=crop&q=60" %>"
                             alt="<%= item.getItemName() %>"/>
                      </div>
      <%
                  }
              }
          }
      %>
    </div>

    <!-- Order Panel UI placeholder -->
    <div class="order">
      <div class="order-head">
        <div>
          <h3>Your Order</h3>
          <div class="order-items">Cart module coming next</div>
        </div>
        <div class="clear">Soon</div>
      </div>

      <div class="order-placeholder">
        This panel is ready for the cart flow. Once we wire the Add to Cart module, selected items, quantity, subtotal, delivery fee and total will show here automatically.
      </div>

      <div class="divider"></div>

      <div class="fee"><span class="lbl">Subtotal</span><span>₹0</span></div>
      <div class="fee"><span class="lbl">Delivery Fee</span><span>₹0</span></div>
      <div class="fee"><span class="lbl">Packaging Fee</span><span>₹0</span></div>

      <div class="coupon">
        <span class="l">🎟 Apply Coupon</span>
        <span>›</span>
      </div>

      <div class="divider"></div>
      <div class="total"><span>Total</span><span>₹0</span></div>

      <button class="view-cart">View Cart</button>
    </div>

  </div>

  <!-- Features -->
  <div class="features">
    <div class="feature">
      <div class="ic">🚚</div>
      <div><b>Fast Delivery</b><small>At your doorstep</small></div>
    </div>
    <div class="feature">
      <div class="ic">🍽</div>
      <div><b>Best Quality</b><small>Fresh & Tasty</small></div>
    </div>
    <div class="feature">
      <div class="ic">🔒</div>
      <div><b>Safe Payment</b><small>100% Secure</small></div>
    </div>
    <div class="feature">
      <div class="ic">↺</div>
      <div><b>Easy Ordering</b><small>Simple checkout</small></div>
    </div>
  </div>

</div>

</body>
</html>