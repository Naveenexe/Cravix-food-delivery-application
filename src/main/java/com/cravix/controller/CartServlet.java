package com.cravix.controller;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import com.cravix.dao.MenuItemDAO;
import com.cravix.daoimpl.MenuItemDAOImpl;
import com.cravix.model.CartItem;
import com.cravix.model.MenuItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private MenuItemDAO menuItemDAO;

    @Override
    public void init() throws ServletException {
        menuItemDAO = new MenuItemDAOImpl();
    }

    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem> getCart(HttpSession session) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Map<Integer, CartItem> cart = getCart(session);

        if ("clearAndAdd".equals(action)) {
            handleClearAndAdd(request, response, cart);
            return;
        }

        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Map<Integer, CartItem> cart = getCart(session);

        if ("add".equals(action)) {
            handleAddToCart(request, response, cart);
            return;
        }

        if ("increase".equals(action)) {
            int menuId = Integer.parseInt(request.getParameter("menuId"));
            if (cart.containsKey(menuId)) {
                CartItem item = cart.get(menuId);
                item.setQuantity(item.getQuantity() + 1);
            }
            response.sendRedirect("cart");
            return;
        }

        if ("decrease".equals(action)) {
            int menuId = Integer.parseInt(request.getParameter("menuId"));
            if (cart.containsKey(menuId)) {
                CartItem item = cart.get(menuId);
                if (item.getQuantity() > 1) {
                    item.setQuantity(item.getQuantity() - 1);
                } else {
                    cart.remove(menuId);
                }
            }
            response.sendRedirect("cart");
            return;
        }

        if ("remove".equals(action)) {
            int menuId = Integer.parseInt(request.getParameter("menuId"));
            cart.remove(menuId);
            response.sendRedirect("cart");
            return;
        }

        if ("clear".equals(action)) {
            cart.clear();
            response.sendRedirect("cart");
            return;
        }

        response.sendRedirect("cart");
    }

    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response,
                                 Map<Integer, CartItem> cart) throws IOException {

        String menuIdParam = request.getParameter("menuId");
        String restaurantIdParam = request.getParameter("restaurantId");

        if (menuIdParam == null || restaurantIdParam == null) {
            response.sendRedirect("home");
            return;
        }

        int menuId = Integer.parseInt(menuIdParam);
        int restaurantId = Integer.parseInt(restaurantIdParam);

        MenuItem menuItem = menuItemDAO.getMenuItemById(menuId);

        if (menuItem == null) {
            response.sendRedirect("home");
            return;
        }

        // SINGLE RESTAURANT CART RESTRICTION
        if (!cart.isEmpty()) {
            CartItem firstItem = cart.values().iterator().next();

            if (firstItem.getRestaurantId() != restaurantId) {
                response.sendRedirect("restaurant?restaurantId=" + restaurantId
                        + "&cartConflict=true&menuId=" + menuId);
                return;
            }
        }

        addItemToCart(cart, menuItem);

        response.sendRedirect("restaurant?restaurantId=" + restaurantId);
    }

    private void handleClearAndAdd(HttpServletRequest request, HttpServletResponse response,
                                   Map<Integer, CartItem> cart) throws IOException {

        String menuIdParam = request.getParameter("menuId");
        String restaurantIdParam = request.getParameter("restaurantId");

        if (menuIdParam == null || restaurantIdParam == null) {
            response.sendRedirect("home");
            return;
        }

        int menuId = Integer.parseInt(menuIdParam);
        int restaurantId = Integer.parseInt(restaurantIdParam);

        MenuItem menuItem = menuItemDAO.getMenuItemById(menuId);

        if (menuItem == null) {
            response.sendRedirect("home");
            return;
        }

        cart.clear();
        addItemToCart(cart, menuItem);

        response.sendRedirect("restaurant?restaurantId=" + restaurantId);
    }

    private void addItemToCart(Map<Integer, CartItem> cart, MenuItem menuItem) {
        int menuId = menuItem.getMenuId();

        if (cart.containsKey(menuId)) {
            CartItem existingItem = cart.get(menuId);
            existingItem.setQuantity(existingItem.getQuantity() + 1);
        } else {
            CartItem cartItem = new CartItem(
                    menuItem.getMenuId(),
                    menuItem.getItemName(),
                    menuItem.getPrice(),
                    1,
                    menuItem.getImagePath(),
                    menuItem.getRestaurant().getRestaurantId(),
                    menuItem.getRestaurant().getName()
            );
            cart.put(menuId, cartItem);
        }
    }
}