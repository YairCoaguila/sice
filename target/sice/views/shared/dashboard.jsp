<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,model.*,util.HtmlUtil" %>
<%
Map<String,Object> stats = (Map<String,Object>) request.getAttribute("stats");
List<Map<String,Object>> top10 = (List<Map<String,Object>>) request.getAttribute("top10");
List<Map<String,Object>> porCarrera = (List<Map<String,Object>>) request.getAttribute("porCarrera");
List<Map<String,Object>> porGrado = (List<Map<String,Object>>) request.getAttribute("porGrado");
if (stats == null) stats = new HashMap<>();
String ctx = request.getContextPath();
String msg = (String) session.getAttribute("msg");
String msgErr = (String) session.getAttribute("msgError");
session.removeAttribute("msg");
session.removeAttribute("msgError");
Usuario cu = (Usuario) request.getAttribute("currentUser");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard | San José</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= ctx %>/assets/css/main.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">
    <div class="sidebar-overlay" id="sidebarOverlay"></div>
    <jsp:include page="sidebar.jsp"/>
    <div class="main-content w-100">
        <jsp:include page="navbar.jsp"/>

        <div class="pt-2">
            <div class="page-header">
                <div>
                    <h1 class="page-title">
                        <i class="bi bi-speedometer2 me-2"></i>Dashboard
                    </h1>
                    <p class="page-subtitle">Resumen del Sistema de Simulacros</p>
                </div>
                <% if (cu != null) { %>
                <a href="<%= ctx %>/app/inscripciones?accion=nuevo" class="btn btn-primary">
                    <i class="bi bi-pencil-square me-1"></i>Nueva Inscripción
                </a>
                <% } %>
            </div>

            <% if (cu != null) { %>
            <div class="d-flex align-items-center justify-content-between bg-light p-3 rounded mb-4 border" style="border-color:var(--primary-light)!important;">
                <div>
                    <strong><i class="bi bi-person-circle me-2" style="color:var(--primary)"></i><%= HtmlUtil.e(cu.getUsername()) %></strong>
                    <small class="text-muted ms-2">
                        <i class="bi bi-shield-fill me-1"></i>
                        <%= HtmlUtil.e(cu.getRol().substring(0,1).toUpperCase() + cu.getRol().substring(1)) %>
                        &nbsp;|&nbsp; Colegio San José · Juliaca
                    </small>
                </div>
            </div>
            <% } %>

            <% if (msg != null) { %>
                <div class="alert alert-success alert-dismissible fade show mb-4">
                    <i class="bi bi-check-circle-fill me-2"></i><%= HtmlUtil.e(msg) %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            <% if (msgErr != null) { %>
                <div class="alert alert-danger alert-dismissible fade show mb-4">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i><%= HtmlUtil.e(msgErr) %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-people-fill"></i></div>
                        <div>
                            <div class="stat-value"><%= stats.getOrDefault("totalAlumnos", 0) %></div>
                            <div class="stat-label">Total Alumnos</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-person-badge-fill"></i></div>
                        <div>
                            <div class="stat-value"><%= stats.getOrDefault("totalDocentes", 0) %></div>
                            <div class="stat-label">Total Docentes</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-file-earmark-text-fill"></i></div>
                        <div>
                            <div class="stat-value"><%= stats.getOrDefault("totalExamenes", 0) %></div>
                            <div class="stat-label">Total Exámenes</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-pencil-square"></i></div>
                        <div>
                            <div class="stat-value"><%= stats.getOrDefault("totalInscritos", 0) %></div>
                            <div class="stat-label">Total Inscritos</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <div class="card h-100"><div class="card-body d-flex align-items-center gap-3">
                        <div class="stat-icon"><i class="bi bi-trophy-fill"></i></div>
                        <div>
                            <div class="stat-label">Mejor Sección</div>
                            <div class="fw-bold fs-4" style="color:var(--primary)"><%= HtmlUtil.e(String.valueOf(stats.getOrDefault("mejorSeccion", "—"))) %></div>
                        </div>
                    </div></div>
                </div>
                <div class="col-md-6">
                    <div class="card h-100"><div class="card-body d-flex align-items-center gap-3">
                        <div class="stat-icon"><i class="bi bi-building-fill"></i></div>
                        <div>
                            <div class="stat-label">Mejor Carrera</div>
                            <div class="fw-bold fs-4" style="color:var(--primary)"><%= HtmlUtil.e(String.valueOf(stats.getOrDefault("mejorCarrera", "—"))) %></div>
                        </div>
                    </div></div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-lg-7">
                    <div class="card">
                        <div class="card-header"><i class="bi bi-trophy-fill"></i> Top 10 Alumnos</div>
                        <% if (top10 == null || top10.isEmpty()) { %>
                            <div class="empty-state">
                                <i class="bi bi-bar-chart"></i>
                                <p>Sin resultados aún</p>
                            </div>
                        <% } else { %>
                            <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Pos</th>
                                        <th>Alumno</th>
                                        <th>Carrera</th>
                                        <th>Puntaje</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% int rk = 1; for (Map<String,Object> row : top10) { %>
                                    <tr>
                                        <td>
                                            <% if (rk == 1) { %>
                                                <i class="bi bi-trophy-fill medal-gold fs-5"></i>
                                            <% } else if (rk == 2) { %>
                                                <i class="bi bi-trophy-fill medal-silver fs-5"></i>
                                            <% } else if (rk == 3) { %>
                                                <i class="bi bi-trophy-fill medal-bronze fs-5"></i>
                                            <% } else { %>
                                                <span class="text-muted fw-bold"><%= rk %></span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <strong><%= HtmlUtil.e((String)row.get("nombre")) %></strong><br>
                                            <small class="text-muted"><%= HtmlUtil.e((String)row.get("seccion")) %></small>
                                        </td>
                                        <td><small><%= HtmlUtil.e((String)row.get("carrera")) %></small></td>
                                        <td><span class="badge bg-primary fs-6 px-3"><%= row.get("puntaje") %></span></td>
                                    </tr>
                                <% rk++; } %>
                                </tbody>
                            </table>
                            </div>
                        <% } %>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="card mb-3">
                        <div class="card-header"><i class="bi bi-pie-chart-fill"></i> Inscritos por Carrera</div>
                        <% if (porCarrera == null || porCarrera.isEmpty()) { %>
                            <div class="empty-state py-4">
                                <i class="bi bi-people"></i>
                                <p>Sin datos</p>
                            </div>
                        <% } else { %>
                            <table class="table mb-0">
                                <tbody>
                                <% for (Map<String,Object> row : porCarrera) { %>
                                    <tr>
                                        <td><%= HtmlUtil.e(String.valueOf(row.get("carrera"))) %></td>
                                        <td class="text-end"><span class="badge bg-primary"><%= row.get("total") %></span></td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>

                    <div class="card">
                        <div class="card-header"><i class="bi bi-layers-fill"></i> Inscritos por Grado</div>
                        <% if (porGrado == null || porGrado.isEmpty()) { %>
                            <div class="empty-state py-4">
                                <i class="bi bi-people"></i>
                                <p>Sin datos</p>
                            </div>
                        <% } else { %>
                            <table class="table mb-0">
                                <tbody>
                                <% for (Map<String,Object> row : porGrado) { %>
                                    <tr>
                                        <td><%= HtmlUtil.e(String.valueOf(row.get("grado"))) %></td>
                                        <td class="text-end"><span class="badge bg-primary"><%= row.get("total") %></span></td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= ctx %>/assets/js/main.js"></script>
</body>
</html>
