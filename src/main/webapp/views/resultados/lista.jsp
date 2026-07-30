<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*" %>
<% List<Resultado> resultados=(List<Resultado>)request.getAttribute("resultados"); List<Examen> examenes=(List<Examen>)request.getAttribute("examenes"); Integer idExSel=(Integer)request.getAttribute("idExamenSel"); Examen exSel=(Examen)request.getAttribute("examenSel"); String ctx=request.getContextPath(); String msg=(String)session.getAttribute("msg"); session.removeAttribute("msg"); if(resultados==null)resultados=new ArrayList<>();if(examenes==null)examenes=new ArrayList<>(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Resultados | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<%if(msg!=null){%><div class="alert alert-success alert-dismissible fade show mb-4"><i class="bi bi-check-circle-fill me-2"></i><%=msg%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<div class="page-header"><div><h1 class="page-title"><i class="bi bi-bar-chart-fill me-2 text-primary"></i>Resultados</h1><p class="page-subtitle">Puntajes y estadísticas</p></div>
<%if(idExSel!=null){%><a href="<%=ctx%>/app/resultados?accion=nuevo&idExamen=<%=idExSel%>" class="btn btn-primary"><i class="bi bi-plus-lg me-1"></i>Registrar Resultado</a><%}%></div>
<div class="card mb-4"><div class="card-body py-3"><form action="<%=ctx%>/app/resultados" method="get" class="d-flex gap-2 align-items-end">
<div><label class="form-label mb-1">Seleccionar Examen</label><select name="idExamen" class="form-select" style="min-width:340px"><option value="">-- Selecciona un examen --</option><%for(Examen e:examenes){%><option value="<%=e.getId()%>" <%=idExSel!=null&&idExSel.equals(e.getId())?"selected":""%>><%=e.getNombre()%> (<%=e.getPeriodo()%> <%=e.getAnio()%>)</option><%}%></select></div>
<button type="submit" class="btn btn-primary"><i class="bi bi-search me-1"></i>Ver Resultados</button>
<%if(idExSel!=null){%><a href="<%=ctx%>/app/resultados?export=csv&idExamen=<%=idExSel%>" class="btn btn-success"><i class="bi bi-download me-1"></i>CSV</a><%}%></form></div></div>
<%if(exSel!=null){%>
<div class="row g-3 mb-4">
<div class="col-md-3"><div class="stat-card"><div class="stat-icon stat-icon-blue"><i class="bi bi-people-fill"></i></div><div><div class="stat-value"><%=resultados.size()%></div><div class="stat-label">Participantes</div></div></div></div>
<div class="col-md-3"><div class="stat-card"><div class="stat-icon stat-icon-green"><i class="bi bi-check-circle-fill"></i></div><div><div class="stat-value"><%=String.format("%.1f",resultados.stream().mapToDouble(Resultado::getPuntaje).average().orElse(0))%></div><div class="stat-label">Puntaje Promedio</div></div></div></div>
<div class="col-md-3"><div class="stat-card"><div class="stat-icon stat-icon-amber"><i class="bi bi-trophy-fill"></i></div><div><div class="stat-value"><%=String.format("%.0f",resultados.stream().mapToDouble(Resultado::getPuntaje).max().orElse(0))%></div><div class="stat-label">Puntaje Máximo</div></div></div></div>
<div class="col-md-3"><div class="stat-card"><div class="stat-icon stat-icon-purple"><i class="bi bi-file-earmark-text-fill"></i></div><div><div class="stat-value"><%=exSel.getCantidadPreguntas()%></div><div class="stat-label">Total Preguntas</div></div></div></div>
</div><%}%>
<div class="table-wrapper">
<%if(idExSel==null){%><div class="empty-state"><i class="bi bi-bar-chart"></i><p>Selecciona un examen para ver resultados</p></div>
<%}else if(resultados.isEmpty()){%><div class="empty-state"><i class="bi bi-inbox"></i><p>Sin resultados para este examen</p><a href="<%=ctx%>/app/resultados?accion=nuevo&idExamen=<%=idExSel%>" class="btn btn-primary btn-sm mt-2">Registrar</a></div>
<%}else{%><div class="table-responsive"><table class="table table-hover">
<thead><tr><th>Pos.</th><th>Alumno</th><th>DNI</th><th>Grado/Sec</th><th>Carrera</th><th>Puntaje</th><th>Correctas</th><th>Incorrectas</th><th>Blanco</th><th>%</th><th>Acción</th></tr></thead>
<tbody><%int pos=1;for(Resultado r:resultados){%><tr>
<td class="text-center"><%if(pos==1){%><i class="bi bi-trophy-fill medal-gold"></i><%}else if(pos==2){%><i class="bi bi-trophy-fill medal-silver"></i><%}else if(pos==3){%><i class="bi bi-trophy-fill medal-bronze"></i><%}else{%><span class="text-muted fw-bold"><%=pos%></span><%}%></td>
<td><strong><%=r.getAlumnoNombre()!=null?r.getAlumnoNombre():"—"%></strong></td>
<td><code><small><%=r.getAlumnoDni()!=null?r.getAlumnoDni():"—"%></small></code></td>
<td><small><%=r.getSeccionNombre()!=null?r.getSeccionNombre():"—"%></small></td>
<td><small><%=r.getCarreraNombre()!=null?r.getCarreraNombre():"—"%></small></td>
<td><span class="badge bg-primary fs-6 px-3"><%=r.getPuntaje()%></span></td>
<td><span class="text-success fw-bold"><%=r.getCorrectas()%></span></td>
<td><span class="text-danger fw-bold"><%=r.getIncorrectas()%></span></td>
<td><span class="text-muted"><%=r.getEnBlanco()%></span></td>
<td><strong><%=r.getPorcentaje()%>%</strong></td>
<td><div class="d-flex gap-1 justify-content-end">
<a href="<%=ctx%>/app/resultados?accion=editar&id=<%=r.getId()%>" class="btn btn-sm btn-outline-primary btn-icon" title="Editar"><i class="bi bi-pencil"></i></a>
<a href="<%=ctx%>/app/resultados?accion=eliminar&id=<%=r.getId()%>" class="btn btn-sm btn-outline-danger btn-icon" data-confirm="¿Eliminar resultado?" title="Eliminar"><i class="bi bi-trash"></i></a>
</div></td>
</tr><%pos++;}%></tbody></table></div><%}%></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
