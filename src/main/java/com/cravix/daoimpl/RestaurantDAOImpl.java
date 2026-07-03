package com.cravix.daoimpl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.cravix.dao.RestaurantDAO;
import com.cravix.model.Restaurant;
import com.cravix.util.HibernateUtil;

public class RestaurantDAOImpl implements RestaurantDAO {

    @Override
    public boolean saveRestaurant(Restaurant restaurant) {
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(restaurant);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Restaurant getRestaurantById(int restaurantId) {
        Transaction transaction = null;
        Restaurant restaurant = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            restaurant = session.get(Restaurant.class, restaurantId);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }

        return restaurant;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        Transaction transaction = null;
        List<Restaurant> restaurants = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Query<Restaurant> query = session.createQuery("FROM Restaurant", Restaurant.class);
            restaurants = query.list();
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public List<Restaurant> getActiveRestaurants() {
        Transaction transaction = null;
        List<Restaurant> restaurants = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Query<Restaurant> query = session.createQuery(
                    "FROM Restaurant WHERE isActive = true", Restaurant.class);
            restaurants = query.list();
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public List<Restaurant> searchRestaurants(String keyword) {
        Transaction transaction = null;
        List<Restaurant> restaurants = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            String searchKeyword = "%" + keyword.toLowerCase().trim() + "%";

            Query<Restaurant> query = session.createQuery(
                    "FROM Restaurant WHERE isActive = true AND (" +
                    "lower(name) LIKE :keyword OR " +
                    "lower(cuisineType) LIKE :keyword OR " +
                    "lower(address) LIKE :keyword" +
                    ")",
                    Restaurant.class
            );

            query.setParameter("keyword", searchKeyword);
            restaurants = query.list();

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public boolean updateRestaurant(Restaurant restaurant) {
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(restaurant);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteRestaurant(int restaurantId) {
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            Restaurant restaurant = session.get(Restaurant.class, restaurantId);
            if (restaurant != null) {
                session.remove(restaurant);
                transaction.commit();
                return true;
            }

        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }

        return false;
    }
}