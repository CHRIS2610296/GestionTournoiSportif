package com.tournoi.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// Ce filtre sécurise tout le site
@WebFilter("/*")
public class AuthFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        String loginURI = req.getContextPath() + "/LoginServlet";
        String loginPage = req.getContextPath() + "/login.jsp";

        boolean loggedIn = session != null && session.getAttribute("utilisateurConnecte") != null;
        boolean loginRequest = req.getRequestURI().equals(loginURI) || req.getRequestURI().equals(loginPage);
        // On laisse passer les éventuelles images ou CSS
        boolean isStaticResource = req.getRequestURI().matches(".*(css|jpg|png|gif|js)");

        if (loggedIn || loginRequest || isStaticResource) {
            chain.doFilter(request, response); // Autorisé
        } else {
            res.sendRedirect(loginURI); // Bloqué : redirection vers login
        }
    }
}