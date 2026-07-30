package filter;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Usuario;
import java.io.IOException;
import java.util.*;
public class AuthFilter implements Filter {
    private static final Map<String, Set<String>> PERMS = new LinkedHashMap<>();
    static {
        PERMS.put("/app/docentes",          Set.of("administrador"));
        PERMS.put("/app/grados",            Set.of("administrador"));
        PERMS.put("/app/secciones",         Set.of("administrador"));
        PERMS.put("/app/carreras",          Set.of("administrador"));
        PERMS.put("/app/areas",             Set.of("administrador"));
        PERMS.put("/app/periodos",          Set.of("administrador"));
        PERMS.put("/app/aulas",             Set.of("administrador"));
        PERMS.put("/app/usuarios",          Set.of("administrador"));
        PERMS.put("/app/docente-aula",      Set.of("administrador"));
        PERMS.put("/app/examen-asignacion", Set.of("administrador"));
        PERMS.put("/app/importar",          Set.of("administrador"));
        PERMS.put("/app/dashboard",         Set.of("administrador","digitador"));
        PERMS.put("/app/alumnos",           Set.of("administrador","digitador"));
        PERMS.put("/app/examenes",          Set.of("administrador","digitador"));
        PERMS.put("/app/inscripciones",     Set.of("administrador","digitador"));
        PERMS.put("/app/resultados",        Set.of("administrador","digitador"));
        PERMS.put("/app/ranking",           Set.of("administrador","digitador"));
        PERMS.put("/app/constancia-pdf",    Set.of("administrador","digitador"));
        PERMS.put("/docente",               Set.of("docente"));
    }
    @Override public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        if (usuario == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        req.setAttribute("currentUser", usuario);
        String path = req.getRequestURI().substring(req.getContextPath().length());
        Set<String> allowed = null;
        for (Map.Entry<String, Set<String>> e : PERMS.entrySet()) {
            if (path.startsWith(e.getKey())) { allowed = e.getValue(); break; }
        }
        if (allowed != null && !allowed.contains(usuario.getRol())) {
            req.setAttribute("error", "No tienes permiso para acceder a esta sección.");
            req.getRequestDispatcher("/views/shared/error403.jsp").forward(req, resp);
            return;
        }
        chain.doFilter(request, response);
    }
    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}
