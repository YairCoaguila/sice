package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

public class CSRFToken {
    private static final String SESSION_KEY = "_csrf";
    private static final SecureRandom rng = new SecureRandom();

    public static String getToken(HttpSession session) {
        String token = (String) session.getAttribute(SESSION_KEY);
        if (token == null) {
            byte[] b = new byte[24];
            rng.nextBytes(b);
            token = Base64.getEncoder().encodeToString(b);
            session.setAttribute(SESSION_KEY, token);
        }
        return token;
    }

    public static boolean validate(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;
        String expected = (String) session.getAttribute(SESSION_KEY);
        if (expected == null) return false;
        String actual = req.getParameter("_csrf");
        return expected.equals(actual);
    }
}