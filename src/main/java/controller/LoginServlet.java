package controller;
import dao.UsuarioDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Usuario;
import java.io.IOException;
public class LoginServlet extends HttpServlet {
    private final UsuarioDAO dao = new UsuarioDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        HttpSession s=q.getSession(false);
        if(s!=null){Usuario u=(Usuario)s.getAttribute("usuarioLogueado");if(u!=null){r.sendRedirect(q.getContextPath()+(u.isDocente()?"/docente/dashboard":"/app/dashboard"));return;}}
        q.getRequestDispatcher("/views/shared/login.jsp").forward(q,r);
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        String u=q.getParameter("username"), p=q.getParameter("password");
        if(u==null||u.isBlank()||p==null||p.isBlank()){q.setAttribute("error","Usuario y contraseña requeridos.");q.getRequestDispatcher("/views/shared/login.jsp").forward(q,r);return;}
        try{
            Usuario usr=dao.autenticar(u.trim(),p.trim());
            if(usr!=null){HttpSession s=q.getSession(true);s.setAttribute("usuarioLogueado",usr);s.setMaxInactiveInterval(1800);String dest=usr.isDocente()?"/docente/dashboard":"/app/dashboard";r.sendRedirect(q.getContextPath()+dest);}
            else{q.setAttribute("error","Usuario o contraseña incorrectos.");q.getRequestDispatcher("/views/shared/login.jsp").forward(q,r);}
        }catch(Exception e){q.setAttribute("error","Error: "+e.getMessage());q.getRequestDispatcher("/views/shared/login.jsp").forward(q,r);}
    }
}
