package controller;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.qrcode.QRCodeWriter;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import dao.InscripcionDAO;
import dao.ResultadoDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Alumno;
import model.Inscripcion;
import model.Resultado;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.format.DateTimeFormatter;

public class EstudianteDiplomaServlet extends HttpServlet {

    private final ResultadoDAO resultadoDAO = new ResultadoDAO();
    private final InscripcionDAO inscripcionDAO = new InscripcionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Alumno alumno = (Alumno) req.getSession().getAttribute("estudiante");
        if (alumno == null) {
            resp.sendRedirect(req.getContextPath() + "/estudiante/login");
            return;
        }

        String idExamenStr = req.getParameter("idExamen");
        if (idExamenStr == null) { resp.sendError(400); return; }

        int idExamen = Integer.parseInt(idExamenStr);

        Resultado resultado = resultadoDAO.buscarPorAlumnoYExamen(alumno.getId(), idExamen);
        if (resultado == null) { resp.sendError(404); return; }

        int rank = resultado.getRankingGeneral();
        if (rank < 1 || rank > 3) { resp.sendError(403, "No tienes un diploma disponible para este examen."); return; }

        Inscripcion insc = inscripcionDAO.buscarPorAlumnoYExamen(alumno.getId(), idExamen);
        String codigo = insc != null ? insc.getCodigoInscripcion() : ("DIP-" + alumno.getId() + "-" + idExamen);

        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "inline; filename=\"diploma-" + codigo + ".pdf\"");

        Color azulOscuro = new Color(19, 37, 66);
        Color azul = new Color(30, 58, 95);
        Color azulClaro = new Color(232, 237, 244);
        Color gris = new Color(75, 85, 99);
        Color dorado = new Color(184, 134, 11);

        String[] medallas = {"ORO", "PLATA", "BRONCE"};
        String[] romanos = {"I", "II", "III"};
        Color[] coloresMedalla = {new Color(212, 175, 55), new Color(192, 192, 192), new Color(205, 127, 50)};

        Font fTit = new Font(Font.TIMES_ROMAN, 24, Font.BOLD, azulOscuro);
        Font fMed = new Font(Font.TIMES_ROMAN, 11, Font.BOLD, coloresMedalla[rank - 1]);
        Font fNom = new Font(Font.TIMES_ROMAN, 18, Font.BOLD, azul);
        Font fBody = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL, gris);
        Font fFecha = new Font(Font.TIMES_ROMAN, 9, Font.ITALIC, gris);
        Font fFirma = new Font(Font.TIMES_ROMAN, 8, Font.BOLD, gris);
        Font fFooter = new Font(Font.HELVETICA, 7, Font.NORMAL, gris);

        Document doc = new Document(PageSize.A4.rotate(), 40, 40, 40, 40);
        try {
            PdfWriter.getInstance(doc, resp.getOutputStream());
            doc.open();

            PdfPTable top = new PdfPTable(3);
            top.setWidthPercentage(100);
            top.setWidths(new float[]{25, 50, 25});
            PdfPCell left = new PdfPCell();
            left.setBorder(Rectangle.NO_BORDER);
            left.setPadding(4);
            left.addElement(new Paragraph("I.E.P. SAN JOSÉ", new Font(Font.TIMES_ROMAN, 9, Font.BOLD, gris)));
            left.addElement(new Paragraph("Juliaca – Perú", new Font(Font.TIMES_ROMAN, 7, Font.NORMAL, gris)));
            top.addCell(left);
            PdfPCell mid = new PdfPCell();
            mid.setBorder(Rectangle.NO_BORDER);
            top.addCell(mid);
            PdfPCell right = new PdfPCell();
            right.setBorder(Rectangle.NO_BORDER);
            right.setHorizontalAlignment(Element.ALIGN_RIGHT);
            right.setPadding(4);
            try {
                QRCodeWriter qrWriter = new QRCodeWriter();
                var bitMatrix = qrWriter.encode(codigo, BarcodeFormat.QR_CODE, 55, 55);
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                MatrixToImageWriter.writeToStream(bitMatrix, "PNG", baos);
                Image qrImage = Image.getInstance(baos.toByteArray());
                qrImage.setAlignment(Element.ALIGN_RIGHT);
                right.addElement(new Paragraph("CÓDIGO QR", new Font(Font.HELVETICA, 6, Font.NORMAL, gris)));
                right.addElement(qrImage);
            } catch (WriterException e) {
                right.addElement(new Paragraph("[QR]", new Font(Font.HELVETICA, 10, Font.BOLD, gris)));
            }
            top.addCell(right);
            doc.add(top);

            doc.add(new Paragraph(" "));

            PdfPTable line = new PdfPTable(1);
            line.setWidthPercentage(60);
            line.setHorizontalAlignment(Element.ALIGN_CENTER);
            PdfPCell lc = new PdfPCell();
            lc.setBorderColor(dorado);
            lc.setBorderWidth(1.5f);
            lc.setFixedHeight(2);
            line.addCell(lc);
            doc.add(line);

            Paragraph titulo = new Paragraph("DIPLOMA DE HONOR", fTit);
            titulo.setAlignment(Element.ALIGN_CENTER);
            titulo.setSpacingBefore(8);
            titulo.setSpacingAfter(2);
            doc.add(titulo);

            Paragraph medalla = new Paragraph("M E D A L L A   D E   " + medallas[rank - 1], fMed);
            medalla.setAlignment(Element.ALIGN_CENTER);
            medalla.setSpacingAfter(10);
            doc.add(medalla);

            Paragraph otorga = new Paragraph("La Dirección de Admisiones otorga el presente diploma a:", fBody);
            otorga.setAlignment(Element.ALIGN_CENTER);
            otorga.setSpacingAfter(6);
            doc.add(otorga);

            Paragraph nombreAlumno = new Paragraph(alumno.getNombres() + " " + alumno.getApellidoPaterno() + " " + alumno.getApellidoMaterno(), fNom);
            nombreAlumno.setAlignment(Element.ALIGN_CENTER);
            nombreAlumno.setSpacingAfter(4);
            doc.add(nombreAlumno);

            Paragraph detalle = new Paragraph("Por haber obtenido el " + romanos[rank - 1] + "° puesto en el ranking general", fBody);
            detalle.setAlignment(Element.ALIGN_CENTER);
            detalle.setSpacingAfter(2);
            doc.add(detalle);

            Paragraph examen = new Paragraph(resultado.getExamenNombre(), fBody);
            examen.setAlignment(Element.ALIGN_CENTER);
            examen.setSpacingAfter(2);
            doc.add(examen);

            String fechaStr = resultado.getFechaRegistro() != null ?
                resultado.getFechaRegistro().format(DateTimeFormatter.ofPattern("dd 'de' MMMM 'de' yyyy")) : "";
            Paragraph fechaP = new Paragraph(fechaStr, fFecha);
            fechaP.setAlignment(Element.ALIGN_CENTER);
            fechaP.setSpacingAfter(10);
            doc.add(fechaP);

            PdfPTable line2 = new PdfPTable(1);
            line2.setWidthPercentage(60);
            line2.setHorizontalAlignment(Element.ALIGN_CENTER);
            PdfPCell lc2 = new PdfPCell();
            lc2.setBorderColor(dorado);
            lc2.setBorderWidth(1.5f);
            lc2.setFixedHeight(2);
            line2.addCell(lc2);
            doc.add(line2);

            doc.add(new Paragraph(" "));

            PdfPTable firma = new PdfPTable(3);
            firma.setWidthPercentage(70);
            firma.setHorizontalAlignment(Element.ALIGN_CENTER);
            for (String cargo : new String[]{"Director(a) de Admisiones", "", "Coordinador(a) Académico(a)"}) {
                PdfPCell fc = new PdfPCell();
                fc.setBorder(Rectangle.NO_BORDER);
                fc.setPadding(4);
                fc.setHorizontalAlignment(Element.ALIGN_CENTER);
                fc.addElement(new Paragraph("____________________________", new Font(Font.HELVETICA, 8, Font.NORMAL, gris)));
                fc.addElement(new Paragraph(" ", new Font(Font.HELVETICA, 2, Font.NORMAL, gris)));
                if (!cargo.isEmpty()) {
                    fc.addElement(new Paragraph(cargo, fFirma));
                }
                firma.addCell(fc);
            }
            doc.add(firma);

            PdfPTable footer = new PdfPTable(1);
            footer.setWidthPercentage(100);
            PdfPCell foCell = new PdfPCell();
            foCell.setBackgroundColor(azulClaro);
            foCell.setBorderColor(dorado);
            foCell.setBorderWidth(0.5f);
            foCell.setPadding(5);
            foCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            foCell.addElement(new Paragraph("Documento oficial emitido por SICE — I.E.P. San José — Juliaca", fFooter));
            foCell.addElement(new Paragraph("Código: " + codigo, new Font(Font.HELVETICA, 6, Font.NORMAL, new Color(156, 163, 175))));
            footer.addCell(foCell);
            doc.add(footer);

            doc.close();
        } catch (DocumentException e) {
            throw new IOException("Error PDF: " + e.getMessage(), e);
        }
    }
}
