<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Connexion - TournoiSportif</title>
    <style>
        body { font-family: Arial; background-color: #f4f4f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-card { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 10px 20px rgba(0,0,0,0.1); width: 100%; max-width: 400px; text-align: center; border-top: 5px solid #007bff; }
        input, button { width: 100%; padding: 12px; margin: 10px 0; border-radius: 5px; border: 1px solid #ccc; box-sizing: border-box; font-size: 1em; }
        button { background-color: #007bff; color: white; border: none; cursor: pointer; font-weight: bold; }
        button:hover { background-color: #0056b3; }
        .error { color: #dc3545; font-weight: bold; margin-bottom: 15px; background: #f8d7da; padding: 10px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="login-card">
        <h1 style="color: #333; margin-top: 0;">⚽ Connexion</h1>
        <p style="color: #666; margin-bottom: 20px;">Accès sécurisé à la plateforme</p>
        
        <% if(request.getAttribute("erreur") != null) { %>
            <div class="error"><%= request.getAttribute("erreur") %></div>
        <% } %>

        <form action="LoginServlet" method="POST">
            <input type="text" name="username" placeholder="Nom d'utilisateur" required>
            <input type="password" name="password" placeholder="Mot de passe" required>
            <button type="submit">Se connecter</button>
        </form>
    </div>
</body>
</html>