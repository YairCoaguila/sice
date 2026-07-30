<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="model.Grado" %>
<% Grado g=(Grado)request.getAttribute("grado"); boolean ed=g!=null&&g.getId()>0; String ctx=request.getContextPath(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title><%=ed?"Editar":"Nuevo"%> Grado | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="sidebar.jsp"/><div class="main-content w-100"><jsp:include page="navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/grados">Grados</a></li><li class="breadcrumb-item active"><%=ed?"Editar":"Nuevo"%></li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-layers-fill me-2 text-primary"></i><%=ed?"Editar Grado":"Nuevo Grado"%></h1></div>
<div class="card" style="max-width:480px"><div class="card-body">
<form action="<%=ctx%>/app/grados" method="post">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<%if(ed){%><input type="hidden" name="id" value="<%=g.getId()%>"><%}%>
<div class="mb-3"><label class="form-label">Nombre del Grado *</label><input type="text" name="nombre" class="form-control" required placeholder="Ej: 5to Secundaria" value="<%=g!=null&&g.getNombre()!=null?g.getNombre():""%>"></div>
<div class="mb-3"><label class="form-label">Nivel (orden) *</label><input type="number" name="nivel" class="form-control" required min="1" max="10" value="<%=g!=null?g.getNivel():1%>"><div class="form-text">1=1ro, 2=2do, 3=3ro, 4=4to, 5=5to</div></div>
<div class="mb-4"><div class="form-check"><input class="form-check-input" type="checkbox" name="participa" id="participa" <%=g==null||g.isParticipa()?"checked":""%>><label class="form-check-label" for="participa"><strong>Participa en simulacros</strong><div class="text-muted small">1ro de secundaria NO participa</div></label></div></div>
<div class="d-flex gap-2"><button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i><%=ed?"Actualizar":"Guardar"%></button><a href="<%=ctx%>/app/grados" class="btn btn-outline-secondary">Cancelar</a></div>
</form></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
