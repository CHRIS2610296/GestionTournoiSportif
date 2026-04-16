package com.tournoi.controller;

import com.tournoi.dao.UtilisateurDAO;
import com.tournoi.model.Utilisateur;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        Utilisateur u = utilisateurDAO.authentifier(user, pass);

        if (u != null) {
            HttpSession session = request.getSession();
            session.setAttribute("utilisateurConnecte", u);
            response.sendRedirect("TournoiServlet");
        } else {
            request.setAttribute("erreur", "Identifiant ou mot de passe incorrect !");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}