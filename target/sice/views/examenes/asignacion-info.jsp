<%@ page contentType="text/html;charset=UTF-8" %><%@ page import="java.util.*,model.*" %>
<% Examen ex=(Examen)request.getAttribute("examen"); List<ExamenAsignacion> asigs=(List<ExamenAsignacion>)request.getAttribute("asignaciones"); List<Docente> docs=(List<Docente>)request.getAttribute("docentes"); List<Aula> aulas=(List<Aula>)request.getAttribute("aulas"); String ctx=request.getContextPath(); String msg=(String)session.getAttribute("msg"); String err=(String)session.getAttribute("msgError"); session.removeAttribute("msg");session.removeAttribute("msgError"); if(asigs==null)asigs=new ArrayList<>();if(docs==null)docs=new ArrayList<>();if(aulas==null)aulas=new ArrayList<>(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Asignaciones | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<%if(msg!=null){%><div class="alert alert-success alert-dismissible fade show mb-4"><i class="bi bi-check-circle-fill me-2"></i><%=msg%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<%if(err!=null){%><div class="alert alert-danger alert-dismissible fade show mb-4"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=err%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/examenes">Exámenes</a></li><li class="breadcrumb-item active">Asignar docentes</li></ol></nav>
<div class="page-header"><div><h1 class="page-title"><i class="bi bi-person-check-fill me-2 text-primary"></i><%=ex!=null?ex.getNombre():"—"%></h1><p class="page-subtitle"><%=ex!=null?ex.getGradoNombre():"—"%> • <%=ex!=null?ex.getPeriodo():"—"%> <%=ex!=null?ex.getAnio():""%></p></div>
<div>
<a href="<%=ctx%>/app/examen-asignacion?accion=asignar-aulas&idExamen=<%=ex.getId()%>" class="btn btn-success" onclick="return confirm('¿Asignar aulas automáticamente a todos los inscritos según capacidad?')"><i class="bi bi-diagram-3-fill me-1"></i>Asignar Aulas</a>
</div></div>

<%-- Formulario para agregar asignación --%>
<div class="card mb-4"><div class="card-header"><i class="bi bi-plus-circle me-2"></i>Asignar docente a este examen</div><div class="card-body">
<form action="<%=ctx%>/app/examen-asignacion" method="post" class="row g-3">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<input type="hidden" name="idExamen" value="<%=ex!=null?ex.getId():""%>">
<div class="col-md-5"><label class="form-label">Docente *</label><select name="idDocente" class="form-select" required><option value="">Seleccionar...</option><%for(Docente d:docs){%><option value="<%=d.getId()%>"><%=d.getNombreCompleto()%></option><%}%></select></div>
<div class="col-md-5"><label class="form-label">Aula *</label><select name="idAula" class="form-select" required><option value="">Seleccionar...</option><%for(Aula a:aulas){%><option value="<%=a.getId()%>"><%=a.getCodigo()%> (<%=a.getCapacidad()%> cupos)</option><%}%></select></div>
<div class="col-md-2 d-flex align-items-end"><button type="submit" class="btn btn-primary w-100"><i class="bi bi-check-lg"></i> Asignar</button></div>
</form></div></div>

<%-- Tabla de asignaciones existentes --%>
<h5 class="mb-3"><%=asigs.size()%> docente(s) asignado(s)</h5>
<% if(asigs.isEmpty()){ %>
<div class="empty-state"><i class="bi bi-person-x"></i><h5>Sin asignaciones</h5><p>No hay docentes asignados a este examen.</p></div>
<% }else{ %>
<div class="table-responsive"><table class="table table-hover">
<thead><tr><th>#</th><th>Docente</th><th>Aula</th><th>Acciones</th></tr></thead>
<tbody><%int n=1;for(ExamenAsignacion ea:asigs){%><tr>
<td class="text-muted"><%=n++%></td>
<td><strong><%=ea.getDocenteNombre()%></strong></td>
<td><span class="badge bg-secondary"><%=ea.getAulaCodigo()%></span> <small class="text-muted"><%=ea.getAulaCapacidad()%> cupos</small></td>
<td><a href="<%=ctx%>/app/examen-asignacion?accion=eliminar&id=<%=ea.getId()%>&idExamen=<%=ex.getId()%>" class="btn btn-sm btn-outline-danger btn-icon" data-confirm="¿Quitar a este docente?"><i class="bi bi-trash"></i></a></td>
</tr><%}%></tbody></table></div>
<% } %>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
