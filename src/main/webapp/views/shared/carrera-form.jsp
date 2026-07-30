<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*" %>
<% Carrera c=(Carrera)request.getAttribute("carrera"); List<Area> areas=(List<Area>)request.getAttribute("areas"); boolean ed=c!=null&&c.getId()>0; String ctx=request.getContextPath(); if(areas==null)areas=new ArrayList<>(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title><%=ed?"Editar":"Nueva"%> Carrera | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="sidebar.jsp"/><div class="main-content w-100"><jsp:include page="navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/carreras">Carreras</a></li><li class="breadcrumb-item active"><%=ed?"Editar":"Nueva"%></li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-building-fill me-2 text-primary"></i><%=ed?"Editar":"Nueva"%> Carrera</h1></div>
<div class="card" style="max-width:560px"><div class="card-body">
<form action="<%=ctx%>/app/carreras" method="post">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<%if(ed){%><input type="hidden" name="id" value="<%=c.getId()%>"><%}%>
<div class="mb-3"><label class="form-label">Nombre *</label><input type="text" name="nombre" class="form-control" required value="<%=c!=null&&c.getNombre()!=null?c.getNombre():""%>"></div>
<div class="mb-3"><label class="form-label">Área *</label><select name="idArea" class="form-select" required><option value="">Seleccionar...</option><%for(Area a:areas){%><option value="<%=a.getId()%>" <%=c!=null&&c.getIdArea()==a.getId()?"selected":""%>><%=a.getNombre()%></option><%}%></select></div>
<div class="mb-4"><label class="form-label">Descripción</label><textarea name="descripcion" class="form-control" rows="2"><%=c!=null&&c.getDescripcion()!=null?c.getDescripcion():""%></textarea></div>
<div class="d-flex gap-2"><button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i><%=ed?"Actualizar":"Guardar"%></button><a href="<%=ctx%>/app/carreras" class="btn btn-outline-secondary">Cancelar</a></div>
</form></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
