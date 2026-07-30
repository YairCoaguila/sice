package util;

public class HtmlUtil {
    public static String e(String s) {
        if (s == null) return "";
        StringBuilder sb = null;
        int len = s.length();
        for (int i = 0; i < len; i++) {
            char c = s.charAt(i);
            String r;
            switch (c) {
                case '&': r = "&amp;"; break;
                case '<': r = "&lt;"; break;
                case '>': r = "&gt;"; break;
                case '"': r = "&quot;"; break;
                case '\'': r = "&#39;"; break;
                default: r = null;
            }
            if (r != null) {
                if (sb == null) { sb = new StringBuilder(len + 24); sb.append(s, 0, i); }
                sb.append(r);
            } else if (sb != null) {
                sb.append(c);
            }
        }
        return sb != null ? sb.toString() : s;
    }
}