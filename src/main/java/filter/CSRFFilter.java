package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.CSRFToken;
import java.io.IOException;

public class CSRFFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            if (!CSRFToken.validate(request)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF token inválido");
                return;
            }
        } else {
            CSRFToken.getToken(request.getSession());
        }
        chain.doFilter(req, res);
    }
}