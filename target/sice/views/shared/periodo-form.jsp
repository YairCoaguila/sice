<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="model.Periodo" %>
<% Periodo p=(Periodo)request.getAttribute("periodo"); boolean ed=p!=null&&p.getId()>0; String ctx=request.getContextPath(); int anio=java.time.Year.now().getValue(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title><%=ed?"Editar":"Nuevo"%> Periodo | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="sidebar.jsp"/><div class="main-content w-100"><jsp:include page="navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/periodos">Periodos</a></li><li class="breadcrumb-item active"><%=ed?"Editar":"Nuevo"%></li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-calendar3 me-2 text-primary"></i><%=ed?"Editar":"Nuevo"%> Periodo</h1></div>
<div class="card" style="max-width:520px"><div class="card-body">
<form action="<%=ctx%>/app/periodos" method="post">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<%if(ed){%><input type="hidden" name="id" value="<%=p.getId()%>"><%}%>
<div class="row g-3 mb-3">
<div class="col-md-8"><label class="form-label">Nombre *</label><select name="nombre" class="form-select" required><option value="Periodo 1" <%=p==null||"Periodo 1".equals(p.getNombre())?"selected":""%>>Periodo 1</option><option value="Periodo 2" <%=p!=null&&"Periodo 2".equals(p.getNombre())?"selected":""%>>Periodo 2</option></select></div>
<div class="col-md-4"><label class="form-label">Año *</label><input type="number" name="anio" class="form-control" required min="2020" max="2099" value="<%=p!=null?p.getAnio():anio%>"></div>
</div>
<div class="mb-3"><label class="form-label">Descripción</label><input type="text" name="descripcion" class="form-control" value="<%=p!=null&&p.getDescripcion()!=null?p.getDescripcion():""%>"></div>
<div class="mb-4"><div class="form-check"><input class="form-check-input" type="checkbox" name="activo" id="activo" <%=p==null||p.isActivo()?"checked":""%>><label class="form-check-label" for="activo"><strong>Periodo activo</strong></label></div></div>
<div class="d-flex gap-2"><button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i><%=ed?"Actualizar":"Guardar"%></button><a href="<%=ctx%>/app/periodos" class="btn btn-outline-secondary">Cancelar</a></div>
</form></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
