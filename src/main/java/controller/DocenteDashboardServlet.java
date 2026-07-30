package controller;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.AlumnoDAO;
import dao.DocenteAulaDAO;
import dao.DocenteDAO;
import dao.ExamenAsignacionDAO;
import dao.ResultadoDAO;
import dao.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Alumno;
import model.Docente;
import model.DocenteAula;
import model.ExamenAsignacion;
import model.Resultado;
import model.Usuario;

import java.io.IOException;
import java.util.*;

    public class DocenteDashboardServlet extends HttpServlet {
    private static final Logger log = Logger.getLogger(DocenteDashboardServlet.class.getName());

    private final DocenteAulaDAO docenteAulaDAO = new DocenteAulaDAO();
    private final AlumnoDAO alumnoDAO = new AlumnoDAO();
    private final DocenteDAO docenteDAO = new DocenteDAO();
    private final ExamenAsignacionDAO examenAsignacionDAO = new ExamenAsignacionDAO();
    private final ResultadoDAO resultadoDAO = new ResultadoDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario usuario = (Usuario) request.getAttribute("currentUser");
        if (usuario == null || !usuario.isDocente()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int idDocente = usuario.getIdDocente();
        Docente docente = null;

        if (idDocente > 0) {
            docente = docenteDAO.buscarPorId(idDocente);
        }

        if (docente == null && usuario.getUsername() != null) {
            docente = docenteDAO.buscarPorDni(usuario.getUsername());
        }

        if (docente == null) {
            request.setAttribute("error", "No se encontró un docente vinculado a tu cuenta. Contacta al administrador.");
            request.getRequestDispatcher("/views/docente/dashboard.jsp").forward(request, response);
            return;
        }

        request.setAttribute("docente", docente);

        try {
            List<DocenteAula> asignaciones = docenteAulaDAO.listarPorDocente(docente.getId());
            request.setAttribute("asignaciones", asignaciones);

            Map<String, Object> datosPorAsignacion = new LinkedHashMap<>();
            for (DocenteAula da : asignaciones) {
                String key = da.getId() + "|" + da.getGradoNombre() + "|" + da.getSeccionNombre() + "|" + da.getAnio() + "|" + da.getPeriodo();
                List<Alumno> alumnos = alumnoDAO.listarPorGradoSeccion(da.getIdGrado(), da.getIdSeccion());
                List<Map<String, Object>> alumnosConResultados = new ArrayList<>();
                for (Alumno a : alumnos) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("alumno", a);
                    List<Resultado> resultados = resultadoDAO.listarPorAlumno(a.getId());
                    row.put("resultados", resultados);
                    row.put("totalExamenes", resultados.size());
                    double promedio = resultados.stream().mapToDouble(Resultado::getPorcentaje).average().orElse(0);
                    row.put("promedio", Math.round(promedio * 100.0) / 100.0);
                    alumnosConResultados.add(row);
                }
                datosPorAsignacion.put(key, alumnosConResultados);
            }
            request.setAttribute("datosPorAsignacion", datosPorAsignacion);

            List<ExamenAsignacion> examenesAsignados = examenAsignacionDAO.listarPorDocente(docente.getId());
            request.setAttribute("examenesAsignados", examenesAsignados);

        } catch (Exception e) {
            log.log(Level.SEVERE, "Error", e);
            request.setAttribute("error", "Error al cargar datos: " + e.getMessage());
        }

        request.getRequestDispatcher("/views/docente/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        Usuario usuario = (Usuario) request.getAttribute("currentUser");

        if ("cambiarPassword".equals(accion) && usuario != null) {
            String nueva = request.getParameter("nuevaPassword");
            String confirmar = request.getParameter("confirmarPassword");

            if (nueva == null || !nueva.equals(confirmar) || nueva.length() < 6) {
                request.setAttribute("error", "Las contraseñas no coinciden o son muy cortas (mín. 6 caracteres).");
            } else {
                usuarioDAO.cambiarPassword(usuario.getId(), nueva);
                request.setAttribute("mensaje", "Contraseña actualizada correctamente.");
            }
        }

        doGet(request, response);
    }
}