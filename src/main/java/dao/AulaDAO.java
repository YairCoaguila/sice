package dao;
import model.Aula;
import java.sql.*;
public class AulaDAO extends GenericDAO<Aula> {
    @Override protected String getTableName() { return "aula"; }
    @Override protected String getColumns() { return "codigo,capacidad,descripcion"; }
    @Override protected String getPlaceholders() { return "?,?,?"; }
    @Override protected String getUpdateSets() { return "codigo=?,capacidad=?,descripcion=?"; }
    @Override protected String getOrderBy() { return " ORDER BY codigo"; }
    @Override protected Aula map(ResultSet rs) throws SQLException {
        Aula a=new Aula(); a.setId(rs.getInt("id")); a.setCodigo(rs.getString("codigo"));
        a.setCapacidad(rs.getInt("capacidad")); a.setDescripcion(rs.getString("descripcion")); return a;
    }
    @Override protected void setInsertParams(PreparedStatement ps, Aula a) throws SQLException {
        ps.setString(1,a.getCodigo()); ps.setInt(2,a.getCapacidad()); ps.setString(3,a.getDescripcion());
    }
    @Override protected int setUpdateParams(PreparedStatement ps, Aula a) throws SQLException {
        ps.setString(1,a.getCodigo()); ps.setInt(2,a.getCapacidad()); ps.setString(3,a.getDescripcion()); return 4;
    }
    @Override protected int getId(Aula a) { return a.getId(); }
    @Override protected void setId(Aula a, int id) { a.setId(id); }
}