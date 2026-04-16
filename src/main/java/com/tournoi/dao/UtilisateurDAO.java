package com.tournoi.dao;

import com.tournoi.model.Utilisateur;
import java.sql.*;

public class UtilisateurDAO {
    public Utilisateur authentifier(String username, String password) {
        String sql = "SELECT * FROM utilisateur WHERE username = ? AND password = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Utilisateur(rs.getInt("id"), rs.getString("username"), rs.getString("role"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}