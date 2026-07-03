package com.cravix.model;

import java.math.BigDecimal;
import jakarta.persistence.*;

@Entity
@Table(name = "restaurants")
public class Restaurant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "restaurant_id")
    private int restaurantId;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "cuisine_type", length = 50)
    private String cuisineType;

    @Column(name = "address", length = 255)
    private String address;

    @Column(name = "rating", precision = 2, scale = 1)
    private BigDecimal rating;

    @Column(name = "image_path", length = 255)
    private String imagePath;

    @Column(name = "is_active")
    private boolean isActive = true;

    public Restaurant() {
    }

    public Restaurant(String name, String cuisineType, String address, BigDecimal rating, String imagePath, boolean isActive) {
        this.name = name;
        this.cuisineType = cuisineType;
        this.address = address;
        this.rating = rating;
        this.imagePath = imagePath;
        this.isActive = isActive;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCuisineType() {
        return cuisineType;
    }

    public void setCuisineType(String cuisineType) {
        this.cuisineType = cuisineType;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public BigDecimal getRating() {
        return rating;
    }

    public void setRating(BigDecimal rating) {
        this.rating = rating;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}