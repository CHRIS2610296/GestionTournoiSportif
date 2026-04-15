package com.tournoi.controller;
import com.tournoi.dao.EquipeDAO; import com.tournoi.model.Equipe; import javax.servlet.ServletException; import javax.servlet.annotation.WebServlet; import javax.servlet.http.*; import java.io.IOException;
@WebServlet("/TeamServlet")
public class TeamServlet extends HttpServlet {
    private EquipeDAO equipeDAO = new EquipeDAO();
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String idTournoiStr = request.getParameter("idTournoi");
        
        if (idTournoiStr != null && !idTournoiStr.isEmpty()) {
            int idTournoi = Integer.parseInt(idTournoiStr);
            
            // Si on a cliqué sur "Inscrire une équipe"
            if ("ajouter".equals(action)) {
                // On envoie la liste des clubs existants au formulaire
                request.setAttribute("equipesExistantes", equipeDAO.listerEquipesDistinctes());
                request.setAttribute("idTournoi", idTournoi);
                request.getRequestDispatcher("addTeam.jsp").forward(request, response);
            } 
            // Sinon, on affiche simplement la liste des équipes du tournoi
            else {
                request.setAttribute("equipes", equipeDAO.listerParTournoi(idTournoi));
                request.setAttribute("idTournoi", idTournoi);
                request.getRequestDispatcher("listTeams.jsp").forward(request, response);
            }
        } else { 
            response.sendRedirect("TournoiServlet"); 
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Equipe e = new Equipe();
        e.setNom(request.getParameter("nom")); e.setVille(request.getParameter("ville")); e.setNombreJoueurs(Integer.parseInt(request.getParameter("nombreJoueurs"))); e.setLogo(request.getParameter("logo")); e.setContact(request.getParameter("contact"));
        int idTournoi = Integer.parseInt(request.getParameter("idTournoi")); e.setIdTournoi(idTournoi);
        equipeDAO.ajouterEquipe(e);
        response.sendRedirect("TeamServlet?idTournoi=" + idTournoi);
    }
}