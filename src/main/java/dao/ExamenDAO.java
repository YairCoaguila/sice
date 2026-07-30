package dao;
import model.Examen;
import util.Conexion;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
public class ExamenDAO extends GenericDAO<Examen> {
    @Override protected String getTableName() { return "examen"; }
    @Override protected String getColumns() { return "nombre,fecha,anio,periodo,id_grado,id_area,cantidad_preguntas,puntaje_total,estado"; }
    @Override protected String getPlaceholders() { return "?,?,?,?,?,?,?,?,?"; }
    @Override protected String getUpdateSets() { return "nombre=?,fecha=?,anio=?,periodo=?,id_grado=?,id_area=?,cantidad_preguntas=?,puntaje_total=?,estado=?"; }
    @Override protected String getReadQuery() { return "SELECT e.*,g.nombre AS grado_nombre,a.nombre AS area_nombre FROM examen e JOIN grado g ON e.id_grado=g.id JOIN area a ON e.id_area=a.id"; }
    @Override protected String getOrderBy() { return " ORDER BY e.anio DESC,e.fecha DESC"; }
    @Override protected String getIdColumn() { return "e.id"; }
    @Override protected Examen map(ResultSet rs) throws SQLException {
        Examen e=new Examen(); e.setId(rs.getInt("id")); e.setNombre(rs.getString("nombre"));
        Date f=rs.getDate("fecha"); if(f!=null) e.setFecha(f.toLocalDate());
        e.setAnio(rs.getInt("anio")); e.setPeriodo(rs.getString("periodo"));
        e.setIdGrado(rs.getInt("id_grado")); e.setIdArea(rs.getInt("id_area"));
        e.setCantidadPreguntas(rs.getInt("cantidad_preguntas")); e.setPuntajeTotal(rs.getDouble("puntaje_total"));
        e.setEstado(rs.getString("estado"));
        try{e.setGradoNombre(rs.getString("grado_nombre"));}catch(SQLException ignored){}
        try{e.setAreaNombre(rs.getString("area_nombre"));}catch(SQLException ignored){}
        return e;
    }
    @Override protected void setInsertParams(PreparedStatement ps, Examen e) throws SQLException {
        ps.setString(1,e.getNombre()); ps.setDate(2,e.getFecha()!=null?Date.valueOf(e.getFecha()):null);
        ps.setInt(3,e.getAnio()); ps.setString(4,e.getPeriodo()); ps.setInt(5,e.getIdGrado());
        ps.setInt(6,e.getIdArea()); ps.setInt(7,e.getCantidadPreguntas()); ps.setDouble(8,e.getPuntajeTotal());
        ps.setString(9,e.getEstado()!=null?e.getEstado():"ACTIVO");
    }
    @Override protected int setUpdateParams(PreparedStatement ps, Examen e) throws SQLException {
        ps.setString(1,e.getNombre()); ps.setDate(2,e.getFecha()!=null?Date.valueOf(e.getFecha()):null);
        ps.setInt(3,e.getAnio()); ps.setString(4,e.getPeriodo()); ps.setInt(5,e.getIdGrado());
        ps.setInt(6,e.getIdArea()); ps.setInt(7,e.getCantidadPreguntas()); ps.setDouble(8,e.getPuntajeTotal());
        ps.setString(9,e.getEstado()); return 10;
    }
    @Override protected int getId(Examen e) { return e.getId(); }
    @Override protected void setId(Examen e, int id) { e.setId(id); }

    public String buscarAulaPorExamen(int idExamen) {
        return queryString("SELECT a.codigo FROM examen_aula ea JOIN aula a ON ea.id_aula=a.id WHERE ea.id_examen=?", idExamen);
    }

    public Map<Integer, String> buscarAulasPorExamenes() {
        Map<Integer, String> mapa = new HashMap<>();
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement("SELECT ea.id_examen, a.codigo FROM examen_aula ea JOIN aula a ON ea.id_aula = a.id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) mapa.put(rs.getInt("id_examen"), rs.getString("codigo"));
        } catch (SQLException e) { throw new RuntimeException(e); }
        return mapa;
    }

    public String buscarProfesorPorGradoSeccionPeriodo(int idGrado, int idSeccion, int anio, String periodo) {
        return queryString("SELECT docente_nombre FROM vw_docente_aula WHERE id_grado=? AND id_seccion=? AND anio=? AND periodo=?", idGrado, idSeccion, anio, periodo);
    }
}