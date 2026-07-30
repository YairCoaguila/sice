package controller;
import dao.AlumnoDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Alumno;
import java.io.IOException;
import java.time.LocalDate;

public class EstudiantePerfilServlet extends HttpServlet {
    private final AlumnoDAO dao = new AlumnoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Alumno alumno = (Alumno) req.getSession().getAttribute("estudiante");
        if (alumno == null) { resp.sendRedirect(req.getContextPath() + "/estudiante/login"); return; }
        req.getRequestDispatcher("/views/estudiante/perfil.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Alumno alumno = (Alumno) req.getSession().getAttribute("estudiante");
        if (alumno == null) { resp.sendRedirect(req.getContextPath() + "/estudiante/login"); return; }

        String celular = req.getParameter("celular");
        String direccion = req.getParameter("direccion");
        String colegio = req.getParameter("colegio");
        String fechaNac = req.getParameter("fechaNacimiento");

        alumno.setCelular(celular);
        alumno.setDireccion(direccion);
        alumno.setColegio(colegio);
        if (fechaNac != null && !fechaNac.isEmpty()) {
            try { alumno.setFechaNacimiento(LocalDate.parse(fechaNac)); }
            catch (Exception ignored) {}
        }

        try {
            dao.actualizar(alumno);
            req.getSession().setAttribute("estudiante", alumno);
            req.getSession().setAttribute("msg", "Datos actualizados correctamente.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Error al actualizar: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/estudiante/perfil");
    }
}
