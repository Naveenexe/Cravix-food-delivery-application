package com.cravix.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.cravix.dao.MenuItemDAO;
import com.cravix.dao.OrderDAO;
import com.cravix.daoimpl.MenuItemDAOImpl;
import com.cravix.daoimpl.OrderDAOImpl;
import com.cravix.model.CartItem;
import com.cravix.model.MenuItem;
import com.cravix.model.OrderItem;
import com.cravix.model.Orders;
import com.cravix.model.Restaurant;
import com.cravix.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private OrderDAO orderDAO;
    private MenuItemDAO menuItemDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAOImpl();
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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Map<Integer, CartItem> cart = getCart(session);
        if (cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Map<Integer, CartItem> cart = getCart(session);
        if (cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        String deliveryAddress = request.getParameter("deliveryAddress");
        String paymentMode = request.getParameter("paymentMode");

        if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
            request.setAttribute("error", "Delivery address is required.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        if (paymentMode == null || paymentMode.trim().isEmpty()) {
            paymentMode = "COD";
        }

        BigDecimal subtotal = BigDecimal.ZERO;
        Restaurant restaurant = null;

        for (CartItem cartItem : cart.values()) {
            subtotal = subtotal.add(cartItem.getTotalPrice());

            if (restaurant == null) {
                MenuItem menuItem = menuItemDAO.getMenuItemById(cartItem.getMenuId());
                if (menuItem != null) {
                    restaurant = menuItem.getRestaurant();
                }
            }
        }

        if (restaurant == null) {
            request.setAttribute("error", "Unable to place order. Restaurant information missing.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        BigDecimal deliveryFee = new BigDecimal("30");
        BigDecimal packagingFee = new BigDecimal("20");
        BigDecimal totalAmount = subtotal.add(deliveryFee).add(packagingFee);

        Orders order = new Orders();
        order.setUser(user);
        order.setRestaurant(restaurant);
        order.setTotalAmount(totalAmount);
        order.setStatus("PLACED");
        order.setDeliveryAddress(deliveryAddress);
        order.setPaymentMode(paymentMode);

        int orderId = orderDAO.saveOrder(order);

        if (orderId <= 0) {
            request.setAttribute("error", "Failed to place order. Please try again.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        List<OrderItem> orderItems = new ArrayList<>();

        for (CartItem cartItem : cart.values()) {
            MenuItem menuItem = menuItemDAO.getMenuItemById(cartItem.getMenuId());
            if (menuItem == null) {
                continue;
            }

            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(order);
            orderItem.setMenuItem(menuItem);
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setPrice(cartItem.getPrice());

            orderItems.add(orderItem);
        }

        boolean itemsSaved = orderDAO.saveOrderItems(orderItems);

        if (!itemsSaved) {
            request.setAttribute("error", "Order created but items could not be saved. Please contact support.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        // Save success-page data before clearing cart
        session.setAttribute("lastOrderId", orderId);
        session.setAttribute("lastOrderItems", new ArrayList<>(cart.values()));
        session.setAttribute("lastOrderSubtotal", subtotal);
        session.setAttribute("lastDeliveryFee", deliveryFee);
        session.setAttribute("lastPackagingFee", packagingFee);
        session.setAttribute("lastOrderTotal", totalAmount);
        session.setAttribute("lastOrderAddress", deliveryAddress);
        session.setAttribute("lastPaymentMode", paymentMode);

        // Clear cart after order placed successfully
        cart.clear();

        response.sendRedirect("order-success.jsp");
    }
}