package com.tournoi.controller;

import com.tournoi.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/TournamentServlet")
public class TournamentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String sport = request.getParameter("sport");
        String type = request.getParameter("type");
        String startDate = request.getParameter("startDate");
        int maxTeams = Integer.parseInt(request.getParameter("maxTeams"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO tournaments (name, sport, type, start_date, max_teams) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, sport);
            stmt.setString(3, type);
            stmt.setString(4, startDate);
            stmt.setInt(5, maxTeams);
            
            stmt.executeUpdate();
            // Once created, redirect to the team list to start assigning teams
            response.sendRedirect("listTeams.jsp"); 
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}