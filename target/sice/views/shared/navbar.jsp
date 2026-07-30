<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Usuario,util.HtmlUtil" %>
<%
Usuario cu = (Usuario) request.getAttribute("currentUser");
String ctx = request.getContextPath();
%>
<nav id="topNavbar">
    <button class="btn btn-sm d-lg-none" id="sidebarToggleMobile" style="border:none;background:transparent;color:var(--primary)">
        <i class="bi bi-list fs-5"></i>
    </button>
    <div class="brand-logo ms-2"><i class="bi bi-shield-shaded"></i></div>
        <div class="d-none d-md-block">
            <div class="brand-text" style="margin-left:0;line-height:1.1">SAN JOSÉ</div>
            <div style="font-size:.68rem;color:var(--muted);letter-spacing:1px;margin-left:10px">Sistema Integral de Calificación · Juliaca</div>
        </div>
    <div class="ms-auto d-flex align-items-center gap-3">
        <button id="darkModeToggle" class="btn btn-sm" style="border:1px solid var(--primary-light);border-radius:8px;padding:5px 10px;background:var(--primary-light);color:var(--primary)" title="Modo oscuro">
            <i class="bi bi-moon-fill"></i>
        </button>
        <% if (cu != null) { %>
        <span class="badge-rol badge-rol-<%= cu.getRol().toLowerCase() %> d-none d-sm-inline-flex">
            <i class="bi bi-<%= cu.isAdmin() ? "shield-fill" : cu.isDocente() ? "person-badge-fill" : "keyboard" %>"></i>
            <%= HtmlUtil.e(cu.getRol().substring(0, 1).toUpperCase() + cu.getRol().substring(1)) %>
        </span>
        <div class="dropdown">
            <button class="btn d-flex align-items-center gap-2" style="border:1px solid var(--primary-light);border-radius:8px;padding:5px 12px;background:var(--primary-light)" data-bs-toggle="dropdown">
                <div class="avatar-circle"><%= HtmlUtil.e(cu.getUsername().substring(0, 1).toUpperCase()) %></div>
                <span class="d-none d-md-inline" style="font-size:.875rem;color:var(--primary);font-weight:600"><%= HtmlUtil.e(cu.getUsername()) %></span>
                <i class="bi bi-chevron-down" style="font-size:.7rem;color:var(--primary)"></i>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                <li><h6 class="dropdown-header" style="color:var(--primary)"><i class="bi bi-person-circle me-1"></i><%= HtmlUtil.e(cu.getUsername()) %></h6></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-danger" href="<%= ctx %>/logout"><i class="bi bi-box-arrow-right me-2"></i>Cerrar Sesión</a></li>
            </ul>
        </div>
        <% } %>
    </div>
</nav>
