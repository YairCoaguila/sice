<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="util.HtmlUtil" %>
<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inscripción Simulacro | San José</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/assets/css/merced.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
            overflow: hidden;
        }
        body.merced-page {
            position: relative;
            animation: fadeIn 0.8s ease-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .login-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 0;
            overflow: hidden;
        }
        .login-bg img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
            animation: subtleZoom 20s ease-in-out infinite alternate;
        }
        @keyframes subtleZoom {
            from { transform: scale(1); }
            to { transform: scale(1.06); }
        }
        .login-bg::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
        }
        .login-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 1;
            background: rgba(255, 255, 255, 0.5);
        }
        .merced-header {
            position: relative;
            z-index: 2;
        }
        .merced-main--center {
            position: relative;
            z-index: 2;
            justify-content: center;
            padding: 20px;
            height: calc(100vh - 130px);
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .merced-main--center .merced-title,
        .merced-main--center .merced-subtitle {
            text-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .merced-main--center .merced-title {
            color: #1e293b;
        }
        .merced-main--center .merced-subtitle {
            color: #475569;
        }
        .merced-search {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: 16px;
            padding: 28px 32px;
            box-shadow: 0 8px 40px rgba(0, 0, 0, 0.08), 0 1px 4px rgba(0, 0, 0, 0.04);
            max-width: 520px;
            width: 100%;
            transition: box-shadow 0.3s ease;
        }
        .merced-search:hover {
            box-shadow: 0 12px 48px rgba(0, 0, 0, 0.12), 0 1px 4px rgba(0, 0, 0, 0.04);
        }
        .merced-search .form-control {
            border: 1px solid rgba(0, 0, 0, 0.08);
            background: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
            padding: 13px 18px;
            font-size: 1rem;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .merced-search .form-control:focus {
            border-color: var(--merced-red);
            box-shadow: 0 0 0 3px rgba(30, 58, 95, 0.12);
            background: white;
        }
        .merced-search .merced-btn {
            border-radius: 10px;
            padding: 13px 32px;
            font-weight: 500;
            letter-spacing: 0.3px;
        }
        .merced-alert-box {
            max-width: 520px;
            width: 100%;
        }
        .merced-alert-box .alert {
            border-radius: 12px;
            border: none;
            box-shadow: 0 2px 12px rgba(0,0,0,0.04);
        }
        .merced-link {
            color: #475569;
            font-weight: 500;
            text-decoration: none;
            padding: 6px 14px;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
            transition: background 0.2s, color 0.2s;
        }
        .merced-link:hover {
            background: rgba(255, 255, 255, 0.85);
            color: var(--merced-red);
        }
        .merced-footer {
            position: relative;
            z-index: 2;
            margin: 0 40px 12px;
            padding: 12px 20px;
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
            border-radius: 12px;
            border: none;
        }
        @media (max-width: 576px) {
            body.merced-page { overflow: auto; }
            .merced-main--center { height: auto; min-height: calc(100vh - 130px); padding: 16px; }
            .merced-search { padding: 20px; }
            .merced-footer { margin: 0 16px 12px; }
        }
        [data-bs-theme=dark] .login-overlay { background: rgba(0,0,0,0.5); }
        [data-bs-theme=dark] .merced-main--center .merced-title { color: var(--merced-text); }
        [data-bs-theme=dark] .merced-main--center .merced-subtitle { color: var(--merced-muted); }
        [data-bs-theme=dark] .merced-search { background: rgba(30,41,59,0.92); border-color: var(--merced-border); }
        [data-bs-theme=dark] .merced-search .form-control { background: #0f172a; border-color: var(--merced-border); color: var(--merced-text); }
        [data-bs-theme=dark] .merced-search .form-control:focus { background: #0f172a; border-color: var(--merced-red); }
        [data-bs-theme=dark] .merced-link { background: rgba(30,41,59,0.6); color: var(--merced-muted); }
        [data-bs-theme=dark] .merced-link:hover { background: rgba(30,41,59,0.9); color: var(--merced-red); }
        [data-bs-theme=dark] .merced-footer { background: rgba(30,41,59,0.6); }
    </style>
</head>
<body class="merced-page">

    <div class="login-bg">
        <img src="https://images.unsplash.com/photo-1524178232363-1fb2b075b655?auto=format&fit=crop&w=1920&q=80"
             alt="Salón de clases"
             loading="lazy">
    </div>
    <div class="login-overlay"></div>

    <jsp:include page="../shared/merced-header.jsp"/>

    <main class="merced-main merced-main--center">
        <h1 class="merced-title">Inscripción de Exámenes</h1>

        <div class="merced-alert-box">
            <% if (error != null) { %>
                <div class="alert alert-danger"><i class="bi bi-exclamation-circle-fill me-2"></i><%= HtmlUtil.e(error) %></div>
            <% } %>
            <% if (success != null) { %>
                <div class="alert alert-success"><i class="bi bi-check-circle-fill me-2"></i><%= HtmlUtil.e(success) %></div>
            <% } %>
        </div>

        <form action="<%= request.getContextPath() %>/estudiante/login" method="post" autocomplete="off" class="merced-search">
            <input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
            <input type="text" name="dni" class="form-control" placeholder="Ingresa tu DNI" required pattern="[0-9]{8}" maxlength="8" autofocus>
            <button type="submit" class="merced-btn"><i class="bi bi-search me-2"></i>Buscar</button>
        </form>

        <div class="mt-4">
            <a href="<%= request.getContextPath() %>/login" class="merced-link">
                <i class="bi bi-arrow-left me-1"></i> Acceso Administrativo
            </a>
        </div>
    </main>

    <jsp:include page="../shared/merced-footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
