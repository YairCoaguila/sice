<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*" %>
<% List<Resultado> ranking=(List<Resultado>)request.getAttribute("ranking"); List<Examen> examenes=(List<Examen>)request.getAttribute("examenes"); List<Grado> grados=(List<Grado>)request.getAttribute("grados"); List<Seccion> secciones=(List<Seccion>)request.getAttribute("secciones"); Integer idExSel=(Integer)request.getAttribute("idExamenSel"); String tipoRanking=(String)request.getAttribute("tipoRanking"); String ctx=request.getContextPath(); String tipoSel=request.getParameter("tipo"); String idGSel=request.getParameter("idGrado"); if(ranking==null)ranking=new ArrayList<>();if(examenes==null)examenes=new ArrayList<>();if(grados==null)grados=new ArrayList<>();if(secciones==null)secciones=new ArrayList<>();if(tipoSel==null)tipoSel="general"; %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Ranking | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<div class="page-header"><div><h1 class="page-title"><i class="bi bi-trophy-fill me-2"></i>Ranking</h1><p class="page-subtitle">Clasificación de alumnos por puntaje</p></div></div>
<div class="card mb-4"><div class="card-body"><form action="<%=ctx%>/app/ranking" method="get" class="row g-3 align-items-end">
<div class="col-md-4"><label class="form-label">Examen *</label><select name="idExamen" class="form-select" required><option value="">Seleccionar...</option><%for(Examen e:examenes){%><option value="<%=e.getId()%>" <%=idExSel!=null&&idExSel.equals(e.getId())?"selected":""%>><%=e.getNombre()%> (<%=e.getPeriodo()%> <%=e.getAnio()%>)</option><%}%></select></div>
<div class="col-md-3"><label class="form-label">Tipo</label><select name="tipo" class="form-select"><option value="general" <%= "general".equals(tipoSel)?"selected":"" %>>Ranking General</option><option value="grado" <%= "grado".equals(tipoSel)?"selected":"" %>>Por Grado</option><option value="seccion" <%= "seccion".equals(tipoSel)?"selected":"" %>>Por Sección</option></select></div>
<div class="col-md-3"><label class="form-label">Grado</label><select name="idGrado" class="form-select"><option value="">Todos</option><%for(Grado g:grados){%><option value="<%=g.getId()%>" <%= idGSel!=null && idGSel.equals(String.valueOf(g.getId()))?"selected":"" %>><%=g.getNombre()%></option><%}%></select></div>
<div class="col-md-2"><button type="submit" class="btn btn-primary w-100"><i class="bi bi-funnel me-1"></i>Generar</button></div>
<div class="col-md-1"><%if(idExSel!=null){%><a href="<%=ctx%>/app/ranking?export=csv&idExamen=<%=idExSel%>&tipo=<%=tipoSel%>&idGrado=<%=idGSel!=null?idGSel:""%>" class="btn btn-success w-100" title="Descargar CSV"><i class="bi bi-download"></i></a><%}%></div>
</form></div></div>
<%if(!ranking.isEmpty()){%>
<div class="card mb-4"><div class="card-header d-flex align-items-center justify-content-between"><span><i class="bi bi-trophy-fill me-2"></i><%= tipoRanking != null ? tipoRanking : "Ranking General" %></span><span class="badge bg-light text-dark fs-6"><%=ranking.size()%> participantes</span></div>
<div class="table-responsive"><table class="table table-hover">
<thead><tr><th width="60">Puesto</th><th>Alumno</th><th>DNI</th><th>Grado / Sección</th><th>Carrera</th><th>Puntaje</th><th>Correctas</th><th>Incorrectas</th><th>%</th></tr></thead>
<tbody><%int pos=1;for(Resultado r:ranking){%><tr class="<%=pos<=3?"table-warning":""%>">
<td class="text-center"><%if(pos==1){%><i class="bi bi-trophy-fill medal-gold fs-5"></i><%}else if(pos==2){%><i class="bi bi-trophy-fill medal-silver fs-5"></i><%}else if(pos==3){%><i class="bi bi-trophy-fill medal-bronze fs-5"></i><%}else{%><span class="fw-bold text-muted"><%=pos%></span><%}%></td>
<td><strong><%=r.getAlumnoNombre()!=null?r.getAlumnoNombre():"—"%></strong></td>
<td><code><%=r.getAlumnoDni()!=null?r.getAlumnoDni():"—"%></code></td>
<td><small><%=r.getSeccionNombre()!=null?r.getSeccionNombre():"—"%></small></td>
<td><small><%=r.getCarreraNombre()!=null?r.getCarreraNombre():"—"%></small></td>
<td><span class="badge bg-primary fs-6"><%=r.getPuntaje()%></span></td>
<td><span class="text-success fw-bold"><%=r.getCorrectas()%></span></td>
<td><span class="text-danger fw-bold"><%=r.getIncorrectas()%></span></td>
<td><%=r.getPorcentaje()%>%</td>
</tr><%pos++;}%></tbody></table></div></div>
<%}else if(idExSel!=null){%><div class="empty-state"><i class="bi bi-trophy"></i><p>No hay resultados para este examen</p></div>
<%}else{%><div class="empty-state"><i class="bi bi-funnel"></i><p>Selecciona un examen para ver el ranking</p></div><%}%>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script></body></html>
