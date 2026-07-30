<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Usuario" %>
<%
String ctx = request.getContextPath();
String uri = request.getRequestURI();
Usuario _usr = (Usuario) request.getAttribute("currentUser");
boolean _isAdmin = _usr != null && "administrador".equals(_usr.getRol());
boolean _isDigitador = _usr != null && "digitador".equals(_usr.getRol());
%>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo"><i class="bi bi-shield-shaded"></i></div>
        <div>
            <div class="sidebar-subtitle" style="font-size:.65rem;letter-spacing:1px;text-transform:uppercase">I.E.P.</div>
            <div class="sidebar-title">SAN JOSÉ</div>
            <div class="sidebar-subtitle" style="font-size:.68rem;letter-spacing:2px">JULIACA · SICE</div>
        </div>
        <button class="btn btn-sm ms-auto d-lg-none" id="sidebarClose" style="color:rgba(255,255,255,.6);background:transparent;border:none">
            <i class="bi bi-x-lg"></i>
        </button>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-label">Principal</div>
        <a href="<%=ctx%>/app/dashboard" class="nav-item <%= uri.contains("/dashboard") ? "active" : "" %>">
            <i class="bi bi-speedometer2"></i><span>Dashboard</span>
        </a>
        
        <div class="nav-label">Académico</div>
        <a href="<%=ctx%>/app/alumnos" class="nav-item <%= uri.contains("/alumnos") ? "active" : "" %>">
            <i class="bi bi-people-fill"></i><span>Alumnos</span>
        </a>
        <%if(_isAdmin){%><a href="<%=ctx%>/app/docentes" class="nav-item <%= uri.contains("/docentes") ? "active" : "" %>">
            <i class="bi bi-person-badge-fill"></i><span>Docentes</span>
        </a><%}%>
        
        <%if(_isAdmin){%><a href="<%=ctx%>/app/aulas" class="nav-item <%= uri.contains("/aulas") ? "active" : "" %>">
            <i class="bi bi-door-open-fill"></i><span>Aulas</span>
        </a><%}%>
        <%if(_isAdmin){%><div class="nav-label">Catálogos</div><%}%>
        <%if(_isAdmin){%><a href="<%=ctx%>/app/grados" class="nav-item <%= uri.contains("/grados") ? "active" : "" %>">
            <i class="bi bi-layers-fill"></i><span>Grados</span>
        </a><%}%>
        <%if(_isAdmin){%><a href="<%=ctx%>/app/secciones" class="nav-item <%= uri.contains("/secciones") ? "active" : "" %>">
            <i class="bi bi-grid-3x3-gap-fill"></i><span>Secciones</span>
        </a><%}%>
        <%if(_isAdmin){%><a href="<%=ctx%>/app/carreras" class="nav-item <%= uri.contains("/carreras") ? "active" : "" %>">
            <i class="bi bi-building-fill"></i><span>Carreras</span>
        </a><%}%>
        <%if(_isAdmin){%><a href="<%=ctx%>/app/areas" class="nav-item <%= uri.contains("/areas") ? "active" : "" %>">
            <i class="bi bi-bookmarks-fill"></i><span>Áreas</span>
        </a><%}%>
        <%if(_isAdmin){%><a href="<%=ctx%>/app/periodos" class="nav-item <%= uri.contains("/periodos") ? "active" : "" %>">
            <i class="bi bi-calendar3"></i><span>Periodos</span>
        </a><%}%>
        
        <%if(_isAdmin){%><div class="nav-label">Seguridad</div><%}%>
        <%if(_isAdmin){%><a href="<%=ctx%>/app/usuarios" class="nav-item <%= uri.contains("/usuarios") ? "active" : "" %>">
            <i class="bi bi-shield-lock-fill"></i><span>Usuarios</span>
        </a><%}%>
        
        <div class="nav-label">Simulacros</div>
        <a href="<%=ctx%>/app/examenes" class="nav-item <%= uri.contains("/examenes") ? "active" : "" %>">
            <i class="bi bi-file-earmark-text-fill"></i><span>Exámenes</span>
        </a>
        <a href="<%=ctx%>/app/inscripciones" class="nav-item <%= uri.contains("/inscripciones") ? "active" : "" %>">
            <i class="bi bi-pencil-square"></i><span>Inscripciones</span>
        </a>
        <a href="<%=ctx%>/app/resultados" class="nav-item <%= uri.contains("/resultados") ? "active" : "" %>">
            <i class="bi bi-bar-chart-fill"></i><span>Resultados</span>
        </a>
        <a href="<%=ctx%>/app/ranking" class="nav-item <%= uri.contains("/ranking") ? "active" : "" %>">
            <i class="bi bi-trophy-fill"></i><span>Ranking</span>
        </a>
    </nav>
    <div class="sidebar-footer">
        <a href="<%=ctx%>/logout" class="nav-item" style="color:rgba(255,255,255,.7)">
            <i class="bi bi-box-arrow-right"></i><span>Cerrar Sesión</span>
        </a>
    </div>
</aside>