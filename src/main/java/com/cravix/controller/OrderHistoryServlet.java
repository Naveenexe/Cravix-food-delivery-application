package com.cravix.controller;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.cravix.dao.OrderDAO;
import com.cravix.dao.OrderItemDAO;
import com.cravix.daoimpl.OrderDAOImpl;
import com.cravix.daoimpl.OrderItemDAOImpl;
import com.cravix.model.OrderItem;
import com.cravix.model.Orders;
import com.cravix.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/order-history")
public class OrderHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAOImpl();
        orderItemDAO = new OrderItemDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedInUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Orders> orderList = orderDAO.getOrdersByUserId(user.getUserId());

        Map<Integer, List<OrderItem>> orderItemsMap = new LinkedHashMap<>();

        if (orderList != null) {
            for (Orders order : orderList) {
                List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(order.getOrderId());
                orderItemsMap.put(order.getOrderId(), items);
            }
        }

        request.setAttribute("orderList", orderList);
        request.setAttribute("orderItemsMap", orderItemsMap);

        request.getRequestDispatcher("order-history.jsp").forward(request, response);
    }
}