<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - EventosCR</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;700;800&display=swap" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;700;800&display=swap');
        * { font-family: 'Space Grotesk', sans-serif; box-sizing: border-box; margin:0; padding:0; }
        body { 
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e); 
            min-height: 100vh; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            padding: 20px; 
            color: white;
        }
        .glass { 
            background: rgba(255,255,255,0.1); 
            backdrop-filter: blur(20px); 
            border-radius: 30px; 
            padding: 50px; 
            max-width: 520px; 
            width: 100%; 
            box-shadow: 0 20px 60px rgba(0,0,0,0.6); 
            border: 1px solid rgba(255,255,255,0.2); 
            position: relative;
            overflow: hidden;
        }
        .glass::before {
            content: '';
            position: absolute;
            top: -2px; left: -2px; right: -2px; bottom: -2px;
            background: linear-gradient(45deg, #00ff88, #00dbde, #fc00ff, #8a2be2);
            border-radius: 32px;
            z-index: -1;
            opacity: 0.7;
            animation: neon 4s linear infinite;
        }
        @keyframes neon { 0% { filter: hue-rotate(0deg); } 100% { filter: hue-rotate(360deg); } }
        
        h2 { 
            font-size: 3.2rem; 
            text-align: center; 
            background: linear-gradient(90deg, #00ff88, #fc00ff); 
            -webkit-background-clip: text; 
            -webkit-text-fill-color: transparent; 
            margin-bottom: 40px; 
            font-weight: 800;
        }
        .input-group { 
            position: relative; 
            margin: 28px 0; 
        }
        .input-group i { 
            position: absolute; 
            left: 20px; 
            top: 50%; 
            transform: translateY(-50%); 
            color: #00ff88; 
            font-size: 1.4rem;
        }
        .input-group input { 
            width: 100%; 
            padding: 20px 20px 20px 60px; 
            background: rgba(255,255,255,0.1); 
            border: 2px solid transparent; 
            border-radius: 20px; 
            color: white; 
            font-size: 1.1rem; 
            transition: all 0.4s;
        }
        .input-group input:focus { 
            border-color: #fc00ff; 
            box-shadow: 0 0 25px rgba(252,0,255,0.6); 
            outline: none; 
            background: rgba(255,255,255,0.2);
        }
        .input-group input::placeholder { color: rgba(255,255,255,0.6); }
        
        .btn { 
            background: linear-gradient(45deg, #ff00c8, #8a2be2); 
            border: none; 
            padding: 22px; 
            width: 100%; 
            border-radius: 50px; 
            color: white; 
            font-size: 1.5rem; 
            font-weight: 700;
            margin-top: 30px; 
            cursor: pointer; 
            transition: all 0.4s;
            box-shadow: 0 15px 40px rgba(138,43,226,0.6);
        }
        .btn:hover { 
            transform: translateY(-8px) scale(1.05); 
            box-shadow: 0 25px 60px rgba(138,43,226,0.9); 
        }
        
        .error { 
            color: #ff006e; 
            text-align: center; 
            margin: 20px 0; 
            font-weight: bold; 
            background: rgba(255,0,110,0.2); 
            padding: 18px; 
            border-radius: 18px; 
            border: 2px solid #ff006e;
        }
        .exito { 
            color: #00ff88; 
            text-align: center; 
            margin: 20px 0; 
            font-weight: bold; 
            background: rgba(0,255,136,0.2); 
            padding: 18px; 
            border-radius: 18px; 
            border: 2px solid #00ff88;
        }
        
        a { color: #00ff88; text-decoration: none; font-weight: 600; }
        a:hover { color: #fc00ff; text-shadow: 0 0 15px rgba(252,0,255,0.8); }
    </style>
</head>
<body>
<div class="glass">
    <h2>CREAR CUENTA</h2>

    <!-- MENSAJE DE ERROR (ej: correo ya existe) -->
    <% if(request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>

    <!-- MENSAJE DE ÉXITO (opcional) -->
    <% if(request.getParameter("exito") != null) { %>
        <div class="exito">¡Cuenta creada con éxito! Ya puedes iniciar sesión</div>
    <% } %>

    <form action="RegistroServlet" method="post" onsubmit="return validarClave()">
        <div class="input-group">
            <i class="fas fa-user"></i>
            <input type="text" name="usuario" placeholder="Tu nombre completo" required>
        </div>
        
        <div class="input-group">
            <i class="fas fa-envelope"></i>
            <input type="email" name="correo" placeholder="tuemail@cr.com" required>
        </div>
        
        <div class="input-group">
            <i class="fas fa-lock"></i>
            <input type="password" name="clave" id="claveReg" placeholder="Contraseña (mínimo 8 caracteres)" required>
        </div>

        <button type="submit" class="btn">
            REGISTRARSE GRATIS
        </button>
    </form>

    <p style="text-align:center; margin-top:30px; font-size:1.1rem;">
        ¿Ya tienes cuenta? 
        <a href="login.jsp">Inicia sesión aquí</a>
    </p>
</div>

<script>
function validarClave() {
    const clave = document.getElementById("claveReg").value;
    if (clave.length < 8) {
        alert("¡La contraseña debe tener mínimo 8 caracteres!");
        return false;
    }
    return true;
}
</script>
</body>
</html>