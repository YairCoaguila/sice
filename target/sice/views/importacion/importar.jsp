<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*" %>
<% String ctx=request.getContextPath(); String titulo=(String)request.getAttribute("titulo"); String columnas=(String)request.getAttribute("columnas"); String error=(String)request.getAttribute("error"); Integer insertados=(Integer)request.getAttribute("insertados"); Integer omitidos=(Integer)request.getAttribute("omitidos"); List<String> errores=(List<String>)request.getAttribute("errores"); String tipo=(String)request.getAttribute("tipo"); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title><%=titulo!=null?titulo:"Importar"%> | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/<%=tipo%>"><%=tipo!=null&&tipo.equals("alumnos")?"Alumnos":"Docentes"%></a></li><li class="breadcrumb-item active">Importar CSV</li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-upload me-2 text-primary"></i><%=titulo!=null?titulo:"Importar"%></h1></div>

<%if(insertados!=null){%>
<div class="row g-3 mb-4">
<div class="col-md-4"><div class="stat-card"><div class="stat-icon stat-icon-green"><i class="bi bi-check-circle-fill"></i></div><div><div class="stat-value"><%=insertados%></div><div class="stat-label">Importados</div></div></div></div>
<div class="col-md-4"><div class="stat-card"><div class="stat-icon stat-icon-amber"><i class="bi bi-skip-forward-fill"></i></div><div><div class="stat-value"><%=omitidos!=null?omitidos:0%></div><div class="stat-label">Omitidos (duplicados)</div></div></div></div>
<div class="col-md-4"><div class="stat-card"><div class="stat-icon stat-icon-red"><i class="bi bi-x-circle-fill"></i></div><div><div class="stat-value"><%=errores!=null?errores.size():0%></div><div class="stat-label">Errores</div></div></div></div>
</div>
<%if(errores!=null&&!errores.isEmpty()){%><div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i><ul class="mb-0"><%for(String e:errores){%><li><%=e%></li><%}%></ul></div><%}%>
<a href="<%=ctx%>/app/<%=tipo%>" class="btn btn-primary"><i class="bi bi-arrow-left me-1"></i>Volver a <%=tipo!=null&&tipo.equals("alumnos")?"Alumnos":"Docentes"%></a>
<%}else{%>
<div class="row justify-content-center"><div class="col-md-7">
<div class="card"><div class="card-body p-4">
<%if(error!=null){%><div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=error%></div><%}%>
<div class="alert alert-info"><i class="bi bi-info-circle-fill me-2"></i>El archivo debe ser CSV con codificación UTF-8 y la primera fila debe contener las cabeceras. <strong>Columnas esperadas:</strong><br><code><%=columnas%></code></div>
<form action="<%=ctx%>/app/importar" method="post" enctype="multipart/form-data">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<input type="hidden" name="tipo" value="<%=tipo%>">
<div class="mb-4"><label class="form-label">Seleccionar archivo CSV</label><input type="file" name="archivo" class="form-control" accept=".csv" required></div>
<button type="submit" class="btn btn-primary w-100"><i class="bi bi-upload me-1"></i>Importar</button>
</form></div></div></div></div>
<%}%>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
