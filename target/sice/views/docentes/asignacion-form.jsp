<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*,util.HtmlUtil" %>
<% DocenteAula da=(DocenteAula)request.getAttribute("asignacion"); List<Docente> docs=(List<Docente>)request.getAttribute("docentes"); List<Grado> grados=(List<Grado>)request.getAttribute("grados"); List<Seccion> secs=(List<Seccion>)request.getAttribute("secciones"); boolean ed=da!=null&&da.getId()>0; String ctx=request.getContextPath(); int anio=java.time.Year.now().getValue(); if(docs==null)docs=new ArrayList<>();if(grados==null)grados=new ArrayList<>();if(secs==null)secs=new ArrayList<>(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Asignación | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/docente-aula">Asignaciones</a></li><li class="breadcrumb-item active"><%=ed?"Editar":"Nueva"%></li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-diagram-3-fill me-2 text-primary"></i><%=ed?"Editar":"Nueva"%> Asignación</h1></div>
<div class="card" style="max-width:620px"><div class="card-header"><i class="bi bi-diagram-3 me-2"></i>Datos</div><div class="card-body">
<form action="<%=ctx%>/app/docente-aula" method="post">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<%if(ed){%><input type="hidden" name="id" value="<%=da.getId()%>"><%}%>
<div class="mb-3"><label class="form-label">Docente *</label><select name="idDocente" class="form-select" required><option value="">Seleccionar...</option><%for(Docente doc:docs){%><option value="<%=doc.getId()%>" <%=da!=null&&da.getIdDocente()==doc.getId()?"selected":""%>><%=HtmlUtil.e(doc.getNombreCompleto())%></option><%}%></select></div>
<div class="row g-3 mb-3">
<div class="col-md-6"><label class="form-label">Grado *</label><select name="idGrado" class="form-select" required><option value="">Seleccionar...</option><%for(Grado g:grados){%><option value="<%=g.getId()%>" <%=da!=null&&da.getIdGrado()==g.getId()?"selected":""%>><%=HtmlUtil.e(g.getNombre())%></option><%}%></select></div>
<div class="col-md-6"><label class="form-label">Sección *</label><select name="idSeccion" class="form-select" required><option value="">Seleccionar...</option><%for(Seccion s:secs){%><option value="<%=s.getId()%>" <%=da!=null&&da.getIdSeccion()==s.getId()?"selected":""%>><%=HtmlUtil.e(s.getNombre())%></option><%}%></select></div>
</div>
<div class="row g-3 mb-4">
<div class="col-md-6"><label class="form-label">Año *</label><input type="number" name="anio" class="form-control" required min="2020" max="2099" value="<%=da!=null?da.getAnio():anio%>"></div>
<div class="col-md-6"><label class="form-label">Periodo *</label><select name="periodo" class="form-select" required><option value="Periodo 1" <%=da==null||"Periodo 1".equals(da.getPeriodo())?"selected":""%>>Periodo 1</option><option value="Periodo 2" <%=da!=null&&"Periodo 2".equals(da.getPeriodo())?"selected":""%>>Periodo 2</option></select></div>
</div>
<div class="d-flex gap-2"><button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i><%=ed?"Actualizar":"Guardar"%></button><a href="<%=ctx%>/app/docente-aula" class="btn btn-outline-secondary">Cancelar</a></div>
</form></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
