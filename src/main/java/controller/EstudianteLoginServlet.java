package controller;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.AlumnoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Alumno;
import java.io.IOException;

    public class EstudianteLoginServlet extends HttpServlet {
    private static final Logger log = Logger.getLogger(EstudianteLoginServlet.class.getName());

    private AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/estudiante/login-estudiante.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String dni = request.getParameter("dni");
            if (dni == null || dni.trim().isEmpty()) {
                request.setAttribute("error", "Por favor ingresa un DNI válido.");
                request.getRequestDispatcher("/views/estudiante/login-estudiante.jsp").forward(request, response);
                return;
            }
            
            // Verificar si el estudiante ya existe
            Alumno alumno = alumnoDAO.buscarPorDni(dni.trim());
            
            if (alumno != null) {
                // Ya existe, iniciar sesión directo
                request.getSession().setAttribute("estudiante", alumno);
                response.sendRedirect(request.getContextPath() + "/estudiante/dashboard");
            } else {
                // Es nuevo, guardar DNI en sesión y redirigir al registro
                request.getSession().setAttribute("registro_dni", dni.trim());
                response.sendRedirect(request.getContextPath() + "/estudiante/registro");
            }
            
        } catch (Exception e) {
            log.log(Level.SEVERE, "Error", e);
            request.setAttribute("error", "Error al procesar el DNI: " + e.getMessage());
            request.getRequestDispatcher("/views/estudiante/login-estudiante.jsp").forward(request, response);
        }
    }
}