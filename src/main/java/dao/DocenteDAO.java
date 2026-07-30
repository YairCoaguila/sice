package dao;
import model.Docente;
import java.sql.*;
public class DocenteDAO extends GenericDAO<Docente> {
    @Override protected String getTableName() { return "docente"; }
    @Override protected String getColumns() { return "nombres,apellido_paterno,apellido_materno,dni,celular,correo,especialidad,estado"; }
    @Override protected String getPlaceholders() { return "?,?,?,?,?,?,?,?"; }
    @Override protected String getUpdateSets() { return "nombres=?,apellido_paterno=?,apellido_materno=?,dni=?,celular=?,correo=?,especialidad=?,estado=?"; }
    @Override protected String getOrderBy() { return " ORDER BY apellido_paterno,nombres"; }
    @Override protected Docente map(ResultSet rs) throws SQLException {
        Docente d=new Docente(); d.setId(rs.getInt("id")); d.setNombres(rs.getString("nombres"));
        d.setApellidoPaterno(rs.getString("apellido_paterno")); d.setApellidoMaterno(rs.getString("apellido_materno"));
        d.setDni(rs.getString("dni")); d.setCelular(rs.getString("celular")); d.setCorreo(rs.getString("correo"));
        d.setEspecialidad(rs.getString("especialidad")); d.setEstado(rs.getString("estado")); return d;
    }
    @Override protected void setInsertParams(PreparedStatement ps, Docente d) throws SQLException {
        ps.setString(1,d.getNombres()); ps.setString(2,d.getApellidoPaterno()); ps.setString(3,d.getApellidoMaterno());
        ps.setString(4,d.getDni()); ps.setString(5,d.getCelular()); ps.setString(6,d.getCorreo());
        ps.setString(7,d.getEspecialidad()); ps.setString(8,d.getEstado()!=null?d.getEstado():"ACTIVO");
    }
    @Override protected int setUpdateParams(PreparedStatement ps, Docente d) throws SQLException {
        ps.setString(1,d.getNombres()); ps.setString(2,d.getApellidoPaterno()); ps.setString(3,d.getApellidoMaterno());
        ps.setString(4,d.getDni()); ps.setString(5,d.getCelular()); ps.setString(6,d.getCorreo());
        ps.setString(7,d.getEspecialidad()); ps.setString(8,d.getEstado()); return 9;
    }
    @Override protected int getId(Docente d) { return d.getId(); }
    @Override protected void setId(Docente d, int id) { d.setId(id); }

    public Docente buscarPorDni(String dni) { return queryOne("SELECT * FROM docente WHERE dni=?", dni); }
}