package controller;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.AlumnoDAO;
import dao.AreaDAO;
import dao.CarreraDAO;
import dao.GradoDAO;
import dao.SeccionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Alumno;

import java.io.IOException;
import java.time.LocalDate;

    public class EstudianteRegistroServlet extends HttpServlet {
    private static final Logger log = Logger.getLogger(EstudianteRegistroServlet.class.getName());

    private AlumnoDAO alumnoDAO = new AlumnoDAO();
    private AreaDAO areaDAO = new AreaDAO();
    private GradoDAO gradoDAO = new GradoDAO();
    private SeccionDAO seccionDAO = new SeccionDAO();
    private CarreraDAO carreraDAO = new CarreraDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dni = (String) request.getSession().getAttribute("registro_dni");
        if (dni == null) dni = request.getParameter("dni");
        if (dni == null || dni.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/estudiante/login");
            return;
        }

        request.setAttribute("areas", areaDAO.listar());
        request.setAttribute("grados", gradoDAO.listar());
        request.setAttribute("secciones", seccionDAO.listar());
        request.setAttribute("carreras", carreraDAO.listar());
        request.setAttribute("dni", dni);

        request.getRequestDispatcher("/views/estudiante/registro-estudiante.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        try {
            String dni = (String) request.getSession().getAttribute("registro_dni");
            if (dni == null) dni = request.getParameter("dni");
            
            // Verificar si el estudiante ya existe, por seguridad
            Alumno alumno = alumnoDAO.buscarPorDni(dni);
            
            if (alumno == null) {
                // Crear nuevo estudiante
                alumno = new Alumno();
                alumno.setNombres(request.getParameter("nombres").trim());
                
                String apellidos = request.getParameter("apellidos").trim();
                String[] apellidosArr = apellidos.split(" ");
                alumno.setApellidoPaterno(apellidosArr.length > 0 ? apellidosArr[0] : "");
                alumno.setApellidoMaterno(apellidosArr.length > 1 ? apellidosArr[1] : "");
                
                alumno.setDni(dni);
                
                String fechaNac = request.getParameter("fecha_nacimiento");
                if (fechaNac != null && !fechaNac.isEmpty()) {
                    alumno.setFechaNacimiento(LocalDate.parse(fechaNac));
                }
                
                alumno.setCelular(request.getParameter("celular"));
                alumno.setDireccion(request.getParameter("direccion"));
                alumno.setColegio(request.getParameter("colegio"));
                alumno.setIdGrado(Integer.parseInt(request.getParameter("id_grado")));
                alumno.setIdSeccion(Integer.parseInt(request.getParameter("id_seccion")));
                
                // Obtener id_carrera del formulario
                String idCarreraStr = request.getParameter("id_carrera");
                if (idCarreraStr != null && !idCarreraStr.isEmpty()) {
                    alumno.setIdCarrera(Integer.parseInt(idCarreraStr));
                } else {
                    alumno.setIdCarrera(4); // Valor por defecto
                }
                
                alumnoDAO.insertar(alumno);
                alumno = alumnoDAO.buscarPorDni(dni);
            }
            
            var session = request.getSession();
            session.setAttribute("estudiante", alumno);
            if (session.getAttribute("vioInstrucciones") == null) {
                session.setAttribute("mostrarInstrucciones", true);
            }
            response.sendRedirect(request.getContextPath() + "/estudiante/dashboard");
            
        } catch (Exception e) {
            log.log(Level.SEVERE, "Error", e);
            request.setAttribute("error", "Error al completar el registro: " + e.getMessage());
            // Recargar catálogos
            request.setAttribute("areas", areaDAO.listar());
            request.setAttribute("grados", gradoDAO.listar());
            request.setAttribute("secciones", seccionDAO.listar());
            request.setAttribute("carreras", carreraDAO.listar());
            request.setAttribute("dni", request.getSession().getAttribute("registro_dni"));
            request.getRequestDispatcher("/views/estudiante/registro-estudiante.jsp").forward(request, response);
        }
    }

}