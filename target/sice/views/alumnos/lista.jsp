<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*,util.HtmlUtil" %>
<% List<Alumno> alumnos=(List<Alumno>)request.getAttribute("alumnos"); String busqueda=(String)request.getAttribute("busqueda"); String ctx=request.getContextPath(); String msg=(String)session.getAttribute("msg"); String err=(String)session.getAttribute("msgError"); session.removeAttribute("msg"); session.removeAttribute("msgError"); if(alumnos==null)alumnos=new ArrayList<>(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Alumnos | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<%if(msg!=null){%><div class="alert alert-success alert-dismissible fade show mb-4"><i class="bi bi-check-circle-fill me-2"></i><%=HtmlUtil.e(msg)%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<%if(err!=null){%><div class="alert alert-danger alert-dismissible fade show mb-4"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=HtmlUtil.e(err)%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<div class="page-header"><div><h1 class="page-title"><i class="bi bi-people-fill me-2 text-primary"></i>Alumnos</h1><p class="page-subtitle"><%=alumnos.size()%> registros</p></div>
<div class="d-flex gap-2"><a href="<%=ctx%>/app/importar?tipo=alumnos" class="btn btn-success"><i class="bi bi-upload me-1"></i>Importar CSV</a><a href="<%=ctx%>/app/alumnos?accion=nuevo" class="btn btn-primary"><i class="bi bi-plus-lg me-1"></i>Nuevo Alumno</a></div></div>
<div class="card mb-4"><div class="card-body py-3"><form action="<%=ctx%>/app/alumnos" method="get" class="d-flex gap-2">
<input type="hidden" name="accion" value="buscar"><input type="text" name="q" class="form-control" placeholder="Buscar nombre, apellido o DNI..." value="<%=busqueda!=null?HtmlUtil.e(busqueda):""%>" style="max-width:360px">
<button class="btn btn-primary" type="submit"><i class="bi bi-search me-1"></i>Buscar</button>
<%if(busqueda!=null&&!busqueda.isEmpty()){%><a href="<%=ctx%>/app/alumnos" class="btn btn-outline-secondary">Limpiar</a><%}%>
</form></div></div>
<div class="table-wrapper">
<%if(alumnos.isEmpty()){%><div class="empty-state"><i class="bi bi-people"></i><p>No hay alumnos</p><a href="<%=ctx%>/app/alumnos?accion=nuevo" class="btn btn-primary btn-sm">Registrar</a></div>
<%}else{%><div class="table-responsive"><table class="table table-hover">
<thead><tr><th>#</th><th>Alumno</th><th>DNI</th><th>Grado</th><th>Sección</th><th>Carrera</th><th>Colegio</th><th>Celular</th><th>Acciones</th>
<tbody><%int n=1;for(Alumno a:alumnos){%><tr>
<td class="text-muted"><%=n++%></td>
<td><div class="d-flex align-items-center gap-2"><div class="avatar-circle" style="width:34px;height:34px;font-size:.75rem"><%=HtmlUtil.e(a.getApellidoPaterno().substring(0,1))%></div><div><div class="fw-semibold" style="font-size:.875rem"><%=HtmlUtil.e(a.getApellidoPaterno())%> <%=HtmlUtil.e(a.getApellidoMaterno())%></div><small class="text-muted"><%=HtmlUtil.e(a.getNombres())%></small></div></div></td>
<td><code><%=HtmlUtil.e(a.getDni())%></code></td>
<td><small><%=a.getGradoNombre()!=null?HtmlUtil.e(a.getGradoNombre()):"—"%></small></td>
<td><small><%=a.getSeccionNombre()!=null?HtmlUtil.e(a.getSeccionNombre()):"—"%></small></td>
<td><small><%=a.getCarreraNombre()!=null?HtmlUtil.e(a.getCarreraNombre()):"—"%></small></td>
<td><small><%=a.getColegio()!=null&&!a.getColegio().isEmpty()?HtmlUtil.e(a.getColegio()):"&mdash;"%></small></td>
<td><small><%=a.getCelular()!=null?HtmlUtil.e(a.getCelular()):"&mdash;"%></small></td>
<td><div class="d-flex gap-1">
<a href="<%=ctx%>/app/alumnos?accion=editar&id=<%=a.getId()%>" class="btn btn-sm btn-outline-primary btn-icon" title="Editar"><i class="bi bi-pencil"></i></a>
<a href="<%=ctx%>/app/alumnos?accion=eliminar&id=<%=a.getId()%>" class="btn btn-sm btn-outline-danger btn-icon" data-confirm="¿Eliminar a <%=HtmlUtil.e(a.getNombreCompleto())%>?"><i class="bi bi-trash"></i></a>
</div></td></tr><%}%></tbody></table></div><%}%></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
