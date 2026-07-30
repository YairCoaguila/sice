package controller;
import dao.UsuarioDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Usuario;
import java.io.IOException;
public class UsuarioServlet extends HttpServlet {
    private final UsuarioDAO dao=new UsuarioDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String a=q.getParameter("accion"); if(a==null) a="listar";
        switch(a){
            case "nuevo" ->{q.setAttribute("usuario",null);fwd(q,r);}
            case "editar"->{q.setAttribute("usuario",dao.buscarPorId(Integer.parseInt(q.getParameter("id"))));fwd(q,r);}
            case "eliminar"->{
                try{dao.eliminar(Integer.parseInt(q.getParameter("id")));q.getSession().setAttribute("msg","Usuario eliminado.");}
                catch(Exception e){q.getSession().setAttribute("msgError","No se puede eliminar el usuario.");}
                r.sendRedirect(q.getContextPath()+"/app/usuarios");
            }
            default->{q.setAttribute("usuarios",dao.listar());q.getRequestDispatcher("/views/usuarios/lista.jsp").forward(q,r);}
        }
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        Usuario u=new Usuario(); String id=q.getParameter("id"); if(id!=null&&!id.isBlank()) u.setId(Integer.parseInt(id));
        u.setUsername(q.getParameter("username").trim()); u.setRol(q.getParameter("rol")); u.setEstado(q.getParameter("estado"));
        boolean ed=u.getId()>0;
        if(ed){
            String pwd=q.getParameter("password");
            if(pwd!=null&&!pwd.isBlank()) u.setPassword(pwd);
            else u.setPassword(null);
            if(!u.getUsername().equals(q.getParameter("origUsername")) && dao.existeUsername(u.getUsername())){
                q.setAttribute("error","El nombre de usuario ya existe.");
                q.setAttribute("usuario",dao.buscarPorId(u.getId())); fwd(q,r); return;
            }
            dao.actualizar(u);
            q.getSession().setAttribute("msg","Usuario actualizado.");
        }else{
            String pwd=q.getParameter("password"); String confirm=q.getParameter("confirmPassword");
            if(pwd==null||pwd.length()<3){q.setAttribute("error","La contraseña debe tener al menos 3 caracteres.");q.setAttribute("usuario",null);fwd(q,r);return;}
            if(!pwd.equals(confirm)){q.setAttribute("error","Las contraseñas no coinciden.");q.setAttribute("usuario",null);fwd(q,r);return;}
            if(dao.existeUsername(u.getUsername())){q.setAttribute("error","El nombre de usuario ya existe.");q.setAttribute("usuario",null);fwd(q,r);return;}
            u.setPassword(pwd); u.setIdDocente(0); dao.insertar(u);
            q.getSession().setAttribute("msg","Usuario creado.");
        }
        r.sendRedirect(q.getContextPath()+"/app/usuarios");
    }
    private void fwd(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.getRequestDispatcher("/views/usuarios/formulario.jsp").forward(q,r);
    }
}
