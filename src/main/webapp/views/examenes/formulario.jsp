<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*,util.HtmlUtil" %>
<% Examen ex=(Examen)request.getAttribute("examen"); List<Grado> grados=(List<Grado>)request.getAttribute("grados"); List<Area> areas=(List<Area>)request.getAttribute("areas"); boolean ed=ex!=null&&ex.getId()>0; String ctx=request.getContextPath(); String error=(String)request.getAttribute("error"); int anio=java.time.Year.now().getValue(); if(grados==null)grados=new ArrayList<>();if(areas==null)areas=new ArrayList<>(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title><%=ed?"Editar":"Nuevo"%> Examen | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/examenes">Exámenes</a></li><li class="breadcrumb-item active"><%=ed?"Editar":"Nuevo"%></li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-file-earmark-text-fill me-2 text-primary"></i><%=ed?"Editar Examen":"Nuevo Examen"%></h1></div>
<%if(error!=null){%><div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=HtmlUtil.e(error)%></div><%}%>
<div class="card" style="max-width:750px"><div class="card-header"><i class="bi bi-file-earmark-plus me-2"></i>Datos del Examen</div><div class="card-body">
<form action="<%=ctx%>/app/examenes" method="post" autocomplete="off">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<%if(ed){%><input type="hidden" name="id" value="<%=ex.getId()%>"><%}%>
<div class="mb-3"><label class="form-label">Nombre del Examen *</label><input type="text" name="nombre" class="form-control" required value="<%=ex!=null&&ex.getNombre()!=null?HtmlUtil.e(ex.getNombre()):""%>" placeholder="Ej: Simulacro 01 - Periodo 1 2026"></div>
<div class="row g-3 mb-3">
<div class="col-md-4"><label class="form-label">Fecha</label><input type="date" name="fecha" class="form-control" value="<%=ex!=null&&ex.getFecha()!=null?ex.getFecha().toString():""%>"></div>
<div class="col-md-4"><label class="form-label">Año *</label><input type="number" name="anio" class="form-control" required min="2020" max="2099" value="<%=ex!=null&&ex.getAnio()>0?ex.getAnio():anio%>"></div>
<div class="col-md-4"><label class="form-label">Periodo *</label><select name="periodo" class="form-select" required><option value="Periodo 1" <%=ex==null||"Periodo 1".equals(ex.getPeriodo())?"selected":""%>>Periodo 1</option><option value="Periodo 2" <%=ex!=null&&"Periodo 2".equals(ex.getPeriodo())?"selected":""%>>Periodo 2</option></select></div>
</div>
<div class="row g-3 mb-3">
<div class="col-md-6"><label class="form-label">Grado *</label><select name="idGrado" class="form-select" required><option value="">Seleccionar...</option><%for(Grado g:grados){%><option value="<%=g.getId()%>" <%=ex!=null&&ex.getIdGrado()==g.getId()?"selected":""%>><%=HtmlUtil.e(g.getNombre())%></option><%}%></select></div>
<div class="col-md-6"><label class="form-label">Área *</label><select name="idArea" class="form-select" required><option value="">Seleccionar...</option><%for(Area a:areas){%><option value="<%=a.getId()%>" <%=ex!=null&&ex.getIdArea()==a.getId()?"selected":""%>><%=HtmlUtil.e(a.getNombre())%></option><%}%></select></div>
</div>
<div class="row g-3 mb-4">
<div class="col-md-4"><label class="form-label">Cantidad Preguntas *</label><input type="number" name="cantidadPreguntas" class="form-control" required min="1" value="<%=ex!=null?ex.getCantidadPreguntas():100%>"></div>
<div class="col-md-4"><label class="form-label">Puntaje Total *</label><input type="number" name="puntajeTotal" class="form-control" required min="1" step="0.5" value="<%=ex!=null?ex.getPuntajeTotal():100%>"></div>
<div class="col-md-4"><label class="form-label">Estado</label><select name="estado" class="form-select"><option value="ACTIVO" <%=ex==null||"ACTIVO".equals(ex.getEstado())?"selected":""%>>ACTIVO</option><option value="INACTIVO" <%=ex!=null&&"INACTIVO".equals(ex.getEstado())?"selected":""%>>INACTIVO</option></select></div>
</div>
<div class="d-flex gap-2"><button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i><%=ed?"Actualizar":"Guardar"%></button><a href="<%=ctx%>/app/examenes" class="btn btn-outline-secondary">Cancelar</a></div>
</form></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
