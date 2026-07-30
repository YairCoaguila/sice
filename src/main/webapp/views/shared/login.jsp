<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Acceso Administrativo | San José</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/assets/css/merced.css" rel="stylesheet">
</head>
<body class="merced-page">

    <jsp:include page="merced-header.jsp"/>

    <main class="merced-main merced-main--center">
        <h1 class="merced-title">Acceso Administrativo</h1>
        <h2 class="merced-subtitle">Sistema Integral de Calificación de Exámenes</h2>

        <div class="merced-alert-box">
            <%
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");
                if (error != null) {
            %>
            <div class="alert alert-danger"><i class="bi bi-exclamation-circle-fill me-2"></i><%= HtmlUtil.e(error) %></div>
            <% } if (success != null) { %>
            <div class="alert alert-success"><i class="bi bi-check-circle-fill me-2"></i><%= HtmlUtil.e(success) %></div>
            <% } %>
        </div>

        <div class="merced-login-card">
            <form action="<%= request.getContextPath() %>/login" method="post" autocomplete="off">
                <input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
                <div class="form-group">
                    <label class="form-label" for="username"><i class="bi bi-person me-1"></i>Usuario</label>
                    <div class="input-group-merced">
                        <span class="input-icon"><i class="bi bi-person"></i></span>
                        <input type="text" name="username" id="username" class="form-control-merced"
                               placeholder="nombre.usuario" required autofocus
                               value="<%= request.getParameter("username") != null ? request.getParameter("username").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") : "" %>">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password"><i class="bi bi-lock me-1"></i>Contraseña</label>
                    <div class="input-group-merced">
                        <span class="input-icon"><i class="bi bi-key"></i></span>
                        <input type="password" name="password" id="password" class="form-control-merced" placeholder="••••••••" required>
                        <button type="button" class="password-toggle" onclick="togglePassword()" aria-label="Mostrar/ocultar contraseña">
                            <i class="bi bi-eye" id="toggleIcon"></i>
                        </button>
                    </div>
                </div>

                <div class="merced-login-options">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="remember" name="remember">
                        <label class="form-check-label" for="remember">Recordarme</label>
                    </div>
                </div>

                <button type="submit" class="merced-btn merced-btn--red merced-btn--full">
                    <i class="bi bi-box-arrow-in-right me-1"></i> Iniciar sesión
                </button>
            </form>
        </div>

        <div class="mt-4 text-center">
            <p class="mb-0" style="font-size:.85rem;color:var(--merced-muted)">
                <i class="bi bi-person me-1"></i> ¿Eres estudiante?
                <a href="<%= request.getContextPath() %>/estudiante/login" class="merced-link--accent">Inscríbete aquí</a>
            </p>
        </div>
    </main>

    <jsp:include page="merced-footer.jsp"/>

    <script>
        function togglePassword() {
            const input = document.getElementById('password');
            const icon = document.getElementById('toggleIcon');
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'bi bi-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'bi bi-eye';
            }
        }
    </script>
</body>
</html>
