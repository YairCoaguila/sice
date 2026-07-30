package controller;
import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Examen;
import model.Inscripcion;
import java.io.IOException;
import java.time.LocalDate;
public class InscripcionServlet extends HttpServlet {
    private final InscripcionDAO dao=new InscripcionDAO();
    private final AlumnoDAO alumnoDAO=new AlumnoDAO();
    private final ExamenDAO examenDAO=new ExamenDAO();
    private final CarreraDAO carreraDAO=new CarreraDAO();
    private final GradoDAO gradoDAO=new GradoDAO();
    private final SeccionDAO seccionDAO=new SeccionDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String a=q.getParameter("accion"); if(a==null) a="listar";
        switch(a){
            case "nuevo"   ->{q.setAttribute("alumnos",alumnoDAO.listar());q.setAttribute("examenes",examenDAO.listar());q.setAttribute("carreras",carreraDAO.listar());q.getRequestDispatcher("/views/inscripciones/formulario.jsp").forward(q,r);}
            case "detalle" ->{q.setAttribute("inscripcion",dao.buscarPorId(Integer.parseInt(q.getParameter("id"))));q.getRequestDispatcher("/views/inscripciones/detalle.jsp").forward(q,r);}
            case "cancelar"->{dao.cancelar(Integer.parseInt(q.getParameter("id")));q.getSession().setAttribute("msg","Inscripción cancelada.");r.sendRedirect(q.getContextPath()+"/app/inscripciones");}
            case "editar"  ->{Inscripcion i=dao.buscarPorId(Integer.parseInt(q.getParameter("id")));q.setAttribute("inscripcion",i);q.setAttribute("examenes",examenDAO.listar());q.setAttribute("carreras",carreraDAO.listar());q.getRequestDispatcher("/views/inscripciones/formulario.jsp").forward(q,r);}
            default        ->{q.setAttribute("inscripciones",dao.listar());q.getRequestDispatcher("/views/inscripciones/lista.jsp").forward(q,r);}
        }
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        String accion=q.getParameter("accion");
        if("actualizar".equals(accion)){
            Inscripcion i=new Inscripcion(); i.setId(Integer.parseInt(q.getParameter("id")));
            i.setIdExamen(Integer.parseInt(q.getParameter("idExamen"))); i.setIdCarrera(Integer.parseInt(q.getParameter("idCarrera")));
            i.setAnio(Integer.parseInt(q.getParameter("anio"))); i.setPeriodo(q.getParameter("periodo")); i.setEstado(q.getParameter("estado"));
            dao.actualizar(i); q.getSession().setAttribute("msg","Inscripción actualizada."); r.sendRedirect(q.getContextPath()+"/app/inscripciones"); return;
        }
        int idAlumno=Integer.parseInt(q.getParameter("idAlumno")); int idExamen=Integer.parseInt(q.getParameter("idExamen"));
        if(dao.existeInscripcion(idAlumno,idExamen)){q.setAttribute("error","El alumno ya está inscrito en este examen.");q.setAttribute("alumnos",alumnoDAO.listar());q.setAttribute("examenes",examenDAO.listar());q.setAttribute("carreras",carreraDAO.listar());q.getRequestDispatcher("/views/inscripciones/formulario.jsp").forward(q,r);return;}
        Examen exam=examenDAO.buscarPorId(idExamen);
        if(exam!=null&&exam.getFecha()!=null&&exam.getFecha().isBefore(LocalDate.now())){q.setAttribute("error","No puedes inscribir en un examen cuya fecha ya pasó ("+exam.getFecha()+").");q.setAttribute("alumnos",alumnoDAO.listar());q.setAttribute("examenes",examenDAO.listar());q.setAttribute("carreras",carreraDAO.listar());q.getRequestDispatcher("/views/inscripciones/formulario.jsp").forward(q,r);return;}
        if(exam!=null&&exam.getFecha()!=null&&dao.existeInscripcionEnFecha(idAlumno,exam.getFecha())){q.setAttribute("error","El alumno ya tiene un examen inscrito en la fecha "+exam.getFecha()+".");q.setAttribute("alumnos",alumnoDAO.listar());q.setAttribute("examenes",examenDAO.listar());q.setAttribute("carreras",carreraDAO.listar());q.getRequestDispatcher("/views/inscripciones/formulario.jsp").forward(q,r);return;}
        int anio=Integer.parseInt(q.getParameter("anio"));
        Inscripcion i=new Inscripcion(); i.setCodigoInscripcion(dao.generarCodigo(anio)); i.setIdAlumno(idAlumno); i.setIdExamen(idExamen);
        i.setIdCarrera(Integer.parseInt(q.getParameter("idCarrera"))); i.setAnio(anio); i.setPeriodo(q.getParameter("periodo")); i.setEstado("ACTIVO");
        int newId=dao.insertar(i);
        q.getSession().setAttribute("msg","Inscripción "+i.getCodigoInscripcion()+" registrada exitosamente.");
        r.sendRedirect(q.getContextPath()+"/app/inscripciones?accion=detalle&id="+newId);
    }
}
