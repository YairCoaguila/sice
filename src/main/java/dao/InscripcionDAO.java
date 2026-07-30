package dao;
import model.Inscripcion;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
public class InscripcionDAO extends GenericDAO<Inscripcion> {
    @Override protected String getTableName() { return "inscripcion"; }
    @Override protected String getColumns() { return "codigo_inscripcion,id_alumno,id_examen,id_carrera,anio,periodo,estado"; }
    @Override protected String getPlaceholders() { return "?,?,?,?,?,?,?"; }
    @Override protected String getUpdateSets() { return "id_examen=?,id_carrera=?,anio=?,periodo=?,estado=?"; }
    @Override protected String getReadQuery() { return "SELECT * FROM vw_inscripciones"; }
    @Override protected String getOrderBy() { return " ORDER BY fecha_inscripcion DESC"; }
    @Override protected Inscripcion map(ResultSet rs) throws SQLException {
        Inscripcion i=new Inscripcion(); i.setId(rs.getInt("id")); i.setCodigoInscripcion(rs.getString("codigo_inscripcion"));
        i.setIdAlumno(rs.getInt("id_alumno")); i.setIdExamen(rs.getInt("id_examen")); i.setIdCarrera(rs.getInt("id_carrera"));
        i.setAnio(rs.getInt("anio")); i.setPeriodo(rs.getString("periodo")); i.setEstado(rs.getString("estado"));
        Timestamp ts=rs.getTimestamp("fecha_inscripcion"); if(ts!=null) i.setFechaInscripcion(ts.toLocalDateTime());
        try{i.setAlumnoNombre(rs.getString("alumno_nombre"));}catch(SQLException ignored){}
        try{i.setAlumnoDni(rs.getString("alumno_dni"));}catch(SQLException ignored){}
        try{i.setExamenNombre(rs.getString("examen_nombre"));}catch(SQLException ignored){}
        try{i.setCarreraNombre(rs.getString("carrera_nombre"));}catch(SQLException ignored){}
        try{i.setAreaNombre(rs.getString("area_nombre"));}catch(SQLException ignored){}
        try{i.setGradoNombre(rs.getString("grado_nombre")); i.setIdGrado(rs.getInt("id_grado"));}catch(SQLException ignored){}
        try{i.setSeccionNombre(rs.getString("seccion_nombre")); i.setIdSeccion(rs.getInt("id_seccion"));}catch(SQLException ignored){}
        try{ Date ef=rs.getDate("examen_fecha"); if(ef!=null) i.setExamenFecha(ef.toLocalDate()); }catch(SQLException ignored){}
        return i;
    }
    @Override protected void setInsertParams(PreparedStatement ps, Inscripcion i) throws SQLException {
        ps.setString(1,i.getCodigoInscripcion()); ps.setInt(2,i.getIdAlumno()); ps.setInt(3,i.getIdExamen());
        ps.setInt(4,i.getIdCarrera()); ps.setInt(5,i.getAnio()); ps.setString(6,i.getPeriodo());
        ps.setString(7,i.getEstado()!=null?i.getEstado():"ACTIVO");
    }
    @Override protected int setUpdateParams(PreparedStatement ps, Inscripcion i) throws SQLException {
        ps.setInt(1,i.getIdExamen()); ps.setInt(2,i.getIdCarrera()); ps.setInt(3,i.getAnio());
        ps.setString(4,i.getPeriodo()); ps.setString(5,i.getEstado()); return 6;
    }
    @Override protected int getId(Inscripcion i) { return i.getId(); }
    @Override protected void setId(Inscripcion i, int id) { i.setId(id); }

    public boolean existeInscripcion(int idAlumno, int idExamen) {
        return queryInt("SELECT COUNT(*) FROM inscripcion WHERE id_alumno=? AND id_examen=? AND estado<>'CANCELADO'", idAlumno, idExamen) > 0;
    }

    public boolean existeInscripcionIncluyendoCancelados(int idAlumno, int idExamen) {
        return queryInt("SELECT COUNT(*) FROM inscripcion WHERE id_alumno=? AND id_examen=?", idAlumno, idExamen) > 0;
    }

    public Inscripcion buscarInactiva(int idAlumno, int idExamen) {
        return queryOne("SELECT * FROM inscripcion WHERE id_alumno=? AND id_examen=? AND estado='CANCELADO' ORDER BY id DESC LIMIT 1", idAlumno, idExamen);
    }

    public String generarCodigo(int anio) {
        int count = queryInt("SELECT COUNT(*) FROM inscripcion WHERE anio=?", anio);
        return String.format("INS-%d-%04d", anio, count + 1);
    }

    public void cancelar(int id) {
        executeUpdate("UPDATE inscripcion SET estado='CANCELADO' WHERE id=?", id);
    }

    public void reactivar(Inscripcion i) {
        executeUpdate("UPDATE inscripcion SET id_carrera=?, anio=?, periodo=?, estado='ACTIVO' WHERE id=?", i.getIdCarrera(), i.getAnio(), i.getPeriodo(), i.getId());
    }

    public boolean existeInscripcionEnFecha(int idAlumno, java.time.LocalDate fecha) {
        if (fecha == null) return false;
        return queryInt("SELECT COUNT(*) FROM vw_inscripciones WHERE id_alumno=? AND examen_fecha=? AND estado<>'CANCELADO'", idAlumno, fecha) > 0;
    }

    public Inscripcion buscarPorAlumnoYExamen(int idAlumno, int idExamen) {
        return queryOne("SELECT * FROM vw_inscripciones WHERE id_alumno=? AND id_examen=? ORDER BY fecha_inscripcion DESC LIMIT 1", idAlumno, idExamen);
    }

    public List<Inscripcion> listarPorAlumno(int idAlumno) {
        return queryList("SELECT * FROM vw_inscripciones WHERE id_alumno=? ORDER BY fecha_inscripcion DESC", idAlumno);
    }

    public int contarTotal() {
        return queryInt("SELECT COUNT(*) FROM inscripcion WHERE estado<>'CANCELADO'");
    }
}