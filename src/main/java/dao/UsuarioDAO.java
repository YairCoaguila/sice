package dao;
import model.Usuario;
import util.Conexion;
import util.PasswordUtil;
import java.sql.*;
import java.util.*;
public class UsuarioDAO {
    public Usuario autenticar(String username, String password) {
        String sql = "SELECT * FROM usuario WHERE username=? AND estado='ACTIVO'";
        try (Connection c = Conexion.getConexion(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = map(rs);
                    if (PasswordUtil.verify(password, u.getPassword())) {
                        u.setPassword(""); return u;
                    }
                    String oldHash = u.getPassword();
                    if (!oldHash.contains(":") && oldHash.matches("[0-9a-f]+")
                            && PasswordUtil.legacyVerify(password, oldHash)) {
                        String newHash = PasswordUtil.hash(password);
                        try (PreparedStatement up = c.prepareStatement("UPDATE usuario SET password=? WHERE id=?")) {
                            up.setString(1, newHash); up.setInt(2, u.getId()); up.executeUpdate();
                        }
                        u.setPassword(""); return u;
                    }
                }
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return null;
    }
    public List<Usuario> listar() {
        List<Usuario> l = new ArrayList<>();
        try (Connection c = Conexion.getConexion(); PreparedStatement ps = c.prepareStatement("SELECT id,username,rol,estado,id_docente FROM usuario ORDER BY username"); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) { Usuario u=new Usuario(); u.setId(rs.getInt("id")); u.setUsername(rs.getString("username")); u.setRol(rs.getString("rol")); u.setEstado(rs.getString("estado")); try{ u.setIdDocente(rs.getInt("id_docente")); }catch(SQLException ignored){} l.add(u); }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return l;
    }
    public Usuario buscarPorIdDocente(int idDocente) {
        String sql = "SELECT id,username,password,rol,estado,id_docente FROM usuario WHERE id_docente=?";
        try (Connection c = Conexion.getConexion(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idDocente);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return map(rs); }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return null;
    }

    public boolean existeUsername(String username) {
        try (Connection c = Conexion.getConexion(); PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM usuario WHERE username=?")) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1) > 0; }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return false;
    }

    public void eliminar(int id) {
        try (Connection c = Conexion.getConexion(); PreparedStatement ps = c.prepareStatement("DELETE FROM usuario WHERE id=?")) {
            ps.setInt(1, id); ps.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public void eliminarPorIdDocente(int idDocente) {
        try (Connection c = Conexion.getConexion(); PreparedStatement ps = c.prepareStatement("DELETE FROM usuario WHERE id_docente=?")) {
            ps.setInt(1, idDocente); ps.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public void cambiarPassword(int idUsuario, String newPassword) {
        try (Connection c = Conexion.getConexion(); PreparedStatement ps = c.prepareStatement("UPDATE usuario SET password=? WHERE id=?")) {
            ps.setString(1, PasswordUtil.hash(newPassword)); ps.setInt(2, idUsuario); ps.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public void insertar(Usuario u) {
        try (Connection c = Conexion.getConexion(); PreparedStatement ps = c.prepareStatement("INSERT INTO usuario(username,password,rol,estado,id_docente)VALUES(?,?,?,?,?)")) {
            ps.setString(1, u.getUsername()); ps.setString(2, PasswordUtil.hash(u.getPassword()));
            ps.setString(3, u.getRol()); ps.setString(4, u.getEstado());
            if (u.getIdDocente() > 0) ps.setInt(5, u.getIdDocente());
            else ps.setNull(5, java.sql.Types.INTEGER);
            ps.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public Usuario buscarPorId(int id) {
        String sql = "SELECT * FROM usuario WHERE id=?";
        try (Connection c = Conexion.getConexion(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return map(rs); }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return null;
    }

    public void actualizar(Usuario u) {
        boolean changePwd = u.getPassword()!=null && !u.getPassword().isEmpty();
        String sql = "UPDATE usuario SET username=?, rol=?, estado=?" + (changePwd?", password=?":"") + " WHERE id=?";
        try (Connection c = Conexion.getConexion(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, u.getUsername()); ps.setString(2, u.getRol()); ps.setString(3, u.getEstado());
            int idx=4;
            if (changePwd) { ps.setString(idx++, PasswordUtil.hash(u.getPassword())); }
            ps.setInt(idx, u.getId()); ps.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    private Usuario map(ResultSet rs) throws SQLException {
        Usuario u=new Usuario(); u.setId(rs.getInt("id")); u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password")); u.setRol(rs.getString("rol")); u.setEstado(rs.getString("estado"));
        try{ u.setIdDocente(rs.getInt("id_docente")); }catch(SQLException ignored){}
        return u;
    }
}
