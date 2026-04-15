package com.tournoi.controller;
import com.tournoi.dao.TournoiDAO; import com.tournoi.model.Tournoi; import javax.servlet.ServletException; import javax.servlet.annotation.WebServlet; import javax.servlet.http.*; import java.io.IOException;
@WebServlet("/TournoiServlet")
public class TournoiServlet extends HttpServlet {
    private TournoiDAO tournoiDAO = new TournoiDAO();
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("tournois", tournoiDAO.listerTournois());
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Tournoi t = new Tournoi();
        t.setNom(request.getParameter("nom")); t.setSport(request.getParameter("sport")); t.setTypeTournoi(request.getParameter("typeTournoi")); t.setLieu(request.getParameter("lieu")); t.setDateDebut(request.getParameter("dateDebut")); t.setDateFin(request.getParameter("dateFin"));
        tournoiDAO.creerTournoi(t);
        response.sendRedirect("TournoiServlet");
    }
}