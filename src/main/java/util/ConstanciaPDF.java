package util;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.qrcode.QRCodeWriter;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import model.Inscripcion;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.time.format.DateTimeFormatter;

/**
 * Generador de constancia de preinscripción virtual con formato universitario formal.
 */
public class ConstanciaPDF {

    private ConstanciaPDF() {}

    private static final float MARGIN = 56f;

    public static void generar(OutputStream out, Inscripcion i) throws IOException {
        DateTimeFormatter df = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String fechahoy = java.time.LocalDate.now().format(df);
        String fi = i.getFechaInscripcion() != null
                ? i.getFechaInscripcion().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))
                : fechahoy;

        Font fUniversidad = new Font(Font.HELVETICA, 15, Font.BOLD, Color.BLACK);
        Font fUniversidadSub = new Font(Font.HELVETICA, 9, Font.NORMAL, new Color(90, 90, 90));
        Font fComision = new Font(Font.HELVETICA, 11, Font.BOLD, Color.BLACK);
        Font fTitulo = new Font(Font.HELVETICA, 15, Font.BOLD, Color.BLACK);
        Font fSub = new Font(Font.HELVETICA, 11, Font.NORMAL, new Color(80, 80, 80));
        Font fCuerpo = new Font(Font.HELVETICA, 10.5f, Font.NORMAL, Color.BLACK);
        Font fCuerpoBold = new Font(Font.HELVETICA, 10.5f, Font.BOLD, Color.BLACK);
        Font fNombre = new Font(Font.HELVETICA, 14, Font.BOLD, Color.BLACK);
        Font fDatosTit = new Font(Font.HELVETICA, 11, Font.BOLD, Color.BLACK);
        Font fLabel = new Font(Font.HELVETICA, 10.5f, Font.BOLD, Color.BLACK);
        Font fVal = new Font(Font.HELVETICA, 10.5f, Font.NORMAL, Color.BLACK);
        Font fFirma = new Font(Font.HELVETICA, 10, Font.BOLD, Color.BLACK);
        Font fFirmaSub = new Font(Font.HELVETICA, 9, Font.NORMAL, new Color(90, 90, 90));
        Font fQrText = new Font(Font.HELVETICA, 7, Font.NORMAL, new Color(90, 90, 90));

        Document doc = new Document(PageSize.A4, MARGIN, MARGIN, MARGIN, MARGIN);
        try {
            PdfWriter writer = PdfWriter.getInstance(doc, out);
            doc.open();

            // ── Encabezado: institución al centro, escudo arriba derecha ──
            PdfPTable hdr = new PdfPTable(3);
            hdr.setWidthPercentage(100);
            hdr.setWidths(new float[]{1f, 2.2f, 1f});
            hdr.setHorizontalAlignment(Element.ALIGN_CENTER);

            PdfPCell cLeft = new PdfPCell();
            cLeft.setBorder(Rectangle.NO_BORDER);
            hdr.addCell(cLeft);

            PdfPCell cCenter = new PdfPCell();
            cCenter.setBorder(Rectangle.NO_BORDER);
            cCenter.setHorizontalAlignment(Element.ALIGN_CENTER);
            cCenter.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cCenter.addElement(new Paragraph("I.E.P. SAN JOSÉ", fUniversidad));
            cCenter.addElement(new Paragraph("JULIACA – PERÚ", fUniversidadSub));
            hdr.addCell(cCenter);

            PdfPCell cLogo = new PdfPCell();
            cLogo.setBorder(Rectangle.NO_BORDER);
            cLogo.setHorizontalAlignment(Element.ALIGN_CENTER);
            cLogo.setVerticalAlignment(Element.ALIGN_MIDDLE);
            Image escudo = escudoImagen(writer, 34, 44);
            if (escudo != null) {
                escudo.setAlignment(Element.ALIGN_CENTER);
                cLogo.addElement(escudo);
            }
            cLogo.addElement(new Paragraph("SAN JOSÉ", new Font(Font.HELVETICA, 7, Font.BOLD, Color.BLACK)));
            hdr.addCell(cLogo);

            doc.add(hdr);
            doc.add(new Paragraph(" ", fCuerpo));

            // ── Comisión ──
            Paragraph comision = new Paragraph("COMISIÓN DE ADMISIÓN", fComision);
            comision.setAlignment(Element.ALIGN_CENTER);
            comision.setSpacingAfter(4);
            doc.add(comision);

            PdfPTable linea = new PdfPTable(1);
            linea.setWidthPercentage(100);
            PdfPCell lc = new PdfPCell();
            lc.setBorder(Rectangle.BOTTOM);
            lc.setBorderWidth(0.7f);
            lc.setBorderColor(Color.BLACK);
            lc.setFixedHeight(6f);
            lc.setPadding(0);
            linea.addCell(lc);
            doc.add(linea);

            // ── Título principal ──
            Paragraph titulo = new Paragraph("CONSTANCIA DE PREINSCRIPCIÓN VIRTUAL", fTitulo);
            titulo.setAlignment(Element.ALIGN_CENTER);
            titulo.setSpacingBefore(18);
            titulo.setSpacingAfter(2);
            doc.add(titulo);

            Paragraph sub = new Paragraph(
                    "Simulacro de Admisión " + i.getAnio() + " – " + nvl(i.getPeriodo()) + " | " + nvl(i.getExamenNombre()),
                    fSub);
            sub.setAlignment(Element.ALIGN_CENTER);
            sub.setSpacingAfter(22);
            doc.add(sub);

            // ── Introducción ──
            Paragraph intro = new Paragraph(
                    "La Comisión de Admisión de la I.E.P. San José hace constar que el(la) postulante:", fCuerpo);
            intro.setAlignment(Element.ALIGN_LEFT);
            intro.setSpacingAfter(16);
            doc.add(intro);

            // ── Nombre en recuadro ──
            PdfPTable nameBox = new PdfPTable(1);
            nameBox.setWidthPercentage(70);
            nameBox.setHorizontalAlignment(Element.ALIGN_CENTER);
            PdfPCell nbc = new PdfPCell(new Phrase(nvl(i.getAlumnoNombre()), fNombre));
            nbc.setBorder(Rectangle.BOX);
            nbc.setBorderWidth(1f);
            nbc.setBorderColor(Color.BLACK);
            nbc.setPadding(12);
            nbc.setHorizontalAlignment(Element.ALIGN_CENTER);
            nbc.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nameBox.addCell(nbc);
            doc.add(nameBox);
            doc.add(new Paragraph(" ", fCuerpo));

            // ── DATOS PERSONALES ──
            Paragraph datosTit = new Paragraph("DATOS PERSONALES", fDatosTit);
            datosTit.setSpacingAfter(8);
            doc.add(datosTit);

            PdfPTable datos = new PdfPTable(2);
            datos.setWidthPercentage(90);
            datos.setHorizontalAlignment(Element.ALIGN_CENTER);
            datos.setWidths(new float[]{2.4f, 3.2f});
            addDato(datos, "Apellidos y Nombres:", nvl(i.getAlumnoNombre()), fLabel, fVal);
            addDato(datos, "DNI:", nvl(i.getAlumnoDni()), fLabel, fVal);
            addDato(datos, "Grado:", nvl(i.getGradoNombre()), fLabel, fVal);
            addDato(datos, "Sección:", nvl(i.getSeccionNombre()), fLabel, fVal);
            addDato(datos, "Carrera de interés:", nvl(i.getCarreraNombre()), fLabel, fVal);
            addDato(datos, "Área:", nvl(i.getAreaNombre()), fLabel, fVal);
            addDato(datos, "Código de inscripción:", nvl(i.getCodigoInscripcion()), fLabel, fVal);
            addDato(datos, "Fecha de inscripción:", fi, fLabel, fVal);
            doc.add(datos);
            doc.add(new Paragraph(" ", fCuerpo));

            // ── Párrafos explicativos ──
            String fechaEx = i.getExamenFecha() != null ? i.getExamenFecha().format(df) : "por definir";
            Paragraph p1 = new Paragraph(
                    "El(la) postulante ha realizado su preinscripción virtual al "
                    + nvl(i.getExamenNombre()) + " programado para el día " + fechaEx
                    + ". Su participación queda registrada en el sistema oficial de la institución.", fCuerpo);
            p1.setAlignment(Element.ALIGN_JUSTIFIED);
            p1.setSpacingAfter(10);
            doc.add(p1);

            Paragraph p2 = new Paragraph(
                    "Se recomienda presentarse con 20 minutos de anticipación en el aula asignada, portando su DNI y esta "
                    + "constancia impresa. Cualquier duda, comunicarse con la Comisión de Admisión.", fCuerpo);
            p2.setAlignment(Element.ALIGN_JUSTIFIED);
            p2.setSpacingAfter(18);
            doc.add(p2);

            // ── NOTA ──
            Paragraph nota = new Paragraph();
            nota.add(new Chunk("NOTA: ", fCuerpoBold));
            nota.add(new Chunk(
                    "La presente constancia es un comprobante de preinscripción virtual y no sustituye al certificado oficial "
                    + "de admisión. Verifique su autenticidad escaneando el código QR ubicado en la parte inferior izquierda.",
                    fCuerpo));
            nota.setAlignment(Element.ALIGN_JUSTIFIED);
            nota.setSpacingAfter(50);
            doc.add(nota);

            // ── Parte inferior: QR izquierda, fecha y firma derecha ──
            PdfPTable abajo = new PdfPTable(2);
            abajo.setWidthPercentage(100);
            abajo.setWidths(new float[]{1f, 1f});

            PdfPCell cQR = new PdfPCell();
            cQR.setBorder(Rectangle.NO_BORDER);
            cQR.setHorizontalAlignment(Element.ALIGN_LEFT);
            cQR.setVerticalAlignment(Element.ALIGN_BOTTOM);
            try {
                QRCodeWriter qrWriter = new QRCodeWriter();
                var bitMatrix = qrWriter.encode("SICE|" + nvl(i.getCodigoInscripcion()), BarcodeFormat.QR_CODE, 60, 60);
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                MatrixToImageWriter.writeToStream(bitMatrix, "PNG", baos);
                Image qrImage = Image.getInstance(baos.toByteArray());
                qrImage.scaleToFit(72, 72);
                qrImage.setAlignment(Element.ALIGN_LEFT);

                PdfPTable qrBox = new PdfPTable(1);
                qrBox.setWidthPercentage(42);
                qrBox.setHorizontalAlignment(Element.ALIGN_LEFT);
                PdfPCell qbc = new PdfPCell(qrImage);
                qbc.setBorder(Rectangle.BOX);
                qbc.setBorderWidth(0.7f);
                qbc.setBorderColor(Color.BLACK);
                qbc.setPadding(3);
                qbc.setHorizontalAlignment(Element.ALIGN_CENTER);
                qrBox.addCell(qbc);
                cQR.addElement(qrBox);
                cQR.addElement(new Paragraph("Verifique la autenticidad", fQrText));
            } catch (WriterException e) {
                cQR.addElement(new Paragraph("[QR]", fQrText));
            }
            abajo.addCell(cQR);

            PdfPCell cFirma = new PdfPCell();
            cFirma.setBorder(Rectangle.NO_BORDER);
            cFirma.setHorizontalAlignment(Element.ALIGN_CENTER);
            cFirma.setVerticalAlignment(Element.ALIGN_BOTTOM);
            cFirma.addElement(new Paragraph("Juliaca, " + fechahoy, fCuerpo));
            cFirma.addElement(new Paragraph("____________________________",
                    new Font(Font.HELVETICA, 10, Font.NORMAL, new Color(90, 90, 90))));
            cFirma.addElement(new Paragraph("COMISIÓN DE ADMISIÓN", fFirma));
            cFirma.addElement(new Paragraph("I.E.P. San José – Juliaca", fFirmaSub));
            abajo.addCell(cFirma);

            doc.add(abajo);

            doc.close();
        } catch (DocumentException e) {
            throw new IOException("Error PDF: " + e.getMessage(), e);
        }
    }

    private static void addDato(PdfPTable t, String label, String val, Font fl, Font fv) {
        PdfPCell lc = new PdfPCell(new Phrase(label, fl));
        lc.setBorder(Rectangle.NO_BORDER);
        lc.setPadding(4);
        PdfPCell vc = new PdfPCell(new Phrase(val != null ? val : "-", fv));
        vc.setBorder(Rectangle.BOTTOM);
        vc.setBorderWidth(0.4f);
        vc.setBorderColor(new Color(210, 210, 210));
        vc.setPadding(4);
        t.addCell(lc);
        t.addCell(vc);
    }

    private static Image escudoImagen(PdfWriter writer, float w, float h) {
        try {
            PdfTemplate tpl = writer.getDirectContent().createTemplate(w, h);
            tpl.setLineWidth(1.2f);
            tpl.setColorStroke(Color.BLACK);
            tpl.setColorFill(Color.WHITE);
            tpl.moveTo(0.15f * w, 0.9f * h);
            tpl.lineTo(0.85f * w, 0.9f * h);
            tpl.lineTo(0.85f * w, 0.35f * h);
            tpl.lineTo(0.5f * w, 0.05f * h);
            tpl.lineTo(0.15f * w, 0.35f * h);
            tpl.closePath();
            tpl.fillStroke();

            tpl.setLineWidth(0.8f);
            tpl.moveTo(0.2f * w, 0.62f * h);
            tpl.lineTo(0.8f * w, 0.62f * h);
            tpl.stroke();

            BaseFont bf = BaseFont.createFont(BaseFont.HELVETICA_BOLD, BaseFont.WINANSI, BaseFont.NOT_EMBEDDED);
            tpl.beginText();
            tpl.setFontAndSize(bf, 6);
            tpl.setColorFill(Color.BLACK);
            tpl.setTextMatrix(0.4f * w, 0.7f * h);
            tpl.showText("SJ");
            tpl.endText();

            return Image.getInstance(tpl);
        } catch (Exception e) {
            return null;
        }
    }

    private static String nvl(String s) { return s != null ? s : "-"; }
}
