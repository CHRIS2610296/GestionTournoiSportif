<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %> 
<%@ page import="com.tournoi.model.Classement" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TournoiMaster - Classement</title>
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
            max-width: 1200px;
            margin: 0 auto;
            animation: fadeInUp 0.5s ease-out;
        }

        /* Header Section */
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
            font-size: 2rem;
        }

        .hero p {
            color: rgba(255,255,255,0.9);
            font-size: 1rem;
        }

        /* Back Button */
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
            padding: 0.7rem 1.5rem;
            border-radius: 2rem;
            color: white;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.3);
        }

        .back-button:hover {
            background: rgba(255,255,255,0.3);
            transform: translateX(-5px);
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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
            color: #ffd700;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #f1f5f9;
            padding: 1rem 0.75rem;
            text-align: center;
            font-weight: 700;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #475569;
            border-bottom: 2px solid #e2e8f0;
        }

        td {
            padding: 1rem 0.75rem;
            text-align: center;
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

        /* Position Column */
        .position-cell {
            font-weight: 800;
            font-size: 1rem;
        }

        .position-1 {
            background: linear-gradient(135deg, #ffd70020, #ffed4e10);
            border-left: 4px solid #ffd700;
        }

        .position-2 {
            background: linear-gradient(135deg, #c0c0c020, #e8e8e810);
            border-left: 4px solid #c0c0c0;
        }

        .position-3 {
            background: linear-gradient(135deg, #cd7f3220, #f0a05010);
            border-left: 4px solid #cd7f32;
        }

        /* Team Cell */
        .team-cell {
            text-align: left;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .team-logo {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
            background: #f1f5f9;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .team-placeholder {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.8rem;
        }

        .team-name {
            font-weight: 700;
            color: #1e293b;
        }

        /* Points Cell */
        .points-cell {
            font-weight: 800;
            font-size: 1.1rem;
            color: #667eea;
        }

        /* Difference Cell */
        .diff-positive {
            color: #10b981;
            font-weight: 600;
        }

        .diff-negative {
            color: #ef4444;
            font-weight: 600;
        }

        /* Medal Icons */
        .medal {
            font-size: 1.2rem;
        }

        .medal-gold { color: #ffd700; }
        .medal-silver { color: #c0c0c0; }
        .medal-bronze { color: #cd7f32; }

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
                padding: 0.75rem 0.4rem;
                font-size: 0.75rem;
            }

            .team-cell {
                gap: 0.4rem;
            }

            .team-logo, .team-placeholder {
                width: 24px;
                height: 24px;
                font-size: 0.6rem;
            }

            .team-name {
                font-size: 0.8rem;
            }

            .points-cell {
                font-size: 0.9rem;
            }
        }

        @media (max-width: 640px) {
            th:nth-child(6), th:nth-child(7), th:nth-child(8),
            td:nth-child(6), td:nth-child(7), td:nth-child(8) {
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
                <i class="fas fa-trophy"></i>
                Classement Officiel
                <i class="fas fa-chart-line"></i>
            </h1>
            <p>Suivez l'évolution des équipes et les statistiques du tournoi</p>
        </div>

        <!-- Back Button -->
        <a href="MatchServlet?idTournoi=<%= request.getAttribute("idTournoi") %>" class="back-button">
            <i class="fas fa-arrow-left"></i>
            Retour aux Matchs
        </a>

        <% 
        List<Classement> liste = (List<Classement>) request.getAttribute("classement");
        if (liste != null && !liste.isEmpty()) {
            // Calculate statistics
            int totalTeams = liste.size();
            int totalGoals = 0;
            int topScore = 0;
            String topTeam = "";
            for (Classement c : liste) {
                totalGoals += c.getButsPour();
                if (c.getButsPour() > topScore) {
                    topScore = c.getButsPour();
                    topTeam = c.getNomEquipe();
                }
            }
        %>
        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <i class="fas fa-users"></i>
                <div class="stat-value"><%= totalTeams %></div>
                <div class="stat-label">Équipes</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-futbol"></i>
                <div class="stat-value"><%= totalGoals %></div>
                <div class="stat-label">Buts marqués</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-chart-simple"></i>
                <div class="stat-value"><%= (int)(totalGoals * 1.0 / totalTeams) %></div>
                <div class="stat-label">Moy. buts/équipe</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-crown"></i>
                <div class="stat-value" style="font-size: 1rem;"><%= topTeam.length() > 15 ? topTeam.substring(0, 12) + "..." : topTeam %></div>
                <div class="stat-label">Meilleure attaque</div>
            </div>
        </div>
        <% } %>

        <!-- Ranking Table -->
        <div class="table-container">
            <div class="table-header">
                <h2>
                    <i class="fas fa-ranking-star"></i>
                    Classement Général
                </h2>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th style="text-align:left;">Équipe</th>
                        <th>Pts</th>
                        <th>J</th>
                        <th>G</th>
                        <th>N</th>
                        <th>P</th>
                        <th>BP</th>
                        <th>BC</th>
                        <th>Diff</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    if (liste != null && !liste.isEmpty()) { 
                        int pos = 1; 
                        for (Classement c : liste) { 
                            String positionClass = "";
                            String medalIcon = "";
                            if (pos == 1) {
                                positionClass = "position-1";
                                medalIcon = "<i class='fas fa-crown medal medal-gold'></i>";
                            } else if (pos == 2) {
                                positionClass = "position-2";
                                medalIcon = "<i class='fas fa-medal medal medal-silver'></i>";
                            } else if (pos == 3) {
                                positionClass = "position-3";
                                medalIcon = "<i class='fas fa-medal medal medal-bronze'></i>";
                            }
                    %>
                    <tr class="<%= positionClass %>">
                        <td class="position-cell">
                            <%= medalIcon %>
                            <span style="margin-left: 4px;"><%= pos %></span>
                        </td>
                        <td style="text-align:left;">
                            <div class="team-cell">
                                <% if(c.getLogo() != null && !c.getLogo().trim().isEmpty()) { %>
                                    <img src="<%= c.getLogo() %>" class="team-logo" alt="logo" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                    <div class="team-placeholder" style="display: none;"><%= c.getNomEquipe().charAt(0) %></div>
                                <% } else { %>
                                    <div class="team-placeholder"><%= c.getNomEquipe().charAt(0) %></div>
                                <% } %>
                                <span class="team-name"><%= c.getNomEquipe() %></span>
                            </div>
                        </td>
                        <td class="points-cell"><%= c.getPoints() %></td>
                        <td><%= c.getMatchsJoues() %></td>
                        <td><%= c.getVictoires() %></td>
                        <td><%= c.getNuls() %></td>
                        <td><%= c.getDefaites() %></td>
                        <td><strong><%= c.getButsPour() %></strong></td>
                        <td><%= c.getButsContre() %></td>
                        <td class="<%= c.getDifferenceButs() > 0 ? "diff-positive" : (c.getDifferenceButs() < 0 ? "diff-negative" : "") %>">
                            <%= (c.getDifferenceButs() > 0 ? "+" : "") + c.getDifferenceButs() %>
                        </td>
                    </tr>
                    <% 
                            pos++;
                        } 
                    } else { 
                    %>
                    <tr>
                        <td colspan="10">
                            <div class="empty-state">
                                <i class="fas fa-chart-simple"></i>
                                <p>Classement non disponible pour le moment</p>
                                <p style="font-size: 0.8rem; margin-top: 0.5rem;">Les données apparaîtront après les premiers matchs</p>
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
                if (this.nextElementSibling && this.nextElementSibling.classList.contains('team-placeholder')) {
                    this.nextElementSibling.style.display = 'flex';
                }
            });
        });
    </script>
</body>
</html>