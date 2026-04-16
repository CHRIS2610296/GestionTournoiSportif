<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %> 
<%@ page import="com.tournoi.model.Tournoi" %>
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
    <title>Gestion Tournois</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* (Le CSS reste identique, très moderne) */
        :root { --bg-color: #F9FAFB; --surface-color: #FFFFFF; --border-color: #E5E7EB; --text-primary: #111827; --text-secondary: #6B7280; --accent-color: #0F172A; --accent-hover: #1E293B; --danger-color: #EF4444; --radius: 8px; --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05); --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background-color: var(--bg-color); color: var(--text-primary); line-height: 1.5; }
        .navbar { background: var(--surface-color); border-bottom: 1px solid var(--border-color); position: sticky; top: 0; z-index: 100; }
        .navbar-content { max-width: 1000px; margin: 0 auto; padding: 16px 24px; display: flex; justify-content: space-between; align-items: center; }
        .brand { font-weight: 700; font-size: 1.25rem; display: flex; align-items: center; gap: 8px; }
        .user-menu { display: flex; align-items: center; gap: 16px; font-size: 0.875rem; color: var(--text-secondary); }
        .user-name { font-weight: 600; color: var(--text-primary); }
        .btn-logout { color: var(--danger-color); text-decoration: none; font-weight: 500; padding: 6px 12px; border-radius: 6px; transition: background 0.2s; }
        .btn-logout:hover { background: #FEF2F2; }
        .container { max-width: 1000px; margin: 40px auto; padding: 0 24px; }
        .section-title { font-size: 1.125rem; font-weight: 600; margin-bottom: 16px; color: var(--text-primary); }
        .card { background: var(--surface-color); border: 1px solid var(--border-color); border-radius: var(--radius); box-shadow: var(--shadow-sm); margin-bottom: 32px; overflow: hidden; }
        .card-body { padding: 24px; }
        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin-bottom: 24px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group label { font-size: 0.875rem; font-weight: 500; }
        .form-group input, .form-group select { padding: 10px 12px; border: 1px solid var(--border-color); border-radius: 6px; font-family: inherit; font-size: 0.875rem; background-color: #F9FAFB; }
        .btn { display: inline-flex; align-items: center; justify-content: center; gap: 8px; padding: 10px 16px; border: none; border-radius: 6px; font-weight: 500; font-size: 0.875rem; cursor: pointer; text-decoration: none; transition: 0.2s; }
        .btn-primary { background: var(--accent-color); color: white; }
        .btn-primary:hover { background: var(--accent-hover); }
        .btn-secondary { background: white; color: var(--text-primary); border: 1px solid var(--border-color); }
        .btn-secondary:hover { background: #F9FAFB; border-color: #D1D5DB; }
        .btn-spectator { background: #E0E7FF; color: #3730A3; font-weight: 600; width: 100%; border: 1px solid #C7D2FE;}
        .btn-spectator:hover { background: #C7D2FE; }
        .tournoi-item { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid var(--border-color); }
        .tournoi-item:hover { background-color: #F8FAFC; }
        .tournoi-info { display: flex; flex-direction: column; gap: 8px; }
        .tournoi-header { display: flex; align-items: center; gap: 12px; }
        .tournoi-title { font-size: 1rem; font-weight: 600; }
        .badge { padding: 2px 8px; border-radius: 9999px; font-size: 0.75rem; font-weight: 500; }
        .badge-sport { background: #E0E7FF; color: #3730A3; }
        .badge-type { background: #FEF3C7; color: #92400E; }
        .tournoi-meta { font-size: 0.875rem; color: var(--text-secondary); display: flex; gap: 16px; }
        .empty-state { padding: 48px 24px; text-align: center; color: var(--text-secondary); }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <div class="brand"><span>🏆</span> TournoiSportif</div>
            <% if(currentUser != null) { %>
            <div class="user-menu">
                <span><span class="user-name"><%= currentUser.getUsername() %></span> (<%= currentUser.getRole() %>)</span>
                <a href="LogoutServlet" class="btn-logout">Déconnexion</a>
            </div>
            <% } %>
        </div>
    </nav>

    <div class="container">
        <% if (peutModifier) { %>
        <div class="card">
            <div class="card-body">
                <h2 class="section-title">Nouveau tournoi</h2>
                <form action="TournoiServlet" method="POST">
                    <div class="form-grid">
                        <div class="form-group"><label>Nom du tournoi</label><input type="text" name="nom" required></div>
                        <div class="form-group"><label>Sport</label><select name="sport"><option value="Football">Football</option><option value="Basketball">Basketball</option></select></div>
                        <div class="form-group"><label>Format</label><select name="typeTournoi"><option value="Championnat">Championnat</option><option value="Elimination">Élimination directe</option></select></div>
                        <div class="form-group"><label>Lieu</label><input type="text" name="lieu"></div>
                        <div class="form-group"><label>Date de début</label><input type="date" name="dateDebut" required></div>
                        <div class="form-group"><label>Date de fin</label><input type="date" name="dateFin" required></div>
                    </div>
                    <button type="submit" class="btn btn-primary">Créer le tournoi</button>
                </form>
            </div>
        </div>
        <% } %>

        <h2 class="section-title">Tournois en cours</h2>
        <div class="card">
            <div class="tournoi-list">
                <% 
                List<Tournoi> tournois = (List<Tournoi>) request.getAttribute("tournois"); 
                if (tournois != null && !tournois.isEmpty()) { 
                    for (Tournoi t : tournois) { 
                %>
                <div class="tournoi-item">
                    <div class="tournoi-info">
                        <div class="tournoi-header">
                            <span class="tournoi-title"><%= t.getNom() %></span>
                            <span class="badge badge-sport"><%= t.getSport() %></span>
                            <span class="badge badge-type"><%= t.getTypeTournoi() %></span>
                        </div>
                        <div class="tournoi-meta">
                            <span>📍 <%= t.getLieu() != null ? t.getLieu() : "Non spécifié" %></span>
                            <span>📅 <%= t.getDateDebut() %> au <%= t.getDateFin() %></span>
                        </div>
                    </div>
                    <div class="action-buttons">
                        <% if (peutModifier) { %>
                            <a href="TeamServlet?idTournoi=<%= t.getId() %>" class="btn btn-secondary">Équipes</a>
                            <a href="MatchServlet?idTournoi=<%= t.getId() %>" class="btn btn-primary">Gérer Matchs</a>
                        <% } else { %>
                            <a href="MatchServlet?idTournoi=<%= t.getId() %>" class="btn btn-spectator">📅 Voir Calendrier & Scores</a>
                        <% } %>
                    </div>
                </div>
                <% } } else { %>
                <div class="empty-state">
                    <div style="font-size: 2rem; margin-bottom: 10px;">📭</div>
                    <h3>Aucun tournoi disponible</h3>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>