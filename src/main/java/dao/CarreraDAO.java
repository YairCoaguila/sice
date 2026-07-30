package dao;
import model.Carrera;
import java.sql.*;
import java.util.*;
public class CarreraDAO extends GenericDAO<Carrera> {
    @Override protected String getTableName() { return "carrera c"; }
    @Override protected String getColumns() { return "nombre,id_area,descripcion"; }
    @Override protected String getPlaceholders() { return "?,?,?"; }
    @Override protected String getUpdateSets() { return "nombre=?,id_area=?,descripcion=?"; }
    @Override protected String getReadQuery() { return "SELECT c.*,a.nombre AS area_nombre FROM carrera c JOIN area a ON c.id_area=a.id"; }
    @Override protected String getOrderBy() { return " ORDER BY a.nombre,c.nombre"; }
    @Override protected String getIdColumn() { return "c.id"; }
    @Override protected Carrera map(ResultSet rs) throws SQLException {
        Carrera car=new Carrera(); car.setId(rs.getInt("id")); car.setNombre(rs.getString("nombre"));
        car.setIdArea(rs.getInt("id_area")); car.setAreaNombre(rs.getString("area_nombre")); car.setDescripcion(rs.getString("descripcion")); return car;
    }
    @Override protected void setInsertParams(PreparedStatement ps, Carrera car) throws SQLException {
        ps.setString(1,car.getNombre()); ps.setInt(2,car.getIdArea()); ps.setString(3,car.getDescripcion());
    }
    @Override protected int setUpdateParams(PreparedStatement ps, Carrera car) throws SQLException {
        ps.setString(1,car.getNombre()); ps.setInt(2,car.getIdArea()); ps.setString(3,car.getDescripcion()); return 4;
    }
    @Override protected int getId(Carrera car) { return car.getId(); }
    @Override protected void setId(Carrera car, int id) { car.setId(id); }

    public List<Carrera> listarPorArea(int idArea) {
        return queryList(getReadQuery() + " WHERE c.id_area=? ORDER BY c.nombre", idArea);
    }
}