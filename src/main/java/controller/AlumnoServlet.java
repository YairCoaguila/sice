package controller;
import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Alumno;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
public class AlumnoServlet extends HttpServlet {
    private final AlumnoDAO alumnoDAO=new AlumnoDAO();
    private final GradoDAO gradoDAO=new GradoDAO();
    private final SeccionDAO seccionDAO=new SeccionDAO();
    private final CarreraDAO carreraDAO=new CarreraDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String a=q.getParameter("accion"); if(a==null) a="listar";
        switch(a){
            case "nuevo"   ->mostrarForm(q,r,null);
            case "editar"  ->{Alumno al=alumnoDAO.buscarPorId(Integer.parseInt(q.getParameter("id")));mostrarForm(q,r,al);}
            case "eliminar"->{try{alumnoDAO.eliminar(Integer.parseInt(q.getParameter("id")));q.getSession().setAttribute("msg","Alumno eliminado.");}catch(Exception e){q.getSession().setAttribute("msgError","No se puede eliminar: tiene registros asociados.");}r.sendRedirect(q.getContextPath()+"/app/alumnos");}
            case "buscar"  ->{String t=q.getParameter("q");q.setAttribute("alumnos",t!=null&&!t.isBlank()?alumnoDAO.buscar(t.trim()):alumnoDAO.listar());q.setAttribute("busqueda",t);q.getRequestDispatcher("/views/alumnos/lista.jsp").forward(q,r);}
            default        ->{q.setAttribute("alumnos",alumnoDAO.listar());q.getRequestDispatcher("/views/alumnos/lista.jsp").forward(q,r);}
        }
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        Alumno a=extraer(q);
        String accion=q.getParameter("accion");
        if("actualizar".equals(accion)){
            a.setId(Integer.parseInt(q.getParameter("id")));
            if(alumnoDAO.existeDni(a.getDni(),a.getId())){q.setAttribute("error","DNI ya existe.");mostrarForm(q,r,a);return;}
            alumnoDAO.actualizar(a); q.getSession().setAttribute("msg","Alumno actualizado."); r.sendRedirect(q.getContextPath()+"/app/alumnos");
        } else {
            if(alumnoDAO.existeDni(a.getDni(),0)){q.setAttribute("error","DNI ya existe.");mostrarForm(q,r,a);return;}
            alumnoDAO.insertar(a); q.getSession().setAttribute("msg","Alumno registrado."); r.sendRedirect(q.getContextPath()+"/app/alumnos");
        }
    }
    private void mostrarForm(HttpServletRequest q, HttpServletResponse r, Alumno a) throws ServletException, IOException {
        q.setAttribute("alumno",a); q.setAttribute("grados",gradoDAO.listarParticipantes());
        q.setAttribute("secciones",seccionDAO.listar()); q.setAttribute("carreras",carreraDAO.listar());
        q.getRequestDispatcher("/views/alumnos/formulario.jsp").forward(q,r);
    }
    private Alumno extraer(HttpServletRequest q) {
        Alumno a=new Alumno();
        a.setNombres(q.getParameter("nombres").trim());
        a.setApellidoPaterno(q.getParameter("apellidoPaterno").trim());
        a.setApellidoMaterno(q.getParameter("apellidoMaterno").trim());
        a.setDni(q.getParameter("dni").trim());
        String fn=q.getParameter("fechaNacimiento"); if(fn!=null&&!fn.isBlank()) a.setFechaNacimiento(LocalDate.parse(fn));
        a.setCelular(q.getParameter("celular")); a.setDireccion(q.getParameter("direccion")); a.setColegio(q.getParameter("colegio"));
        a.setIdGrado(Integer.parseInt(q.getParameter("idGrado")));
        a.setIdSeccion(Integer.parseInt(q.getParameter("idSeccion")));
        a.setIdCarrera(Integer.parseInt(q.getParameter("idCarrera")));
        return a;
    }
}
