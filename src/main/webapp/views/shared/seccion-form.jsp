<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*" %>
<% Seccion s=(Seccion)request.getAttribute("seccion"); List<Grado> grados=(List<Grado>)request.getAttribute("grados"); boolean ed=s!=null&&s.getId()>0; String ctx=request.getContextPath(); if(grados==null)grados=new ArrayList<>(); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title><%=ed?"Editar":"Nueva"%> Sección | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="sidebar.jsp"/><div class="main-content w-100"><jsp:include page="navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/secciones">Secciones</a></li><li class="breadcrumb-item active"><%=ed?"Editar":"Nueva"%></li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-grid-3x3-gap-fill me-2 text-primary"></i><%=ed?"Editar":"Nueva"%> Sección</h1></div>
<div class="card" style="max-width:480px"><div class="card-body">
<form action="<%=ctx%>/app/secciones" method="post">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<%if(ed){%><input type="hidden" name="id" value="<%=s.getId()%>"><%}%>
<div class="mb-3"><label class="form-label">Nombre *</label><input type="text" name="nombre" class="form-control" required maxlength="10" placeholder="Ej: A, B, C" value="<%=s!=null&&s.getNombre()!=null?s.getNombre():""%>"></div>
<div class="mb-4"><label class="form-label">Grado *</label><select name="idGrado" class="form-select" required><option value="">Seleccionar...</option><%for(Grado gr:grados){%><option value="<%=gr.getId()%>" <%=s!=null&&s.getIdGrado()==gr.getId()?"selected":""%>><%=gr.getNombre()%></option><%}%></select></div>
<div class="d-flex gap-2"><button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i><%=ed?"Actualizar":"Guardar"%></button><a href="<%=ctx%>/app/secciones" class="btn btn-outline-secondary">Cancelar</a></div>
</form></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
