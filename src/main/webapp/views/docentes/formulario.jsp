<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="model.Docente,util.HtmlUtil" %>
<% Docente d=(Docente)request.getAttribute("docente"); boolean ed=d!=null&&d.getId()>0; String ctx=request.getContextPath(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title><%=ed?"Editar":"Nuevo"%> Docente | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/docentes">Docentes</a></li><li class="breadcrumb-item active"><%=ed?"Editar":"Nuevo"%></li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-person-badge-fill me-2 text-primary"></i><%=ed?"Editar Docente":"Nuevo Docente"%></h1></div>
<div class="card" style="max-width:750px"><div class="card-header"><i class="bi bi-person-lines-fill me-2"></i>Datos del Docente</div><div class="card-body">
<form action="<%=ctx%>/app/docentes" method="post" autocomplete="off">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<input type="hidden" name="accion" value="<%=ed?"actualizar":"guardar"%>">
<%if(ed){%><input type="hidden" name="id" value="<%=d.getId()%>"><%}%>
<div class="row g-3 mb-3">
<div class="col-md-6"><label class="form-label">Apellido Paterno *</label><input type="text" name="apellidoPaterno" class="form-control" required value="<%=d!=null&&d.getApellidoPaterno()!=null?HtmlUtil.e(d.getApellidoPaterno()):""%>"></div>
<div class="col-md-6"><label class="form-label">Apellido Materno *</label><input type="text" name="apellidoMaterno" class="form-control" required value="<%=d!=null&&d.getApellidoMaterno()!=null?HtmlUtil.e(d.getApellidoMaterno()):""%>"></div>
</div>
<div class="row g-3 mb-3">
<div class="col-md-8"><label class="form-label">Nombres *</label><input type="text" name="nombres" class="form-control" required value="<%=d!=null&&d.getNombres()!=null?HtmlUtil.e(d.getNombres()):""%>"></div>
<div class="col-md-4"><label class="form-label">DNI *</label><input type="text" name="dni" class="form-control" maxlength="15" required value="<%=d!=null&&d.getDni()!=null?HtmlUtil.e(d.getDni()):""%>"></div>
</div>
<div class="row g-3 mb-3">
<div class="col-md-4"><label class="form-label">Celular</label><input type="text" name="celular" class="form-control" value="<%=d!=null&&d.getCelular()!=null?HtmlUtil.e(d.getCelular()):""%>"></div>
<div class="col-md-4"><label class="form-label">Correo</label><input type="email" name="correo" class="form-control" value="<%=d!=null&&d.getCorreo()!=null?HtmlUtil.e(d.getCorreo()):""%>"></div>
<div class="col-md-4"><label class="form-label">Especialidad</label><input type="text" name="especialidad" class="form-control" value="<%=d!=null&&d.getEspecialidad()!=null?HtmlUtil.e(d.getEspecialidad()):""%>"></div>
</div>
<div class="mb-4"><label class="form-label">Estado</label><select name="estado" class="form-select" style="max-width:180px"><option value="ACTIVO" <%=d==null||"ACTIVO".equals(d.getEstado())?"selected":""%>>ACTIVO</option><option value="INACTIVO" <%=d!=null&&"INACTIVO".equals(d.getEstado())?"selected":""%>>INACTIVO</option></select></div>
<div class="d-flex gap-2"><button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i><%=ed?"Actualizar":"Registrar"%></button><a href="<%=ctx%>/app/docentes" class="btn btn-outline-secondary">Cancelar</a></div>
</form></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
