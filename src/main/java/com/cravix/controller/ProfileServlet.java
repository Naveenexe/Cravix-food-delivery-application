package com.cravix.controller;

import java.io.IOException;

import com.cravix.dao.UserDAO;
import com.cravix.daoimpl.UserDAOImpl;
import com.cravix.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Full name is required.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        loggedInUser.setFullName(fullName.trim());
        loggedInUser.setPhone(phone != null ? phone.trim() : null);
        loggedInUser.setAddress(address != null ? address.trim() : null);

        boolean updated = userDAO.updateUser(loggedInUser);

        if (updated) {
            session.setAttribute("loggedInUser", loggedInUser);
            session.setAttribute("userName", loggedInUser.getFullName());
            request.setAttribute("success", "Profile updated successfully.");
        } else {
            request.setAttribute("error", "Failed to update profile. Please try again.");
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}