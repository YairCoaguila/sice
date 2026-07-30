package dao;
import util.Conexion;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
public class DashboardDAO {
    private static final Logger log = Logger.getLogger(DashboardDAO.class.getName());
    public Map<String,Object> obtenerEstadisticas() {
        Map<String,Object> m=new LinkedHashMap<>();
        try(Connection c=Conexion.getConexion(); PreparedStatement ps=c.prepareStatement("SELECT * FROM vw_dashboard LIMIT 1"); ResultSet rs=ps.executeQuery()){
            if(rs.next()){
                m.put("totalAlumnos",rs.getInt("total_alumnos")); m.put("totalDocentes",rs.getInt("total_docentes"));
                m.put("totalExamenes",rs.getInt("total_examenes")); m.put("totalInscritos",rs.getInt("total_inscritos"));
                m.put("promedioPuntaje",rs.getDouble("promedio_puntaje")); m.put("mejorSeccion",rs.getString("mejor_seccion")); m.put("mejorCarrera",rs.getString("mejor_carrera"));
            }
        } catch(SQLException e){ log.log(Level.WARNING, "Error al obtener estadisticas", e); m.put("totalAlumnos",0); m.put("totalDocentes",0); m.put("totalExamenes",0); m.put("totalInscritos",0); }
        return m;
    }
    public List<Map<String,Object>> top10Alumnos() {
        List<Map<String,Object>> l=new ArrayList<>();
        String sql="SELECT alumno_nombre,carrera_nombre,grado_nombre,seccion_nombre,MAX(puntaje) AS mejor_puntaje FROM vw_resultados GROUP BY alumno_nombre,carrera_nombre,grado_nombre,seccion_nombre,id_alumno ORDER BY mejor_puntaje DESC LIMIT 10";
        try(Connection c=Conexion.getConexion(); PreparedStatement ps=c.prepareStatement(sql); ResultSet rs=ps.executeQuery()){
            while(rs.next()){ Map<String,Object> row=new LinkedHashMap<>(); row.put("nombre",rs.getString("alumno_nombre")); row.put("carrera",rs.getString("carrera_nombre")); row.put("grado",rs.getString("grado_nombre")); row.put("seccion",rs.getString("seccion_nombre")); row.put("puntaje",rs.getDouble("mejor_puntaje")); l.add(row); }
        } catch(SQLException e){ log.log(Level.WARNING, "Error al obtener top 10 alumnos", e); }
        return l;
    }
    public List<Map<String,Object>> inscritosPorCarrera() {
        List<Map<String,Object>> l=new ArrayList<>();
        try(Connection c=Conexion.getConexion(); PreparedStatement ps=c.prepareStatement("SELECT carrera_nombre,total FROM vw_inscritos_por_carrera ORDER BY total DESC"); ResultSet rs=ps.executeQuery()){
            while(rs.next()){ Map<String,Object> row=new LinkedHashMap<>(); row.put("carrera",rs.getString("carrera_nombre")); row.put("total",rs.getInt("total")); l.add(row); }
        } catch(SQLException e){ log.log(Level.WARNING, "Error al obtener inscritos por carrera", e); }
        return l;
    }
    public List<Map<String,Object>> inscritosPorGrado() {
        List<Map<String,Object>> l=new ArrayList<>();
        try(Connection c=Conexion.getConexion(); PreparedStatement ps=c.prepareStatement("SELECT grado_nombre,total FROM vw_inscritos_por_grado ORDER BY total DESC"); ResultSet rs=ps.executeQuery()){
            while(rs.next()){ Map<String,Object> row=new LinkedHashMap<>(); row.put("grado",rs.getString("grado_nombre")); row.put("total",rs.getInt("total")); l.add(row); }
        } catch(SQLException e){ log.log(Level.WARNING, "Error al obtener inscritos por grado", e); }
        return l;
    }
}