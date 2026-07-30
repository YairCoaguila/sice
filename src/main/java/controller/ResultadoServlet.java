package controller;
import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Resultado;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
public class ResultadoServlet extends HttpServlet {
    private final ResultadoDAO dao=new ResultadoDAO();
    private final ExamenDAO examenDAO=new ExamenDAO();
    private final AlumnoDAO alumnoDAO=new AlumnoDAO();
    private final InscripcionDAO inscDAO=new InscripcionDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        if("csv".equals(q.getParameter("export"))){
            int idEx=Integer.parseInt(q.getParameter("idExamen"));
            List<Resultado> list=dao.listarPorExamen(idEx);
            r.setContentType("text/csv; charset=UTF-8");
            r.setHeader("Content-Disposition","attachment; filename=\"resultados_"+idEx+".csv\"");
            PrintWriter w=r.getWriter(); w.write('\uFEFF');
            w.println("Puesto,Alumno,DNI,Grado/Seccion,Carrera,Puntaje,Correctas,Incorrectas,En Blanco,Porcentaje");
            int p=1; for(Resultado res:list){w.println(p+","+csv(res.getAlumnoNombre())+","+csv(res.getAlumnoDni())+","+csv(res.getSeccionNombre())+","+csv(res.getCarreraNombre())+","+res.getPuntaje()+","+res.getCorrectas()+","+res.getIncorrectas()+","+res.getEnBlanco()+","+res.getPorcentaje());p++;}
            w.flush(); return;
        }
        String a=q.getParameter("accion"); if(a==null) a="listar";
        if("nuevo".equals(a)){q.setAttribute("examenes",examenDAO.listar());q.setAttribute("alumnos",alumnoDAO.listar());q.setAttribute("inscripciones",inscDAO.listar());q.getRequestDispatcher("/views/resultados/formulario.jsp").forward(q,r);return;}
        if("editar".equals(a)){q.setAttribute("res",dao.buscarPorId(Integer.parseInt(q.getParameter("id"))));q.setAttribute("examenes",examenDAO.listar());q.setAttribute("alumnos",alumnoDAO.listar());q.setAttribute("inscripciones",inscDAO.listar());q.getRequestDispatcher("/views/resultados/formulario.jsp").forward(q,r);return;}
        if("eliminar".equals(a)){dao.eliminar(Integer.parseInt(q.getParameter("id")));q.getSession().setAttribute("msg","Resultado eliminado.");r.sendRedirect(q.getContextPath()+"/app/resultados");return;}
        q.setAttribute("examenes",examenDAO.listar());
        String idEx=q.getParameter("idExamen");
        if(idEx!=null&&!idEx.isBlank()){int id=Integer.parseInt(idEx);q.setAttribute("resultados",dao.listarPorExamen(id));q.setAttribute("idExamenSel",id);q.setAttribute("examenSel",examenDAO.buscarPorId(id));}
        q.getRequestDispatcher("/views/resultados/lista.jsp").forward(q,r);
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        Resultado res=new Resultado();
        String idStr=q.getParameter("id"); if(idStr!=null&&!idStr.isBlank()) res.setId(Integer.parseInt(idStr));
        int idExamen=Integer.parseInt(q.getParameter("idExamen"));
        res.setIdAlumno(Integer.parseInt(q.getParameter("idAlumno"))); res.setIdExamen(idExamen);
        res.setCorrectas(Integer.parseInt(q.getParameter("correctas"))); res.setIncorrectas(Integer.parseInt(q.getParameter("incorrectas"))); res.setEnBlanco(Integer.parseInt(q.getParameter("enBlanco")));
        var ex=examenDAO.buscarPorId(idExamen);
        
        int totalRespuestas = res.getCorrectas() + res.getIncorrectas() + res.getEnBlanco();
        if (ex != null && totalRespuestas != ex.getCantidadPreguntas()) {
            q.setAttribute("res", res);
            q.setAttribute("error", "La suma de correctas, incorrectas y en blanco (" + totalRespuestas + ") debe ser igual al total de preguntas del examen (" + ex.getCantidadPreguntas() + ").");
            q.setAttribute("examenes",examenDAO.listar());
            q.setAttribute("alumnos",alumnoDAO.listar());
            q.setAttribute("inscripciones",inscDAO.listar());
            q.getRequestDispatcher("/views/resultados/formulario.jsp").forward(q,r);
            return;
        }

        if(ex!=null&&ex.getCantidadPreguntas()>0){double pp=ex.getPuntajeTotal()/ex.getCantidadPreguntas();double pts=res.getCorrectas()*pp;res.setPuntaje(Math.round(pts*100.0)/100.0);res.setPorcentaje(Math.round((pts/ex.getPuntajeTotal())*10000.0)/100.0);}
        if(res.getId()>0){dao.actualizar(res);q.getSession().setAttribute("msg","Resultado actualizado.");}
        else{dao.insertar(res);q.getSession().setAttribute("msg","Resultado registrado.");}
        r.sendRedirect(q.getContextPath()+"/app/resultados?idExamen="+idExamen);
    }
    private String csv(String s){return s!=null?"\""+s.replace("\"","\"\"")+"\"":"";}
}
