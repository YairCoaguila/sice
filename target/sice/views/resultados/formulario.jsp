<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*" %>
<% Resultado res=(Resultado)request.getAttribute("res"); boolean ed=res!=null&&res.getId()>0; List<Examen> examenes=(List<Examen>)request.getAttribute("examenes"); List<Alumno> alumnos=(List<Alumno>)request.getAttribute("alumnos"); List<Inscripcion> inscripciones=(List<Inscripcion>)request.getAttribute("inscripciones"); String ctx=request.getContextPath(); String error=(String)request.getAttribute("error"); if(examenes==null)examenes=new ArrayList<>();if(alumnos==null)alumnos=new ArrayList<>();if(inscripciones==null)inscripciones=new ArrayList<>();
StringBuilder jsonIns=new StringBuilder("[");
for(int i=0;i<inscripciones.size();i++){Inscripcion ins=inscripciones.get(i);if(i>0)jsonIns.append(",");jsonIns.append("{\"idExamen\":").append(ins.getIdExamen()).append(",\"idAlumno\":").append(ins.getIdAlumno()).append(",\"nombre\":\"").append(ins.getAlumnoNombre().replace("\\","\\\\").replace("\"","\\\"")).append("\",\"dni\":\"").append(ins.getAlumnoDni().replace("\\","\\\\").replace("\"","\\\"")).append("\"}");}
jsonIns.append("]");
%>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title><%=ed?"Editar":"Registrar"%> Resultado | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/resultados">Resultados</a></li><li class="breadcrumb-item active"><%=ed?"Editar":"Registrar"%></li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-bar-chart-fill me-2 text-primary"></i><%=ed?"Editar Resultado":"Registrar Resultado"%></h1></div>
<%if(error!=null){%><div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=error%></div><%}%>
<div class="card" style="max-width:600px"><div class="card-header"><i class="bi bi-clipboard-data me-2"></i>Datos del Resultado</div><div class="card-body">
<div class="alert alert-info mb-4"><i class="bi bi-info-circle-fill me-2"></i>El puntaje se calcula automáticamente según las respuestas correctas.</div>
<form action="<%=ctx%>/app/resultados" method="post" autocomplete="off">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<%if(ed){%><input type="hidden" name="id" value="<%=res.getId()%>"><%}%>
<div class="mb-3"><label class="form-label">Examen *</label><select name="idExamen" id="selExamen" class="form-select" required <%=ed?"disabled":""%> onchange="calcular()"><option value="">Seleccionar...</option><%for(Examen e:examenes){%><option value="<%=e.getId()%>" data-total="<%=e.getCantidadPreguntas()%>" data-pts="<%=e.getPuntajeTotal()%>" <%=ed&&res.getIdExamen()==e.getId()?"selected":""%>><%=e.getNombre()%> (<%=e.getPeriodo()%> <%=e.getAnio()%>) — <%=e.getCantidadPreguntas()%> preguntas</option><%}%></select>
<%if(ed){%><input type="hidden" name="idExamen" value="<%=res.getIdExamen()%>"><%}%></div>
<div class="mb-3"><label class="form-label">Alumno *</label><select name="idAlumno" id="selAlumno" class="form-select" required <%=ed?"disabled":""%>><option value="">Primero selecciona un examen</option></select>
<%if(ed){%><input type="hidden" name="idAlumno" value="<%=res.getIdAlumno()%>"><%}%></div>
<div class="row g-3 mb-3">
<div class="col-md-4"><label class="form-label">Correctas *</label><input type="number" name="correctas" id="cor" class="form-control" min="0" value="<%=ed?res.getCorrectas():0%>" required oninput="calcular()"></div>
<div class="col-md-4"><label class="form-label">Incorrectas *</label><input type="number" name="incorrectas" id="inc" class="form-control" min="0" value="<%=ed?res.getIncorrectas():0%>" required oninput="calcular()"></div>
<div class="col-md-4"><label class="form-label">En Blanco *</label><input type="number" name="enBlanco" id="bl" class="form-control" min="0" value="<%=ed?res.getEnBlanco():0%>" required oninput="calcular()"></div>
</div>
<div class="card mb-4" style="background:#f0fdf4;border-color:#bbf7d0" id="cardResult"><div class="card-body py-3"><div class="row text-center">
<div class="col-4"><div class="text-muted" style="font-size:.75rem;text-transform:uppercase;font-weight:700">Respuestas</div><div id="prvSuma" class="fw-bold fs-3">0 / 0</div></div>
<div class="col-4"><div class="text-muted" style="font-size:.75rem;text-transform:uppercase;font-weight:700">Puntaje</div><div id="prvPts" class="fw-bold text-success fs-3">0.00</div></div>
<div class="col-4"><div class="text-muted" style="font-size:.75rem;text-transform:uppercase;font-weight:700">Porcentaje</div><div id="prvPct" class="fw-bold text-primary fs-3">0%</div></div>
</div></div></div>
<div class="d-flex gap-2"><button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i><%=ed?"Actualizar":"Guardar"%> Resultado</button><a href="<%=ctx%>/app/resultados" class="btn btn-outline-secondary">Cancelar</a></div>
</form></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script>
<script>
var inscripciones=<%=jsonIns%>;
function filtrarAlumnos(){var ex=parseInt(document.getElementById('selExamen').value);var sel=document.getElementById('selAlumno');sel.innerHTML='';if(isNaN(ex)){sel.innerHTML='<option value="">Primero selecciona un examen</option>';return;}var filt=inscripciones.filter(function(i){return i.idExamen===ex;});if(filt.length===0){sel.innerHTML='<option value="">No hay alumnos inscritos</option>';return;}sel.innerHTML='<option value="">Seleccionar...</option>';filt.forEach(function(i){var o=document.createElement('option');o.value=i.idAlumno;o.textContent=i.nombre+' - '+i.dni;sel.appendChild(o);});}
document.getElementById('selExamen').addEventListener('change',filtrarAlumnos);
function calcular(){var sel=document.getElementById('selExamen');var opt=sel.options[sel.selectedIndex];if(!opt||!opt.value){document.getElementById('prvSuma').textContent='0 / 0';document.getElementById('prvPts').textContent='0.00';document.getElementById('prvPct').textContent='0%';return;}var pts=parseFloat(opt.dataset.pts||100);var tot=parseInt(opt.dataset.total||100);var cor=parseInt(document.getElementById('cor').value)||0;var inc=parseInt(document.getElementById('inc').value)||0;var bl=parseInt(document.getElementById('bl').value)||0;var suma=cor+inc+bl;var pp=tot>0?pts/tot:1;var p=cor*pp;var pct=pts>0?p/pts*100:0;document.getElementById('prvSuma').textContent=suma+' / '+tot;document.getElementById('prvPts').textContent=p.toFixed(2);document.getElementById('prvPct').textContent=pct.toFixed(1)+'%';var c=document.getElementById('cardResult');if(suma>tot){c.style.backgroundColor='#fef2f2';c.style.borderColor='#fecaca';document.getElementById('prvSuma').classList.add('text-danger');}else if(suma<tot){c.style.backgroundColor='#fffbeb';c.style.borderColor='#fde68a';document.getElementById('prvSuma').classList.remove('text-danger');}else{c.style.backgroundColor='#f0fdf4';c.style.borderColor='#bbf7d0';document.getElementById('prvSuma').classList.remove('text-danger');}}
document.addEventListener('DOMContentLoaded',function(){calcular();filtrarAlumnos();
<%if(ed){%>var s=document.getElementById('selAlumno');s.value='<%=res.getIdAlumno()%>';<%}%>});
</script>
</body></html>
