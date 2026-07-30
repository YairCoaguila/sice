package controller;
import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Resultado;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
public class RankingServlet extends HttpServlet {
    private final ResultadoDAO resultadoDAO=new ResultadoDAO();
    private final ExamenDAO examenDAO=new ExamenDAO();
    private final GradoDAO gradoDAO=new GradoDAO();
    private final SeccionDAO seccionDAO=new SeccionDAO();
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        if("csv".equals(q.getParameter("export"))){
            int idEx=Integer.parseInt(q.getParameter("idExamen"));
            List<Resultado> list;
            String tipo=q.getParameter("tipo");
            if("grado".equals(tipo)){int idG=Integer.parseInt(q.getParameter("idGrado"));list=resultadoDAO.rankingPorGrado(idEx,idG);}
            else if("seccion".equals(tipo)){int idS=Integer.parseInt(q.getParameter("idSeccion"));list=resultadoDAO.rankingPorSeccion(idEx,idS);}
            else{list=resultadoDAO.rankingGeneral(idEx);}
            r.setContentType("text/csv; charset=UTF-8");
            r.setHeader("Content-Disposition","attachment; filename=\"ranking_"+idEx+".csv\"");
            PrintWriter w=r.getWriter(); w.write('\uFEFF');
            w.println("Puesto,Alumno,DNI,Grado/Seccion,Carrera,Puntaje,Correctas,Incorrectas,Porcentaje");
            int p=1; for(Resultado res:list){w.println(p+","+csv(res.getAlumnoNombre())+","+csv(res.getAlumnoDni())+","+csv(res.getSeccionNombre())+","+csv(res.getCarreraNombre())+","+res.getPuntaje()+","+res.getCorrectas()+","+res.getIncorrectas()+","+res.getPorcentaje());p++;}
            w.flush(); return;
        }
        q.setAttribute("examenes",examenDAO.listar()); q.setAttribute("grados",gradoDAO.listarParticipantes()); q.setAttribute("secciones",seccionDAO.listar());
        String idExStr=q.getParameter("idExamen");
        if(idExStr!=null&&!idExStr.isBlank()){
            int idEx=Integer.parseInt(idExStr); q.setAttribute("idExamenSel",idEx);
            String tipo=q.getParameter("tipo");
            if("grado".equals(tipo)){int idG=Integer.parseInt(q.getParameter("idGrado"));q.setAttribute("ranking",resultadoDAO.rankingPorGrado(idEx,idG));q.setAttribute("tipoRanking","Ranking por Grado");}
            else if("seccion".equals(tipo)){int idS=Integer.parseInt(q.getParameter("idSeccion"));q.setAttribute("ranking",resultadoDAO.rankingPorSeccion(idEx,idS));q.setAttribute("tipoRanking","Ranking por Sección");}
            else{q.setAttribute("ranking",resultadoDAO.rankingGeneral(idEx));q.setAttribute("tipoRanking","Ranking General");}
        }
        q.getRequestDispatcher("/views/resultados/ranking.jsp").forward(q,r);
    }
    private String csv(String s){return s!=null?"\""+s.replace("\"","\"\"")+"\"":"";}
}
