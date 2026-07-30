<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="model.Aula,util.HtmlUtil" %>
<% Aula a=(Aula)request.getAttribute("aula"); boolean ed=a!=null&&a.getId()>0; String ctx=request.getContextPath(); String capVal=(a!=null&&a.getCapacidad()>0)?String.valueOf(a.getCapacidad()):""; %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title><%=ed?"Editar":"Nueva"%> Aula | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/aulas">Aulas</a></li><li class="breadcrumb-item active"><%=ed?"Editar":"Nueva"%></li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-door-open-fill me-2 text-primary"></i><%=ed?"Editar Aula":"Nueva Aula"%></h1></div>
<div class="card" style="max-width:520px"><div class="card-body">
<form action="<%=ctx%>/app/aulas" method="post">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<%if(ed){%><input type="hidden" name="id" value="<%=a.getId()%>"><%}%>
<div class="mb-3"><label class="form-label">Código *</label><input type="text" name="codigo" class="form-control" required value="<%=a!=null&&a.getCodigo()!=null?HtmlUtil.e(a.getCodigo()):""%>"></div>
<div class="mb-3"><label class="form-label">Capacidad *</label><input type="number" name="capacidad" class="form-control" min="1" required value="<%=capVal%>"></div>
<div class="mb-4"><label class="form-label">Descripción</label><input type="text" name="descripcion" class="form-control" value="<%=a!=null&&a.getDescripcion()!=null?HtmlUtil.e(a.getDescripcion()):""%>"></div>
<div class="d-flex gap-2"><button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i><%=ed?"Actualizar":"Guardar"%></button><a href="<%=ctx%>/app/aulas" class="btn btn-outline-secondary">Cancelar</a></div>
</form></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
