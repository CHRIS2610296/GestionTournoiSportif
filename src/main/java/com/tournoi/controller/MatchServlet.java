package com.tournoi.controller;
import com.tournoi.dao.*; import com.tournoi.model.*; import javax.servlet.ServletException; import javax.servlet.annotation.WebServlet; import javax.servlet.http.*; import java.io.IOException; import java.util.List;
@WebServlet("/MatchServlet")
public class MatchServlet extends HttpServlet {
    private MatchDAO matchDAO = new MatchDAO(); private EquipeDAO equipeDAO = new EquipeDAO(); private TournoiDAO tournoiDAO = new TournoiDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idTStr = request.getParameter("idTournoi");
        if (idTStr != null) {
            int idTournoi = Integer.parseInt(idTStr);
            Tournoi tournoiActuel = tournoiDAO.getTournoiById(idTournoi);
            
            // Si c'est une élimination directe, on cherche s'il y a un grand vainqueur final
            if ("Elimination".equals(tournoiActuel.getTypeTournoi())) {
                Equipe vainqueur = matchDAO.getVainqueurKnockout(idTournoi);
                request.setAttribute("vainqueur", vainqueur);
            }

            request.setAttribute("matchs", matchDAO.listerMatchsParTournoi(idTournoi));
            request.setAttribute("equipes", equipeDAO.listerParTournoi(idTournoi));
            request.setAttribute("tournoi", tournoiActuel);
            request.setAttribute("idTournoi", idTournoi);
            
            request.getRequestDispatcher("matches.jsp").forward(request, response);
        } else { 
            response.sendRedirect("TournoiServlet"); 
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int idTournoi = Integer.parseInt(request.getParameter("idTournoi"));
        if ("genererTournoi".equals(action)) {
            List<Equipe> equipes = equipeDAO.listerParTournoi(idTournoi);
            Tournoi t = tournoiDAO.getTournoiById(idTournoi);
            if (equipes.size() >= 2) {
                if ("Elimination".equals(t.getTypeTournoi())) { matchDAO.genererKnockout(equipes); } else { matchDAO.genererChampionnat(equipes); }
            }
        } else if ("saisirScore".equals(action)) {
            int idMatch = Integer.parseInt(request.getParameter("idMatch"));
            int scoreDom = Integer.parseInt(request.getParameter("scoreDom"));
            int scoreExt = Integer.parseInt(request.getParameter("scoreExt"));
            
            // 1. On enregistre le score du match
            matchDAO.enregistrerScore(idMatch, scoreDom, scoreExt);
            
            // 2. On regarde si c'est un tournoi à élimination
            Tournoi t = tournoiDAO.getTournoiById(idTournoi);
            if ("Elimination".equals(t.getTypeTournoi())) {
                // 3. LA MAGIE OPÈRE ICI : On vérifie s'il faut générer le tour suivant
                matchDAO.verifierEtGenererTourSuivant(idTournoi);
            }
        }
        response.sendRedirect("MatchServlet?idTournoi=" + idTournoi);
    }
}