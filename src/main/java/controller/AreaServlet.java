package controller;
import dao.AreaDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Area;
import java.io.IOException;
public class AreaServlet extends HttpServlet {
    private final AreaDAO dao=new AreaDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String a=q.getParameter("accion"); if(a==null) a="listar";
        switch(a){
            case "nuevo","editar" ->{if("editar".equals(a)) q.setAttribute("area",dao.buscarPorId(Integer.parseInt(q.getParameter("id"))));q.getRequestDispatcher("/views/shared/area-form.jsp").forward(q,r);}
            case "eliminar"       ->{try{dao.eliminar(Integer.parseInt(q.getParameter("id")));q.getSession().setAttribute("msg","Área eliminada.");}catch(Exception e){q.getSession().setAttribute("msgError","No se puede eliminar.");}r.sendRedirect(q.getContextPath()+"/app/areas");}
            default               ->{q.setAttribute("entityType","areas");q.setAttribute("areas",dao.listar());q.getRequestDispatcher("/views/shared/catalogo.jsp").forward(q,r);}
        }
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        Area ar=new Area(); String id=q.getParameter("id"); if(id!=null&&!id.isBlank()) ar.setId(Integer.parseInt(id));
        ar.setNombre(q.getParameter("nombre").trim()); ar.setDescripcion(q.getParameter("descripcion"));
        if(ar.getId()>0) dao.actualizar(ar); else dao.insertar(ar);
        q.getSession().setAttribute("msg","Área guardada."); r.sendRedirect(q.getContextPath()+"/app/areas");
    }
}
