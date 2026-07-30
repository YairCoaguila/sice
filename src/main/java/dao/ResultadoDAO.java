package dao;
import model.Resultado;
import java.sql.*;
import java.util.*;
public class ResultadoDAO extends GenericDAO<Resultado> {
    @Override protected String getTableName() { return "resultado"; }
    @Override protected String getColumns() { return "id_alumno,id_examen,puntaje,correctas,incorrectas,en_blanco,porcentaje"; }
    @Override protected String getPlaceholders() { return "?,?,?,?,?,?,?"; }
    @Override protected String getUpdateSets() { return "correctas=?,incorrectas=?,en_blanco=?,puntaje=?,porcentaje=?"; }
    @Override protected String getReadQuery() { return "SELECT * FROM vw_resultados"; }
    @Override protected Resultado map(ResultSet rs) throws SQLException {
        Resultado r=new Resultado(); r.setId(rs.getInt("id")); r.setIdAlumno(rs.getInt("id_alumno")); r.setIdExamen(rs.getInt("id_examen"));
        r.setPuntaje(rs.getDouble("puntaje")); r.setCorrectas(rs.getInt("correctas")); r.setIncorrectas(rs.getInt("incorrectas"));
        r.setEnBlanco(rs.getInt("en_blanco")); r.setPorcentaje(rs.getDouble("porcentaje"));
        Timestamp ts=rs.getTimestamp("fecha_registro"); if(ts!=null) r.setFechaRegistro(ts.toLocalDateTime());
        try{r.setAlumnoNombre(rs.getString("alumno_nombre"));}catch(SQLException ignored){}
        try{r.setAlumnoDni(rs.getString("alumno_dni"));}catch(SQLException ignored){}
        try{r.setExamenNombre(rs.getString("examen_nombre"));}catch(SQLException ignored){}
        try{r.setGradoNombre(rs.getString("grado_nombre")); r.setIdGrado(rs.getInt("id_grado"));}catch(SQLException ignored){}
        try{r.setSeccionNombre(rs.getString("seccion_nombre")); r.setIdSeccion(rs.getInt("id_seccion"));}catch(SQLException ignored){}
        try{r.setCarreraNombre(rs.getString("carrera_nombre"));}catch(SQLException ignored){}
        try{r.setRankingGeneral(rs.getInt("ranking_general"));}catch(SQLException ignored){}
        try{r.setRankingGrado(rs.getInt("ranking_grado"));}catch(SQLException ignored){}
        return r;
    }
    @Override protected void setInsertParams(PreparedStatement ps, Resultado r) throws SQLException {
        ps.setInt(1,r.getIdAlumno()); ps.setInt(2,r.getIdExamen()); ps.setDouble(3,r.getPuntaje());
        ps.setInt(4,r.getCorrectas()); ps.setInt(5,r.getIncorrectas()); ps.setInt(6,r.getEnBlanco()); ps.setDouble(7,r.getPorcentaje());
    }
    @Override protected int setUpdateParams(PreparedStatement ps, Resultado r) throws SQLException {
        ps.setInt(1,r.getCorrectas()); ps.setInt(2,r.getIncorrectas()); ps.setInt(3,r.getEnBlanco());
        ps.setDouble(4,r.getPuntaje()); ps.setDouble(5,r.getPorcentaje()); return 6;
    }
    @Override protected int getId(Resultado r) { return r.getId(); }
    @Override protected void setId(Resultado r, int id) { r.setId(id); }

    public List<Resultado> listarPorExamen(int idExamen) { return queryList("SELECT * FROM vw_resultados WHERE id_examen=? ORDER BY puntaje DESC", idExamen); }
    public List<Resultado> listarPorAlumno(int idAlumno) { return queryList("SELECT * FROM vw_resultados WHERE id_alumno=? ORDER BY fecha_registro DESC", idAlumno); }
    public List<Resultado> rankingGeneral(int idExamen) { return queryList("SELECT * FROM vw_ranking_general WHERE id_examen=? ORDER BY ranking_general", idExamen); }
    public List<Resultado> rankingPorGrado(int idExamen, int idGrado) { return queryList("SELECT * FROM vw_ranking_grado WHERE id_examen=? AND id_grado=? ORDER BY ranking_grado", idExamen, idGrado); }
    public List<Resultado> rankingPorSeccion(int idExamen, int idSeccion) { return queryList("SELECT * FROM vw_ranking_seccion WHERE id_examen=? AND id_seccion=? ORDER BY ranking_seccion", idExamen, idSeccion); }
    public List<Resultado> rankingGeneralPorAlumno(int idAlumno) { return queryList("SELECT * FROM vw_ranking_general WHERE id_alumno=? ORDER BY id_examen", idAlumno); }
    public List<Resultado> rankingGradoPorAlumno(int idAlumno) { return queryList("SELECT * FROM vw_ranking_grado WHERE id_alumno=? ORDER BY id_examen", idAlumno); }
    public Resultado buscarPorAlumnoYExamen(int idAlumno, int idExamen) { return queryOne("SELECT * FROM vw_ranking_general WHERE id_alumno=? AND id_examen=?", idAlumno, idExamen); }
}