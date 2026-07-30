package dao;
import model.ExamenAsignacion;
import util.Conexion;
import java.sql.*;
import java.util.*;
public class ExamenAsignacionDAO {
    public List<ExamenAsignacion> listarPorExamen(int idExamen) {
        List<ExamenAsignacion> l=new ArrayList<>();
        try(Connection c=Conexion.getConexion(); PreparedStatement ps=c.prepareStatement("SELECT * FROM vw_examen_asignacion WHERE id_examen=? ORDER BY id")){
            ps.setInt(1,idExamen); try(ResultSet rs=ps.executeQuery()){while(rs.next())l.add(map(rs));}
        } catch(SQLException e){throw new RuntimeException(e);} return l;
    }
    public List<ExamenAsignacion> listarPorDocente(int idDocente) {
        List<ExamenAsignacion> l=new ArrayList<>();
        try(Connection c=Conexion.getConexion(); PreparedStatement ps=c.prepareStatement("SELECT * FROM vw_examen_asignacion WHERE id_docente=? ORDER BY examen_anio DESC,examen_nombre")){
            ps.setInt(1,idDocente); try(ResultSet rs=ps.executeQuery()){while(rs.next())l.add(map(rs));}
        } catch(SQLException e){throw new RuntimeException(e);} return l;
    }
    public void insertar(ExamenAsignacion ea) {
        try(Connection c=Conexion.getConexion(); PreparedStatement ps=c.prepareStatement("INSERT INTO examen_asignacion(id_examen,id_docente,id_aula)VALUES(?,?,?)")){
            ps.setInt(1,ea.getIdExamen()); ps.setInt(2,ea.getIdDocente()); ps.setInt(3,ea.getIdAula()); ps.executeUpdate();
        } catch(SQLException e){throw new RuntimeException(e);}
    }
    public void eliminarPorDocente(int idDocente) {
        try(Connection c=Conexion.getConexion(); PreparedStatement ps=c.prepareStatement("DELETE FROM examen_asignacion WHERE id_docente=?")){
            ps.setInt(1,idDocente); ps.executeUpdate();
        } catch(SQLException e){throw new RuntimeException(e);}
    }
    public void eliminar(int id) {
        try(Connection c=Conexion.getConexion(); PreparedStatement ps=c.prepareStatement("DELETE FROM examen_asignacion WHERE id=?")){
            ps.setInt(1,id); ps.executeUpdate();
        } catch(SQLException e){throw new RuntimeException(e);}
    }
    private ExamenAsignacion map(ResultSet rs) throws SQLException {
        ExamenAsignacion ea=new ExamenAsignacion(); ea.setId(rs.getInt("id")); ea.setIdExamen(rs.getInt("id_examen"));
        ea.setIdDocente(rs.getInt("id_docente")); ea.setIdAula(rs.getInt("id_aula"));
        try{ea.setExamenNombre(rs.getString("examen_nombre"));}catch(SQLException ignored){}
        try{ea.setExamenAnio(rs.getInt("examen_anio"));}catch(SQLException ignored){}
        try{ea.setExamenPeriodo(rs.getString("examen_periodo"));}catch(SQLException ignored){}
        try{ea.setDocenteNombre(rs.getString("docente_nombre"));}catch(SQLException ignored){}
        try{ea.setAulaCodigo(rs.getString("aula_codigo"));}catch(SQLException ignored){}
        try{ea.setAulaCapacidad(rs.getInt("aula_capacidad"));}catch(SQLException ignored){}
        return ea;
    }
}
