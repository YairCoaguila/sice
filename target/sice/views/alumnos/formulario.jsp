<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.util.*,model.*,util.HtmlUtil" %>
<% Alumno al=(Alumno)request.getAttribute("alumno"); List<Grado> grados=(List<Grado>)request.getAttribute("grados"); List<Seccion> secciones=(List<Seccion>)request.getAttribute("secciones"); List<Carrera> carreras=(List<Carrera>)request.getAttribute("carreras"); boolean ed=al!=null&&al.getId()>0; String ctx=request.getContextPath(); String error=(String)request.getAttribute("error"); if(grados==null)grados=new ArrayList<>();if(secciones==null)secciones=new ArrayList<>();if(carreras==null)carreras=new ArrayList<>();
StringBuilder jsonSecciones=new StringBuilder("[");
for(int i=0;i<secciones.size();i++){Seccion s=secciones.get(i);if(i>0)jsonSecciones.append(",");jsonSecciones.append("{\"id\":").append(s.getId()).append(",\"nombre\":\"").append(s.getNombre().replace("\\","\\\\").replace("\"","\\\"")).append("\",\"idGrado\":").append(s.getIdGrado()).append("}");}
jsonSecciones.append("]");
%>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title><%=ed?"Editar":"Nuevo"%> Alumno | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body><div class="app-shell"><div class="sidebar-overlay" id="sidebarOverlay"></div>
<jsp:include page="../shared/sidebar.jsp"/><div class="main-content w-100"><jsp:include page="../shared/navbar.jsp"/>
<div class="pt-2">
<nav aria-label="breadcrumb" class="mb-3"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%=ctx%>/app/alumnos">Alumnos</a></li><li class="breadcrumb-item active"><%=ed?"Editar":"Nuevo"%></li></ol></nav>
<div class="page-header"><h1 class="page-title"><i class="bi bi-person-plus-fill me-2 text-primary"></i><%=ed?"Editar Alumno":"Nuevo Alumno"%></h1></div>
<%if(error!=null){%><div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i><%=HtmlUtil.e(error)%></div><%}%>
<div class="card" style="max-width:800px"><div class="card-header"><i class="bi bi-person-lines-fill me-2"></i>Datos del Alumno</div><div class="card-body">
<form action="<%=ctx%>/app/alumnos" method="post" autocomplete="off">
<input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
<input type="hidden" name="accion" value="<%=ed?"actualizar":"guardar"%>">
<%if(ed){%><input type="hidden" name="id" value="<%=al.getId()%>"><%}%>
<div class="row g-3 mb-3">
    <div class="col-md-6"><label class="form-label">Apellido Paterno *</label><input type="text" name="apellidoPaterno" class="form-control" required value="<%=al!=null&&al.getApellidoPaterno()!=null?HtmlUtil.e(al.getApellidoPaterno()):""%>"></div>
    <div class="col-md-6"><label class="form-label">Apellido Materno *</label><input type="text" name="apellidoMaterno" class="form-control" required value="<%=al!=null&&al.getApellidoMaterno()!=null?HtmlUtil.e(al.getApellidoMaterno()):""%>"></div>
</div>
<div class="row g-3 mb-3">
    <div class="col-md-8"><label class="form-label">Nombres *</label><input type="text" name="nombres" class="form-control" required value="<%=al!=null&&al.getNombres()!=null?HtmlUtil.e(al.getNombres()):""%>"></div>
    <div class="col-md-4"><label class="form-label">DNI *</label><input type="text" name="dni" class="form-control" maxlength="8" required value="<%=al!=null&&al.getDni()!=null?HtmlUtil.e(al.getDni()):""%>"></div>
</div>
<div class="row g-3 mb-3">
    <div class="col-md-4"><label class="form-label">Fecha Nacimiento</label><input type="date" name="fechaNacimiento" class="form-control" value="<%=al!=null&&al.getFechaNacimiento()!=null?al.getFechaNacimiento().toString():""%>"></div>
    <div class="col-md-4"><label class="form-label">Celular</label><input type="text" name="celular" class="form-control" value="<%=al!=null&&al.getCelular()!=null?HtmlUtil.e(al.getCelular()):""%>"></div>
    <div class="col-md-4"><label class="form-label">Dirección</label><input type="text" name="direccion" class="form-control" value="<%=al!=null&&al.getDireccion()!=null?HtmlUtil.e(al.getDireccion()):""%>"></div>
    <div class="col-md-4"><label class="form-label">Colegio</label><input type="text" name="colegio" class="form-control" placeholder="Ej: San José" value="<%=al!=null&&al.getColegio()!=null?HtmlUtil.e(al.getColegio()):""%>"></div>
</div>
<hr class="my-3">
<div class="row g-3 mb-4">
    <div class="col-md-4"><label class="form-label">Grado *</label><select id="gradoSelect" name="idGrado" class="form-select" required><option value="">Seleccionar...</option><%for(Grado g:grados){%><option value="<%=g.getId()%>" <%=al!=null&&al.getIdGrado()==g.getId()?"selected":""%>><%=HtmlUtil.e(g.getNombre())%></option><%}%></select></div>
    <div class="col-md-4"><label class="form-label">Sección *</label><select id="seccionSelect" name="idSeccion" class="form-select" required><option value="">Primero selecciona un grado</option><%for(Seccion s:secciones){%><option value="<%=s.getId()%>" <%=al!=null&&al.getIdSeccion()==s.getId()?"selected":""%>><%=HtmlUtil.e(s.getNombre())%></option><%}%></select></div>
    <div class="col-md-4"><label class="form-label">Carrera *</label><select name="idCarrera" class="form-select" required><option value="">Seleccionar...</option><%for(Carrera c:carreras){%><option value="<%=c.getId()%>" <%=al!=null&&al.getIdCarrera()==c.getId()?"selected":""%>><%=HtmlUtil.e(c.getNombre())%></option><%}%></select></div>
</div>
<div class="d-flex gap-2"><button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i><%=ed?"Actualizar":"Registrar"%></button><a href="<%=ctx%>/app/alumnos" class="btn btn-outline-secondary">Cancelar</a></div>
</form></div></div>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/assets/js/main.js"></script>
<script>
var secciones=<%=jsonSecciones%>;
document.getElementById('gradoSelect').addEventListener('change',function(){
    var gId=parseInt(this.value); var sel=document.getElementById('seccionSelect'); sel.innerHTML='';
    if(isNaN(gId)){sel.innerHTML='<option value="">Seleccionar...</option>';return;}
    var filt=secciones.filter(function(s){return s.idGrado===gId;});
    sel.innerHTML='<option value="">Seleccionar...</option>';
    filt.forEach(function(s){var o=document.createElement('option');o.value=s.id;o.textContent=s.nombre;sel.appendChild(o);});
});
<% if(ed && al!=null){ %>document.getElementById('gradoSelect').dispatchEvent(new Event('change'));
document.getElementById('seccionSelect').value='<%=al.getIdSeccion()%>';<% } %>
</script></body></html>
