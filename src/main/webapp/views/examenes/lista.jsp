<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*,util.HtmlUtil" %>
<% List<Examen> examenes=(List<Examen>)request.getAttribute("examenes"); String ctx=request.getContextPath(); String msg=(String)session.getAttribute("msg"); String err=(String)session.getAttribute("msgError"); session.removeAttribute("msg");session.removeAttribute("msgError"); if(examenes==null)examenes=new ArrayList<>(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Exámenes | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<%if(msg!=null){%><div class="alert alert-success alert-dismissible fade show mb-4"><i class="bi bi-check-circle-fill me-2"></i><%=HtmlUtil.e(msg)%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<%if(err!=null){%><div class="alert alert-danger alert-dismissible fade show mb-4"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=HtmlUtil.e(err)%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<div class="page-header"><div><h1 class="page-title"><i class="bi bi-file-earmark-text-fill me-2 text-primary"></i>Exámenes</h1><p class="page-subtitle"><%=examenes.size()%> registros</p></div>
<a href="<%=ctx%>/app/examenes?accion=nuevo" class="btn btn-primary"><i class="bi bi-plus-lg me-1"></i>Nuevo Examen</a></div>
<div class="table-wrapper">
<%if(examenes.isEmpty()){%><div class="empty-state"><i class="bi bi-file-earmark-text"></i><p>No hay exámenes</p><a href="<%=ctx%>/app/examenes?accion=nuevo" class="btn btn-primary btn-sm">Crear</a></div>
<%}else{%><div class="table-responsive"><table class="table table-hover">
<thead><tr><th>#</th><th>Nombre</th><th>Fecha</th><th>Grado</th><th>Área</th><th>Preguntas</th><th>Puntaje</th><th>Periodo</th><th>Estado</th><th>Acciones</th></tr></thead>
<tbody><%int n=1;for(Examen e:examenes){%><tr>
<td class="text-muted"><%=n++%></td>
<td><strong><%=HtmlUtil.e(e.getNombre())%></strong></td>
<td><small><%=e.getFecha()!=null?e.getFecha().toString():"—"%></small></td>
<td><small><%=e.getGradoNombre()!=null?HtmlUtil.e(e.getGradoNombre()):"—"%></small></td>
<td><small><%=e.getAreaNombre()!=null?HtmlUtil.e(e.getAreaNombre()):"—"%></small></td>
<td class="text-center"><span class="badge bg-primary"><%=e.getCantidadPreguntas()%></span></td>
<td class="text-center"><span class="badge bg-success"><%=e.getPuntajeTotal()%></span></td>
<td><small><%=e.getPeriodo()%> · <%=e.getAnio()%></small></td>
<td><span class="badge-<%=e.getEstado()!=null?e.getEstado().toLowerCase():"activo"%>"><%=e.getEstado()!=null?e.getEstado():"ACTIVO"%></span></td>
<td><div class="d-flex gap-1">
<a href="<%=ctx%>/app/examenes?accion=editar&id=<%=e.getId()%>" class="btn btn-sm btn-outline-primary btn-icon" title="Editar"><i class="bi bi-pencil"></i></a>
<a href="<%=ctx%>/app/examen-asignacion?idExamen=<%=e.getId()%>" class="btn btn-sm btn-outline-warning btn-icon" title="Asignar docente"><i class="bi bi-person-check"></i></a>
<a href="<%=ctx%>/app/resultados?idExamen=<%=e.getId()%>" class="btn btn-sm btn-outline-success btn-icon" title="Ver resultados"><i class="bi bi-bar-chart"></i></a>
<a href="<%=ctx%>/app/examenes?accion=eliminar&id=<%=e.getId()%>" class="btn btn-sm btn-outline-danger btn-icon" data-confirm="¿Eliminar '<%=HtmlUtil.e(e.getNombre())%>'?"><i class="bi bi-trash"></i></a>
</div></td></tr><%}%></tbody></table></div><%}%></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
