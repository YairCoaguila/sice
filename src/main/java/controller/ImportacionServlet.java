package controller;
import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.*;

@MultipartConfig(maxFileSize=5*1024*1024, fileSizeThreshold=1024*1024)
public class ImportacionServlet extends HttpServlet {
    private final AlumnoDAO alumnoDAO=new AlumnoDAO();
    private final DocenteDAO docenteDAO=new DocenteDAO();
    private final GradoDAO gradoDAO=new GradoDAO();
    private final SeccionDAO seccionDAO=new SeccionDAO();
    private final CarreraDAO carreraDAO=new CarreraDAO();
    private final UsuarioDAO usuarioDAO=new UsuarioDAO();

    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        String tipo=q.getParameter("tipo");
        q.setAttribute("tipo",tipo);
        if("alumnos".equals(tipo)){q.setAttribute("titulo","Importar Alumnos");q.setAttribute("columnas","apellido_paterno,apellido_materno,nombres,dni,celular,direccion,fecha_nacimiento,grado,seccion,carrera,colegio");}
        else if("docentes".equals(tipo)){q.setAttribute("titulo","Importar Docentes");q.setAttribute("columnas","apellido_paterno,apellido_materno,nombres,dni,celular,correo,especialidad");}
        else{r.sendRedirect(q.getContextPath()+"/app/dashboard");return;}
        q.getRequestDispatcher("/views/importacion/importar.jsp").forward(q,r);
    }

    @Override protected void doPost(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        String tipo=q.getParameter("tipo");
        Part filePart=q.getPart("archivo");
        if(filePart==null||filePart.getSize()==0){
            q.setAttribute("error","Selecciona un archivo CSV."); doGet(q,r); return;
        }
        List<String[]> rows=new ArrayList<>();
        try(BufferedReader br=new BufferedReader(new InputStreamReader(filePart.getInputStream(),StandardCharsets.UTF_8))){
            String line; boolean first=true;
            while((line=br.readLine())!=null){
                if(line.isBlank()) continue;
                if(first){first=false;continue;}
                rows.add(parseCsvLine(line));
            }
        }
        if(rows.isEmpty()){q.setAttribute("error","El archivo CSV est\u00e1 vac\u00edo (solo cabeceras).");doGet(q,r);return;}

        int insertados=0, omitidos=0;
        List<String> errores=new ArrayList<>();

        if("alumnos".equals(tipo)){
            Map<String,Integer> gradoMap=new HashMap<>(); for(Grado g:gradoDAO.listar()) gradoMap.put(g.getNombre().toLowerCase(),g.getId());
            Map<String,Map<String,Integer>> seccionMap=new HashMap<>(); for(Seccion s:seccionDAO.listar()){seccionMap.computeIfAbsent(s.getNombre().toLowerCase(),k->new HashMap<>()).put(gradoDAO.buscarPorId(s.getIdGrado()).getNombre().toLowerCase(),s.getId());}
            Map<String,Integer> carreraMap=new HashMap<>(); for(Carrera c:carreraDAO.listar()) carreraMap.put(c.getNombre().toLowerCase(),c.getId());

            for(int i=0;i<rows.size();i++){
                String[] col=rows.get(i);
                try{
                    if(col.length<7){errores.add("Fila "+(i+2)+": columnas insuficientes ("+col.length+")");continue;}
                    String dni=col[3].trim(); if(dni.isEmpty()){errores.add("Fila "+(i+2)+": DNI vac\u00edo");continue;}
                    if(alumnoDAO.existeDni(dni,0)){omitidos++;continue;}
                    Alumno a=new Alumno(); a.setApellidoPaterno(val(col,0)); a.setApellidoMaterno(val(col,1));
                    a.setNombres(val(col,2)); a.setDni(dni); a.setCelular(val(col,4)); a.setDireccion(val(col,5));
                    if(col.length>6&&!col[6].isBlank()) try{a.setFechaNacimiento(LocalDate.parse(col[6].trim()));}catch(Exception ignored){}
                    if(col.length>7){Integer idG=gradoMap.get(col[7].trim().toLowerCase()); if(idG!=null) a.setIdGrado(idG);}
                    if(col.length>8&&a.getIdGrado()>0){String sec=col[8].trim().toLowerCase(); var sm=seccionMap.get(sec); if(sm!=null){Integer idS=sm.get(gradoDAO.buscarPorId(a.getIdGrado()).getNombre().toLowerCase()); if(idS!=null) a.setIdSeccion(idS);}}
                    if(col.length>9){Integer idCa=carreraMap.get(col[9].trim().toLowerCase()); if(idCa!=null) a.setIdCarrera(idCa);}
                    if(col.length>10){a.setColegio(val(col,10));}
                    alumnoDAO.insertar(a); insertados++;
                }catch(Exception e){errores.add("Fila "+(i+2)+": "+e.getMessage());}
            }
        }else if("docentes".equals(tipo)){
            for(int i=0;i<rows.size();i++){
                String[] col=rows.get(i);
                try{
                    if(col.length<4){errores.add("Fila "+(i+2)+": columnas insuficientes ("+col.length+")");continue;}
                    String dni=col[3].trim(); if(dni.isEmpty()){errores.add("Fila "+(i+2)+": DNI vac\u00edo");continue;}
                    if(docenteDAO.buscarPorDni(dni)!=null){omitidos++;continue;}
                    String apPat=val(col,0), apMat=val(col,1), nom=val(col,2);
                    Docente d=new Docente(); d.setApellidoPaterno(apPat); d.setApellidoMaterno(apMat); d.setNombres(nom);
                    d.setDni(dni); d.setCelular(val(col,4)); d.setCorreo(col.length>5?val(col,5):""); d.setEspecialidad(col.length>6?val(col,6):"");
                    int idDoc=docenteDAO.insertar(d);
                    String username=dni; if(usuarioDAO.existeUsername(username)) username=dni+"_"+idDoc;
                    Usuario u=new Usuario(); u.setUsername(username); u.setPassword("doc123"); u.setRol("docente"); u.setEstado("ACTIVO"); u.setIdDocente(idDoc);
                    usuarioDAO.insertar(u); insertados++;
                }catch(Exception e){errores.add("Fila "+(i+2)+": "+e.getMessage());}
            }
        }

        q.setAttribute("tipo",tipo);
        q.setAttribute("insertados",insertados);
        q.setAttribute("omitidos",omitidos);
        q.setAttribute("errores",errores);
        q.setAttribute("titulo","alumnos".equals(tipo)?"Importar Alumnos":"Importar Docentes");
        q.setAttribute("columnas","alumnos".equals(tipo)?"apellido_paterno,apellido_materno,nombres,dni,celular,direccion,fecha_nacimiento,grado,seccion,carrera,colegio":"apellido_paterno,apellido_materno,nombres,dni,celular,correo,especialidad");
        q.getRequestDispatcher("/views/importacion/importar.jsp").forward(q,r);
    }

    private String val(String[] col, int idx){return col.length>idx&&col[idx]!=null?col[idx].trim():"";}
    private String[] parseCsvLine(String line){
        List<String> cols=new ArrayList<>();
        boolean inQ=false; StringBuilder cur=new StringBuilder();
        for(int i=0;i<line.length();i++){
            char c=line.charAt(i);
            if(c=='"'){if(inQ&&i+1<line.length()&&line.charAt(i+1)=='"'){cur.append('"');i++;}else inQ=!inQ;}
            else if(c==','&&!inQ){cols.add(cur.toString().trim());cur.setLength(0);}
            else cur.append(c);
        }
        cols.add(cur.toString().trim());
        return cols.toArray(new String[0]);
    }
}