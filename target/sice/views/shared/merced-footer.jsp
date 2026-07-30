<%@ page contentType="text/html;charset=UTF-8" %>
<footer class="merced-footer">
    <div>Colegio San José · Juliaca</div>
    <div>Sistema Integral de Calificación de Exámenes</div>
</footer>
<script>
(function(){var b=document.getElementById('dmTogglePublic'),i=b?.querySelector('i');if(b){var d=localStorage.getItem('sice-dark');if(d==='1'){document.documentElement.setAttribute('data-bs-theme','dark');i?.classList.replace('bi-moon-fill','bi-sun-fill');}
b.addEventListener('click',function(){var h=document.documentElement;if(h.getAttribute('data-bs-theme')==='dark'){h.removeAttribute('data-bs-theme');localStorage.setItem('sice-dark','0');i?.classList.replace('bi-sun-fill','bi-moon-fill');}else{h.setAttribute('data-bs-theme','dark');localStorage.setItem('sice-dark','1');i?.classList.replace('bi-moon-fill','bi-sun-fill');}});}})();
</script>
