<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %> 
<%@ page import="com.tournoi.model.Equipe" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TournoiMaster - Équipes</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700;14..32,800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem;
        }

        .container {
            max-width: 1100px;
            margin: 0 auto;
            animation: fadeInUp 0.5s ease-out;
        }

        /* Hero Section */
        .hero {
            text-align: center;
            margin-bottom: 2rem;
        }

        .hero h1 {
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, #fff, #e0d4ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
        }

        .hero h1 i {
            background: none;
            -webkit-text-fill-color: #ffd700;
        }

        .hero p {
            color: rgba(255,255,255,0.9);
            font-size: 1rem;
        }

        /* Button Group */
        .button-group {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            padding: 0.75rem 1.5rem;
            border-radius: 2rem;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
        }

        .btn-back {
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
        }

        .btn-back:hover {
            background: rgba(255,255,255,0.3);
            transform: translateX(-3px);
        }

        .btn-add {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.4);
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(10px);
            border-radius: 1rem;
            padding: 1rem;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
        }

        .stat-card i {
            font-size: 1.8rem;
            color: #667eea;
            margin-bottom: 0.5rem;
        }

        .stat-card .stat-value {
            font-size: 1.8rem;
            font-weight: 800;
            color: #1e293b;
        }

        .stat-card .stat-label {
            font-size: 0.75rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Table Container */
        .table-container {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
            border-radius: 1.5rem;
            overflow: hidden;
            box-shadow: 0 20px 35px -10px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255,255,255,0.3);
        }

        .table-header {
            padding: 1.25rem 1.5rem;
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            border-bottom: 3px solid #667eea;
        }

        .table-header h2 {
            color: white;
            font-size: 1.25rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .table-header h2 i {
            color: #10b981;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #f1f5f9;
            padding: 1rem 1rem;
            text-align: left;
            font-weight: 700;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #475569;
            border-bottom: 2px solid #e2e8f0;
        }

        th.center {
            text-align: center;
        }

        td {
            padding: 1rem 1rem;
            border-bottom: 1px solid #f0f2f5;
            font-size: 0.9rem;
            color: #334155;
        }

        tr {
            transition: all 0.2s ease;
        }

        tr:hover {
            background: #f8fafc;
        }

        /* Logo Cell */
        .logo-cell {
            text-align: center;
            width: 80px;
        }

        .team-logo {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            object-fit: cover;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s ease;
        }

        .team-logo:hover {
            transform: scale(1.1);
        }

        .logo-placeholder {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            font-weight: 600;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        /* Team Name */
        .team-name {
            font-weight: 700;
            color: #1e293b;
            font-size: 1rem;
        }

        /* City Badge */
        .city-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            background: #eef2ff;
            padding: 0.25rem 0.75rem;
            border-radius: 2rem;
            font-size: 0.8rem;
            color: #4f46e5;
        }

        .city-badge i {
            font-size: 0.7rem;
        }

        /* Players Count */
        .players-count {
            font-weight: 700;
            color: #667eea;
            background: #eef2ff;
            display: inline-block;
            padding: 0.25rem 0.6rem;
            border-radius: 2rem;
            font-size: 0.8rem;
        }

        /* Contact Info */
        .contact-info {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #64748b;
            font-size: 0.85rem;
        }

        .contact-info i {
            color: #10b981;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #64748b;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .empty-state p {
            margin-bottom: 1.5rem;
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }

            .hero h1 {
                font-size: 1.8rem;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            th, td {
                padding: 0.75rem 0.5rem;
            }

            .team-logo, .logo-placeholder {
                width: 36px;
                height: 36px;
                font-size: 1rem;
            }

            .team-name {
                font-size: 0.85rem;
            }

            .city-badge {
                font-size: 0.7rem;
                padding: 0.2rem 0.5rem;
            }

            .players-count {
                font-size: 0.7rem;
            }

            .contact-info {
                font-size: 0.7rem;
            }
        }

        @media (max-width: 640px) {
            th:nth-child(4), td:nth-child(4),
            th:nth-child(5), td:nth-child(5) {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Hero Section -->
        <div class="hero">
            <h1>
                <i class="fas fa-users"></i>
                Équipes Participantes
                <i class="fas fa-shield-alt"></i>
            </h1>
            <p>Gérez les équipes inscrites dans ce tournoi</p>
        </div>

        <!-- Action Buttons -->
        <div class="button-group">
            <a href="TournoiServlet" class="btn btn-back">
                <i class="fas fa-arrow-left"></i>
                Retour aux Tournois
            </a>
            <a href="TeamServlet?action=ajouter&idTournoi=<%= request.getAttribute("idTournoi") %>" class="btn btn-add">
                <i class="fas fa-plus-circle"></i>
                Inscrire une équipe
            </a>
        </div>

        <% 
        List<Equipe> equipes = (List<Equipe>) request.getAttribute("equipes"); 
        if (equipes != null && !equipes.isEmpty()) {
            // Calculate statistics
            int totalPlayers = 0;
            int totalTeams = equipes.size();
            for (Equipe eq : equipes) {
                totalPlayers += eq.getNombreJoueurs();
            }
            int avgPlayers = totalTeams > 0 ? totalPlayers / totalTeams : 0;
        %>
        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <i class="fas fa-users"></i>
                <div class="stat-value"><%= totalTeams %></div>
                <div class="stat-label">Équipes inscrites</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-user-friends"></i>
                <div class="stat-value"><%= totalPlayers %></div>
                <div class="stat-label">Joueurs total</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-chart-line"></i>
                <div class="stat-value"><%= avgPlayers %></div>
                <div class="stat-label">Moy. par équipe</div>
            </div>
        </div>
        <% } %>

        <!-- Teams Table -->
        <div class="table-container">
            <div class="table-header">
                <h2>
                    <i class="fas fa-list-ul"></i>
                    Liste des équipes
                </h2>
            </div>
            <table>
                <thead>
                    <tr>
                        <th class="center">Logo</th>
                        <th>Nom</th>
                        <th>Ville</th>
                        <th class="center">Joueurs</th>
                        <th>Contact</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    if (equipes != null && !equipes.isEmpty()) { 
                        for (Equipe eq : equipes) { 
                    %>
                    <tr>
                        <td class="logo-cell">
                            <% if(eq.getLogo() != null && !eq.getLogo().trim().isEmpty()) { %>
                                <img src="<%= eq.getLogo() %>" class="team-logo" alt="Logo" onerror="this.style.display='none'; this.nextElementSibling.style.display='inline-flex';">
                                <div class="logo-placeholder" style="display: none;"><%= eq.getNom().charAt(0) %></div>
                            <% } else { %>
                                <div class="logo-placeholder"><%= eq.getNom().charAt(0) %></div>
                            <% } %>
                        </td>
                        <td>
                            <span class="team-name"><%= eq.getNom() %></span>
                        </td>
                        <td>
                            <span class="city-badge">
                                <i class="fas fa-map-marker-alt"></i>
                                <%= eq.getVille() %>
                            </span>
                        </td>
                        <td class="center">
                            <span class="players-count">
                                <i class="fas fa-futbol"></i> <%= eq.getNombreJoueurs() %>
                            </span>
                        </td>
                        <td>
                            <span class="contact-info">
                                <i class="fas fa-envelope"></i>
                                <%= eq.getContact() %>
                            </span>
                        </td>
                    </tr>
                    <% 
                        } 
                    } else { 
                    %>
                    <tr>
                        <td colspan="5">
                            <div class="empty-state">
                                <i class="fas fa-users-slash"></i>
                                <p>Aucune équipe n'est inscrite dans ce tournoi</p>
                                <a href="TeamServlet?action=ajouter&idTournoi=<%= request.getAttribute("idTournoi") %>" class="btn btn-add" style="display: inline-flex;">
                                    <i class="fas fa-plus-circle"></i>
                                    Inscrire la première équipe
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Fix for images that fail to load
        document.querySelectorAll('.team-logo').forEach(img => {
            img.addEventListener('error', function() {
                this.style.display = 'none';
                if (this.nextElementSibling && this.nextElementSibling.classList.contains('logo-placeholder')) {
                    this.nextElementSibling.style.display = 'inline-flex';
                }
            });
        });
    </script>
</body>
</html>