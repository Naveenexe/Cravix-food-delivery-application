package com.cravix.dao;

import java.util.List;
import com.cravix.model.MenuItem;

public interface MenuItemDAO {

    boolean saveMenuItem(MenuItem menuItem);

    MenuItem getMenuItemById(int menuId);

    List<MenuItem> getMenuByRestaurantId(int restaurantId);

    List<MenuItem> getAvailableMenuByRestaurantId(int restaurantId);

    boolean updateMenuItem(MenuItem menuItem);

    boolean deleteMenuItem(int menuId);
}