<%@ page contentType="text/html;charset=UTF-8" %><%@ page import="model.Alumno,util.HtmlUtil" %>
<% Alumno alumno = (Alumno) session.getAttribute("estudiante"); if (alumno == null) { response.sendRedirect(request.getContextPath() + "/estudiante/login"); return; } String ctx = request.getContextPath(); String msg = (String) session.getAttribute("msg"); String error = (String) session.getAttribute("error"); session.removeAttribute("msg"); session.removeAttribute("error"); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Mi Perfil | San José</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%= ctx %>/assets/css/merced.css" rel="stylesheet"></head>
<body class="merced-page">
<jsp:include page="../shared/merced-header.jsp"/>
<main class="merced-main">
<h1 class="merced-title"><i class="bi bi-person-gear me-2"></i>Mi Perfil</h1>
<h2 class="merced-subtitle">Actualiza tus datos de contacto</h2>

<div class="merced-user-bar" style="justify-content:flex-end">
    <a href="<%= ctx %>/estudiante/dashboard" class="merced-btn merced-btn--outline" style="padding:8px 20px;font-size:.85rem;border-color:white;color:white">
        <i class="bi bi-arrow-left"></i> Volver al Panel
    </a>
</div>

<div class="merced-content-wide">
    <% if (msg != null) { %><div class="alert alert-success alert-dismissible fade show"><i class="bi bi-check-circle-fill me-2"></i><%= HtmlUtil.e(msg) %><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><% } %>
    <% if (error != null) { %><div class="alert alert-danger alert-dismissible fade show"><i class="bi bi-exclamation-triangle-fill me-2"></i><%= HtmlUtil.e(error) %><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><% } %>

    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <div class="text-center mb-4">
                        <i class="bi bi-person-circle" style="font-size:4rem;color:var(--merced-red)"></i>
                        <h5 class="mt-2 fw-bold"><%= HtmlUtil.e(alumno.getNombres()) %> <%= HtmlUtil.e(alumno.getApellidoPaterno()) %> <%= HtmlUtil.e(alumno.getApellidoMaterno()) %></h5>
                        <span class="badge" style="background:var(--merced-red)"><%= alumno.getDni() %></span>
                    </div>

                    <form action="<%= ctx %>/estudiante/perfil" method="post" autocomplete="off">
                        <input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Nombres</label>
                            <input type="text" class="form-control" value="<%= HtmlUtil.e(alumno.getNombres()) %>" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Apellidos</label>
                            <input type="text" class="form-control" value="<%= HtmlUtil.e(alumno.getApellidoPaterno()) %> <%= HtmlUtil.e(alumno.getApellidoMaterno()) %>" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">DNI</label>
                            <input type="text" class="form-control" value="<%= alumno.getDni() %>" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Fecha de Nacimiento</label>
                            <input type="date" name="fechaNacimiento" class="form-control" value="<%= HtmlUtil.e(alumno.getFechaNacimiento() != null ? alumno.getFechaNacimiento().toString() : "") %>">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Celular</label>
                            <input type="text" name="celular" class="form-control" value="<%= HtmlUtil.e(alumno.getCelular() != null ? alumno.getCelular() : "") %>">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Direcci&oacute;n</label>
                            <input type="text" name="direccion" class="form-control" value="<%= HtmlUtil.e(alumno.getDireccion() != null ? alumno.getDireccion() : "") %>">
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Colegio</label>
                            <input type="text" name="colegio" class="form-control" value="<%= HtmlUtil.e(alumno.getColegio() != null ? alumno.getColegio() : "") %>">
                        </div>
                        <button type="submit" class="merced-btn merced-btn--red" style="width:100%;padding:10px">
                            <i class="bi bi-check-lg me-1"></i>Guardar Cambios
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</main>
<jsp:include page="../shared/merced-footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>