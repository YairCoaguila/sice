package controller;
import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Examen;
import java.io.IOException;
import java.time.LocalDate;
public class ExamenServlet extends HttpServlet {
    private final ExamenDAO dao=new ExamenDAO();
    private final GradoDAO gradoDAO=new GradoDAO();
    private final AreaDAO areaDAO=new AreaDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String a=q.getParameter("accion"); if(a==null) a="listar";
        switch(a){
            case "nuevo","editar" ->{q.setAttribute("grados",gradoDAO.listarParticipantes());q.setAttribute("areas",areaDAO.listar());if("editar".equals(a)) q.setAttribute("examen",dao.buscarPorId(Integer.parseInt(q.getParameter("id"))));q.getRequestDispatcher("/views/examenes/formulario.jsp").forward(q,r);}
            case "eliminar"       ->{try{dao.eliminar(Integer.parseInt(q.getParameter("id")));q.getSession().setAttribute("msg","Examen eliminado.");}catch(Exception e){q.getSession().setAttribute("msgError","No se puede eliminar: tiene resultados asociados.");}r.sendRedirect(q.getContextPath()+"/app/examenes");}
            default               ->{q.setAttribute("examenes",dao.listar());q.getRequestDispatcher("/views/examenes/lista.jsp").forward(q,r);}
        }
    }
    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        Examen e=new Examen(); String id=q.getParameter("id"); if(id!=null&&!id.isBlank()) e.setId(Integer.parseInt(id));
        e.setNombre(q.getParameter("nombre").trim());
        String f=q.getParameter("fecha"); if(f!=null&&!f.isBlank()) e.setFecha(LocalDate.parse(f));
        e.setAnio(Integer.parseInt(q.getParameter("anio"))); e.setPeriodo(q.getParameter("periodo"));
        e.setIdGrado(Integer.parseInt(q.getParameter("idGrado"))); e.setIdArea(Integer.parseInt(q.getParameter("idArea")));
        e.setCantidadPreguntas(Integer.parseInt(q.getParameter("cantidadPreguntas"))); e.setPuntajeTotal(Double.parseDouble(q.getParameter("puntajeTotal")));
        e.setEstado(q.getParameter("estado")!=null?q.getParameter("estado"):"ACTIVO");
        if(e.getId()>0) dao.actualizar(e); else dao.insertar(e);
        q.getSession().setAttribute("msg","Examen guardado."); r.sendRedirect(q.getContextPath()+"/app/examenes");
    }
}
