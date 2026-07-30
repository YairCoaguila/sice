<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*,util.HtmlUtil" %>
<% List<Aula> aulas=(List<Aula>)request.getAttribute("aulas"); String ctx=request.getContextPath(); String msg=(String)session.getAttribute("msg"); String msgError=(String)session.getAttribute("msgError"); if(aulas==null)aulas=new ArrayList<>(); session.removeAttribute("msg"); session.removeAttribute("msgError"); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Aulas | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item active">Aulas</li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-door-open-fill me-2 text-primary"></i>Aulas</h1><a href="<%=ctx%>/app/aulas?accion=nuevo" class="btn btn-primary"><i class="bi bi-plus-lg me-1"></i>Nueva Aula</a></div>
<%if(msg!=null){%><div class="alert alert-success"><i class="bi bi-check-circle-fill me-2"></i><%=HtmlUtil.e(msg)%></div><%}%>
<%if(msgError!=null){%><div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=HtmlUtil.e(msgError)%></div><%}%>
<div class="card"><div class="card-body p-0">
<div class="table-responsive"><table class="table table-hover align-middle mb-0">
<thead class="table-light"><tr><th>Código</th><th>Capacidad</th><th>Descripción</th><th class="text-end">Acciones</th></tr></thead>
<tbody><%for(Aula a:aulas){%><tr>
<td><strong><%=HtmlUtil.e(a.getCodigo())%></strong></td><td><%=a.getCapacidad()%> asientos</td><td class="text-muted"><%=a.getDescripcion()!=null&&!a.getDescripcion().isBlank()?HtmlUtil.e(a.getDescripcion()):"—"%></td>
<td class="text-end">
<a href="<%=ctx%>/app/aulas?accion=editar&id=<%=a.getId()%>" class="btn btn-sm btn-outline-primary" title="Editar"><i class="bi bi-pencil"></i></a>
<a href="<%=ctx%>/app/aulas?accion=eliminar&id=<%=a.getId()%>" class="btn btn-sm btn-outline-danger" title="Eliminar" onclick="return confirm('¿Eliminar aula?')"><i class="bi bi-trash"></i></a>
</td></tr><%}%>
<%if(aulas.isEmpty()){%><tr><td colspan="4" class="text-center text-muted py-4">No hay aulas registradas.</td></tr><%}%>
</tbody></table></div></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
