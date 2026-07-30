<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*" %>
<% List<DocenteAula> asigs=(List<DocenteAula>)request.getAttribute("asignaciones"); String ctx=request.getContextPath(); String msg=(String)session.getAttribute("msg"); String err=(String)session.getAttribute("msgError"); session.removeAttribute("msg");session.removeAttribute("msgError"); if(asigs==null)asigs=new ArrayList<>(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Asignaciones | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<%if(msg!=null){%><div class="alert alert-success alert-dismissible fade show mb-4"><i class="bi bi-check-circle-fill me-2"></i><%=msg%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<%if(err!=null){%><div class="alert alert-danger alert-dismissible fade show mb-4"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=err%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<div class="page-header"><div><h1 class="page-title"><i class="bi bi-diagram-3-fill me-2 text-primary"></i>Asignación Docente-Aula</h1><p class="page-subtitle"><%=asigs.size()%> asignaciones registradas</p></div>
<a href="<%=ctx%>/app/docente-aula?accion=nuevo" class="btn btn-primary"><i class="bi bi-plus-lg me-1"></i>Nueva Asignación</a></div>
<div class="table-wrapper">
<%if(asigs.isEmpty()){%><div class="empty-state"><i class="bi bi-diagram-3"></i><p>No hay asignaciones</p><a href="<%=ctx%>/app/docente-aula?accion=nuevo" class="btn btn-primary btn-sm">Crear</a></div>
<%}else{%><div class="table-responsive"><table class="table table-hover">
<thead><tr><th>#</th><th>Docente</th><th>Grado</th><th>Sección</th><th>Año</th><th>Periodo</th><th>Acciones</th></tr></thead>
<tbody><%int n=1;for(DocenteAula da:asigs){%><tr>
<td class="text-muted"><%=n++%></td>
<td><strong><%=da.getDocenteNombre()!=null?da.getDocenteNombre():"—"%></strong></td>
<td><small><%=da.getGradoNombre()!=null?da.getGradoNombre():"—"%></small></td>
<td><span class="badge bg-primary"><%=da.getSeccionNombre()!=null?da.getSeccionNombre():"—"%></span></td>
<td><%=da.getAnio()%></td><td><small><%=da.getPeriodo()%></small></td>
<td><div class="d-flex gap-1">
<a href="<%=ctx%>/app/docente-aula?accion=editar&id=<%=da.getId()%>" class="btn btn-sm btn-outline-primary btn-icon"><i class="bi bi-pencil"></i></a>
<a href="<%=ctx%>/app/docente-aula?accion=eliminar&id=<%=da.getId()%>" class="btn btn-sm btn-outline-danger btn-icon" data-confirm="¿Eliminar esta asignación?"><i class="bi bi-trash"></i></a>
</div></td></tr><%}%></tbody></table></div><%}%></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
