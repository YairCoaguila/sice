<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*" %>
<% List<Alumno> alumnos=(List<Alumno>)request.getAttribute("alumnos"); List<Examen> examenes=(List<Examen>)request.getAttribute("examenes"); List<Carrera> carreras=(List<Carrera>)request.getAttribute("carreras"); Inscripcion insc=(Inscripcion)request.getAttribute("inscripcion"); String ctx=request.getContextPath(); String error=(String)request.getAttribute("error"); boolean ed=insc!=null&&insc.getId()>0; int anio=java.time.Year.now().getValue(); if(alumnos==null)alumnos=new ArrayList<>();if(examenes==null)examenes=new ArrayList<>();if(carreras==null)carreras=new ArrayList<>(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Inscripción | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/inscripciones">Inscripciones</a></li><li class="breadcrumb-item active"><%=ed?"Editar":"Nueva"%></li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-pencil-square me-2 text-primary"></i><%=ed?"Editar Inscripción":"Nueva Inscripción"%></h1></div>
<%if(error!=null){%><div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=error%></div><%}%>
<div class="card" style="max-width:680px"><div class="card-header"><i class="bi bi-pencil-square me-2"></i>Datos de Inscripción</div><div class="card-body">
<form action="<%=ctx%>/app/inscripciones" method="post">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<input type="hidden" name="accion" value="<%=ed?"actualizar":"guardar"%>">
<%if(ed){%><input type="hidden" name="id" value="<%=insc.getId()%>"><%}%>
<%if(!ed){%>
<div class="mb-3"><label class="form-label">Alumno *</label><select name="idAlumno" class="form-select" required><option value="">Seleccionar alumno...</option><%for(Alumno a:alumnos){%><option value="<%=a.getId()%>"><%=a.getNombreCompleto()%> — <%=a.getDni()%></option><%}%></select></div>
<%}%>
<div class="mb-3"><label class="form-label">Examen *</label><select name="idExamen" class="form-select" required><option value="">Seleccionar examen...</option><%for(Examen e:examenes){%><option value="<%=e.getId()%>" <%=insc!=null&&insc.getIdExamen()==e.getId()?"selected":""%>><%=e.getNombre()%> — <%=e.getPeriodo()%> <%=e.getAnio()%></option><%}%></select></div>
<div class="mb-3"><label class="form-label">Carrera Postulada *</label><select name="idCarrera" class="form-select" required><option value="">Seleccionar...</option><%for(Carrera c:carreras){%><option value="<%=c.getId()%>" <%=insc!=null&&insc.getIdCarrera()==c.getId()?"selected":""%>><%=c.getNombre()%></option><%}%></select></div>
<div class="row g-3 mb-4">
<div class="col-md-6"><label class="form-label">Año *</label><input type="number" name="anio" class="form-control" required min="2020" max="2099" value="<%=insc!=null&&insc.getAnio()>0?insc.getAnio():anio%>"></div>
<div class="col-md-6"><label class="form-label">Periodo *</label><select name="periodo" class="form-select" required><option value="Periodo 1" <%=insc==null||"Periodo 1".equals(insc.getPeriodo())?"selected":""%>>Periodo 1</option><option value="Periodo 2" <%=insc!=null&&"Periodo 2".equals(insc.getPeriodo())?"selected":""%>>Periodo 2</option></select></div>
</div>
<%if(ed){%><div class="mb-4"><label class="form-label">Estado</label><select name="estado" class="form-select" style="max-width:200px"><option value="ACTIVO" <%="ACTIVO".equals(insc.getEstado())?"selected":""%>>ACTIVO</option><option value="CANCELADO" <%="CANCELADO".equals(insc.getEstado())?"selected":""%>>CANCELADO</option></select></div><%}%>
<div class="d-flex gap-2"><button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i><%=ed?"Actualizar":"Registrar Inscripción"%></button><a href="<%=ctx%>/app/inscripciones" class="btn btn-outline-secondary">Cancelar</a></div>
</form></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
