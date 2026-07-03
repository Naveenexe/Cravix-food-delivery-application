package com.cravix.dao;

import java.util.List;
import com.cravix.model.Orders;

public interface OrderDAO {

    int saveOrder(Orders order);

    Orders getOrderById(int orderId);

    List<Orders> getOrdersByUserId(int userId);

    List<Orders> getAllOrders();

    boolean updateOrder(Orders order);

    boolean deleteOrder(int orderId);
}