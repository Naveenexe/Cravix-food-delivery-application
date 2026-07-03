package com.cravix.daoimpl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.cravix.dao.OrderItemDAO;
import com.cravix.model.OrderItem;
import com.cravix.util.HibernateUtil;

public class OrderItemDAOImpl implements OrderItemDAO {

    @Override
    public boolean saveOrderItem(OrderItem orderItem) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(orderItem);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<OrderItem> query = session.createQuery(
                    "FROM OrderItem WHERE order.orderId = :orderId", OrderItem.class);
            query.setParameter("orderId", orderId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean deleteOrderItemsByOrderId(int orderId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            session.createMutationQuery(
                    "DELETE FROM OrderItem WHERE order.orderId = :orderId")
                    .setParameter("orderId", orderId)
                    .executeUpdate();

            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
        return false;
    }
    }
