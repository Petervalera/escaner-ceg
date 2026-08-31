<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Acceso al Sistema - C.E. Guaicaipuro</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap');
    body { font-family: 'Inter', sans-serif; }
    
    .bg-watermark {
      position: fixed;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 70vw;
      max-width: 450px;
      height: auto;
      opacity: 0.04;
      pointer-events: none;
      z-index: 0;
    }
  </style>
</head>
<body class="bg-slate-900 text-gray-100 min-h-screen flex flex-col justify-between p-4 relative overflow-x-hidden">

  <!-- MARCA DE AGUA INSTITUCIONAL -->
  <img id="watermarkImg" src="logo_ce_guaicaipuro.png" alt="Insignia Institucional" class="bg-watermark" onerror="this.style.display='none'">

  <div class="max-w-md w-full mx-auto my-auto z-10 space-y-6">
    
    <!-- ENCABEZADO INSTITUCIONAL -->
    <header class="text-center space-y-3">
      <div class="w-20 h-20 bg-slate-800/80 rounded-2xl border border-slate-700/80 flex items-center justify-center mx-auto shadow-xl p-2">
        <img id="logoHeader" src="logo_ce_guaicaipuro.png" alt="Logo Colegio" class="w-full h-full object-contain" onerror="this.src='https://cdn-icons-png.flaticon.com/512/167/167707.png'">
      </div>
      <div>
        <h1 id="tituloInstitucion" class="text-2xl font-extrabold text-white tracking-tight uppercase">C.E. GUAICAIPURO</h1>
        <p class="text-xs text-blue-400 font-bold uppercase tracking-wider mt-1">Control de Asistencia e Identificación Digital</p>
      </div>
    </header>

    <!-- TARJETA DEL FORMULARIO DE INICIO DE SESIÓN -->
    <main class="bg-slate-800/90 backdrop-blur-md rounded-2xl border border-slate-700/80 p-6 sm:p-8 shadow-2xl space-y-6">
      
      <div class="border-b border-slate-700/80 pb-4 text-center">
        <h2 class="text-lg font-bold text-white">Iniciar Sesión</h2>
        <p class="text-xs text-gray-400">Ingrese sus credenciales de acceso institucional</p>
      </div>

      <form id="loginForm" onsubmit="procesarLogin(event)" class="space-y-5">
        
        <!-- CÉDULA DE IDENTIDAD -->
        <div>
          <label class="block text-xs font-bold uppercase text-gray-300 mb-1.5 flex items-center gap-1">
            <span>🪪</span> Cédula de Identidad (Usuario)
          </label>
          <input type="text" id="cedula" required placeholder="Ej: 12345678" class="w-full bg-slate-900 border border-slate-700 text-white rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-blue-500 focus:outline-none transition">
        </div>

        <!-- CONTRASEÑA / PIN -->
        <div>
          <label class="block text-xs font-bold uppercase text-gray-300 mb-1.5 flex items-center gap-1">
            <span>🔑</span> Contraseña / PIN
          </label>
          <input type="password" id="password" required placeholder="••••••••" class="w-full bg-slate-900 border border-slate-700 text-white rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-blue-500 focus:outline-none transition">
        </div>

        <!-- BOTÓN DE INGRESO -->
        <button type="submit" id="submitBtn" class="w-full bg-blue-600 hover:bg-blue-500 text-white font-extrabold py-3.5 rounded-xl shadow-lg border border-blue-400/30 transition duration-200 text-sm flex justify-center items-center gap-2 cursor-pointer">
          <span>🚀</span> Ingresar al Sistema
        </button>

      </form>

      <!-- MENSAJE DE ERROR -->
      <div id="mensajeError" class="hidden text-center text-xs font-bold text-red-400 bg-red-900/40 border border-red-700/60 p-3 rounded-xl"></div>

      <!-- ENLACE AL REGISTRO -->
      <div class="text-center pt-2 border-t border-slate-700/80">
        <p class="text-xs text-gray-400">
          ¿Aún no estás registrado? 
          <a href="registro.html" class="text-blue-400 font-bold hover:underline">Registrarse aquí</a>
        </p>
      </div>

    </main>

  </div>

  <!-- PIE DE PÁGINA CORPORATIVO -->
  <footer class="z-10 text-center py-3 w-full border-t border-slate-800/80 bg-slate-900/50 backdrop-blur-sm mt-4">
    <p class="text-xs font-semibold text-gray-400 tracking-wider">
      Desarrollado por <span class="text-blue-400 font-extrabold">DME Technology</span>
    </p>
  </footer>

  <!-- LÓGICA CONEXIÓN CON SUPABASE -->
  <script>
    const SUPABASE_URL = 'https://dampbjspktpcffqpuiuz.supabase.co';
    const SUPABASE_ANON_KEY = 'sb_publishable_raLpaXN3c1UpS4mHFvWkTQ_YNbtB3Q5';
    const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

    // CARGAR CONFIGURACIÓN INSTITUCIONAL PERSONALIZADA SI EXISTE
    window.onload = function() {
      const nombreGuardado = localStorage.getItem('nombre_institucion');
      const logoGuardado = localStorage.getItem('logo_institucion');

      if (nombreGuardado) {
        document.getElementById('tituloInstitucion').textContent = nombreGuardado;
      }
      if (logoGuardado) {
        document.getElementById('logoHeader').src = logoGuardado;
        document.getElementById('watermarkImg').src = logoGuardado;
      }
    };

    // PROCESAR INICIO DE SESIÓN
    async function procesarLogin(event) {
      event.preventDefault();

      const cedulaInput = document.getElementById('cedula').value.trim();
      const passwordInput = document.getElementById('password').value.trim();
      const msgError = document.getElementById('mensajeError');
      const submitBtn = document.getElementById('submitBtn');

      msgError.classList.add('hidden');
      submitBtn.disabled = true;
      submitBtn.textContent = 'Verificando...';

      try {
        // Consultar la tabla registro_general en Supabase por número de Cédula
        const { data, error } = await supabaseClient
          .from('registro_general')
          .select('*')
          .eq('cedula', cedulaInput)
          .maybeSingle();

        if (error) throw error;

        if (!data) {
          throw new Error('La cédula ingresada no se encuentra registrada en el sistema.');
        }

        // Verificar si el rol posee clave asignada
        if (!data.clave) {
          throw new Error('Este rol no tiene acceso por clave habilitado o es un perfil operativo/estudiante.');
        }

        // Validar contraseña exacta contra la columna "clave"
        if (data.clave !== passwordInput) {
          throw new Error('La contraseña ingresada es incorrecta.');
        }

        // Guardar sesión del usuario activo en localStorage
        const usuarioSesion = {
          cedula: data.cedula,
          nombre_apellido: data.nombre_apellido,
          rol: data.rol,
          telefono: data.telefono
        };
        localStorage.setItem('currentUser', JSON.stringify(usuarioSesion));

        // Redirigir al panel principal
        window.location.href = "panel.html";

      } catch (err) {
        msgError.textContent = err.message;
        msgError.classList.remove('hidden');
      } finally {
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<span>🚀</span> Ingresar al Sistema';
      }
    }
  </script>

</body>
</html>
