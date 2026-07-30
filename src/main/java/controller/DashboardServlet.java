package controller;
import dao.DashboardDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
public class DashboardServlet extends HttpServlet {
    private final DashboardDAO dao=new DashboardDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        try{
            q.setAttribute("stats",dao.obtenerEstadisticas());
            q.setAttribute("top10",dao.top10Alumnos());
            q.setAttribute("porCarrera",dao.inscritosPorCarrera());
            q.setAttribute("porGrado",dao.inscritosPorGrado());
        }catch(Exception e){q.setAttribute("dashError",e.getMessage());}
        q.getRequestDispatcher("/views/shared/dashboard.jsp").forward(q,r);
    }
}
