package com.cravix.daoimpl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.cravix.dao.MenuItemDAO;
import com.cravix.model.MenuItem;
import com.cravix.util.HibernateUtil;

public class MenuItemDAOImpl implements MenuItemDAO {

    @Override
    public boolean saveMenuItem(MenuItem menuItem) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(menuItem);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public MenuItem getMenuItemById(int menuId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(MenuItem.class, menuId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<MenuItem> getMenuByRestaurantId(int restaurantId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MenuItem> query = session.createQuery(
                    "FROM MenuItem WHERE restaurant.restaurantId = :restaurantId", MenuItem.class);
            query.setParameter("restaurantId", restaurantId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<MenuItem> getAvailableMenuByRestaurantId(int restaurantId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MenuItem> query = session.createQuery(
                    "FROM MenuItem WHERE restaurant.restaurantId = :restaurantId AND isAvailable = true",
                    MenuItem.class);
            query.setParameter("restaurantId", restaurantId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean updateMenuItem(MenuItem menuItem) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(menuItem);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteMenuItem(int menuId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            MenuItem menuItem = session.get(MenuItem.class, menuId);
            if (menuItem != null) {
                session.remove(menuItem);
                transaction.commit();
                return true;
            }
            transaction.rollback();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
        return false;
    }
}