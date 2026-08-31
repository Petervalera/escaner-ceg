<!-- dashboard.html -->
<h1>Bienvenido al Panel</h1>
<button id="logoutBtn">Cerrar Sesión</button>

<script type="module">
  import { supabase } from './supabaseClient.js';

  // 1. Verificar sesión activa al cargar la página
  async function checkSession() {
    const { data: { session } } = await supabase.auth.getSession();
    
    // Si NO hay sesión, lo devuelve al login inmediatamente
    if (!session) {
      window.location.href = "index.html";
    } else {
      console.log("Usuario autenticado:", session.user.email);
    }
  }

  checkSession();

  // 2. Evento para Cerrar Sesión
  const logoutBtn = document.getElementById('logoutBtn');
  
  logoutBtn.addEventListener('click', async () => {
    const { error } = await supabase.auth.signOut();
    if (!error) {
      window.location.href = "index.html";
    } else {
      alert("Error al cerrar sesión: " + error.message);
    }
  });
</script>
