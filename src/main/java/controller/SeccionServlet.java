package controller;
import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Seccion;
import java.io.IOException;
public class SeccionServlet extends HttpServlet {
    private final SeccionDAO dao=new SeccionDAO(); private final GradoDAO gradoDAO=new GradoDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String a=q.getParameter("accion"); if(a==null) a="listar";
        switch(a){
            case "nuevo","editar" ->{q.setAttribute("grados",gradoDAO.listar());if("editar".equals(a)) q.setAttribute("seccion",dao.buscarPorId(Integer.parseInt(q.getParameter("id"))));q.getRequestDispatcher("/views/shared/seccion-form.jsp").forward(q,r);}
            case "eliminar"       ->{try{dao.eliminar(Integer.parseInt(q.getParameter("id")));q.getSession().setAttribute("msg","Sección eliminada.");}catch(Exception e){q.getSession().setAttribute("msgError","No se puede eliminar.");}r.sendRedirect(q.getContextPath()+"/app/secciones");}
            default               ->{q.setAttribute("entityType","secciones");q.setAttribute("secciones",dao.listar());q.getRequestDispatcher("/views/shared/catalogo.jsp").forward(q,r);}
        }
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        Seccion s=new Seccion(); String id=q.getParameter("id"); if(id!=null&&!id.isBlank()) s.setId(Integer.parseInt(id));
        s.setNombre(q.getParameter("nombre").trim()); s.setIdGrado(Integer.parseInt(q.getParameter("idGrado")));
        if(s.getId()>0) dao.actualizar(s); else dao.insertar(s);
        q.getSession().setAttribute("msg","Sección guardada."); r.sendRedirect(q.getContextPath()+"/app/secciones");
    }
}
