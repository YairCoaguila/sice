<%@ page contentType="text/html;charset=UTF-8" language="java" %><% String ctx=request.getContextPath(); String error=(String)request.getAttribute("error"); %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Acceso Denegado | SICE</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="<%=ctx%>/assets/css/main.css" rel="stylesheet"></head>
<body class="d-flex align-items-center" style="min-height:100vh;background:var(--bg);color:var(--text)"><div class="container text-center">
<div class="mb-4"><i class="bi bi-shield-exclamation" style="font-size:5rem;color:var(--bs-danger)"></i></div>
<h1 class="display-4 fw-bold text-danger mb-3">403</h1>
<h3 class="mb-3">Acceso Denegado</h3>
<p class="text-muted mb-4"><%=error!=null?error:"No tienes permisos para acceder a esta página."%></p>
<a href="<%=ctx%>/app/dashboard" class="btn btn-primary"><i class="bi bi-house-door-fill me-1"></i>Ir al Dashboard</a>
</div></body></html>
