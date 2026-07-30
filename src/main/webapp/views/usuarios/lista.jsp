<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*" %>
<% List<Usuario> usuarios=(List<Usuario>)request.getAttribute("usuarios"); String ctx=request.getContextPath(); String msg=(String)session.getAttribute("msg"); String msgError=(String)session.getAttribute("msgError"); if(usuarios==null)usuarios=new ArrayList<>(); session.removeAttribute("msg"); session.removeAttribute("msgError"); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Usuarios | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item active">Usuarios</li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-shield-lock-fill me-2 text-primary"></i>Usuarios del Sistema</h1><a href="<%=ctx%>/app/usuarios?accion=nuevo" class="btn btn-primary"><i class="bi bi-plus-lg me-1"></i>Nuevo Usuario</a></div>
<%if(msg!=null){%><div class="alert alert-success"><i class="bi bi-check-circle-fill me-2"></i><%=msg%></div><%}%>
<%if(msgError!=null){%><div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=msgError%></div><%}%>
<div class="card"><div class="card-body p-0">
<div class="table-responsive"><table class="table table-hover align-middle mb-0">
<thead class="table-light"><tr><th>ID</th><th>Usuario</th><th>Rol</th><th>Estado</th><th>Vinculado a</th><th class="text-end">Acciones</th></tr></thead>
<tbody><%for(Usuario u:usuarios){%><tr>
<td class="text-muted"><%=u.getId()%></td>
<td><strong><%=u.getUsername()%></strong></td>
<td><span class="badge <%=u.isAdmin()?"bg-danger":u.isDigitador()?"bg-info text-dark":"bg-secondary"%>"><%=u.getRol()%></span></td>
<td><span class="badge <%=u.getEstado()!=null&&u.getEstado().equals("ACTIVO")?"bg-success":"bg-secondary"%>"><%=u.getEstado()!=null?u.getEstado():"INACTIVO"%></span></td>
<td><%=u.hasDocente()?"Docente ID "+u.getIdDocente():"—"%></td>
<td class="text-end">
<a href="<%=ctx%>/app/usuarios?accion=editar&id=<%=u.getId()%>" class="btn btn-sm btn-outline-primary" title="Editar"><i class="bi bi-pencil"></i></a>
<a href="<%=ctx%>/app/usuarios?accion=eliminar&id=<%=u.getId()%>" class="btn btn-sm btn-outline-danger" title="Eliminar" onclick="return confirm('¿Eliminar usuario?')"><i class="bi bi-trash"></i></a>
</td></tr><%}%>
<%if(usuarios.isEmpty()){%><tr><td colspan="6" class="text-center text-muted py-4">No hay usuarios registrados.</td></tr><%}%>
</tbody></table></div></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
