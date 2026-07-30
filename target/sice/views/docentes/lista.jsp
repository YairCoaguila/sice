<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*,util.HtmlUtil" %>
<% List<Docente> docentes=(List<Docente>)request.getAttribute("docentes"); Map<Integer,Usuario> credenciales=(Map<Integer,Usuario>)request.getAttribute("credenciales"); String ctx=request.getContextPath(); String msg=(String)session.getAttribute("msg"); String err=(String)session.getAttribute("msgError"); session.removeAttribute("msg");session.removeAttribute("msgError"); if(docentes==null)docentes=new ArrayList<>(); if(credenciales==null)credenciales=new HashMap<>(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Docentes | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<%if(msg!=null){%><div class="alert alert-success alert-dismissible fade show mb-4"><i class="bi bi-check-circle-fill me-2"></i><%=HtmlUtil.e(msg)%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<%if(err!=null){%><div class="alert alert-danger alert-dismissible fade show mb-4"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=HtmlUtil.e(err)%><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><%}%>
<div class="page-header"><div><h1 class="page-title"><i class="bi bi-person-badge-fill me-2 text-primary"></i>Docentes</h1><p class="page-subtitle"><%=docentes.size()%> registros</p></div>
<div class="d-flex gap-2"><a href="<%=ctx%>/app/importar?tipo=docentes" class="btn btn-success"><i class="bi bi-upload me-1"></i>Importar CSV</a><a href="<%=ctx%>/app/docentes?accion=nuevo" class="btn btn-primary"><i class="bi bi-plus-lg me-1"></i>Nuevo Docente</a></div></div>
<div class="table-wrapper">
<%if(docentes.isEmpty()){%><div class="empty-state"><i class="bi bi-person-badge"></i><p>No hay docentes registrados</p><a href="<%=ctx%>/app/docentes?accion=nuevo" class="btn btn-primary btn-sm">Registrar</a></div>
<%}else{%><div class="table-responsive"><table class="table table-hover">
<thead><tr><th>#</th><th>Docente</th><th>DNI</th><th>Especialidad</th><th>Celular</th><th>Correo</th><th>Estado</th><th>Acciones</th></tr></thead>
<tbody><%int n=1;for(Docente d:docentes){%><tr>
<td class="text-muted"><%=n++%></td>
<td><div class="d-flex align-items-center gap-2"><div class="avatar-circle" style="width:34px;height:34px;font-size:.75rem;background:linear-gradient(135deg,#1e3a5f,#132542)"><%=d.getApellidoPaterno()!=null?HtmlUtil.e(d.getApellidoPaterno().substring(0,1)):"D"%></div><div><div class="fw-semibold" style="font-size:.875rem"><%=HtmlUtil.e(d.getApellidoPaterno())%> <%=HtmlUtil.e(d.getApellidoMaterno())%></div><small class="text-muted"><%=HtmlUtil.e(d.getNombres())%></small></div></div></td>
<td><code><%=HtmlUtil.e(d.getDni())%></code></td>
<td><small><%=d.getEspecialidad()!=null?HtmlUtil.e(d.getEspecialidad()):"—"%></small></td>
<td><small><%=d.getCelular()!=null?HtmlUtil.e(d.getCelular()):"—"%></small></td>
<td><small><%=d.getCorreo()!=null?HtmlUtil.e(d.getCorreo()):"—"%></small></td>
<td><span class="badge-<%=d.getEstado()!=null?d.getEstado().toLowerCase():"activo"%>"><%=d.getEstado()!=null?d.getEstado():"ACTIVO"%></span></td>
<td><div class="d-flex gap-1">
<a href="<%=ctx%>/app/docentes?accion=editar&id=<%=d.getId()%>" class="btn btn-sm btn-outline-primary btn-icon" title="Editar"><i class="bi bi-pencil"></i></a>
<% Usuario cred=credenciales.get(d.getId()); if(cred!=null){ %>
<button class="btn btn-sm btn-outline-warning btn-icon" title="Ver credenciales" onclick="verCredenciales('<%=HtmlUtil.e(cred.getUsername())%>','<%=HtmlUtil.e(cred.getPassword())%>')"><i class="bi bi-key"></i></button>
<% } %>
<a href="<%=ctx%>/app/docentes?accion=eliminar&id=<%=d.getId()%>" class="btn btn-sm btn-outline-danger btn-icon" data-confirm="¿Eliminar a <%=HtmlUtil.e(d.getNombreCompleto())%>?"><i class="bi bi-trash"></i></a>
</div></td></tr>
<%}%></tbody></table></div><%}%></div>

<%-- Modal credenciales (único) --%>
<div class="modal fade" id="credModal" tabindex="-1">
<div class="modal-dialog modal-sm modal-dialog-centered">
<div class="modal-content">
<div class="modal-header" style="background:var(--primary);color:white"><h6 class="modal-title"><i class="bi bi-key me-2"></i>Credenciales</h6><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
<div class="modal-body">
<p class="mb-2"><strong>Usuario:</strong><br><code id="credUsername"></code></p>
<p class="mb-0"><strong>Contraseña:</strong><br><code id="credPassword"></code></p>
</div>
<div class="modal-footer"><button class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cerrar</button></div>
</div></div></div>
<script>function verCredenciales(u,p){document.getElementById('credUsername').textContent=u;document.getElementById('credPassword').textContent=p;new bootstrap.Modal(document.getElementById('credModal')).show();}</script>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
