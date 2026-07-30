<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model.Grado, model.Seccion, model.Carrera, model.Area" %>
<%
    List<Area>    areas    = (List<Area>)    request.getAttribute("areas");
    List<Grado>   grados   = (List<Grado>)   request.getAttribute("grados");
    List<Seccion> secciones = (List<Seccion>) request.getAttribute("secciones");
    List<Carrera> carreras  = (List<Carrera>) request.getAttribute("carreras");
    String error   = (String) request.getAttribute("error");
    String dni     = (String) request.getAttribute("dni");
    if (areas    == null) areas    = new java.util.ArrayList<>();
    if (grados   == null) grados   = new java.util.ArrayList<>();
    if (secciones == null) secciones = new java.util.ArrayList<>();
    if (carreras  == null) carreras  = new java.util.ArrayList<>();

    StringBuilder jsonCarreras = new StringBuilder("[");
    for (int i = 0; i < carreras.size(); i++) {
        Carrera c = carreras.get(i);
        if (i > 0) jsonCarreras.append(",");
        jsonCarreras.append("{\"id\":").append(c.getId())
            .append(",\"nombre\":\"").append(escapeJson(c.getNombre()))
            .append("\",\"idArea\":").append(c.getIdArea()).append("}");
    }
    jsonCarreras.append("]");

    StringBuilder jsonSecciones = new StringBuilder("[");
    for (int i = 0; i < secciones.size(); i++) {
        Seccion s = secciones.get(i);
        if (i > 0) jsonSecciones.append(",");
        jsonSecciones.append("{\"id\":").append(s.getId())
            .append(",\"nombre\":\"").append(escapeJson(s.getNombre()))
            .append("\",\"idGrado\":").append(s.getIdGrado()).append("}");
    }
    jsonSecciones.append("]");
%>
<%!
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Completar Registro | San José</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/assets/css/merced.css" rel="stylesheet">
</head>
<body class="merced-page">

    <jsp:include page="../shared/merced-header.jsp"/>

    <main class="merced-main">
        <h1 class="merced-title">Completa tus datos</h1>
        <h2 class="merced-subtitle">Ficha de Inscripción</h2>

        <div class="merced-alert-box">
            <% if (error != null) { %>
                <div class="alert alert-danger"><i class="bi bi-exclamation-circle-fill me-2"></i><%= error %></div>
            <% } %>
        </div>

        <form action="<%= request.getContextPath() %>/estudiante/registro" method="post" autocomplete="off" class="merced-form-container">
            <input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
            <div class="mb-3">
                <label class="form-label">DNI</label>
                <input type="text" name="dni" class="form-control merced-readonly" value="<%= dni != null ? dni : "" %>" readonly>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Nombres *</label>
                    <input type="text" name="nombres" class="form-control" placeholder="Ej: Juan Carlos" required autofocus>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Apellidos *</label>
                    <input type="text" name="apellidos" class="form-control" placeholder="Ej: Pérez García" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Fecha de Nacimiento *</label>
                <input type="date" name="fecha_nacimiento" class="form-control" required>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Grado *</label>
                    <select id="gradoSelect" name="id_grado" class="form-select" required>
                        <option value="">Seleccionar...</option>
                        <% for (Grado g : grados) { %>
                            <option value="<%= g.getId() %>"><%= g.getNombre() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Sección *</label>
                    <select id="seccionSelect" name="id_seccion" class="form-select" required>
                        <option value="">Primero selecciona un grado</option>
                    </select>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Área *</label>
                <select id="areaSelect" class="form-select" required>
                    <option value="">Seleccionar...</option>
                    <% for (Area a : areas) { %>
                        <option value="<%= a.getId() %>"><%= a.getNombre() %></option>
                    <% } %>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Carrera a la que postulas *</label>
                <select name="id_carrera" id="carreraSelect" class="form-select" required>
                    <option value="">Primero selecciona un área</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Celular</label>
                <input type="text" name="celular" class="form-control" placeholder="Ej: 987654321" pattern="[0-9]{9}" maxlength="9">
            </div>

            <div class="mb-4">
                <label class="form-label">Dirección</label>
                <input type="text" name="direccion" class="form-control" placeholder="Ej: Av. Principal 123">
            </div>

            <div class="mb-4">
                <label class="form-label">Colegio de Procedencia</label>
                <input type="text" name="colegio" class="form-control" placeholder="Ej: San José - La Salle">
            </div>

            <button type="submit" class="merced-btn merced-btn--full">Guardar e Inscribirse</button>

            <div class="text-center mt-3">
                <a href="<%= request.getContextPath() %>/estudiante/login" class="merced-link">
                    <i class="bi bi-arrow-left me-1"></i> Cambiar DNI
                </a>
            </div>
        </form>
    </main>

    <jsp:include page="../shared/merced-footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var carreras = <%= jsonCarreras %>;
        var secciones = <%= jsonSecciones %>;

        document.getElementById('gradoSelect').addEventListener('change', function() {
            var gradoId = parseInt(this.value);
            var seccionSelect = document.getElementById('seccionSelect');
            seccionSelect.innerHTML = '';
            if (isNaN(gradoId)) {
                seccionSelect.innerHTML = '<option value="">Seleccionar...</option>';
                return;
            }
            var filtradas = secciones.filter(function(s) { return s.idGrado === gradoId; });
            seccionSelect.innerHTML = '<option value="">Seleccionar...</option>';
            filtradas.forEach(function(s) {
                var opt = document.createElement('option');
                opt.value = s.id;
                opt.textContent = s.nombre;
                seccionSelect.appendChild(opt);
            });
        });

        document.getElementById('areaSelect').addEventListener('change', function() {
            var areaId = parseInt(this.value);
            var carreraSelect = document.getElementById('carreraSelect');
            carreraSelect.innerHTML = '';

            if (isNaN(areaId)) {
                carreraSelect.innerHTML = '<option value="">Primero selecciona un área</option>';
                return;
            }

            var filtradas = carreras.filter(function(c) { return c.idArea === areaId; });

            if (filtradas.length === 0) {
                carreraSelect.innerHTML = '<option value="">No hay carreras en esta área</option>';
                return;
            }

            carreraSelect.innerHTML = '<option value="">Seleccionar...</option>';
            filtradas.forEach(function(c) {
                var opt = document.createElement('option');
                opt.value = c.id;
                opt.textContent = c.nombre;
                carreraSelect.appendChild(opt);
            });
        });
    </script>
</body>
</html>
