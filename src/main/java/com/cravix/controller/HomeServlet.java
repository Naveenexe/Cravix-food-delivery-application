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

        String search = request.getParameter("search");
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
}