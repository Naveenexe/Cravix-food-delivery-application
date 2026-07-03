package com.cravix.controller;

import java.io.IOException;
import java.util.List;

import com.cravix.dao.MenuItemDAO;
import com.cravix.dao.RestaurantDAO;
import com.cravix.daoimpl.MenuItemDAOImpl;
import com.cravix.daoimpl.RestaurantDAOImpl;
import com.cravix.model.MenuItem;
import com.cravix.model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/restaurant")
public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RestaurantDAO restaurantDAO;
    private MenuItemDAO menuItemDAO;

    @Override
    public void init() throws ServletException {
        restaurantDAO = new RestaurantDAOImpl();
        menuItemDAO = new MenuItemDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String restaurantIdParam = request.getParameter("restaurantId");

        if (restaurantIdParam == null || restaurantIdParam.trim().isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        int restaurantId;
        try {
            restaurantId = Integer.parseInt(restaurantIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
            return;
        }

        Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);

        if (restaurant == null) {
            response.sendRedirect("home");
            return;
        }

        List<MenuItem> menuItemList = menuItemDAO.getAvailableMenuByRestaurantId(restaurantId);

        request.setAttribute("restaurant", restaurant);
        request.setAttribute("menuItemList", menuItemList);
        request.getRequestDispatcher("restaurant.jsp").forward(request, response);
    }
}