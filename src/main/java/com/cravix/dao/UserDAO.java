package com.cravix.dao;

import java.util.List;
import com.cravix.model.User;

public interface UserDAO {

    boolean saveUser(User user);

    User getUserById(int userId);

    User getUserByEmail(String email);

    User validateUser(String email, String password);

    boolean updateUser(User user);

    List<User> getAllUsers();
}