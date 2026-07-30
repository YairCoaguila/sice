<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Alumno, java.util.*, model.Examen, model.Resultado, util.HtmlUtil" %>
<% Map<Integer, Integer> mapaInscripciones = (Map<Integer, Integer>) request.getAttribute("mapaInscripciones"); %>
<% Map<Integer, Resultado> mapaResultados = (Map<Integer, Resultado>) request.getAttribute("mapaResultados"); %>
<% Map<Integer, Integer> mapaRankingGeneral = (Map<Integer, Integer>) request.getAttribute("mapaRankingGeneral"); %>
<% Map<Integer, Integer> mapaRankingGrado = (Map<Integer, Integer>) request.getAttribute("mapaRankingGrado"); %>
<% Map<Integer, String> mapaAulas = (Map<Integer, String>) request.getAttribute("mapaAulas"); %>
<% Map<Integer, String> mapaProfesores = (Map<Integer, String>) request.getAttribute("mapaProfesores"); %>
<%
Alumno alumno = (Alumno) session.getAttribute("estudiante");
if (alumno == null) {
    response.sendRedirect(request.getContextPath() + "/estudiante/login");
    return;
}
String ctx = request.getContextPath();
List<Examen> examenesDisponibles = (List<Examen>) request.getAttribute("examenesDisponibles");
List<Examen> examenesInscritos = (List<Examen>) request.getAttribute("examenesInscritos");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Panel Estudiante | San José</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<%= ctx %>/assets/css/merced.css" rel="stylesheet">
    <style>
        .tour-overlay{position:fixed;inset:0;z-index:1040;background:rgba(0,0,0,.45);display:none}
        .tour-overlay.active{display:block}
        .tour-highlight{position:relative;z-index:1050;box-shadow:0 0 0 4px #1e3a5f,0 0 20px rgba(30,58,95,.35);border-radius:8px;transition:box-shadow .3s}
        .tour-bubble{position:fixed;z-index:1060;background:#fff;border-radius:12px;padding:20px 24px;max-width:380px;box-shadow:0 12px 40px rgba(0,0,0,.25);display:none;border-left:5px solid #1e3a5f}
        .tour-bubble.active{display:block}
        .tour-bubble::before{content:'';position:absolute;width:14px;height:14px;background:#fff;transform:rotate(45deg);border:1px solid #e5e7eb}
        .tour-bubble--top::before{bottom:-7px;left:30px;border-top:none;border-left:none}
        .tour-bubble--bottom::before{top:-7px;left:30px;border-bottom:none;border-right:none}
        .tour-bubble--left::before{right:-7px;top:20px;border-bottom:none;border-left:none}
        .tour-bubble--right::before{left:-7px;top:20px;border-top:none;border-right:none}
        .tour-step-indicator{color:#9ca3af;font-size:.8rem;margin-bottom:8px}
        .tour-bubble h6{margin-bottom:6px;color:#1e3a5f;font-weight:700}
        .tour-bubble p{margin-bottom:12px;font-size:.9rem;color:#4b5563;line-height:1.5}
        .tour-bubble .btn{font-size:.82rem;padding:6px 18px;border-radius:6px}
        .tour-bubble .btn-primary{background:#1e3a5f;border-color:#1e3a5f}
        .tour-bubble .btn-primary:hover{background:#132542}
        .tour-bubble .btn-outline-secondary{border-color:#d1d5db;color:#6b7280}
    </style>
</head>
<body class="merced-page">

    <jsp:include page="../shared/merced-header.jsp"/>

    <!-- Tour guiado -->
    <div class="tour-overlay" id="tourOverlay"></div>
    <div class="tour-bubble" id="tourBubble">
        <div class="tour-step-indicator" id="tourStep">Paso 1 de 7</div>
        <h6 id="tourTitle">Título</h6>
        <p id="tourDesc">Descripción</p>
        <div class="d-flex justify-content-between align-items-center">
            <button class="btn btn-outline-secondary btn-sm" id="tourPrev" onclick="tourPrev()"><i class="bi bi-chevron-left"></i> Anterior</button>
            <div>
                <button class="btn btn-sm me-1" style="background:transparent;color:#9ca3af;border:none" onclick="tourEnd()">Cerrar</button>
                <button class="btn btn-primary btn-sm" id="tourNext" onclick="tourNext()">Siguiente <i class="bi bi-chevron-right"></i></button>
            </div>
        </div>
    </div>

    <main class="merced-main" id="tourMain">
        <h1 class="merced-title" id="tourStep1">Mi Panel de Inscripción</h1>
        <h2 class="merced-subtitle">Inscripción de Exámenes</h2>

        <div class="merced-user-bar" id="tourStep2">
            <div>
                <h2><i class="bi bi-person-circle me-2"></i><%= HtmlUtil.e(alumno.getNombres()) %> <%= HtmlUtil.e(alumno.getApellidoPaterno()) %></h2>
                <small><i class="bi bi-card-text me-1"></i> DNI: <%= alumno.getDni() %> | Grado: <%= HtmlUtil.e(alumno.getGradoNombre() != null ? alumno.getGradoNombre() : "No asignado") %> | Colegio: <%= HtmlUtil.e(alumno.getColegio() != null && !alumno.getColegio().isEmpty() ? alumno.getColegio() : "&mdash;") %></small>
            </div>
            <div class="d-flex gap-2 align-items-center">
                <a href="<%= ctx %>/estudiante/perfil" class="merced-btn" style="padding:8px 16px;font-size:.82rem;background:rgba(255,255,255,.15);border:1px solid rgba(255,255,255,.3);color:white">
                    <i class="bi bi-person-gear"></i> Mi Perfil
                </a>
                <button onclick="tourStart()" class="merced-btn" style="padding:8px 16px;font-size:.82rem;background:rgba(255,255,255,.15);border:1px solid rgba(255,255,255,.3);color:white">
                    <i class="bi bi-question-circle"></i> Tutorial
                </button>
                <a href="<%= ctx %>/estudiante/logout" class="merced-btn merced-btn--outline" style="padding:8px 20px;font-size:.85rem;border-color:white;color:white">
                    <i class="bi bi-box-arrow-right"></i> Salir
                </a>
            </div>
        </div>

        <div class="merced-content-wide">
            <% String msg = (String) session.getAttribute("msg"); if (msg != null) { session.removeAttribute("msg"); %>
                <div class="alert alert-success alert-dismissible fade show"><i class="bi bi-check-circle-fill me-2"></i><%= HtmlUtil.e(msg) %><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            <% } %>
            <% String error = (String) session.getAttribute("error"); if (error != null) { session.removeAttribute("error"); %>
                <div class="alert alert-danger alert-dismissible fade show"><i class="bi bi-exclamation-triangle-fill me-2"></i><%= HtmlUtil.e(error) %><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            <% } %>

            <% Boolean mostrarInstrucciones = (Boolean) session.getAttribute("mostrarInstrucciones");
               if (mostrarInstrucciones != null && mostrarInstrucciones) {
                   session.setAttribute("vioInstrucciones", true);
                   session.removeAttribute("mostrarInstrucciones"); %>
                <div id="tourStartTrigger" style="display:none;"></div>
            <% } %>

            <div class="mb-5" id="tourStep3">
                <h4 class="merced-section-title"><i class="bi bi-calendar-event"></i>Exámenes Disponibles</h4>
                <div class="row">
                    <% if (examenesDisponibles == null || examenesDisponibles.isEmpty()) { %>
                        <div class="col-12">
                            <div class="alert alert-info">No hay exámenes disponibles en este momento.</div>
                        </div>
                    <% } else {
                        int idxDisponible = 0;
                        for (Examen e : examenesDisponibles) { idxDisponible++; %>
                            <div class="col-md-4 col-lg-3 mb-3">
                                <div class="merced-card h-100">
                                    <div class="card-body text-center p-4">
                                        <i class="bi bi-file-earmark-text fs-1" style="color:#1e3a5f"></i>
                                        <h6 class="mt-2 fw-bold"><%= HtmlUtil.e(e.getNombre()) %></h6>
                                        <span class="merced-badge-disponible">Disponible</span>
                                        <p class="small text-muted mt-2"><%= HtmlUtil.e(e.getFecha() != null ? e.getFecha().toString() : "Fecha por definir") %></p>
                                        <form action="<%= ctx %>/estudiante/inscribir" method="post">
                                            <input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
                                            <input type="hidden" name="idExamen" value="<%= e.getId() %>">
                                            <button type="submit" class="merced-btn merced-btn--red merced-btn--full" style="padding:8px;font-size:.85rem" <%= idxDisponible == 1 ? "id=\"tourBtnInscribir\"" : "" %>>
                                                <i class="bi bi-check-lg"></i> Inscribirme
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                    <% } } %>
                </div>
            </div>

            <div id="tourStep5">
                <h4 class="merced-section-title"><i class="bi bi-clipboard-check"></i>Mis Inscripciones</h4>
                <div class="row">
                    <% if (examenesInscritos == null || examenesInscritos.isEmpty()) { %>
                        <div class="col-12">
                            <div class="alert alert-secondary">Aún no estás inscrito en ningún examen.</div>
                        </div>
                    <% } else {
                        int idxInscrito = 0;
                        for (Examen e : examenesInscritos) { idxInscrito++;
                            Resultado r = mapaResultados != null ? mapaResultados.get(e.getId()) : null;
                            String aula = mapaAulas != null ? mapaAulas.get(e.getId()) : null;
                            String profesor = mapaProfesores != null ? mapaProfesores.get(e.getId()) : null;
                            Integer rankGen = mapaRankingGeneral != null ? mapaRankingGeneral.get(e.getId()) : null;
                            Integer rankGrado = mapaRankingGrado != null ? mapaRankingGrado.get(e.getId()) : null; %>
                            <div class="col-md-4 col-lg-3 mb-3">
                                <div class="merced-card <%= r != null ? "merced-card--resultado" : "merced-card--inscrito" %> h-100">
                                    <div class="card-body text-center p-4">
                                        <% if (r != null) { %>
                                            <i class="bi bi-trophy-fill fs-1" style="color:#1e3a5f"></i>
                                            <h6 class="mt-2 fw-bold"><%= HtmlUtil.e(e.getNombre()) %></h6>
                                            <div class="mb-2">
                                                <span class="badge fs-6" style="background-color:#1e3a5f;color:white;padding:6px 14px;border-radius:20px;">
                                                    <%= String.format("%.1f", r.getPorcentaje()) %>%
                                                </span>
                                            </div>
                                            <div class="small mb-2">
                                                <% if (rankGen != null) { %>
                                                    <span class="badge bg-dark me-1">#<%= rankGen %> General</span>
                                                <% } %>
                                                <% if (rankGrado != null) { %>
                                                    <span class="badge bg-secondary">#<%= rankGrado %> en tu grado</span>
                                                <% } %>
                                            </div>
                                            <table class="table table-sm table-borderless mb-2" style="font-size:.8rem;">
                                                <tr><td class="text-muted text-end pe-2">Puntaje:</td><td class="text-start fw-bold"><%= String.format("%.2f", r.getPuntaje()) %></td></tr>
                                                <tr><td class="text-muted text-end pe-2">Correctas:</td><td class="text-start fw-bold" style="color:#198754;"><%= r.getCorrectas() %></td></tr>
                                                <tr><td class="text-muted text-end pe-2">Incorrectas:</td><td class="text-start fw-bold" style="color:#dc3545;"><%= r.getIncorrectas() %></td></tr>
                                                <tr><td class="text-muted text-end pe-2">En blanco:</td><td class="text-start fw-bold" style="color:#6c757d;"><%= r.getEnBlanco() %></td></tr>
                                            </table>
                                        <% } else { %>
                                            <i class="bi bi-check-circle-fill fs-1" style="color:#1e3a5f"></i>
                                            <h6 class="mt-2 fw-bold"><%= HtmlUtil.e(e.getNombre()) %></h6>
                                            <span class="merced-badge-inscrito">✓ Inscrito</span>
                                            <p class="small text-muted mt-2"><%= HtmlUtil.e(e.getFecha() != null ? e.getFecha().toString() : "Fecha por definir") %></p>
                                        <% } %>
                                            <hr class="my-2">
                                            <div class="small text-start">
                                                <% if (aula != null) { %>
                                                    <p class="mb-1"><i class="bi bi-building"></i> Salón: <strong><%= HtmlUtil.e(aula) %></strong></p>
                                                <% } %>
                                                <% if (profesor != null) { %>
                                                    <p class="mb-0"><i class="bi bi-person-video3"></i> Profesor: <strong><%= HtmlUtil.e(profesor) %></strong></p>
                                                <% } %>
                                            </div>
                                        <div class="d-flex gap-1 mt-2">
                                        <a href="<%= ctx %>/estudiante/constancia-pdf?id=<%= mapaInscripciones.get(e.getId()) %>" class="merced-btn merced-btn--outline flex-fill" style="padding:8px;font-size:.8rem" target="_blank" <%= idxInscrito == 1 ? "id=\"tourBtnConstancia\"" : "" %>>
                                            <i class="bi bi-file-pdf"></i> Constancia
                                        </a>
                                        <% if (rankGen != null && rankGen >= 1 && rankGen <= 3) { %>
                                            <a href="<%= ctx %>/estudiante/diploma-pdf?idExamen=<%= e.getId() %>" class="merced-btn flex-fill" style="padding:8px;font-size:.8rem;background:linear-gradient(135deg,#b8860b,#daa520);color:white;border:none" target="_blank" <%= idxInscrito == 1 ? "id=\"tourBtnDiploma\"" : "" %>>
                                                <i class="bi bi-award-fill"></i> Diploma
                                            </a>
                                        <% } %>
                                        </div>
                                        <% if (r == null) { %>
                                             <form action="<%= ctx %>/estudiante/inscribir" method="post" class="mt-2">
                                                 <input type="hidden" name="_csrf" value="<%= session.getAttribute("_csrf") %>">
                                                 <input type="hidden" name="accion" value="cancelar">
                                                <input type="hidden" name="idExamen" value="<%= e.getId() %>">
                                                <button type="submit" class="btn btn-outline-danger btn-sm w-100" style="font-size:.8rem;border-radius:8px;" onclick="return confirm('¿Estás seguro de cancelar tu inscripción?')">
                                                    <i class="bi bi-x-circle"></i> Cancelar inscripción
                                                </button>
                                            </form>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                    <% } } %>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="../shared/merced-footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var tourSteps = [
            { el: 'tourStep1', pos: 'bottom', title: 'Panel de Inscripci\u00f3n', desc: 'Esta es tu pantalla principal. Aqu\u00ed puedes inscribirte en ex\u00e1menes, ver tus inscripciones activas y consultar tus resultados.' },
            { el: 'tourStep2', pos: 'bottom', title: 'Tus datos personales', desc: 'Aqu\u00ed se muestran tu nombre completo, DNI y el grado al que perteneces.' },
            { el: 'tourStep3', pos: 'top', title: 'Ex\u00e1menes disponibles', desc: 'En esta secci\u00f3n aparecen los ex\u00e1menes a los que a\u00fan no te has inscrito. Revisa la lista y elige el que te interese.' },
            { el: 'tourBtnInscribir', pos: 'top', title: 'Inscribirte en un examen', desc: 'Haz clic en este bot\u00f3n para inscribirte al examen seleccionado. Una vez inscrito, pasar\u00e1 a la secci\u00f3n "Mis Inscripciones".' },
            { el: 'tourStep5', pos: 'top', title: 'Mis Inscripciones', desc: 'Aqu\u00ed ves los ex\u00e1menes en los que est\u00e1s inscrito. Si ya tienes resultados, se mostrar\u00e1n tu puntaje, correctas, incorrectas y ranking.' },
            { el: 'tourBtnConstancia', pos: 'top', title: 'Constancia de inscripci\u00f3n', desc: 'Descarga un comprobante PDF de tu inscripci\u00f3n para presentarlo donde lo necesites.' },
            { el: 'tourBtnDiploma', pos: 'top', title: 'Diploma', desc: 'Si quedas entre los 3 primeros puestos del examen, podr\u00e1s descargar tu diploma de reconocimiento.' }
        ];
        var tourStep = 0;
        var tourActive = false;
        function tourStart() {
            tourStep = 0;
            tourActive = true;
            document.getElementById('tourOverlay').classList.add('active');
            document.getElementById('tourStartTrigger')?.remove();
            showTourStep();
        }
        function showTourStep() {
            var s = tourSteps[tourStep];
            var el = document.getElementById(s.el);
            if (!el) { tourEnd(); return; }
            document.querySelectorAll('.tour-highlight').forEach(function(e) { e.classList.remove('tour-highlight'); });
            el.classList.add('tour-highlight');
            el.scrollIntoView({ behavior: 'smooth', block: 'center' });
            var bb = document.getElementById('tourBubble');
            var r = el.getBoundingClientRect();
            var bw = bb.offsetWidth || 340;
            var bh = bb.offsetHeight || 200;
            var left, top, posClass;
            if (s.pos === 'bottom') {
                left = Math.min(r.left + 20, window.innerWidth - bw - 20);
                top = r.bottom + 16;
                posClass = 'tour-bubble--bottom';
            } else {
                left = Math.min(r.left + 20, window.innerWidth - bw - 20);
                top = r.top - bh - 16;
                posClass = 'tour-bubble--top';
            }
            if (top < 10) { top = r.bottom + 16; posClass = 'tour-bubble--bottom'; }
            if (top + bh > window.innerHeight - 10) { top = r.top - bh - 16; posClass = 'tour-bubble--top'; }
            if (top < 10) { top = 10; }
            if (left < 10) left = 10;
            bb.className = 'tour-bubble active ' + posClass;
            bb.style.left = left + 'px';
            bb.style.top = top + 'px';
            document.getElementById('tourStep').textContent = 'Paso ' + (tourStep + 1) + ' de ' + tourSteps.length;
            document.getElementById('tourTitle').textContent = s.title;
            document.getElementById('tourDesc').textContent = s.desc;
            document.getElementById('tourPrev').style.display = tourStep === 0 ? 'none' : 'inline-block';
            document.getElementById('tourNext').innerHTML = tourStep === tourSteps.length - 1 ? 'Finalizar <i class="bi bi-check-lg"></i>' : 'Siguiente <i class="bi bi-chevron-right"></i>';
        }
        function tourNext() {
            if (tourStep < tourSteps.length - 1) { tourStep++; showTourStep(); }
            else tourEnd();
        }
        function tourPrev() {
            if (tourStep > 0) { tourStep--; showTourStep(); }
        }
        function tourEnd() {
            tourActive = false;
            document.getElementById('tourOverlay').classList.remove('active');
            document.getElementById('tourBubble').classList.remove('active');
            document.querySelectorAll('.tour-highlight').forEach(function(e) { e.classList.remove('tour-highlight'); });
        }
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.alert-dismissible').forEach(function(el) {
                setTimeout(function() {
                    bootstrap.Alert.getOrCreateInstance(el)?.close();
                }, 5000);
            });
            if (document.getElementById('tourStartTrigger')) {
                setTimeout(tourStart, 600);
            }
        });
    </script>
</body>
</html>
