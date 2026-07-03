package com.cravix.controller;

import java.io.IOException;
import java.util.List;

import com.cravix.dao.RestaurantDAO;
import com.cravix.daoimpl.RestaurantDAOImpl;
import com.cravix.model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RestaurantDAO restaurantDAO;

    @Override
    public void init() throws ServletException {
        restaurantDAO = new RestaurantDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String suggest = request.getParameter("suggest");
        String search = request.getParameter("search");

        if ("true".equalsIgnoreCase(suggest)) {
            handleSuggestions(search, response);
            return;
        }

        List<Restaurant> restaurantList;

        if (search != null && !search.trim().isEmpty()) {
            restaurantList = restaurantDAO.searchRestaurants(search.trim());
            request.setAttribute("search", search);
        } else {
            restaurantList = restaurantDAO.getActiveRestaurants();
        }

        request.setAttribute("restaurantList", restaurantList);
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }

    private void handleSuggestions(String search, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");

        if (search == null || search.trim().isEmpty()) {
            response.getWriter().write("");
            return;
        }

        List<Restaurant> suggestions = restaurantDAO.searchRestaurants(search.trim());

        StringBuilder sb = new StringBuilder();

        if (suggestions != null && !suggestions.isEmpty()) {
            int count = 0;
            for (Restaurant restaurant : suggestions) {
                if (count >= 6) break;

                sb.append("<a class='suggestion-item' href='restaurant?restaurantId=")
                  .append(restaurant.getRestaurantId())
                  .append("'>")
                  .append("<div class='suggestion-name'>")
                  .append(escapeHtml(restaurant.getName()))
                  .append("</div>")
                  .append("<div class='suggestion-meta'>")
                  .append(escapeHtml(restaurant.getCuisineType()))
                  .append("</div>")
                  .append("</a>");

                count++;
            }
        } else {
            sb.append("<div class='suggestion-empty'>No restaurants found</div>");
        }

        response.getWriter().write(sb.toString());
    }

    private String escapeHtml(String value) {
        if (value == null) return "";
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}