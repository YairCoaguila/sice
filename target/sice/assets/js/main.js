document.addEventListener('DOMContentLoaded',function(){
    const sidebar=document.getElementById('sidebar'),overlay=document.getElementById('sidebarOverlay'),btn=document.getElementById('sidebarToggleMobile'),close=document.getElementById('sidebarClose');
    function open(){sidebar?.classList.add('show');overlay?.classList.add('show');document.body.style.overflow='hidden';}
    function shut(){sidebar?.classList.remove('show');overlay?.classList.remove('show');document.body.style.overflow='';}
    btn?.addEventListener('click',open); close?.addEventListener('click',shut); overlay?.addEventListener('click',shut);
    document.querySelectorAll('.alert-dismissible').forEach(function(el){setTimeout(function(){bootstrap.Alert.getOrCreateInstance(el)?.close();},5000);});
    document.querySelectorAll('[data-confirm]').forEach(function(el){el.addEventListener('click',function(e){if(!confirm(el.getAttribute('data-confirm')||'¿Está seguro?'))e.preventDefault();});});
    document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el=>new bootstrap.Tooltip(el));
    var dmBtn=document.getElementById('darkModeToggle'),dmIcon=dmBtn?.querySelector('i');
    if(dmBtn){var dm=localStorage.getItem('sice-dark');if(dm==='1'){document.documentElement.setAttribute('data-bs-theme','dark');dmIcon?.classList.replace('bi-moon-fill','bi-sun-fill');}
    dmBtn.addEventListener('click',function(){var html=document.documentElement;if(html.getAttribute('data-bs-theme')==='dark'){html.removeAttribute('data-bs-theme');localStorage.setItem('sice-dark','0');dmIcon?.classList.replace('bi-sun-fill','bi-moon-fill');}else{html.setAttribute('data-bs-theme','dark');localStorage.setItem('sice-dark','1');dmIcon?.classList.replace('bi-moon-fill','bi-sun-fill');}});}
});
