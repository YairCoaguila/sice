<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*" %>
<% List<Inscripcion> insc=(List<Inscripcion>)request.getAttribute("inscripciones"); String ctx=request.getContextPath(); String msg=(String)session.getAttribute("msg"); String err=(String)session.getAttribute("msgError"); session.removeAttribute("msg");session.removeAttribute("msgError"); if(insc==null)insc=new ArrayList<>(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Inscripciones | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<%if(msg!=null){%><div class="alert alert-success alert-dismissible fade show mb-4"><i class="bi bi-check-circle-fill me-2"></i><%=msg%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<%if(err!=null){%><div class="alert alert-danger alert-dismissible fade show mb-4"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=err%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<div class="page-header"><div><h1 class="page-title"><i class="bi bi-pencil-square me-2 text-primary"></i>Inscripciones</h1><p class="page-subtitle"><%=insc.size()%> registros</p></div>
<a href="<%=ctx%>/app/inscripciones?accion=nuevo" class="btn btn-primary"><i class="bi bi-plus-lg me-1"></i>Nueva Inscripción</a></div>
<div class="table-wrapper">
<%if(insc.isEmpty()){%><div class="empty-state"><i class="bi bi-pencil-square"></i><p>No hay inscripciones registradas</p><a href="<%=ctx%>/app/inscripciones?accion=nuevo" class="btn btn-primary btn-sm">Inscribir alumno</a></div>
<%}else{%><div class="table-responsive"><table class="table table-hover">
<thead><tr><th>Código</th><th>Alumno</th><th>Examen</th><th>Carrera</th><th>Grado / Sec</th><th>Periodo</th><th>Estado</th><th>Acciones</th></tr></thead>
<tbody><%for(Inscripcion i:insc){%><tr>
<td><code class="text-primary fw-bold"><%=i.getCodigoInscripcion()%></code></td>
<td><div class="fw-semibold" style="font-size:.875rem"><%=i.getAlumnoNombre()!=null?i.getAlumnoNombre():"—"%></div><small class="text-muted"><%=i.getAlumnoDni()!=null?i.getAlumnoDni():""%></small></td>
<td><small><%=i.getExamenNombre()!=null?i.getExamenNombre():"—"%></small></td>
<td><small><%=i.getCarreraNombre()!=null?i.getCarreraNombre():"—"%></small></td>
<td><small><%=i.getGradoNombre()!=null?i.getGradoNombre():"—"%> · <%=i.getSeccionNombre()!=null?i.getSeccionNombre():"—"%></small></td>
<td><small><%=i.getPeriodo()%> · <%=i.getAnio()%></small></td>
<td><span class="badge-<%=i.getEstado()!=null?i.getEstado().toLowerCase():"activo"%>"><%=i.getEstado()!=null?i.getEstado():"ACTIVO"%></span></td>
<td><div class="d-flex gap-1">
<a href="<%=ctx%>/app/inscripciones?accion=detalle&id=<%=i.getId()%>" class="btn btn-sm btn-outline-primary btn-icon" title="Detalle"><i class="bi bi-eye"></i></a>
<a href="<%=ctx%>/app/constancia-pdf?id=<%=i.getId()%>" class="btn btn-sm btn-outline-danger btn-icon" title="PDF" target="_blank"><i class="bi bi-file-earmark-pdf"></i></a>
<%if(!"CANCELADO".equals(i.getEstado())){%><a href="<%=ctx%>/app/inscripciones?accion=cancelar&id=<%=i.getId()%>" class="btn btn-sm btn-outline-warning btn-icon" data-confirm="¿Cancelar inscripción <%=i.getCodigoInscripcion()%>?"><i class="bi bi-x-circle"></i></a><%}%>
</div></td></tr><%}%></tbody></table></div><%}%></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
