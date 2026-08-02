package controller;

import dao.InscripcionDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Inscripcion;
import util.ConstanciaPDF;
import java.io.IOException;

public class PDFConstanciaServlet extends HttpServlet {

    private final InscripcionDAO dao = new InscripcionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        if (idStr == null) { resp.sendError(400); return; }

        Inscripcion i = dao.buscarPorId(Integer.parseInt(idStr));
        if (i == null) { resp.sendError(404); return; }

        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition",
                "inline; filename=\"constancia-" + i.getCodigoInscripcion() + ".pdf\"");

        ConstanciaPDF.generar(resp.getOutputStream(), i);
    }
}
