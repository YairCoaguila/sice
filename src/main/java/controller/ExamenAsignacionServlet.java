package controller;
import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.*;
import java.io.IOException;
import java.util.List;
public class ExamenAsignacionServlet extends HttpServlet {
    private final ExamenAsignacionDAO dao=new ExamenAsignacionDAO();
    private final ExamenDAO examenDAO=new ExamenDAO();
    private final DocenteDAO docenteDAO=new DocenteDAO();
    private final AulaDAO aulaDAO=new AulaDAO();
    private final InscripcionDAO inscripcionDAO=new InscripcionDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String accion=q.getParameter("accion"); if(accion==null) accion="";
        if("asignar-aulas".equals(accion)){
            int idEx=Integer.parseInt(q.getParameter("idExamen"));
            List<Aula> aulas=aulaDAO.listar();
            inscripcionDAO.asignarAulasAutomaticamente(idEx, aulas);
            q.getSession().setAttribute("msg","Aulas asignadas autom\u00e1ticamente a los inscritos.");
            r.sendRedirect(q.getContextPath()+"/app/examen-asignacion?idExamen="+idEx);
            return;
        }
        int idEx=Integer.parseInt(q.getParameter("idExamen"));
        Examen ex=examenDAO.buscarPorId(idEx);
        if(ex==null){r.sendRedirect(q.getContextPath()+"/app/examenes");return;}
        if("eliminar".equals(accion)){
            String idStr=q.getParameter("id");
            if(idStr!=null&&!idStr.isBlank()){try{dao.eliminar(Integer.parseInt(idStr));q.getSession().setAttribute("msg","Asignaci\u00f3n eliminada.");}catch(Exception e){q.getSession().setAttribute("msgError","No se pudo eliminar.");}}
            r.sendRedirect(q.getContextPath()+"/app/examen-asignacion?idExamen="+idEx);
            return;
        }
        q.setAttribute("examen",ex);
        q.setAttribute("asignaciones",dao.listarPorExamen(idEx));
        q.setAttribute("docentes",docenteDAO.listar());
        q.setAttribute("aulas",aulaDAO.listar());
        q.getRequestDispatcher("/views/examenes/asignacion-info.jsp").forward(q,r);
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        int idEx=Integer.parseInt(q.getParameter("idExamen"));
        ExamenAsignacion ea=new ExamenAsignacion(); ea.setIdExamen(idEx);
        ea.setIdDocente(Integer.parseInt(q.getParameter("idDocente")));
        ea.setIdAula(Integer.parseInt(q.getParameter("idAula")));
        if (dao.aulaYaAsignada(idEx, ea.getIdAula())) {
            q.getSession().setAttribute("msgError","Ese aula ya está asignada a otro docente de este examen.");
            r.sendRedirect(q.getContextPath()+"/app/examen-asignacion?idExamen="+idEx);
            return;
        }
        dao.insertar(ea);
        q.getSession().setAttribute("msg","Docente asignado al examen.");
        r.sendRedirect(q.getContextPath()+"/app/examen-asignacion?idExamen="+idEx);
    }
}
