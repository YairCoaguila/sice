package controller;
import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Carrera;
import java.io.IOException;
public class CarreraServlet extends HttpServlet {
    private final CarreraDAO dao=new CarreraDAO(); private final AreaDAO areaDAO=new AreaDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String a=q.getParameter("accion"); if(a==null) a="listar";
        switch(a){
            case "nuevo","editar" ->{q.setAttribute("areas",areaDAO.listar());if("editar".equals(a)) q.setAttribute("carrera",dao.buscarPorId(Integer.parseInt(q.getParameter("id"))));q.getRequestDispatcher("/views/shared/carrera-form.jsp").forward(q,r);}
            case "eliminar"       ->{try{dao.eliminar(Integer.parseInt(q.getParameter("id")));q.getSession().setAttribute("msg","Carrera eliminada.");}catch(Exception e){q.getSession().setAttribute("msgError","No se puede eliminar.");}r.sendRedirect(q.getContextPath()+"/app/carreras");}
            default               ->{q.setAttribute("entityType","carreras");q.setAttribute("carreras",dao.listar());q.getRequestDispatcher("/views/shared/catalogo.jsp").forward(q,r);}
        }
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        Carrera c=new Carrera(); String id=q.getParameter("id"); if(id!=null&&!id.isBlank()) c.setId(Integer.parseInt(id));
        c.setNombre(q.getParameter("nombre").trim()); c.setIdArea(Integer.parseInt(q.getParameter("idArea"))); c.setDescripcion(q.getParameter("descripcion"));
        if(c.getId()>0) dao.actualizar(c); else dao.insertar(c);
        q.getSession().setAttribute("msg","Carrera guardada."); r.sendRedirect(q.getContextPath()+"/app/carreras");
    }
}
