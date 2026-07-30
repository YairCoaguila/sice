package controller;
import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.DocenteAula;
import java.io.IOException;
public class DocenteAulaServlet extends HttpServlet {
    private final DocenteAulaDAO dao=new DocenteAulaDAO();
    private final DocenteDAO docenteDAO=new DocenteDAO();
    private final GradoDAO gradoDAO=new GradoDAO();
    private final SeccionDAO seccionDAO=new SeccionDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String a=q.getParameter("accion"); if(a==null) a="listar";
        switch(a){
            case "nuevo","editar" ->{q.setAttribute("docentes",docenteDAO.listar());q.setAttribute("grados",gradoDAO.listarParticipantes());q.setAttribute("secciones",seccionDAO.listar());if("editar".equals(a)) q.setAttribute("asignacion",dao.buscarPorId(Integer.parseInt(q.getParameter("id"))));q.getRequestDispatcher("/views/docentes/asignacion-form.jsp").forward(q,r);}
            case "eliminar"       ->{try{dao.eliminar(Integer.parseInt(q.getParameter("id")));q.getSession().setAttribute("msg","Asignación eliminada.");}catch(Exception e){q.getSession().setAttribute("msgError","No se puede eliminar.");}r.sendRedirect(q.getContextPath()+"/app/docente-aula");}
            default               ->{q.setAttribute("asignaciones",dao.listar());q.getRequestDispatcher("/views/docentes/asignaciones.jsp").forward(q,r);}
        }
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        DocenteAula da=new DocenteAula(); String id=q.getParameter("id"); if(id!=null&&!id.isBlank()) da.setId(Integer.parseInt(id));
        da.setIdDocente(Integer.parseInt(q.getParameter("idDocente"))); da.setIdGrado(Integer.parseInt(q.getParameter("idGrado")));
        da.setIdSeccion(Integer.parseInt(q.getParameter("idSeccion"))); da.setAnio(Integer.parseInt(q.getParameter("anio"))); da.setPeriodo(q.getParameter("periodo"));
        if(da.getId()>0) dao.actualizar(da); else dao.insertar(da);
        q.getSession().setAttribute("msg","Asignación guardada."); r.sendRedirect(q.getContextPath()+"/app/docente-aula");
    }
}
