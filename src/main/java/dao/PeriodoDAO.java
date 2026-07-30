package dao;
import model.Periodo;
import java.sql.*;
public class PeriodoDAO extends GenericDAO<Periodo> {
    @Override protected String getTableName() { return "periodo"; }
    @Override protected String getColumns() { return "nombre,anio,descripcion,activo"; }
    @Override protected String getPlaceholders() { return "?,?,?,?"; }
    @Override protected String getUpdateSets() { return "nombre=?,anio=?,descripcion=?,activo=?"; }
    @Override protected String getOrderBy() { return " ORDER BY anio DESC,nombre"; }
    @Override protected Periodo map(ResultSet rs) throws SQLException {
        Periodo p=new Periodo(); p.setId(rs.getInt("id")); p.setNombre(rs.getString("nombre"));
        p.setAnio(rs.getInt("anio")); p.setDescripcion(rs.getString("descripcion")); p.setActivo(rs.getBoolean("activo")); return p;
    }
    @Override protected void setInsertParams(PreparedStatement ps, Periodo p) throws SQLException {
        ps.setString(1,p.getNombre()); ps.setInt(2,p.getAnio()); ps.setString(3,p.getDescripcion()); ps.setBoolean(4,p.isActivo());
    }
    @Override protected int setUpdateParams(PreparedStatement ps, Periodo p) throws SQLException {
        ps.setString(1,p.getNombre()); ps.setInt(2,p.getAnio()); ps.setString(3,p.getDescripcion()); ps.setBoolean(4,p.isActivo()); return 5;
    }
    @Override protected int getId(Periodo p) { return p.getId(); }
    @Override protected void setId(Periodo p, int id) { p.setId(id); }
}