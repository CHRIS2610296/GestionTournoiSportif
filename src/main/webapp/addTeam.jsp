<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %> 
<%@ page import="com.tournoi.model.Equipe" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TournoiMaster - Inscription Équipe</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700&display=swap" rel="stylesheet">
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
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Main Container */
        .container {
            max-width: 650px;
            width: 100%;
            margin: 0 auto;
            animation: fadeInUp 0.5s ease-out;
        }

        /* Back Button */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
            padding: 0.6rem 1.2rem;
            border-radius: 2rem;
            color: white;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.3);
        }

        .back-link:hover {
            background: rgba(255,255,255,0.3);
            transform: translateX(-5px);
        }

        /* Main Card */
        .glass-card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
            border-radius: 2rem;
            padding: 2rem;
            box-shadow: 0 25px 45px -12px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255,255,255,0.3);
            transition: transform 0.3s ease;
        }

        .glass-card:hover {
            transform: translateY(-3px);
        }

        /* Header */
        .card-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .card-header .icon-circle {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
        }

        .card-header .icon-circle i {
            font-size: 2rem;
            color: white;
        }

        .card-header h2 {
            font-size: 1.8rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.25rem;
        }

        .card-header p {
            color: #64748b;
            font-size: 0.9rem;
        }

        /* Quick Add Section */
        .quick-add {
            background: linear-gradient(135deg, #f0f4ff 0%, #e8eeff 100%);
            padding: 1.25rem;
            border-radius: 1rem;
            margin-bottom: 1.75rem;
            border-left: 4px solid #667eea;
        }

        .quick-add label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            color: #4f46e5;
            margin-bottom: 0.75rem;
            font-size: 0.9rem;
        }

        .quick-add label i {
            font-size: 1rem;
        }

        .quick-add select {
            width: 100%;
            padding: 0.85rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 0.75rem;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            background: white;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .quick-add select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        /* Form Styles */
        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-group label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            color: #334155;
            font-size: 0.85rem;
            margin-bottom: 0.5rem;
        }

        .form-group label i {
            color: #667eea;
            width: 1.25rem;
            font-size: 0.9rem;
        }

        .form-group input {
            width: 100%;
            padding: 0.85rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 0.75rem;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            transition: all 0.2s ease;
            background: #fafcff;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group input::placeholder {
            color: #cbd5e1;
        }

        /* Double Input Row */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        /* Submit Button */
        .btn-submit {
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 1rem;
            border-radius: 0.75rem;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            margin-top: 0.5rem;
        }

        .btn-submit:hover {
            transform: scale(0.98);
            box-shadow: 0 10px 20px -5px rgba(102, 126, 234, 0.4);
        }

        /* Cancel Link */
        .cancel-link {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1rem;
            border-top: 1px solid #eef2ff;
            color: #94a3b8;
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.2s ease;
        }

        .cancel-link:hover {
            color: #ef4444;
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

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }

        /* Responsive */
        @media (max-width: 640px) {
            body {
                padding: 1rem;
            }
            
            .glass-card {
                padding: 1.5rem;
            }
            
            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }
            
            .card-header h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Back Button -->
        <a href="TeamServlet?idTournoi=<%= request.getAttribute("idTournoi") %>" class="back-link">
            <i class="fas fa-arrow-left"></i>
            Retour aux équipes
        </a>

        <!-- Main Card -->
        <div class="glass-card">
            <div class="card-header">
                <div class="icon-circle">
                    <i class="fas fa-users"></i>
                </div>
                <h2>Nouvelle Équipe</h2>
                <p>Inscrivez votre équipe au tournoi</p>
            </div>

            <!-- Quick Selection -->
            <div class="quick-add">
                <label>
                    <i class="fas fa-bolt"></i>
                    Sélection rapide
                </label>
                <select id="quickSelect" onchange="remplirFormulaire()">
                    <option value="">-- Choisir un club existant --</option>
                    <% 
                        List<Equipe> existantes = (List<Equipe>) request.getAttribute("equipesExistantes");
                        if (existantes != null && !existantes.isEmpty()) {
                            for (Equipe eq : existantes) {
                    %>
                    <option value="<%= eq.getNom() %>" 
                            data-ville="<%= eq.getVille() %>" 
                            data-contact="<%= eq.getContact() %>" 
                            data-logo="<%= eq.getLogo() != null ? eq.getLogo() : "" %>">
                        <i class="fas fa-shield-alt"></i> <%= eq.getNom() %> - <%= eq.getVille() %>
                    </option>
                    <%      }
                        } else { 
                    %>
                    <option value="" disabled>Aucune équipe existante</option>
                    <% } %>
                </select>
            </div>

            <!-- Registration Form -->
            <form action="TeamServlet" method="POST">
                <input type="hidden" name="idTournoi" value="<%= request.getAttribute("idTournoi") %>">
                
                <div class="form-group">
                    <label><i class="fas fa-tag"></i> Nom de l'équipe</label>
                    <input type="text" id="inputNom" name="nom" placeholder="Ex: Olympique Marseille" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label><i class="fas fa-map-marker-alt"></i> Ville</label>
                        <input type="text" id="inputVille" name="ville" placeholder="Paris, Lyon, ..." required>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-users"></i> Nombre de joueurs</label>
                        <input type="number" name="nombreJoueurs" value="11" min="1" max="50" required>
                    </div>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-envelope"></i> Contact</label>
                    <input type="text" id="inputContact" name="contact" placeholder="Email ou téléphone" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-image"></i> URL du Logo</label>
                    <input type="text" id="inputLogo" name="logo" placeholder="https://exemple.com/logo.png">
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fas fa-save"></i>
                    Enregistrer l'équipe
                </button>
            </form>

            <a href="TeamServlet?idTournoi=<%= request.getAttribute("idTournoi") %>" class="cancel-link">
                <i class="fas fa-times-circle"></i>
                Annuler l'inscription
            </a>
        </div>
    </div>

    <script>
        function remplirFormulaire() {
            var select = document.getElementById("quickSelect");
            var selectedOption = select.options[select.selectedIndex];
            
            if (selectedOption.value !== "") {
                document.getElementById("inputNom").value = selectedOption.value;
                document.getElementById("inputVille").value = selectedOption.getAttribute("data-ville") || "";
                document.getElementById("inputContact").value = selectedOption.getAttribute("data-contact") || "";
                document.getElementById("inputLogo").value = selectedOption.getAttribute("data-logo") || "";
                
                // Add a subtle animation effect
                var inputs = document.querySelectorAll('.form-group input');
                inputs.forEach(input => {
                    input.style.transition = 'all 0.2s ease';
                    input.style.borderColor = '#667eea';
                    setTimeout(() => {
                        input.style.borderColor = '#e2e8f0';
                    }, 500);
                });
            } else {
                document.getElementById("inputNom").value = "";
                document.getElementById("inputVille").value = "";
                document.getElementById("inputContact").value = "";
                document.getElementById("inputLogo").value = "";
            }
        }
    </script>
</body>
</html>