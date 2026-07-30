package dao;
import model.DocenteAula;
import java.sql.*;
import java.util.*;
public class DocenteAulaDAO extends GenericDAO<DocenteAula> {
    @Override protected String getTableName() { return "docente_aula"; }
    @Override protected String getColumns() { return "id_docente,id_grado,id_seccion,anio,periodo"; }
    @Override protected String getPlaceholders() { return "?,?,?,?,?"; }
    @Override protected String getUpdateSets() { return "id_docente=?,id_grado=?,id_seccion=?,anio=?,periodo=?"; }
    @Override protected String getReadQuery() { return "SELECT * FROM vw_docente_aula"; }
    @Override protected String getOrderBy() { return " ORDER BY anio DESC,grado_nombre,seccion_nombre"; }
    @Override protected DocenteAula map(ResultSet rs) throws SQLException {
        DocenteAula da=new DocenteAula(); da.setId(rs.getInt("id")); da.setIdDocente(rs.getInt("id_docente"));
        da.setIdGrado(rs.getInt("id_grado")); da.setIdSeccion(rs.getInt("id_seccion")); da.setAnio(rs.getInt("anio")); da.setPeriodo(rs.getString("periodo"));
        try{da.setDocenteNombre(rs.getString("docente_nombre"));}catch(SQLException ignored){}
        try{da.setGradoNombre(rs.getString("grado_nombre"));}catch(SQLException ignored){}
        try{da.setSeccionNombre(rs.getString("seccion_nombre"));}catch(SQLException ignored){}
        return da;
    }
    @Override protected void setInsertParams(PreparedStatement ps, DocenteAula da) throws SQLException {
        ps.setInt(1,da.getIdDocente()); ps.setInt(2,da.getIdGrado()); ps.setInt(3,da.getIdSeccion()); ps.setInt(4,da.getAnio()); ps.setString(5,da.getPeriodo());
    }
    @Override protected int setUpdateParams(PreparedStatement ps, DocenteAula da) throws SQLException {
        ps.setInt(1,da.getIdDocente()); ps.setInt(2,da.getIdGrado()); ps.setInt(3,da.getIdSeccion()); ps.setInt(4,da.getAnio()); ps.setString(5,da.getPeriodo()); return 6;
    }
    @Override protected int getId(DocenteAula da) { return da.getId(); }
    @Override protected void setId(DocenteAula da, int id) { da.setId(id); }

    public void eliminarPorDocente(int idDocente) { executeUpdate("DELETE FROM docente_aula WHERE id_docente=?", idDocente); }
    public List<DocenteAula> listarPorDocente(int idDocente) { return queryList("SELECT * FROM vw_docente_aula WHERE id_docente=? ORDER BY anio DESC,grado_nombre,seccion_nombre", idDocente); }
}