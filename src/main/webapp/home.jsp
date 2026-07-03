<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cravix.model.Restaurant" %>
<%@ page import="com.cravix.model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Restaurant> restaurantList = (List<Restaurant>) request.getAttribute("restaurantList");
    String search = (String) request.getAttribute("search");
    if (search == null) search = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Cravix — Good Food. Great Moments.</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  :root {
    --cream: #faf6ec;
    --cream-2: #fcfbf3;
    --olive: #6b7a2a;
    --olive-dark: #556322;
    --dark: #2b2416;
    --dark-2: #1f1a10;
    --yellow: #f5b829;
    --text: #2b2416;
    --muted: #7a7365;
    --line: #ece7d5;
    --white: #ffffff;
    --star-bg: #4a5a1e;
  }
  html, body { background: var(--cream); color: var(--text); font-family: 'Plus Jakarta Sans', sans-serif; -webkit-font-smoothing: antialiased; }
  body { min-height: 100vh; padding: 28px 0 60px; position: relative; overflow-x: hidden; }

  .leaf-bg { position: absolute; left: -30px; top: 62%; width: 180px; opacity: .55; pointer-events: none; }
  .blob { position: absolute; left: -80px; bottom: -80px; width: 260px; height: 260px; background: #8a9a3d; border-radius: 50%; opacity: .55; pointer-events: none; }
  .dots { position: absolute; right: 40px; bottom: 40px; width: 200px; height: 140px;
    background-image: radial-gradient(circle, #f5b829 2px, transparent 2px);
    background-size: 16px 16px; opacity: .55; pointer-events: none; }
  .bubble { position: absolute; right: -60px; bottom: -80px; width: 220px; height: 220px; background: #fdeecb; border-radius: 50%; opacity: .55; pointer-events: none; }

  .container { max-width: 1200px; margin: 0 auto; padding: 0 24px; position: relative; z-index: 2; }

  .header { display: flex; align-items: center; gap: 24px; margin-bottom: 24px; flex-wrap: wrap; }
  .logo { font-size: 34px; font-weight: 800; color: var(--dark); letter-spacing: -.5px; position: relative; }
  .logo .c { color: var(--olive); position: relative; }
  .logo .c::after {
    content: ""; position: absolute; top: -6px; right: -8px; width: 12px; height: 12px;
    background: var(--yellow); border-radius: 50% 0 50% 50%; transform: rotate(45deg);
  }

  .search-form {
    flex: 1;
    max-width: 520px;
  }

  .search-top {
    background: #fff;
    border-radius: 999px;
    padding: 12px 20px;
    display: flex;
    align-items: center;
    gap: 12px;
    box-shadow: 0 2px 6px rgba(0,0,0,.03);
  }

  .search-top input {
    flex: 1;
    border: 0;
    outline: 0;
    background: transparent;
    font: inherit;
    color: var(--text);
    font-size: 14px;
  }

  .search-top input::placeholder {
    color: #9a9280;
  }

  .search-top button {
    background: var(--olive);
    color: white;
    border: none;
    padding: 10px 18px;
    border-radius: 999px;
    font-size: 13px;
    font-weight: 700;
    cursor: pointer;
  }

  .welcome-user {
    margin-left: auto;
    font-weight: 700;
    color: var(--dark);
  }

  .logout-btn {
    text-decoration: none;
    background: var(--olive);
    color: white;
    padding: 10px 18px;
    border-radius: 12px;
    font-size: 14px;
    font-weight: 600;
  }

  .hero {
    position: relative; border-radius: 24px; overflow: hidden; min-height: 440px;
    background: linear-gradient(90deg, rgba(20,17,10,.88) 0%, rgba(20,17,10,.55) 45%, rgba(20,17,10,.15) 75%), url('https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=1600&q=80') center/cover;
    padding: 60px 60px 40px; color: #fff; display: flex; flex-direction: column; justify-content: space-between;
  }
  .hero h1 { font-size: 56px; font-weight: 800; line-height: 1.05; letter-spacing: -1px; max-width: 560px; }
  .hero h1 .green { color: #b7c46a; }
  .hero p { margin-top: 18px; font-size: 15px; max-width: 380px; color: #eee8d8; }
  .hero .underline { width: 60px; height: 3px; background: var(--yellow); margin-top: 22px; border-radius: 2px; }

  .section-head { display: flex; justify-content: space-between; align-items: center; margin: 46px 0 26px; }
  .section-head h2 { font-size: 30px; font-weight: 800; color: var(--dark); position: relative; padding-bottom: 10px; }
  .section-head h2::after { content: ""; position: absolute; left: 0; bottom: 0; width: 50px; height: 3px; background: var(--yellow); border-radius: 2px; }

  .grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 22px; }

  .restaurant-link {
    text-decoration: none;
    color: inherit;
    display: block;
  }

  .card {
    background: #fff;
    border-radius: 18px;
    overflow: hidden;
    box-shadow: 0 4px 14px rgba(0,0,0,.04);
    display: flex;
    flex-direction: column;
    transition: transform .2s ease, box-shadow .2s ease;
    cursor: pointer;
    height: 100%;
  }

  .card:hover {
    transform: translateY(-4px);
    box-shadow: 0 10px 24px rgba(0,0,0,.08);
  }

  .card .img {
    position: relative;
    height: 200px;
    overflow: hidden;
  }

  .card .img img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
  }

  .card .body { padding: 16px; }

  .card .row1 {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
  }

  .card h3 { font-size: 18px; font-weight: 700; color: var(--dark); }

  .card .rating {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    background: var(--star-bg);
    color: #fff;
    padding: 4px 8px;
    border-radius: 6px;
    font-size: 12px;
    font-weight: 700;
  }

  .card .cuisine {
    color: var(--muted);
    font-size: 14px;
    margin: 8px 0 10px;
  }

  .card .address {
    color: var(--muted);
    font-size: 13px;
  }

  .empty-message {
    background: white;
    padding: 24px;
    border-radius: 16px;
    color: var(--muted);
    font-size: 15px;
  }

  @media (max-width: 900px) {
    .grid { grid-template-columns: repeat(2, 1fr); }
    .hero { padding: 40px 28px; }
    .hero h1 { font-size: 40px; }
  }

  @media (max-width: 600px) {
    .grid { grid-template-columns: 1fr; }
    .hero h1 { font-size: 32px; }
    .search-form { max-width: 100%; width: 100%; }
  }
</style>
</head>
<body>

  <svg class="leaf-bg" viewBox="0 0 100 200" xmlns="http://www.w3.org/2000/svg">
    <path d="M50 0 C 20 60, 20 140, 50 200 C 80 140, 80 60, 50 0 Z" fill="#8a9a3d"/>
    <path d="M50 0 L50 200" stroke="#6b7a2a" stroke-width="1"/>
  </svg>
  <div class="blob"></div>
  <div class="dots"></div>
  <div class="bubble"></div>

  <div class="container">

    <header class="header">
      <div class="logo"><span class="c">C</span>ravix</div>

      <form action="home" method="get" class="search-form">
        <div class="search-top">
          <input type="text" name="search" placeholder="Search for restaurants or cuisines..." value="<%= search %>" />
          <button type="submit">Search</button>
        </div>
      </form>

      <div class="welcome-user">
        Hi, <%= user.getFullName() %>
      </div>

      <a href="logout" class="logout-btn">Logout</a>
    </header>

    <section class="hero">
      <div>
        <h1>Good Food.<br><span class="green">Great</span> Moments.</h1>
        <p>Discover the best restaurants and enjoy food you love.</p>
        <div class="underline"></div>
      </div>
    </section>

    <div class="section-head">
      <h2>Top Restaurants</h2>
    </div>

    <div class="grid">
      <%
          if (restaurantList != null && !restaurantList.isEmpty()) {
              for (Restaurant restaurant : restaurantList) {
      %>
          <a class="restaurant-link" href="restaurant?restaurantId=<%= restaurant.getRestaurantId() %>">
            <div class="card">
              <div class="img">
                <img src="<%= restaurant.getImagePath() %>" alt="<%= restaurant.getName() %>">
              </div>
              <div class="body">
                <div class="row1">
                  <h3><%= restaurant.getName() %></h3>
                  <div class="rating">★ <%= restaurant.getRating() %></div>
                </div>
                <div class="cuisine"><%= restaurant.getCuisineType() %></div>
                <div class="address"><%= restaurant.getAddress() %></div>
              </div>
            </div>
          </a>
      <%
              }
          } else {
      %>
          <div class="empty-message">
            No restaurants found for "<%= search %>".
          </div>
      <%
          }
      %>
    </div>

  </div>
</body>
</html>