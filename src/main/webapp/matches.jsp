<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %> 
<%@ page import="com.tournoi.model.*" %>
<%@ page import="com.tournoi.model.Utilisateur" %>
<% 
    Utilisateur currentUser = (Utilisateur) session.getAttribute("utilisateurConnecte"); 
    boolean peutModifier = (currentUser != null && !currentUser.getRole().equals("Spectateur"));
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calendrier et Scores</title>
    <style>
        /* (CSS Conservé de ton design moderne) */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f0f2f5; padding: 30px; }
        .container { max-width: 1000px; margin: 0 auto; }
        .header { text-align: center; margin-bottom: 30px; }
        .header h1 { font-size: 28px; color: #1a1a2e; margin-bottom: 8px; }
        .tournament-name { background: #1a1a2e; color: white; display: inline-block; padding: 6px 20px; border-radius: 25px; font-size: 14px; font-weight: 500; }
        .button-group { text-align: center; margin-bottom: 25px; }
        .btn { display: inline-flex; align-items: center; gap: 8px; padding: 8px 20px; border-radius: 6px; text-decoration: none; font-weight: 500; font-size: 14px; border: none; cursor: pointer; }
        .btn-back { background: #6c757d; color: white; }
        .btn-ranking { background: #17a2b8; color: white; }
        .btn-generate { background: #28a745; color: white; padding: 12px 25px;}
        .btn-validate { background: #007bff; color: white; padding: 5px 15px; font-size: 12px; border-radius: 4px; border: none; cursor: pointer; }
        .winner-banner { background: linear-gradient(135deg, #ffd700, #ff8c00); text-align: center; padding: 25px; border-radius: 12px; margin-bottom: 25px; color: white; }
        .winner-logo { width: 100px; height: 100px; border-radius: 50%; border: 4px solid white; object-fit: cover; }
        .card { background: white; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 25px; overflow: hidden; }
        .card-header { background: #1a1a2e; color: white; padding: 12px 20px; font-weight: 600; font-size: 16px; }
        .card-body { padding: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #e9ecef; padding: 12px; text-align: center; font-weight: 600; font-size: 13px; color: #495057; border-bottom: 1px solid #dee2e6; }
        td { padding: 15px 12px; text-align: center; border-bottom: 1px solid #f0f0f0; vertical-align: middle; }
        .team-home { text-align: right; font-weight: 600; color: #333; width: 35%; }
        .team-away { text-align: left; font-weight: 600; color: #333; width: 35%; }
        .match-center { display: flex; flex-direction: column; align-items: center; gap: 8px; width: 30%; }
        .date-badge { font-size: 12px; font-weight: 600; color: #495057; background: #e2e8f0; padding: 4px 12px; border-radius: 12px; }
        .score-finished { font-size: 22px; font-weight: 800; color: #1a1a2e; background: #f8f9fa; padding: 5px 15px; border-radius: 8px; border: 1px solid #dee2e6;}
        .score-input { width: 45px; padding: 6px; text-align: center; font-size: 14px; font-weight: 600; border: 1px solid #ddd; border-radius: 4px; }
        .vs { margin: 0 8px; color: #adb5bd; font-weight: 600; font-size: 14px;}
        .status-waiting { font-size: 14px; color: #6c757d; font-weight: 600; background: #f8f9fa; padding: 5px 15px; border-radius: 8px; border: 1px dashed #ced4da;}
    </style>
</head>
<body>
    <div class="container">
        <% Tournoi t = (Tournoi) request.getAttribute("tournoi"); %>
        
        <% if(currentUser != null) { %>
            <div style="text-align: right; margin-bottom: 20px; font-size: 14px;">
                👤 <strong style="color: #1a1a2e;"><%= currentUser.getUsername() %></strong> (<%= currentUser.getRole() %>)
                <a href="LogoutServlet" style="margin-left: 15px; color: #dc3545; text-decoration: none; font-weight: bold;">🚪 Déconnexion</a>
            </div>
        <% } %>

        <div class="header">
            <h1>🏟️ Calendrier des Matchs</h1>
            <div class="tournament-name"><%= t != null ? t.getNom() : "Tournoi" %></div>
        </div>

        <div class="button-group">
            <a href="TournoiServlet" class="btn btn-back">← Retour à l'accueil</a>
            <% if (t != null && "Championnat".equals(t.getTypeTournoi())) { %>
                <a href="ClassementServlet?idTournoi=<%= request.getAttribute("idTournoi") %>" class="btn btn-ranking">🏆 Voir le Classement</a>
            <% } %>
        </div>

        <% Equipe vainqueur = (Equipe) request.getAttribute("vainqueur"); %>
        <% if (vainqueur != null) { %>
            <div class="winner-banner">
                <h3>🏆 CHAMPION DU TOURNOI 🏆</h3>
                <h2><%= vainqueur.getNom() %></h2>
                <img src="<%= (vainqueur.getLogo() != null && !vainqueur.getLogo().isEmpty()) ? vainqueur.getLogo() : "https://cdn-icons-png.flaticon.com/512/1022/1022214.png" %>" class="winner-logo">
            </div>
        <% } %>

        <% if (peutModifier) { %>
        <div class="card" style="border: 1px solid #28a745;">
            <div class="card-body" style="text-align: center;">
                <form action="MatchServlet" method="POST">
                    <input type="hidden" name="action" value="genererTournoi">
                    <input type="hidden" name="idTournoi" value="<%= request.getAttribute("idTournoi") %>">
                    <button type="submit" class="btn btn-generate">⚡ Lancer / Régénérer le calendrier automatique</button>
                </form>
            </div>
        </div>
        <% } %>

        <div class="card">
            <div class="card-header">📅 Rencontres programmées</div>
            <div class="card-body" style="padding: 0;">
                <table>
                    <tbody>
                        <% 
                            List<Match> matchs = (List<Match>) request.getAttribute("matchs"); 
                            if(matchs != null && !matchs.isEmpty()) { 
                                for(Match m : matchs) { 
                        %>
                        <tr>
                            <td class="team-home"><%= m.getNomEquipeDom() %></td>
                            <td>
                                <div class="match-center">
                                    <div class="date-badge">📅 <%= m.getDateMatch() != null ? m.getDateMatch() : "Date à définir" %></div>
                                    
                                    <% if ("Terminé".equals(m.getStatut())) { %>
                                        <div class="score-finished">
                                            <%= m.getScoreDom() %> - <%= m.getScoreExt() %>
                                        </div>
                                    <% } else { %>
                                        <% if (peutModifier) { %>
                                            <form action="MatchServlet" method="POST" style="display: flex; flex-direction: column; align-items: center; gap: 8px; margin-top: 5px;">
                                                <input type="hidden" name="action" value="saisirScore">
                                                <input type="hidden" name="idTournoi" value="<%= request.getAttribute("idTournoi") %>">
                                                <input type="hidden" name="idMatch" value="<%= m.getId() %>">
                                                <div style="display: flex; align-items: center;">
                                                    <input type="number" name="scoreDom" class="score-input" value="0" min="0">
                                                    <span class="vs">VS</span>
                                                    <input type="number" name="scoreExt" class="score-input" value="0" min="0">
                                                </div>
                                                <button type="submit" class="btn-validate">Valider Score</button>
                                            </form>
                                        <% } else { %>
                                            <div class="status-waiting">Match à venir</div>
                                        <% } %>
                                    <% } %>
                                </div>
                            </td>
                            <td class="team-away"><%= m.getNomEquipeExt() %></td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="3" style="padding: 40px; color: gray;">Aucun match programmé pour l'instant.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>