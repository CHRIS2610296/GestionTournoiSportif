package com.tournoi.controller;
import com.tournoi.dao.EquipeDAO; import javax.servlet.ServletException; import javax.servlet.annotation.WebServlet; import javax.servlet.http.*; import java.io.IOException;
@WebServlet("/ClassementServlet")
public class ClassementServlet extends HttpServlet {
    private EquipeDAO equipeDAO = new EquipeDAO();
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idTournoiStr = request.getParameter("idTournoi");
        if (idTournoiStr != null && !idTournoiStr.isEmpty()) {
            int idTournoi = Integer.parseInt(idTournoiStr);
            request.setAttribute("classement", equipeDAO.genererClassement(idTournoi));
            request.setAttribute("idTournoi", idTournoi);
            request.getRequestDispatcher("classement.jsp").forward(request, response);
        } else { response.sendRedirect("TournoiServlet"); }
    }
}