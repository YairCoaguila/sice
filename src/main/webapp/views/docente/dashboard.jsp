<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Usuario, java.util.*, model.DocenteAula, model.Alumno, model.Resultado, model.Docente, model.ExamenAsignacion, util.HtmlUtil" %>
<%
Usuario cu = (Usuario) request.getAttribute("currentUser");
Docente docente = (Docente) request.getAttribute("docente");
List<DocenteAula> asignaciones = (List<DocenteAula>) request.getAttribute("asignaciones");
Map<String, Object> datosPorAsignacion = (Map<String, Object>) request.getAttribute("datosPorAsignacion");
String error = (String) request.getAttribute("error"); String mensaje = (String) request.getAttribute("mensaje");
String ctx = request.getContextPath();
String nombreDocente = docente != null ? docente.getApellidoPaterno() + " " + docente.getApellidoMaterno() + ", " + docente.getNombres() : (cu != null ? cu.getUsername() : "");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Panel Docente | San José</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= ctx %>/assets/css/main.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo"><i class="bi bi-shield-shaded"></i></div>
            <div>
                <div class="sidebar-subtitle" style="font-size:.65rem;letter-spacing:1px;text-transform:uppercase">I.E.P.</div>
                <div class="sidebar-title">SAN JOSÉ</div>
                <div class="sidebar-subtitle">Panel Docente</div>
            </div>
        </div>
        <nav class="sidebar-nav">
            <div class="nav-label">Principal</div>
            <a href="<%=ctx%>/docente/dashboard" class="nav-item active">
                <i class="bi bi-speedometer2"></i><span>Mi Panel</span>
            </a>
        </nav>
        <div class="sidebar-footer">
            <a href="<%=ctx%>/logout" class="nav-item" style="color:rgba(255,255,255,.7)">
                <i class="bi bi-box-arrow-right"></i><span>Cerrar Sesión</span>
            </a>
        </div>
    </aside>

    <div class="main-content w-100">
        <div id="topNavbar">
            <button class="btn d-lg-none" id="sidebarToggleMobile" style="background:transparent;border:none;font-size:1.3rem;color:var(--primary);padding:0">
                <i class="bi bi-list"></i>
            </button>
            <div class="brand-logo"><i class="bi bi-person-badge-fill"></i></div>
            <span class="brand-text">Panel Docente</span>
            <div class="ms-auto d-flex align-items-center gap-2">
                <button class="btn btn-sm" style="background:transparent;color:var(--primary);border:1px solid var(--border)" data-bs-toggle="modal" data-bs-target="#cambiarPasswordModal">
                    <i class="bi bi-key"></i> Cambiar contraseña
                </button>
                <span class="badge-rol badge-rol-docente"><i class="bi bi-person-circle"></i> <%= cu != null ? HtmlUtil.e(cu.getUsername()) : "" %></span>
            </div>
        </div>

        <div class="pt-2">
            <div class="page-header">
                <div>
                    <h1 class="page-title"><i class="bi bi-speedometer2 me-2"></i>Mi Panel</h1>
                    <p class="page-subtitle"><i class="bi bi-person-circle me-1"></i><%= HtmlUtil.e(nombreDocente) %></p>
                </div>
            </div>

            <% if (mensaje != null) { %>
                <div class="alert alert-success alert-dismissible fade show"><i class="bi bi-check-circle-fill me-2"></i><%= HtmlUtil.e(mensaje) %><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            <% } %>
            <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show"><i class="bi bi-exclamation-triangle-fill me-2"></i><%= HtmlUtil.e(error) %><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            <% } %>

            <% List<ExamenAsignacion> examenesAsignados = (List<ExamenAsignacion>) request.getAttribute("examenesAsignados"); boolean tieneAulas = asignaciones != null && !asignaciones.isEmpty(); boolean tieneExamenes = examenesAsignados!=null && !examenesAsignados.isEmpty(); if (tieneAulas) {
                for (DocenteAula da : asignaciones) {
                    String key = da.getId() + "|" + da.getGradoNombre() + "|" + da.getSeccionNombre() + "|" + da.getAnio() + "|" + da.getPeriodo();
                    List<Map<String, Object>> alumnosData = (List<Map<String, Object>>) datosPorAsignacion.get(key);
            %>
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-mortarboard-fill me-2"></i><%= HtmlUtil.e(da.getGradoNombre()) %> - <%= HtmlUtil.e(da.getSeccionNombre()) %></span>
                        <span class="badge bg-light text-dark"><%= da.getPeriodo() %> - <%= da.getAnio() %></span>
                    </div>
                    <div class="card-body p-0">
                        <% if (alumnosData == null || alumnosData.isEmpty()) { %>
                            <div class="p-4 text-center text-muted">No hay alumnos registrados en esta sección.</div>
                        <% } else { %>
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Alumno</th>
                                            <th>DNI</th>
                                            <th>Carrera</th>
                                            <th>Exámenes</th>
                                            <th>Promedio</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% int idx = 0; for (Map<String, Object> row : alumnosData) { idx++;
                                            Alumno a = (Alumno) row.get("alumno");
                                            List<Resultado> res = (List<Resultado>) row.get("resultados");
                                            int totalEx = (int) row.get("totalExamenes");
                                            double promedio = (double) row.get("promedio");
                                        %>
                                        <tr>
                                            <td><%= idx %></td>
                                            <td><strong><%= HtmlUtil.e(a.getApellidoPaterno()) %> <%= HtmlUtil.e(a.getApellidoMaterno()) %>, <%= HtmlUtil.e(a.getNombres()) %></strong></td>
                                            <td><%= HtmlUtil.e(a.getDni()) %></td>
                                            <td><%= a.getCarreraNombre() != null ? HtmlUtil.e(a.getCarreraNombre()) : "-" %></td>
                                            <td><span class="badge bg-primary"><%= totalEx %></span></td>
                                            <td>
                                                <% if (totalEx > 0) { %>
                                                    <span class="fw-bold" style="color:<%= promedio >= 70 ? "#059669" : promedio >= 50 ? "#d97706" : "#dc2626" %>">
                                                        <%= String.format("%.1f", promedio) %>%
                                                    </span>
                                                <% } else { %>
                                                    <span class="text-muted">--</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <% if (res != null && !res.isEmpty()) { %>
                                                    <button class="btn btn-sm btn-outline-primary" type="button" data-bs-toggle="collapse" data-bs-target="#detalle<%= da.getId() %>_<%= a.getId() %>">
                                                        <i class="bi bi-eye"></i> Ver resultados
                                                    </button>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <% if (res != null && !res.isEmpty()) { %>
                                        <tr class="collapse" id="detalle<%= da.getId() %>_<%= a.getId() %>">
                                            <td colspan="7" class="p-0">
                                                <div class="p-3" style="background:#f9fafb;">
                                                    <table class="table table-sm table-bordered mb-0" style="font-size:.8rem;">
                                                        <thead>
                                                            <tr>
                                                                <th>Examen</th>
                                                                <th>Puntaje</th>
                                                                <th>Correctas</th>
                                                                <th>Incorrectas</th>
                                                                <th>Blanco</th>
                                                                <th>%</th>
                                                                <th>Ranking</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for (Resultado r : res) { %>
                                                            <tr>
                                                                <td><%= r.getExamenNombre() != null ? HtmlUtil.e(r.getExamenNombre()) : "ID "+r.getIdExamen() %></td>
                                                                <td><%= String.format("%.2f", r.getPuntaje()) %></td>
                                                                <td style="color:#059669;"><%= r.getCorrectas() %></td>
                                                                <td style="color:#dc2626;"><%= r.getIncorrectas() %></td>
                                                                <td style="color:#6b7280;"><%= r.getEnBlanco() %></td>
                                                                <td><strong><%= String.format("%.1f", r.getPorcentaje()) %>%</strong></td>
                                                                <td>
                                                    <% int rg = r.getRankingGeneral(); %>
                                                    <%= rg > 0 ? "#"+rg+" Gral" : "N/A" %>
                                                                </td>
                                                            </tr>
                                                            <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <% } %>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } } %>

            <% if(tieneExamenes){ %>
                <div class="mt-4"><h5 class="mb-3"><i class="bi bi-file-earmark-text me-2"></i>Exámenes para supervisar</h5>
                <div class="row g-3"><% for(ExamenAsignacion ea:examenesAsignados){ %>
                    <div class="col-md-6"><div class="card"><div class="card-body d-flex align-items-center gap-3">
                        <div class="avatar-circle" style="width:40px;height:40px;background:var(--primary)"><i class="bi bi-file-earmark-text" style="color:#fff;font-size:1.2rem"></i></div>
                        <div><strong><%=HtmlUtil.e(ea.getExamenNombre())%></strong><br><small class="text-muted"><%=HtmlUtil.e(ea.getAulaCodigo())%> • <%=ea.getExamenPeriodo()%> <%=ea.getExamenAnio()%></small></div>
                    </div></div></div>
                <% } %></div></div>
            <% } %>
            <% if(!tieneAulas && !tieneExamenes){ %>
                <div class="empty-state"><i class="bi bi-person-x"></i><h5>Sin asignaciones</h5><p class="text-muted">Aún no te han asignado exámenes para supervisar. Contacta al administrador.</p></div>
            <% } %>
        </div>
    </div>
</div>

<!-- Modal Cambiar Contraseña -->
<div class="modal fade" id="cambiarPasswordModal" tabindex="-1">
    <div class="modal-dialog modal-sm modal-dialog-centered">
        <div class="modal-content">
            <form action="<%=ctx%>/docente/dashboard" method="post">
                <input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
                <div class="modal-header" style="background:var(--primary);color:white">
                    <h6 class="modal-title"><i class="bi bi-key me-2"></i>Cambiar contraseña</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="accion" value="cambiarPassword">
                    <div class="mb-3">
                        <label class="form-label">Nueva contraseña</label>
                        <input type="password" name="nuevaPassword" class="form-control" required minlength="6">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Confirmar contraseña</label>
                        <input type="password" name="confirmarPassword" class="form-control" required minlength="6">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-sm btn-primary">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= ctx %>/assets/js/main.js"></script>
</body>
</html>
