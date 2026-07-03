package com.cravix.dao;

import java.util.List;
import com.cravix.model.OrderItem;

public interface OrderItemDAO {

    boolean saveOrderItem(OrderItem orderItem);

    List<OrderItem> getOrderItemsByOrderId(int orderId);

    boolean deleteOrderItemsByOrderId(int orderId);
}