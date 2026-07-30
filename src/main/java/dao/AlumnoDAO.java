package dao;

import model.Alumno;
import java.sql.*;
import java.util.*;

public class AlumnoDAO extends GenericDAO<Alumno> {
    @Override protected String getTableName() { return "alumno"; }
    @Override protected String getColumns() { return "nombres,apellido_paterno,apellido_materno,dni,fecha_nacimiento,celular,direccion,id_grado,id_seccion,id_carrera,colegio"; }
    @Override protected String getPlaceholders() { return "?,?,?,?,?,?,?,?,?,?,?"; }
    @Override protected String getUpdateSets() { return "nombres=?,apellido_paterno=?,apellido_materno=?,dni=?,fecha_nacimiento=?,celular=?,direccion=?,id_grado=?,id_seccion=?,id_carrera=?,colegio=?"; }
    @Override protected String getReadQuery() { return "SELECT * FROM vw_alumnos"; }
    @Override protected String getOrderBy() { return " ORDER BY apellido_paterno,nombres"; }

    @Override protected Alumno map(ResultSet rs) throws SQLException {
        Alumno a = new Alumno();
        a.setId(rs.getInt("id"));
        a.setNombres(rs.getString("nombres"));
        a.setApellidoPaterno(rs.getString("apellido_paterno"));
        a.setApellidoMaterno(rs.getString("apellido_materno"));
        a.setDni(rs.getString("dni"));
        java.sql.Date fn = rs.getDate("fecha_nacimiento");
        if (fn != null) a.setFechaNacimiento(fn.toLocalDate());
        a.setCelular(rs.getString("celular"));
        a.setDireccion(rs.getString("direccion"));
        a.setIdGrado(rs.getInt("id_grado"));
        a.setIdSeccion(rs.getInt("id_seccion"));
        a.setIdCarrera(rs.getInt("id_carrera"));
        a.setColegio(rs.getString("colegio"));
        try { a.setGradoNombre(rs.getString("grado_nombre")); } catch (SQLException ignored) {}
        try { a.setSeccionNombre(rs.getString("seccion_nombre")); } catch (SQLException ignored) {}
        try { a.setCarreraNombre(rs.getString("carrera_nombre")); } catch (SQLException ignored) {}
        return a;
    }

    @Override protected void setInsertParams(PreparedStatement ps, Alumno a) throws SQLException {
        ps.setString(1, a.getNombres());
        ps.setString(2, a.getApellidoPaterno());
        ps.setString(3, a.getApellidoMaterno());
        ps.setString(4, a.getDni());
        ps.setDate(5, a.getFechaNacimiento() != null ? java.sql.Date.valueOf(a.getFechaNacimiento()) : null);
        ps.setString(6, a.getCelular());
        ps.setString(7, a.getDireccion());
        ps.setInt(8, a.getIdGrado());
        ps.setInt(9, a.getIdSeccion());
        if (a.getIdCarrera() > 0) ps.setInt(10, a.getIdCarrera());
        else ps.setNull(10, java.sql.Types.INTEGER);
        ps.setString(11, a.getColegio());
    }

    @Override protected int setUpdateParams(PreparedStatement ps, Alumno a) throws SQLException {
        ps.setString(1, a.getNombres());
        ps.setString(2, a.getApellidoPaterno());
        ps.setString(3, a.getApellidoMaterno());
        ps.setString(4, a.getDni());
        ps.setDate(5, a.getFechaNacimiento() != null ? java.sql.Date.valueOf(a.getFechaNacimiento()) : null);
        ps.setString(6, a.getCelular());
        ps.setString(7, a.getDireccion());
        ps.setInt(8, a.getIdGrado());
        ps.setInt(9, a.getIdSeccion());
        if (a.getIdCarrera() > 0) ps.setInt(10, a.getIdCarrera());
        else ps.setNull(10, java.sql.Types.INTEGER);
        ps.setString(11, a.getColegio());
        return 12;
    }

    @Override protected int getId(Alumno a) { return a.getId(); }
    @Override protected void setId(Alumno a, int id) { a.setId(id); }

    public List<Alumno> buscar(String t) {
        String q = "%" + t + "%";
        return queryList("SELECT * FROM vw_alumnos WHERE LOWER(nombres) LIKE LOWER(?) OR LOWER(apellido_paterno) LIKE LOWER(?) OR dni LIKE ? ORDER BY apellido_paterno", q, q, q);
    }

    public boolean existeDni(String dni, int excluirId) {
        return queryInt("SELECT COUNT(*) FROM alumno WHERE dni=? AND id<>?", dni, excluirId) > 0;
    }

    public List<Alumno> listarPorGradoSeccion(int idGrado, int idSeccion) {
        return queryList("SELECT * FROM vw_alumnos WHERE id_grado=? AND id_seccion=? ORDER BY apellido_paterno,nombres", idGrado, idSeccion);
    }

    public Alumno buscarPorDni(String dni) {
        return queryOne("SELECT * FROM vw_alumnos WHERE dni=?", dni);
    }
}