package controller;
import dao.PeriodoDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Periodo;
import java.io.IOException;
public class PeriodoServlet extends HttpServlet {
    private final PeriodoDAO dao=new PeriodoDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String a=q.getParameter("accion"); if(a==null) a="listar";
        switch(a){
            case "nuevo","editar" ->{if("editar".equals(a)) q.setAttribute("periodo",dao.buscarPorId(Integer.parseInt(q.getParameter("id"))));q.getRequestDispatcher("/views/shared/periodo-form.jsp").forward(q,r);}
            case "eliminar"       ->{try{dao.eliminar(Integer.parseInt(q.getParameter("id")));q.getSession().setAttribute("msg","Periodo eliminado.");}catch(Exception e){q.getSession().setAttribute("msgError","No se puede eliminar.");}r.sendRedirect(q.getContextPath()+"/app/periodos");}
            default               ->{q.setAttribute("entityType","periodos");q.setAttribute("periodos",dao.listar());q.getRequestDispatcher("/views/shared/catalogo.jsp").forward(q,r);}
        }
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        Periodo p=new Periodo(); String id=q.getParameter("id"); if(id!=null&&!id.isBlank()) p.setId(Integer.parseInt(id));
        p.setNombre(q.getParameter("nombre")); p.setAnio(Integer.parseInt(q.getParameter("anio")));
        p.setDescripcion(q.getParameter("descripcion")); p.setActivo("on".equals(q.getParameter("activo")));
        if(p.getId()>0) dao.actualizar(p); else dao.insertar(p);
        q.getSession().setAttribute("msg","Periodo guardado."); r.sendRedirect(q.getContextPath()+"/app/periodos");
    }
}
