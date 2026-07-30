package controller;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.ExamenDAO;
import dao.InscripcionDAO;
import dao.ResultadoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Alumno;
import model.Examen;
import model.Inscripcion;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;

@WebServlet("/estudiante/inscribir")
    public class EstudianteInscripcionServlet extends HttpServlet {
    private static final Logger log = Logger.getLogger(EstudianteInscripcionServlet.class.getName());
    
    private InscripcionDAO inscripcionDAO = new InscripcionDAO();
    private ExamenDAO examenDAO = new ExamenDAO();
    private ResultadoDAO resultadoDAO = new ResultadoDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Alumno alumno = (Alumno) request.getSession().getAttribute("estudiante");
        if (alumno == null) {
            response.sendRedirect(request.getContextPath() + "/estudiante/login");
            return;
        }
        
        String accion = request.getParameter("accion");
        
        if ("cancelar".equals(accion)) {
            cancelarInscripcion(request, response, alumno);
        } else {
            inscribirExamen(request, response, alumno);
        }
    }
    
    private void inscribirExamen(HttpServletRequest request, HttpServletResponse response, Alumno alumno)
            throws IOException {
        try {
            int idExamen = Integer.parseInt(request.getParameter("idExamen"));
            
            if (inscripcionDAO.existeInscripcion(alumno.getId(), idExamen)) {
                request.getSession().setAttribute("error", "Ya estás inscrito en este examen.");
            } else {
                Examen examen = examenDAO.buscarPorId(idExamen);
                if (examen == null) {
                    request.getSession().setAttribute("error", "El examen no existe.");
                    response.sendRedirect(request.getContextPath() + "/estudiante/dashboard");
                    return;
                }
                if (examen.getFecha() != null && examen.getFecha().isBefore(LocalDate.now())) {
                    request.getSession().setAttribute("error", "Este examen ya se realizó el " + examen.getFecha() + ". No puedes inscribirte.");
                    response.sendRedirect(request.getContextPath() + "/estudiante/dashboard");
                    return;
                }
                if (examen.getFecha() != null && inscripcionDAO.existeInscripcionEnFecha(alumno.getId(), examen.getFecha())) {
                    request.getSession().setAttribute("error", "Ya tienes un examen inscrito en la fecha " + examen.getFecha() + ".");
                    response.sendRedirect(request.getContextPath() + "/estudiante/dashboard");
                    return;
                }
                int anio = examen.getAnio() > 0 ? examen.getAnio() : LocalDate.now().getYear();
                
                Inscripcion existente = inscripcionDAO.buscarInactiva(alumno.getId(), idExamen);
                if (existente != null) {
                    existente.setIdCarrera(alumno.getIdCarrera());
                    existente.setAnio(anio);
                    existente.setPeriodo(examen.getPeriodo());
                    inscripcionDAO.reactivar(existente);
                    request.getSession().setAttribute("msg", "¡Inscripción reactivada exitosamente!");
                } else {
                    String codigo = inscripcionDAO.generarCodigo(anio);
                    Inscripcion inscripcion = new Inscripcion();
                    inscripcion.setCodigoInscripcion(codigo);
                    inscripcion.setIdAlumno(alumno.getId());
                    inscripcion.setIdExamen(idExamen);
                    inscripcion.setIdCarrera(alumno.getIdCarrera());
                    inscripcion.setAnio(anio);
                    inscripcion.setPeriodo(examen.getPeriodo());
                    inscripcion.setFechaInscripcion(LocalDateTime.now());
                    inscripcion.setEstado("ACTIVO");
                    inscripcionDAO.insertar(inscripcion);
                    request.getSession().setAttribute("msg", "¡Inscripción exitosa!");
                }
            }
            
        } catch (Exception e) {
            log.log(Level.SEVERE, "Error", e);
            request.getSession().setAttribute("error", "Error al inscribirte: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/estudiante/dashboard");
    }
    
    private void cancelarInscripcion(HttpServletRequest request, HttpServletResponse response, Alumno alumno)
            throws IOException {
        try {
            int idExamen = Integer.parseInt(request.getParameter("idExamen"));
            
            if (resultadoDAO.buscarPorAlumnoYExamen(alumno.getId(), idExamen) != null) {
                request.getSession().setAttribute("error", "No puedes cancelar la inscripción porque ya tienes resultados registrados.");
                response.sendRedirect(request.getContextPath() + "/estudiante/dashboard");
                return;
            }
            
            Inscripcion insc = inscripcionDAO.buscarPorAlumnoYExamen(alumno.getId(), idExamen);
            if (insc != null) {
                inscripcionDAO.cancelar(insc.getId());
                request.getSession().setAttribute("msg", "Inscripción cancelada correctamente.");
            } else {
                request.getSession().setAttribute("error", "No se encontró la inscripción.");
            }
            
        } catch (Exception e) {
            log.log(Level.SEVERE, "Error", e);
            request.getSession().setAttribute("error", "Error al cancelar la inscripción: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/estudiante/dashboard");
    }
}