<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="model.Usuario" %>
<% Usuario u=(Usuario)request.getAttribute("usuario"); boolean ed=u!=null&&u.getId()>0; String ctx=request.getContextPath(); String error=(String)request.getAttribute("error"); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title><%=ed?"Editar":"Nuevo"%> Usuario | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/usuarios">Usuarios</a></li><li class="breadcrumb-item active"><%=ed?"Editar":"Nuevo"%></li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-shield-lock-fill me-2 text-primary"></i><%=ed?"Editar Usuario":"Nuevo Usuario"%></h1></div>
<%if(error!=null){%><div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=error%></div><%}%>
<div class="card" style="max-width:520px"><div class="card-body">
<form action="<%=ctx%>/app/usuarios" method="post" autocomplete="off">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<%if(ed){%><input type="hidden" name="id" value="<%=u.getId()%>"><input type="hidden" name="origUsername" value="<%=u.getUsername()%>"><%}%>
<div class="mb-3"><label class="form-label">Nombre de usuario *</label><input type="text" name="username" class="form-control" required value="<%=u!=null&&u.getUsername()!=null?u.getUsername():""%>"></div>
<%if(!ed){%>
<div class="mb-3"><label class="form-label">Contraseña *</label><input type="password" name="password" class="form-control" minlength="3" required></div>
<div class="mb-3"><label class="form-label">Confirmar contraseña *</label><input type="password" name="confirmPassword" class="form-control" minlength="3" required></div>
<%}else{%>
<div class="mb-3"><label class="form-label">Nueva contraseña <small class="text-muted">(dejar en blanco para mantener)</small></label><input type="password" name="password" class="form-control" minlength="3"></div>
<%}%>
<div class="mb-3"><label class="form-label">Rol *</label><select name="rol" class="form-select" required><option value="">Seleccionar...</option><option value="administrador" <%=u!=null&&"administrador".equals(u.getRol())?"selected":""%>>Administrador</option><option value="digitador" <%=u!=null&&"digitador".equals(u.getRol())?"selected":""%>>Digitador</option></select></div>
<div class="mb-4"><label class="form-label">Estado *</label><select name="estado" class="form-select" required><option value="ACTIVO" <%=u!=null&&"ACTIVO".equals(u.getEstado())?"selected":""%>>Activo</option><option value="INACTIVO" <%=u!=null&&"INACTIVO".equals(u.getEstado())?"selected":""%>>Inactivo</option></select></div>
<div class="d-flex gap-2"><button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i><%=ed?"Actualizar":"Guardar"%></button><a href="<%=ctx%>/app/usuarios" class="btn btn-outline-secondary">Cancelar</a></div>
</form></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
