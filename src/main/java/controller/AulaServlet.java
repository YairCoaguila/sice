package controller;
import dao.AulaDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Aula;
import java.io.IOException;
public class AulaServlet extends HttpServlet {
    private final AulaDAO dao=new AulaDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String a=q.getParameter("accion"); if(a==null) a="listar";
        switch(a){
            case "nuevo" ->{q.setAttribute("aula",null);fwd(q,r);}
            case "editar"->{q.setAttribute("aula",dao.buscarPorId(Integer.parseInt(q.getParameter("id"))));fwd(q,r);}
            case "eliminar"->{
                try{dao.eliminar(Integer.parseInt(q.getParameter("id")));q.getSession().setAttribute("msg","Aula eliminada.");}
                catch(Exception e){q.getSession().setAttribute("msgError","No se puede eliminar el aula.");}
                r.sendRedirect(q.getContextPath()+"/app/aulas");
            }
            default->{q.setAttribute("aulas",dao.listar());q.getRequestDispatcher("/views/aulas/lista.jsp").forward(q,r);}
        }
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        Aula a=new Aula(); String id=q.getParameter("id"); if(id!=null&&!id.isBlank()) a.setId(Integer.parseInt(id));
        a.setCodigo(q.getParameter("codigo").trim());
        try{ a.setCapacidad(Integer.parseInt(q.getParameter("capacidad"))); }catch(NumberFormatException e){ a.setCapacidad(0); }
        a.setDescripcion(q.getParameter("descripcion"));
        if(a.getId()>0) dao.actualizar(a); else dao.insertar(a);
        q.getSession().setAttribute("msg","Aula guardada."); r.sendRedirect(q.getContextPath()+"/app/aulas");
    }
    private void fwd(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.getRequestDispatcher("/views/aulas/formulario.jsp").forward(q,r);
    }
}
