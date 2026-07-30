package util;
import org.apache.commons.dbcp2.BasicDataSource;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class Conexion {
    private static final BasicDataSource dataSource = new BasicDataSource();
    
    static {
        String url = env("DB_URL");
        String user = env("DB_USER");
        String pass = env("DB_PASS");
        if (url == null) {
            Properties props = loadProperties("database.properties");
            url = props.getProperty("db.url");
            user = props.getProperty("db.user");
            pass = props.getProperty("db.password");
        }
        dataSource.setDriverClassName("org.postgresql.Driver");
        dataSource.setUrl(url != null ? url : "jdbc:postgresql://localhost:5432/simulacro_db?useUnicode=true&characterEncoding=UTF-8");
        dataSource.setUsername(user != null ? user : "postgres");
        dataSource.setPassword(pass != null ? pass : "123456");
        dataSource.setMaxTotal(30);
        dataSource.setMaxIdle(10);
        dataSource.setMinIdle(4);
        dataSource.setMaxWaitMillis(5000);
        dataSource.setValidationQuery("SELECT 1");
        dataSource.setTestOnBorrow(true);
        dataSource.setPoolPreparedStatements(true);
        dataSource.setMaxOpenPreparedStatements(50);
        dataSource.setLogAbandoned(true);
        dataSource.setAbandonedUsageTracking(true);
        dataSource.setRemoveAbandonedOnBorrow(true);
        dataSource.setRemoveAbandonedTimeout(60);
    }

    private static String env(String key) {
        String v = System.getenv(key);
        if (v == null || v.isBlank()) v = System.getProperty(key);
        return v;
    }

    private static Properties loadProperties(String path) {
        Properties props = new Properties();
        try (InputStream in = Thread.currentThread().getContextClassLoader().getResourceAsStream(path)) {
            if (in != null) props.load(in);
        } catch (Exception ignored) {}
        return props;
    }
    
    public static Connection getConexion() throws SQLException {
        return dataSource.getConnection();
    }
    
    public static void cerrar(AutoCloseable... recursos) {
        for (AutoCloseable r : recursos) {
            if (r != null) try { r.close(); } catch (Exception ignored) {}
        }
    }
}
