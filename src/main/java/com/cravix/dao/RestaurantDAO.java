package com.cravix.dao;

import java.util.List;
import com.cravix.model.Restaurant;

public interface RestaurantDAO {

    boolean saveRestaurant(Restaurant restaurant);

    Restaurant getRestaurantById(int restaurantId);

    List<Restaurant> getAllRestaurants();

    List<Restaurant> getActiveRestaurants();

    List<Restaurant> searchRestaurants(String keyword);

    boolean updateRestaurant(Restaurant restaurant);

    boolean deleteRestaurant(int restaurantId);
}