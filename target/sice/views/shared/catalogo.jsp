<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,model.*,util.HtmlUtil" %>
<%
String ctx = request.getContextPath();
String entityType = (String) request.getAttribute("entityType");

String msg = (String) session.getAttribute("msg");
String err = (String) session.getAttribute("msgError");
session.removeAttribute("msg");
session.removeAttribute("msgError");

String entity = "";
String icon = "bi-list";
String path = "";
String cols = "";
List<?> items = null;

if (entityType != null) {
    switch (entityType) {
        case "grados":
            entity = "Grados"; icon = "bi-layers-fill"; path = "grados"; cols = "Nombre|Nivel|Participa";
            items = (List<Grado>) request.getAttribute("grados");
            break;
        case "secciones":
            entity = "Secciones"; icon = "bi-grid-3x3-gap-fill"; path = "secciones"; cols = "Nombre|Grado";
            items = (List<Seccion>) request.getAttribute("secciones");
            break;
        case "carreras":
            entity = "Carreras"; icon = "bi-building-fill"; path = "carreras"; cols = "Nombre|Área|Descripción";
            items = (List<Carrera>) request.getAttribute("carreras");
            break;
        case "areas":
            entity = "Áreas"; icon = "bi-bookmarks-fill"; path = "areas"; cols = "Nombre|Descripción";
            items = (List<Area>) request.getAttribute("areas");
            break;
        case "periodos":
            entity = "Periodos"; icon = "bi-calendar3"; path = "periodos"; cols = "Nombre|Año|Activo";
            items = (List<Periodo>) request.getAttribute("periodos");
            break;
    }
}

// Si items es null, asegurar que sea una lista vacía
if (items == null) {
    items = new ArrayList<>();
}

String[] colArr = cols.split("\\|");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title><%=entity%> | SICE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%=ctx%>/assets/css/main.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">
    <div class="sidebar-overlay" id="sidebarOverlay"></div>
    <jsp:include page="sidebar.jsp"/>
    <div class="main-content w-100">
        <jsp:include page="navbar.jsp"/>
        <div class="pt-2">
            <% if (msg != null) { %>
                <div class="alert alert-success alert-dismissible fade show mb-4">
                    <i class="bi bi-check-circle-fill me-2"></i><%=HtmlUtil.e(msg)%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            <% if (err != null) { %>
                <div class="alert alert-danger alert-dismissible fade show mb-4">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i><%=HtmlUtil.e(err)%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <div class="page-header">
                <div>
                    <h1 class="page-title">
                        <i class="bi <%=icon%> me-2 text-primary"></i><%=entity%>
                    </h1>
                    <p class="page-subtitle"><%=items.size()%> registros</p>
                </div>
                <% if (!path.equals("dashboard")) { %>
                    <a href="<%=ctx%>/app/<%=path%>?accion=nuevo" class="btn btn-primary">
                        <i class="bi bi-plus-lg me-1"></i>Nuevo
                    </a>
                <% } %>
            </div>
            
            <div class="table-wrapper">
                <% if (items == null || items.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi <%=icon%>"></i>
                        <p>No hay <%=entity.toLowerCase()%> registrados</p>
                        <% if (!path.equals("dashboard")) { %>
                            <a href="<%=ctx%>/app/<%=path%>?accion=nuevo" class="btn btn-primary btn-sm">Crear primero</a>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <% for (String col : colArr) { %>
                                        <th><%=col%></th>
                                    <% } %>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int n = 1; 
                                   for (Object item : items) {
                                       int itemId = 0;
                                       String[] vals = new String[]{};
                                       
                                        if (item instanceof Grado g2) {
                                           itemId = g2.getId();
                                           vals = new String[]{
                                               g2.getNombre(),
                                               String.valueOf(g2.getNivel()),
                                               g2.isParticipa() ? "<span class=\"text-success\"><i class='bi bi-check-circle-fill'></i> Sí</span>" : "<span class=\"text-danger\"><i class='bi bi-x-circle-fill'></i> No</span>"
                                           };
                                        } else if (item instanceof Seccion s2) {
                                           itemId = s2.getId();
                                           vals = new String[]{
                                               s2.getNombre(),
                                               s2.getGradoNombre() != null ? s2.getGradoNombre() : "—"
                                           };
                                        } else if (item instanceof Carrera c2) {
                                           itemId = c2.getId();
                                           vals = new String[]{
                                               c2.getNombre(),
                                               c2.getAreaNombre() != null ? c2.getAreaNombre() : "—",
                                               c2.getDescripcion() != null ? c2.getDescripcion() : "—"
                                           };
                                        } else if (item instanceof Area a2) {
                                           itemId = a2.getId();
                                           vals = new String[]{
                                               a2.getNombre(),
                                               a2.getDescripcion() != null ? a2.getDescripcion() : "—"
                                           };
                                        } else if (item instanceof Periodo p2) {
                                           itemId = p2.getId();
                                           vals = new String[]{
                                               p2.getNombre(),
                                               String.valueOf(p2.getAnio()),
                                               p2.isActivo() ? "<span class=\"text-success\"><i class='bi bi-check-circle-fill'></i> Activo</span>" : "<span class=\"text-danger\"><i class='bi bi-x-circle-fill'></i> Inactivo</span>"
                                           };
                                        }
                                %>
                                <tr>
                                    <td class="text-muted"><%=n++%></td>
                                    <% for (int ci = 0; ci < vals.length; ci++) {
                                        boolean isHtml = (ci == vals.length - 1) && ("periodos".equals(entityType) || "grados".equals(entityType));
                                    %>
                                        <td><%= isHtml ? vals[ci] : HtmlUtil.e(vals[ci]) %></td>
                                    <% } %>
                                    <td>
                                        <div class="d-flex gap-1">
                                            <a href="<%=ctx%>/app/<%=path%>?accion=editar&id=<%=itemId%>" 
                                               class="btn btn-sm btn-outline-primary btn-icon">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="<%=ctx%>/app/<%=path%>?accion=eliminar&id=<%=itemId%>" 
                                               class="btn btn-sm btn-outline-danger btn-icon" 
                                               data-confirm="¿Eliminar este registro?">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script>
</body>
</html>