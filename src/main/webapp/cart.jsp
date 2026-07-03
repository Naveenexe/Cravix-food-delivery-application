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
    if (cart == null) {
        cart = new LinkedHashMap<>();
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

    BigDecimal deliveryFee = cart.isEmpty() ? BigDecimal.ZERO : new BigDecimal("30");
    BigDecimal packagingFee = cart.isEmpty() ? BigDecimal.ZERO : new BigDecimal("20");
    BigDecimal total = subtotal.add(deliveryFee).add(packagingFee);
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Cravix — Your Cart</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<style>
  :root{
    --olive:#5a6b1f;
    --olive-dark:#455217;
    --olive-soft:#e8ecd4;
    --cream:#fbf7ec;
    --cream-2:#f5efdd;
    --orange:#f0932b;
    --text:#2a2a2a;
    --muted:#7a7a70;
    --border:#ece7d3;
    --white:#ffffff;
    --red:#c0392b;
    --green:#27ae60;
    --shadow:0 4px 20px rgba(70,70,40,.06);
  }

  *{
    box-sizing:border-box;
    margin:0;
    padding:0;
    font-family:'Plus Jakarta Sans',sans-serif;
  }

  body{
    background:var(--cream);
    color:var(--text);
    min-height:100vh;
    position:relative;
    overflow-x:hidden;
  }

  a{
    text-decoration:none;
    color:inherit;
  }

  button{
    cursor:pointer;
    border:none;
    background:none;
    font-family:inherit;
  }

  .bg-shape{
    position:absolute;
    z-index:0;
    pointer-events:none;
  }

  .shape-leaf-left{
    bottom:60px;
    left:-30px;
    width:180px;
    opacity:.55;
  }

  .shape-blob{
    bottom:-40px;
    left:-40px;
    width:280px;
    height:180px;
    background:var(--olive);
    border-radius:50% 50% 0 40%/60% 40% 0 40%;
    opacity:.85;
  }

  .shape-dots{
    bottom:80px;
    right:40px;
    width:120px;
    height:120px;
    background-image:radial-gradient(var(--orange) 2px, transparent 2px);
    background-size:14px 14px;
    opacity:.4;
  }

  header{
    position:relative;
    z-index:5;
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:18px;
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
    flex-shrink:0;
  }

  .site-logo img{
    height:60px;
    width:auto;
    display:block;
    object-fit:contain;
  }

  .brand-text h2{
    font-size:22px;
    font-weight:800;
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

  .header-right{
    margin-left:auto;
    display:flex;
    align-items:center;
    gap:14px;
    flex-wrap:wrap;
  }

  .cart-btn{
    position:relative;
    padding:10px;
    background:#fff;
    border-radius:12px;
    box-shadow:var(--shadow);
    display:flex;
    align-items:center;
    justify-content:center;
  }

  .cart-badge{
    position:absolute;
    top:-4px;
    right:-4px;
    background:var(--orange);
    color:#fff;
    font-size:11px;
    font-weight:700;
    border-radius:999px;
    padding:2px 6px;
  }

  .user-chip{
    background:#fff;
    padding:10px 16px;
    border-radius:12px;
    box-shadow:var(--shadow);
    font-weight:700;
    transition:.2s ease;
  }

  .user-chip:hover{
    transform:translateY(-1px);
  }

  .nav-btn{
    background:#fff;
    padding:10px 16px;
    border-radius:12px;
    box-shadow:var(--shadow);
    font-weight:700;
    transition:.2s ease;
  }

  .nav-btn:hover{
    transform:translateY(-1px);
  }

  .logout-btn{
    background:var(--olive);
    color:#fff;
    padding:10px 16px;
    border-radius:12px;
    font-weight:700;
  }

  main{
    position:relative;
    z-index:2;
    padding:20px 60px 60px;
  }

  .breadcrumb{
    font-size:14px;
    color:var(--muted);
    display:flex;
    align-items:center;
    gap:8px;
    margin-bottom:24px;
  }

  .breadcrumb .current{
    color:var(--text);
    font-weight:600;
  }

  .grid{
    display:grid;
    grid-template-columns:1fr 380px;
    gap:32px;
    align-items:start;
  }

  .page-title{
    display:flex;
    align-items:center;
    gap:12px;
  }

  h1{
    font-size:42px;
    font-weight:800;
    letter-spacing:-1px;
  }

  .sub{
    color:var(--muted);
    font-size:15px;
    margin:6px 0 24px;
  }

  .sub b{
    color:var(--olive);
    font-weight:700;
  }

  .item{
    background:var(--white);
    border:1px solid var(--border);
    border-radius:18px;
    padding:18px;
    display:grid;
    grid-template-columns:120px 1fr auto;
    gap:20px;
    align-items:center;
    margin-bottom:16px;
    box-shadow:var(--shadow);
  }

  .item img{
    width:120px;
    height:120px;
    border-radius:14px;
    object-fit:cover;
  }

  .item .info h3{
    font-size:18px;
    font-weight:700;
    display:flex;
    align-items:center;
    gap:8px;
    margin-bottom:6px;
  }

  .veg,.nonveg{
    width:14px;
    height:14px;
    border:2px solid var(--green);
    display:inline-flex;
    align-items:center;
    justify-content:center;
    border-radius:3px;
  }

  .veg::after{
    content:"";
    width:6px;
    height:6px;
    background:var(--green);
    border-radius:50%;
  }

  .nonveg{
    border-color:var(--red);
  }

  .nonveg::after{
    content:"";
    width:6px;
    height:6px;
    background:var(--red);
    border-radius:50%;
  }

  .item .desc{
    color:var(--muted);
    font-size:13.5px;
    line-height:1.5;
    margin-bottom:10px;
    max-width:280px;
  }

  .price{
    font-size:17px;
    font-weight:800;
    color:var(--text);
  }

  .item .actions{
    display:flex;
    flex-direction:column;
    align-items:flex-end;
    gap:16px;
    height:100%;
    justify-content:space-between;
  }

  .qty{
    display:inline-flex;
    align-items:center;
    background:var(--cream-2);
    border-radius:10px;
    padding:6px 10px;
    gap:12px;
    font-weight:700;
  }

  .qty form{
    margin:0;
  }

  .qty button{
    font-size:18px;
    color:var(--olive);
    font-weight:700;
    background:none;
    border:none;
    padding:0 4px;
  }

  .trash{
    color:var(--muted);
    padding:4px;
    background:none;
    border:none;
  }

  .trash:hover{
    color:var(--red);
  }

  .action-row{
    background:var(--white);
    border:1px solid var(--border);
    border-radius:14px;
    padding:16px 20px;
    display:flex;
    align-items:center;
    gap:12px;
    margin-top:14px;
    font-weight:600;
    font-size:14.5px;
    color:var(--text);
  }

  .action-row .right{
    margin-left:auto;
    display:flex;
    align-items:center;
    gap:6px;
    color:var(--olive);
    font-weight:700;
  }

  .summary{
    background:var(--white);
    border:1px solid var(--border);
    border-radius:20px;
    padding:26px;
    box-shadow:var(--shadow);
    position:sticky;
    top:20px;
  }

  .summary h2{
    font-size:22px;
    font-weight:800;
    margin-bottom:18px;
  }

  .line{
    display:flex;
    justify-content:space-between;
    font-size:14.5px;
    padding:8px 0;
    color:#444;
  }

  .dash{
    border:none;
    border-top:1px dashed var(--border);
    margin:12px 0;
  }

  .total{
    display:flex;
    justify-content:space-between;
    align-items:center;
    font-weight:800;
  }

  .total .t{
    font-size:20px;
  }

  .total .v{
    font-size:22px;
    color:var(--olive-dark);
  }

  .checkout{
    width:100%;
    background:var(--olive);
    color:#fff;
    padding:16px;
    border-radius:12px;
    font-weight:700;
    font-size:16px;
    display:flex;
    align-items:center;
    justify-content:center;
    gap:10px;
    margin-top:18px;
  }

  .checkout:hover{
    background:var(--olive-dark);
  }

  .rest-card{
    margin-top:18px;
    background:var(--cream-2);
    border-radius:14px;
    padding:14px;
    display:flex;
    align-items:center;
    gap:12px;
  }

  .rest-card .lg{
    width:44px;
    height:44px;
    border-radius:50%;
    background:var(--olive-soft);
    display:grid;
    place-items:center;
    color:var(--olive);
  }

  .rest-card .info strong{
    display:block;
    font-size:14.5px;
    font-weight:700;
  }

  .rest-card .info small{
    color:var(--muted);
    font-size:12.5px;
  }

  .empty-cart{
    background:var(--white);
    border:1px solid var(--border);
    border-radius:18px;
    padding:30px;
    box-shadow:var(--shadow);
    text-align:center;
  }

  .empty-cart h3{
    font-size:24px;
    margin-bottom:10px;
    color:var(--olive-dark);
  }

  .empty-cart p{
    color:var(--muted);
    margin-bottom:20px;
  }

  .empty-cart a{
    display:inline-block;
    background:var(--olive);
    color:#fff;
    padding:12px 20px;
    border-radius:12px;
    font-weight:700;
  }

  @media(max-width:1024px){
    .grid{
      grid-template-columns:1fr;
    }

    header,main{
      padding-left:24px;
      padding-right:24px;
    }
  }

  @media(max-width:768px){
    .brand-block{
      width:100%;
    }

    .header-right{
      margin-left:0;
      width:100%;
      justify-content:flex-start;
    }
  }

  @media(max-width:640px){
    .item{
      grid-template-columns:90px 1fr;
    }

    .item img{
      width:90px;
      height:90px;
    }

    .item .actions{
      flex-direction:row;
      grid-column:1/-1;
      justify-content:space-between;
    }

    h1{
      font-size:32px;
    }

    .brand-text h2{
      font-size:18px;
    }

    .brand-text p{
      font-size:12px;
    }
  }
</style>
</head>
<body>

<header>
  <div class="brand-block">
    <a href="home" class="site-logo">
      <img src="images/cravix-logo.png" alt="Cravix Logo">
    </a>

    <div class="brand-text">
      <h2>Your Cart</h2>
      <p>Review items and place your order</p>
    </div>
  </div>

  <div class="header-right">
    <a href="cart" class="cart-btn">
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/>
        <path d="M3 6h18"/>
        <path d="M16 10a4 4 0 0 1-8 0"/>
      </svg>
      <span class="cart-badge"><%= totalItems %></span>
    </a>

    <a href="profile" class="user-chip">Hi, <%= user.getFullName() %></a>
    <a href="home" class="nav-btn">Home</a>
    <a href="logout" class="logout-btn">Logout</a>
  </div>
</header>

<main>
  <div class="breadcrumb">
    <span>Home</span>
    <span>›</span>
    <span class="current">Cart</span>
  </div>

  <div class="grid">

    <section>
      <div class="page-title">
        <h1>Your Cart</h1>
      </div>
      <p class="sub"><%= totalItems %> item(s) from <b><%= restaurantName %></b></p>

      <%
          if (cart.isEmpty()) {
      %>
          <div class="empty-cart">
              <h3>Your cart is empty</h3>
              <p>Add some delicious food from restaurants and it will appear here.</p>
              <a href="home">Browse Restaurants</a>
          </div>
      <%
          } else {
              for (CartItem item : cart.values()) {
      %>
          <div class="item">
            <img src="<%= item.getImagePath() != null ? item.getImagePath() : "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&auto=format&fit=crop&q=60" %>" alt="<%= item.getItemName() %>"/>

            <div class="info">
              <h3><span class="veg"></span><%= item.getItemName() %></h3>
              <p class="desc"><%= item.getRestaurantName() %></p>
              <div class="price">₹ <%= item.getPrice() %></div>
            </div>

            <div class="actions">
              <div class="qty">
                <form action="cart" method="post">
                  <input type="hidden" name="action" value="decrease">
                  <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                  <button type="submit">−</button>
                </form>

                <span><%= item.getQuantity() %></span>

                <form action="cart" method="post">
                  <input type="hidden" name="action" value="increase">
                  <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                  <button type="submit">+</button>
                </form>
              </div>

              <div class="price">₹ <%= item.getTotalPrice() %></div>

              <form action="cart" method="post">
                <input type="hidden" name="action" value="remove">
                <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                <button type="submit" class="trash">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M3 6h18"/>
                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/>
                    <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
                  </svg>
                </button>
              </form>
            </div>
          </div>
      <%
              }
          }
      %>

      <div class="action-row">
        Add cooking instructions / notes
        <div class="right">Coming soon</div>
      </div>

      <div class="action-row">
        Apply Coupon
        <div class="right">Coming soon</div>
      </div>
    </section>

    <aside class="summary">
      <h2>Order Summary</h2>

      <div class="line">
        <span>Subtotal (<%= totalItems %> items)</span>
        <b>₹ <%= subtotal %></b>
      </div>

      <div class="line">
        <span>Delivery Fee</span>
        <b>₹ <%= deliveryFee %></b>
      </div>

      <div class="line">
        <span>Packaging Fee</span>
        <b>₹ <%= packagingFee %></b>
      </div>

      <hr class="dash"/>

      <div class="total">
        <span class="t">Total</span>
        <span class="v">₹ <%= total %></span>
      </div>

      <a href="checkout" style="text-decoration:none;">
        <button type="button" class="checkout">Proceed to Checkout</button>
      </a>

      <div class="rest-card">
        <div class="lg">🍽</div>
        <div class="info">
          <strong><%= restaurantName %></strong>
          <small>Fresh food, fast delivery</small>
        </div>
      </div>
    </aside>

  </div>
</main>

<svg class="bg-shape shape-leaf-left" viewBox="0 0 200 200">
  <path d="M20 180 C60 100 120 60 190 40 C170 110 110 170 20 180Z" fill="#c9d18a" opacity=".6"/>
</svg>
<div class="bg-shape shape-blob"></div>
<div class="bg-shape shape-dots"></div>

</body>
</html>