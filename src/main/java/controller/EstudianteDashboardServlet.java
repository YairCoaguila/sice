package controller;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.ExamenDAO;
import dao.InscripcionDAO;
import dao.ResultadoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Alumno;
import model.Examen;
import model.Inscripcion;
import model.Resultado;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

    public class EstudianteDashboardServlet extends HttpServlet {
    private static final Logger log = Logger.getLogger(EstudianteDashboardServlet.class.getName());
    
    private ExamenDAO examenDAO = new ExamenDAO();
    private InscripcionDAO inscripcionDAO = new InscripcionDAO();
    private ResultadoDAO resultadoDAO = new ResultadoDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Alumno alumno = (Alumno) request.getSession().getAttribute("estudiante");
        if (alumno == null) {
            response.sendRedirect(request.getContextPath() + "/estudiante/login");
            return;
        }
        
        try {
            List<Examen> todosExamenes = examenDAO.listar();
            
            // Obtener inscripciones activas del estudiante
            List<Inscripcion> inscripciones = inscripcionDAO.listarPorAlumno(alumno.getId());
            
            // Construir set de examenes inscritos (solo activos) y mapa inscripcionId
            Set<Integer> examenesInscritosSet = new HashSet<>();
            Map<Integer, Integer> mapaInscripciones = new HashMap<>();
            for (Inscripcion ins : inscripciones) {
                if (!"CANCELADO".equals(ins.getEstado())) {
                    examenesInscritosSet.add(ins.getIdExamen());
                    mapaInscripciones.put(ins.getIdExamen(), ins.getId());
                }
            }
            
            // Clasificar examenes (0 consultas extras a DB)
            List<Examen> disponibles = new ArrayList<>();
            List<Examen> inscritosList = new ArrayList<>();
            for (Examen e : todosExamenes) {
                if (examenesInscritosSet.contains(e.getId())) {
                    inscritosList.add(e);
                } else {
                    disponibles.add(e);
                }
            }
            
            // Cargar resultados del estudiante
            List<Resultado> resultados = resultadoDAO.listarPorAlumno(alumno.getId());
            Map<Integer, Resultado> mapaResultados = new HashMap<>();
            for (Resultado r : resultados) {
                mapaResultados.put(r.getIdExamen(), r);
            }

            // Cargar rankings del estudiante
            List<Resultado> rankingsGeneral = resultadoDAO.rankingGeneralPorAlumno(alumno.getId());
            Map<Integer, Integer> mapaRankingGeneral = new HashMap<>();
            for (Resultado r : rankingsGeneral) {
                mapaRankingGeneral.put(r.getIdExamen(), r.getRankingGeneral());
            }
            List<Resultado> rankingsGrado = resultadoDAO.rankingGradoPorAlumno(alumno.getId());
            Map<Integer, Integer> mapaRankingGrado = new HashMap<>();
            for (Resultado r : rankingsGrado) {
                mapaRankingGrado.put(r.getIdExamen(), r.getRankingGrado());
            }

            // Cargar aulas desde las inscripciones del alumno
            Map<Integer, String> mapaAulas = new HashMap<>();
            for (Inscripcion ins : inscripciones) {
                if (!"CANCELADO".equals(ins.getEstado()) && ins.getAulaCodigo() != null) {
                    mapaAulas.put(ins.getIdExamen(), ins.getAulaCodigo());
                }
            }

            // Cargar profesor solo para examenes en los que esta inscrito
            Map<Integer, String> mapaProfesores = new HashMap<>();
            for (Examen e : inscritosList) {
                String prof = examenDAO.buscarProfesorPorGradoSeccionPeriodo(
                    alumno.getIdGrado(), alumno.getIdSeccion(), e.getAnio(), e.getPeriodo());
                if (prof != null) mapaProfesores.put(e.getId(), prof);
            }
            
            request.setAttribute("examenesDisponibles", disponibles);
            request.setAttribute("examenesInscritos", inscritosList);
            request.setAttribute("mapaInscripciones", mapaInscripciones);
            request.setAttribute("mapaResultados", mapaResultados);
            request.setAttribute("mapaRankingGeneral", mapaRankingGeneral);
            request.setAttribute("mapaRankingGrado", mapaRankingGrado);
            request.setAttribute("mapaAulas", mapaAulas);
            request.setAttribute("mapaProfesores", mapaProfesores);
            
        } catch (Exception e) {
            log.log(Level.SEVERE, "Error", e);
            request.setAttribute("error", "Error al cargar datos: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/views/estudiante/dashboard-estudiante.jsp").forward(request, response);
    }
}