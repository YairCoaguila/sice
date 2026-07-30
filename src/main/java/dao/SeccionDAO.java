package dao;
import model.Seccion;
import java.sql.*;
public class SeccionDAO extends GenericDAO<Seccion> {
    @Override protected String getTableName() { return "seccion"; }
    @Override protected String getColumns() { return "nombre,id_grado"; }
    @Override protected String getPlaceholders() { return "?,?"; }
    @Override protected String getUpdateSets() { return "nombre=?,id_grado=?"; }
    @Override protected String getReadQuery() { return "SELECT s.*,g.nombre AS grado_nombre FROM seccion s JOIN grado g ON s.id_grado=g.id"; }
    @Override protected String getOrderBy() { return " ORDER BY g.nivel,s.nombre"; }
    @Override protected String getIdColumn() { return "s.id"; }
    @Override protected Seccion map(ResultSet rs) throws SQLException {
        Seccion s=new Seccion(); s.setId(rs.getInt("id")); s.setNombre(rs.getString("nombre"));
        s.setIdGrado(rs.getInt("id_grado")); s.setGradoNombre(rs.getString("grado_nombre")); return s;
    }
    @Override protected void setInsertParams(PreparedStatement ps, Seccion s) throws SQLException {
        ps.setString(1,s.getNombre()); ps.setInt(2,s.getIdGrado());
    }
    @Override protected int setUpdateParams(PreparedStatement ps, Seccion s) throws SQLException {
        ps.setString(1,s.getNombre()); ps.setInt(2,s.getIdGrado()); return 3;
    }
    @Override protected int getId(Seccion s) { return s.getId(); }
    @Override protected void setId(Seccion s, int id) { s.setId(id); }
}