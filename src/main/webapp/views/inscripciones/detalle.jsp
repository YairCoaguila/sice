<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="model.Inscripcion,java.time.format.DateTimeFormatter" %>
<% Inscripcion i=(Inscripcion)request.getAttribute("inscripcion"); String ctx=request.getContextPath(); String msg=(String)session.getAttribute("msg"); session.removeAttribute("msg"); DateTimeFormatter dtf=DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"); DateTimeFormatter df=DateTimeFormatter.ofPattern("dd/MM/yyyy"); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Detalle Inscripción | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<%if(msg!=null){%><div class="alert alert-success alert-dismissible fade show mb-4"><i class="bi bi-check-circle-fill me-2"></i><%=msg%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/inscripciones">Inscripciones</a></li><li class="breadcrumb-item active">Detalle</li></ol></nav>
<div class="page-header"><div><h1 class="page-title"><i class="bi bi-card-checklist me-2 text-primary"></i>Detalle de Inscripción</h1><%if(i!=null){%><p class="page-subtitle">Código: <strong class="text-primary"><%=i.getCodigoInscripcion()%></strong></p><%}%></div>
<%if(i!=null){%><div class="d-flex gap-2"><a href="<%=ctx%>/app/constancia-pdf?id=<%=i.getId()%>" class="btn btn-danger" target="_blank"><i class="bi bi-file-earmark-pdf-fill me-1"></i>Descargar Constancia PDF</a><a href="<%=ctx%>/app/inscripciones" class="btn btn-outline-secondary"><i class="bi bi-arrow-left me-1"></i>Volver</a></div><%}%></div>
<%if(i==null){%><div class="alert alert-warning">Inscripción no encontrada.</div>
<%}else{%>
<div class="card mb-4" style="border-left:4px solid #1e3a5f;background:#e8edf4"><div class="card-body d-flex align-items-center gap-3">
<div style="width:48px;height:48px;background:#e8edf4;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:22px;color:#1e3a5f"><i class="bi bi-check-circle-fill"></i></div>
<div><div class="fw-bold" style="color:#1e3a5f">¡Inscripción exitosa!</div><div style="font-size:.875rem;color:#132542">Código: <strong><%=i.getCodigoInscripcion()%></strong> — Descarga la constancia PDF usando el botón superior.</div></div></div></div>
<div class="row g-4">
<div class="col-md-6"><div class="card h-100"><div class="card-header"><i class="bi bi-person-fill me-2 text-primary"></i>Datos del Alumno</div><div class="card-body">
<table class="table table-sm mb-0">
<tr><th class="text-muted" style="width:42%">Nombre</th><td><strong><%=i.getAlumnoNombre()!=null?i.getAlumnoNombre():"—"%></strong></td></tr>
<tr><th class="text-muted">DNI</th><td><code><%=i.getAlumnoDni()!=null?i.getAlumnoDni():"—"%></code></td></tr>
<tr><th class="text-muted">Grado</th><td><%=i.getGradoNombre()!=null?i.getGradoNombre():"—"%></td></tr>
<tr><th class="text-muted">Sección</th><td><%=i.getSeccionNombre()!=null?i.getSeccionNombre():"—"%></td></tr>
<tr><th class="text-muted">Carrera</th><td><%=i.getCarreraNombre()!=null?i.getCarreraNombre():"—"%></td></tr>
</table></div></div></div>
<div class="col-md-6"><div class="card h-100"><div class="card-header"><i class="bi bi-file-earmark-text-fill me-2 text-warning"></i>Datos del Examen</div><div class="card-body">
<table class="table table-sm mb-0">
<tr><th class="text-muted" style="width:42%">Código</th><td><span class="badge bg-primary fs-6"><%=i.getCodigoInscripcion()%></span></td></tr>
<tr><th class="text-muted">Examen</th><td><%=i.getExamenNombre()!=null?i.getExamenNombre():"—"%></td></tr>
<tr><th class="text-muted">Fecha examen</th><td><%=i.getExamenFecha()!=null?i.getExamenFecha().format(df):"—"%></td></tr>
<tr><th class="text-muted">Periodo</th><td><%=i.getPeriodo()%> — <%=i.getAnio()%></td></tr>
<tr><th class="text-muted">Fecha inscripción</th><td><%=i.getFechaInscripcion()!=null?i.getFechaInscripcion().format(dtf):"—"%></td></tr>
<tr><th class="text-muted">Estado</th><td><span class="badge-<%=i.getEstado()!=null?i.getEstado().toLowerCase():"activo"%>"><%=i.getEstado()!=null?i.getEstado():"ACTIVO"%></span></td></tr>
</table></div></div></div>
</div><%}%>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
