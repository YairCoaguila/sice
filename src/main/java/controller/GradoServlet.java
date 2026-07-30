package controller;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.GradoDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Grado;
import java.io.IOException;
import java.util.List;

    public class GradoServlet extends HttpServlet {
    private static final Logger log = Logger.getLogger(GradoServlet.class.getName());
    private final GradoDAO dao = new GradoDAO();
    
    @Override 
    protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String a = q.getParameter("accion");
        if (a == null || a.isEmpty()) {
            a = "listar";
        }
        
        try {
            switch (a) {
                case "nuevo" -> {
                    q.setAttribute("grado", new Grado());
                    q.getRequestDispatcher("/views/shared/grado-form.jsp").forward(q, r);
                }
                case "editar" -> {
                    String idParam = q.getParameter("id");
                    if (idParam != null && !idParam.isBlank()) {
                        int id = Integer.parseInt(idParam);
                        Grado grado = dao.buscarPorId(id);
                        q.setAttribute("grado", grado != null ? grado : new Grado());
                        if (grado == null) q.getSession().setAttribute("msgError", "Grado no encontrado");
                    } else {
                        q.setAttribute("grado", new Grado());
                        q.getSession().setAttribute("msgError", "ID no proporcionado");
                    }
                    q.getRequestDispatcher("/views/shared/grado-form.jsp").forward(q, r);
                }
                case "eliminar" -> {
                    String idParam = q.getParameter("id");
                    if (idParam != null && !idParam.isBlank()) {
                        try {
                            dao.eliminar(Integer.parseInt(idParam));
                            q.getSession().setAttribute("msg", "Grado eliminado correctamente.");
                        } catch (Exception e) {
                            q.getSession().setAttribute("msgError", "No se puede eliminar. El grado tiene registros asociados.");
                        }
                    } else {
                        q.getSession().setAttribute("msgError", "ID inválido para eliminar");
                    }
                    r.sendRedirect(q.getContextPath() + "/app/grados");
                }
                default -> {
                    q.setAttribute("entityType","grados");q.setAttribute("grados", dao.listar());
                    q.getRequestDispatcher("/views/shared/catalogo.jsp").forward(q, r);
                }
            }
        } catch (Exception e) {
            log.log(Level.SEVERE, "Error", e);
            q.getSession().setAttribute("msgError", "Error: " + e.getMessage());
            r.sendRedirect(q.getContextPath() + "/app/grados");
        }
    }
    
    @Override 
    protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        
        try {
            Grado g = new Grado();
            
            String id = q.getParameter("id");
            if (id != null && !id.isBlank()) {
                g.setId(Integer.parseInt(id));
            }
            
            String nombre = q.getParameter("nombre");
            if (nombre != null && !nombre.isBlank()) {
                g.setNombre(nombre.trim());
            } else {
                q.getSession().setAttribute("msgError", "El nombre es obligatorio.");
                r.sendRedirect(q.getContextPath() + "/app/grados?accion=nuevo");
                return;
            }
            
            String nivelStr = q.getParameter("nivel");
            g.setNivel(nivelStr != null && !nivelStr.isBlank() ? Integer.parseInt(nivelStr) : 1);
            
            g.setParticipa("on".equals(q.getParameter("participa")) || "true".equals(q.getParameter("participa")));
            
            if (g.getId() > 0) {
                dao.actualizar(g);
                q.getSession().setAttribute("msg", "Grado actualizado correctamente.");
            } else {
                dao.insertar(g);
                q.getSession().setAttribute("msg", "Grado creado correctamente.");
            }
            
        } catch (NumberFormatException e) {
            q.getSession().setAttribute("msgError", "Error en el formato de los datos.");
        } catch (Exception e) {
            q.getSession().setAttribute("msgError", "Error al guardar el grado: " + e.getMessage());
        }
        
        r.sendRedirect(q.getContextPath() + "/app/grados");
    }
}