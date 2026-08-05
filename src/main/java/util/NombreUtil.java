package util;

import java.util.Locale;

/**
 * Formateo de nombres: apellidos en mayúsculas, nombres solo con la primera letra en mayúscula.
 */
public final class NombreUtil {

    private NombreUtil() {}

    /**
     * Inicial en mayúscula y el resto en minúscula para cada palabra.
     */
    public static String nombres(String n) {
        if (n == null || n.isBlank()) return "";
        StringBuilder sb = new StringBuilder();
        for (String w : n.trim().toLowerCase(Locale.ROOT).split("\\s+")) {
            if (w.isEmpty()) continue;
            if (sb.length() > 0) sb.append(' ');
            sb.append(Character.toUpperCase(w.charAt(0)));
            if (w.length() > 1) sb.append(w.substring(1));
        }
        return sb.toString();
    }

    public static String apellidos(String a) {
        return a != null ? a.trim().toUpperCase(Locale.ROOT) : "";
    }

    /** APELLIDO_PATERNO APELLIDO_MATERNO, Nombres */
    public static String completo(String paterno, String materno, String nombres) {
        String p = apellidos(paterno);
        String m = apellidos(materno);
        String n = nombres(nombres);
        StringBuilder sb = new StringBuilder();
        if (!p.isEmpty()) sb.append(p);
        if (!m.isEmpty()) { if (sb.length()>0) sb.append(' '); sb.append(m); }
        if (!n.isEmpty()) { if (sb.length()>0) sb.append(", "); sb.append(n); }
        return sb.toString();
    }

    /** Re-formatea un nombre ya concatenado: "APAZA QUISPE, Jose Miguel" -> "APAZA QUISPE, José Miguel" */
    public static String desdeCompleto(String s) {
        if (s == null || s.isBlank()) return s != null ? s : "";
        int idx = s.indexOf(',');
        if (idx >= 0) {
            String ap = s.substring(0, idx);
            String nom = s.substring(idx + 1);
            String r = apellidos(ap);
            if (!nom.isBlank()) r += ", " + nombres(nom);
            return r;
        }
        return apellidos(s);
    }
}