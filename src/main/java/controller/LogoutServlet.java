package controller;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
public class LogoutServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        HttpSession s=q.getSession(false); if(s!=null) s.invalidate(); r.sendRedirect(q.getContextPath()+"/login");
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException { doGet(q,r); }
}
