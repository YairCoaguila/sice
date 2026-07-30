<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>404 | San José</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/assets/css/merced.css" rel="stylesheet">
</head>
<body class="merced-page">

    <jsp:include page="merced-header.jsp"/>

    <main class="merced-main merced-main--center">
        <div class="merced-error-box">
            <div class="merced-error-code">404</div>
            <i class="bi bi-search" style="font-size:3rem;color:var(--merced-red);display:block;margin:12px 0"></i>
            <h2 class="fw-bold mb-2">Página no encontrada</h2>
            <p class="text-muted mb-4">La página que buscas no existe o fue movida.</p>
            <a href="<%= request.getContextPath() %>/login" class="merced-btn merced-btn--red">
                <i class="bi bi-house-fill me-1"></i>Ir al Inicio
            </a>
        </div>
    </main>

    <jsp:include page="merced-footer.jsp"/>
</body>
</html>
