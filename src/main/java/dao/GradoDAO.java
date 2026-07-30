package dao;
import model.Grado;
import java.sql.*;
import java.util.*;
public class GradoDAO extends GenericDAO<Grado> {
    @Override protected String getTableName() { return "grado"; }
    @Override protected String getColumns() { return "nombre,nivel,participa"; }
    @Override protected String getPlaceholders() { return "?,?,?"; }
    @Override protected String getUpdateSets() { return "nombre=?,nivel=?,participa=?"; }
    @Override protected String getOrderBy() { return " ORDER BY nivel"; }
    @Override protected Grado map(ResultSet rs) throws SQLException {
        Grado g=new Grado(); g.setId(rs.getInt("id")); g.setNombre(rs.getString("nombre"));
        g.setNivel(rs.getInt("nivel")); g.setParticipa(rs.getBoolean("participa")); return g;
    }
    @Override protected void setInsertParams(PreparedStatement ps, Grado g) throws SQLException {
        ps.setString(1,g.getNombre()); ps.setInt(2,g.getNivel()); ps.setBoolean(3,g.isParticipa());
    }
    @Override protected int setUpdateParams(PreparedStatement ps, Grado g) throws SQLException {
        ps.setString(1,g.getNombre()); ps.setInt(2,g.getNivel()); ps.setBoolean(3,g.isParticipa()); return 4;
    }
    @Override protected int getId(Grado g) { return g.getId(); }
    @Override protected void setId(Grado g, int id) { g.setId(id); }

    public List<Grado> listarParticipantes() { return queryList("SELECT * FROM grado WHERE participa=TRUE ORDER BY nivel"); }
}