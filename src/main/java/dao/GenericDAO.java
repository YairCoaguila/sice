package dao;

import util.Conexion;
import java.sql.*;
import java.util.*;

public abstract class GenericDAO<T> {

    protected abstract String getTableName();
    protected abstract String getColumns();
    protected abstract String getPlaceholders();
    protected abstract String getUpdateSets();
    protected abstract T map(ResultSet rs) throws SQLException;
    protected abstract void setInsertParams(PreparedStatement ps, T entity) throws SQLException;
    protected abstract int setUpdateParams(PreparedStatement ps, T entity) throws SQLException;
    protected abstract int getId(T entity);
    protected abstract void setId(T entity, int id);

    protected String getReadQuery() { return "SELECT * FROM " + getTableName(); }
    protected String getOrderBy() { return ""; }
    protected String getIdColumn() { return "id"; }
    protected String getCountQuery() { return "SELECT COUNT(*) FROM (" + getReadQuery() + ") AS cnt"; }

    public List<T> listar() {
        List<T> lista = new ArrayList<>();
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(getReadQuery() + getOrderBy());
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(map(rs));
        } catch (SQLException e) { throw new RuntimeException(e); }
        return lista;
    }

    public PaginatedResult<T> listar(int page, int size) {
        int offset = (page - 1) * size;
        String sql = getReadQuery() + getOrderBy() + " LIMIT ? OFFSET ?";
        List<T> data = queryList(sql, size, offset);
        int total = queryInt(getCountQuery());
        return new PaginatedResult<>(data, total, page, size);
    }

    public T buscarPorId(int id) {
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(getReadQuery() + " WHERE " + getIdColumn() + "=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return null;
    }

    public int insertar(T entity) {
        String sql = "INSERT INTO " + getTableName() + "(" + getColumns() + ")VALUES(" + getPlaceholders() + ") RETURNING id";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            setInsertParams(ps, entity);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) { int id = rs.getInt(1); setId(entity, id); return id; }
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return 0;
    }

    public void actualizar(T entity) {
        String sql = "UPDATE " + getTableName() + " SET " + getUpdateSets() + " WHERE id=?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            int idx = setUpdateParams(ps, entity);
            ps.setInt(idx, getId(entity));
            ps.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public void eliminar(int id) {
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement("DELETE FROM " + getTableName() + " WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public int contarTotal() {
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM " + getTableName());
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { throw new RuntimeException(e); }
        return 0;
    }

    protected List<T> queryList(String sql, Object... params) {
        List<T> lista = new ArrayList<>();
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            setParams(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(map(rs));
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return lista;
    }

    protected T queryOne(String sql, Object... params) {
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            setParams(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return null;
    }

    protected int executeUpdate(String sql, Object... params) {
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            setParams(ps, params);
            return ps.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    protected int queryInt(String sql, Object... params) {
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            setParams(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return 0;
    }

    protected String queryString(String sql, Object... params) {
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            setParams(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString(1);
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return null;
    }

    private void setParams(PreparedStatement ps, Object... params) throws SQLException {
        for (int i = 0; i < params.length; i++) {
            if (params[i] instanceof Integer) ps.setInt(i + 1, (Integer) params[i]);
            else if (params[i] instanceof String) ps.setString(i + 1, (String) params[i]);
            else if (params[i] instanceof Double) ps.setDouble(i + 1, (Double) params[i]);
            else if (params[i] instanceof Boolean) ps.setBoolean(i + 1, (Boolean) params[i]);
            else if (params[i] instanceof java.time.LocalDate) ps.setDate(i + 1, java.sql.Date.valueOf((java.time.LocalDate) params[i]));
            else if (params[i] == null) ps.setNull(i + 1, java.sql.Types.NULL);
            else ps.setObject(i + 1, params[i]);
        }
    }
}