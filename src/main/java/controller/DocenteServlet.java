package controller;
import dao.DocenteAulaDAO;
import dao.DocenteDAO;
import dao.ExamenAsignacionDAO;
import dao.UsuarioDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Docente;
import model.Usuario;
import java.io.IOException;
import java.util.*;
public class DocenteServlet extends HttpServlet {
    private final DocenteDAO dao=new DocenteDAO();
    private final DocenteAulaDAO docenteAulaDAO=new DocenteAulaDAO();
    private final ExamenAsignacionDAO examenAsignacionDAO=new ExamenAsignacionDAO();
    private final UsuarioDAO usuarioDAO=new UsuarioDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String a=q.getParameter("accion"); if(a==null) a="listar";
        switch(a){
            case "nuevo"   ->{q.setAttribute("docente",null);fwd(q,r);}
            case "editar"  ->{q.setAttribute("docente",dao.buscarPorId(Integer.parseInt(q.getParameter("id"))));fwd(q,r);}
            case "eliminar"->{
                int idDoc=Integer.parseInt(q.getParameter("id"));
                try{
                    examenAsignacionDAO.eliminarPorDocente(idDoc);
                    docenteAulaDAO.eliminarPorDocente(idDoc);
                    usuarioDAO.eliminarPorIdDocente(idDoc);
                    dao.eliminar(idDoc);
                    q.getSession().setAttribute("msg","Docente eliminado.");
                }catch(Exception e){
                    q.getSession().setAttribute("msgError","No se puede eliminar. El docente tiene registros asociados.");
                }
                r.sendRedirect(q.getContextPath()+"/app/docentes");
            }
            default        ->{
                List<Docente> docentes=dao.listar();
                Map<Integer,Usuario> credenciales=new HashMap<>();
                for(Docente doc:docentes){
                    Usuario u=usuarioDAO.buscarPorIdDocente(doc.getId());
                    if(u!=null) credenciales.put(doc.getId(),u);
                }
                q.setAttribute("docentes",docentes);
                q.setAttribute("credenciales",credenciales);
                q.getRequestDispatcher("/views/docentes/lista.jsp").forward(q,r);
            }
        }
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        Docente d=new Docente();
        String idStr=q.getParameter("id"); if(idStr!=null&&!idStr.isBlank()) d.setId(Integer.parseInt(idStr));
        d.setNombres(q.getParameter("nombres").trim()); d.setApellidoPaterno(q.getParameter("apellidoPaterno").trim());
        d.setApellidoMaterno(q.getParameter("apellidoMaterno").trim()); d.setDni(q.getParameter("dni").trim());
        d.setCelular(q.getParameter("celular")); d.setCorreo(q.getParameter("correo"));
        d.setEspecialidad(q.getParameter("especialidad")); d.setEstado(q.getParameter("estado")!=null?q.getParameter("estado"):"ACTIVO");
        if(d.getId()>0){
            dao.actualizar(d);
            q.getSession().setAttribute("msg","Docente actualizado.");
        }else{
            int idDocente=dao.insertar(d);
            String username=d.getDni();
            if(usuarioDAO.existeUsername(username)){username=username+"_"+idDocente;}
            String password="doc123";
            Usuario u=new Usuario(); u.setUsername(username); u.setPassword(password);
            u.setRol("docente"); u.setEstado("ACTIVO"); u.setIdDocente(idDocente);
            usuarioDAO.insertar(u);
            q.getSession().setAttribute("msg","Docente registrado. Usuario: <strong>"+username+"</strong> / Contraseña: <strong>"+password+"</strong>");
        }
        r.sendRedirect(q.getContextPath()+"/app/docentes");
    }
    private void fwd(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.getRequestDispatcher("/views/docentes/formulario.jsp").forward(q,r);
    }
}
