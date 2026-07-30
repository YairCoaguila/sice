package controller;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.qrcode.QRCodeWriter;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import dao.InscripcionDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Inscripcion;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.format.DateTimeFormatter;

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

        Color azul = new Color(30, 58, 95);
        Color azulOscuro = new Color(19, 37, 66);
        Color azulClaro = new Color(232, 237, 244);
        Color gris = new Color(55, 65, 81);
        Color grisClaro = new Color(107, 114, 128);
        Color dorado = new Color(184, 134, 11);

        Font fEscuela = new Font(Font.TIMES_ROMAN, 14, Font.BOLD, Color.WHITE);
        Font fEscuelaSub = new Font(Font.TIMES_ROMAN, 9, Font.ITALIC, new Color(187, 210, 254));
        Font fDocTit = new Font(Font.TIMES_ROMAN, 18, Font.BOLD, azulOscuro);
        Font fSubtitulo = new Font(Font.TIMES_ROMAN, 11, Font.ITALIC, grisClaro);
        Font fCodigo = new Font(Font.TIMES_ROMAN, 13, Font.BOLD, azul);
        Font fLabel = new Font(Font.HELVETICA, 8, Font.BOLD, grisClaro);
        Font fVal = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL, gris);
        Font fSecTit = new Font(Font.HELVETICA, 9, Font.BOLD, Color.WHITE);
        Font fFirma = new Font(Font.TIMES_ROMAN, 9, Font.BOLD, gris);
        Font fFirmaSub = new Font(Font.TIMES_ROMAN, 8, Font.NORMAL, grisClaro);
        Font fFooter = new Font(Font.HELVETICA, 7, Font.NORMAL, grisClaro);

        Document doc = new Document(PageSize.A4, 50, 50, 50, 50);
        try {
            PdfWriter.getInstance(doc, resp.getOutputStream());
            doc.open();

            PdfPTable hdr = new PdfPTable(2);
            hdr.setWidthPercentage(100);
            hdr.setWidths(new float[]{72, 28});
            PdfPCell hc = new PdfPCell();
            hc.setBackgroundColor(azul);
            hc.setBorder(Rectangle.NO_BORDER);
            hc.setPadding(16);
            hc.setHorizontalAlignment(Element.ALIGN_LEFT);
            hc.addElement(new Paragraph("I.E.P. SAN JOSÉ", fEscuela));
            hc.addElement(new Paragraph("Juliaca – Perú", fEscuelaSub));
            hc.addElement(new Paragraph("Sistema Integral de Calificación de Exámenes", new Font(Font.HELVETICA, 7, Font.NORMAL, new Color(180, 195, 220))));
            hdr.addCell(hc);

            PdfPCell hcQR = new PdfPCell();
            hcQR.setBackgroundColor(azul);
            hcQR.setBorder(Rectangle.NO_BORDER);
            hcQR.setHorizontalAlignment(Element.ALIGN_CENTER);
            hcQR.setVerticalAlignment(Element.ALIGN_MIDDLE);
            hcQR.setPadding(8);
            try {
                QRCodeWriter qrWriter = new QRCodeWriter();
                var bitMatrix = qrWriter.encode(i.getCodigoInscripcion(), BarcodeFormat.QR_CODE, 80, 80);
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                MatrixToImageWriter.writeToStream(bitMatrix, "PNG", baos);
                Image qrImage = Image.getInstance(baos.toByteArray());
                qrImage.setAlignment(Element.ALIGN_CENTER);
                hcQR.addElement(new Paragraph("CÓDIGO QR", new Font(Font.HELVETICA, 6, Font.NORMAL, new Color(187, 210, 254))));
                hcQR.addElement(qrImage);
            } catch (WriterException e) {
                hcQR.addElement(new Paragraph("[QR]", new Font(Font.HELVETICA, 10, Font.BOLD, Color.WHITE)));
            }
            hdr.addCell(hcQR);
            doc.add(hdr);

            Paragraph sep = new Paragraph("_______________________________________________________");
            sep.setAlignment(Element.ALIGN_CENTER);
            sep.setFont(new Font(Font.HELVETICA, 8, Font.NORMAL, dorado));
            sep.setSpacingBefore(14);
            sep.setSpacingAfter(6);
            doc.add(sep);

            Paragraph pt = new Paragraph("CONSTANCIA DE INSCRIPCIÓN", fDocTit);
            pt.setAlignment(Element.ALIGN_CENTER);
            pt.setSpacingAfter(2);
            doc.add(pt);

            Paragraph subTit = new Paragraph("La Dirección de Admisiones hace constar que:", fSubtitulo);
            subTit.setAlignment(Element.ALIGN_CENTER);
            subTit.setSpacingAfter(12);
            doc.add(subTit);

            PdfPTable codRow = new PdfPTable(2);
            codRow.setWidthPercentage(60);
            codRow.setHorizontalAlignment(Element.ALIGN_CENTER);
            codRow.setWidths(new float[]{35, 65});
            codRow.setSpacingBefore(4);
            PdfPCell codLabelCell = new PdfPCell(new Phrase("CÓDIGO DE INSCRIPCIÓN", fLabel));
            codLabelCell.setBackgroundColor(azulClaro);
            codLabelCell.setBorderColor(azul);
            codLabelCell.setPadding(7);
            codLabelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            codLabelCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            codRow.addCell(codLabelCell);
            PdfPCell codValCell = new PdfPCell(new Phrase(i.getCodigoInscripcion(), fCodigo));
            codValCell.setBackgroundColor(azulClaro);
            codValCell.setBorderColor(azul);
            codValCell.setBorderWidth(1.5f);
            codValCell.setPadding(7);
            codValCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            codValCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            codRow.addCell(codValCell);
            doc.add(codRow);
            doc.add(new Paragraph(" "));

            PdfPTable ta = new PdfPTable(new float[]{2f, 3f, 1.5f, 2.5f});
            ta.setWidthPercentage(100);
            addSecHeader(doc, "DATOS DEL ALUMNO", azul, fSecTit);
            addRow(ta, "Apellidos y Nombres:", nvl(i.getAlumnoNombre()), "DNI:", nvl(i.getAlumnoDni()), fLabel, fVal, azulClaro, Color.WHITE);
            addRow(ta, "Grado:", nvl(i.getGradoNombre()), "Sección:", nvl(i.getSeccionNombre()), fLabel, fVal, Color.WHITE, Color.WHITE);
            addRow(ta, "Carrera:", nvl(i.getCarreraNombre()), "Área:", nvl(i.getAreaNombre()), fLabel, fVal, azulClaro, azulClaro);
            doc.add(ta);
            doc.add(new Paragraph(" "));

            PdfPTable te = new PdfPTable(new float[]{2f, 3f, 1.5f, 2.5f});
            te.setWidthPercentage(100);
            addSecHeader(doc, "DATOS DEL EXAMEN", azul, fSecTit);
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            DateTimeFormatter df = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            String fi = i.getFechaInscripcion() != null ? i.getFechaInscripcion().format(dtf) : "-";
            String fe = i.getExamenFecha() != null ? i.getExamenFecha().format(df) : "-";
            addRow(te, "Examen:", nvl(i.getExamenNombre()), "Año:", String.valueOf(i.getAnio()), fLabel, fVal, azulClaro, Color.WHITE);
            addRow(te, "Periodo:", nvl(i.getPeriodo()), "Estado:", nvl(i.getEstado()), fLabel, fVal, Color.WHITE, Color.WHITE);
            addRow(te, "Fecha Inscripción:", fi, "Fecha Examen:", fe, fLabel, fVal, azulClaro, Color.WHITE);
            doc.add(te);

            doc.add(new Paragraph(" "));
            Paragraph sep2 = new Paragraph("_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _");
            sep2.setAlignment(Element.ALIGN_CENTER);
            sep2.setFont(new Font(Font.HELVETICA, 8, Font.NORMAL, dorado));
            sep2.setSpacingAfter(10);
            doc.add(sep2);

            PdfPTable ft = new PdfPTable(2);
            ft.setWidthPercentage(70);
            ft.setHorizontalAlignment(Element.ALIGN_CENTER);
            for (int x = 0; x < 2; x++) {
                PdfPCell fc = new PdfPCell();
                fc.setBorder(Rectangle.NO_BORDER);
                fc.setPadding(8);
                fc.setHorizontalAlignment(Element.ALIGN_CENTER);
                fc.addElement(new Paragraph("____________________________", new Font(Font.HELVETICA, 10, Font.NORMAL, grisClaro)));
                fc.addElement(new Paragraph("Firma y Sello Oficial", fFirma));
                fc.addElement(new Paragraph("Director(a) de Admisiones", fFirmaSub));
                ft.addCell(fc);
            }
            doc.add(ft);

            doc.add(new Paragraph(" "));

            PdfPTable footer = new PdfPTable(1);
            footer.setWidthPercentage(100);
            PdfPCell foCell = new PdfPCell();
            foCell.setBackgroundColor(azulClaro);
            foCell.setBorderColor(dorado);
            foCell.setBorderWidth(1f);
            foCell.setPadding(8);
            foCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            foCell.addElement(new Paragraph("Documento válido como constancia oficial de inscripción.",
                    new Font(Font.HELVETICA, 8, Font.BOLD, azulOscuro)));
            foCell.addElement(new Paragraph("Verifique la autenticidad escaneando el código QR.",
                    new Font(Font.HELVETICA, 7, Font.NORMAL, grisClaro)));
            foCell.addElement(new Paragraph("Generado por SICE | " + fi, fFooter));
            footer.addCell(foCell);
            doc.add(footer);

            doc.close();
        } catch (DocumentException e) {
            throw new IOException("Error PDF: " + e.getMessage(), e);
        }
    }

    private void addSecHeader(Document doc, String title, Color color, Font font) throws DocumentException {
        PdfPTable t = new PdfPTable(1);
        t.setWidthPercentage(100);
        PdfPCell c = new PdfPCell();
        c.setBackgroundColor(color);
        c.setBorder(Rectangle.NO_BORDER);
        c.setPadding(6);
        c.addElement(new Paragraph("  " + title, font));
        t.addCell(c);
        doc.add(t);
    }

    private void addRow(PdfPTable t, String l1, String v1, String l2, String v2,
                        Font fl, Font fv, Color bg1, Color bg2) {
        t.addCell(lCell(l1, fl, bg1));
        t.addCell(vCell(v1, fv, bg1));
        t.addCell(lCell(l2, fl, bg2));
        t.addCell(vCell(v2, fv, bg2));
    }

    private PdfPCell lCell(String t, Font f, Color bg) {
        PdfPCell c = new PdfPCell(new Phrase(t, f));
        c.setBackgroundColor(bg);
        c.setBorderColor(new Color(209, 213, 219));
        c.setPadding(5);
        return c;
    }

    private PdfPCell vCell(String t, Font f, Color bg) {
        PdfPCell c = new PdfPCell(new Phrase(t != null ? t : "-", f));
        c.setBackgroundColor(bg);
        c.setBorderColor(new Color(209, 213, 219));
        c.setPadding(5);
        return c;
    }

    private String nvl(String s) { return s != null ? s : "-"; }
}
