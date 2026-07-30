package dao;
import model.Area;
import java.sql.*;
public class AreaDAO extends GenericDAO<Area> {
    @Override protected String getTableName() { return "area"; }
    @Override protected String getColumns() { return "nombre,descripcion"; }
    @Override protected String getPlaceholders() { return "?,?"; }
    @Override protected String getUpdateSets() { return "nombre=?,descripcion=?"; }
    @Override protected String getOrderBy() { return " ORDER BY nombre"; }
    @Override protected Area map(ResultSet rs) throws SQLException {
        Area a=new Area(); a.setId(rs.getInt("id")); a.setNombre(rs.getString("nombre")); a.setDescripcion(rs.getString("descripcion")); return a;
    }
    @Override protected void setInsertParams(PreparedStatement ps, Area a) throws SQLException {
        ps.setString(1,a.getNombre()); ps.setString(2,a.getDescripcion());
    }
    @Override protected int setUpdateParams(PreparedStatement ps, Area a) throws SQLException {
        ps.setString(1,a.getNombre()); ps.setString(2,a.getDescripcion()); return 3;
    }
    @Override protected int getId(Area a) { return a.getId(); }
    @Override protected void setId(Area a, int id) { a.setId(id); }
}