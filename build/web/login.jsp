<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventosCR - La fiesta empieza aquí</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
    <!-- ANTI-CACHÉ PARA QUE SIEMPRE SE VEA LO NUEVO -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;700;900&display=swap');
        
        :root {
            --cyan: #00dbde; --pink: #ff00c8; --purple: #8a2be2; --green: #00ff88; --yellow: #ffd700;
        }
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Space Grotesk',sans-serif; }
        
        body {
            background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }
        
        body::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: radial-gradient(circle at 20% 80%, rgba(0,255,136,0.15) 0%, transparent 50%),
                        radial-gradient(circle at 80% 20%, rgba(255,0,200,0.15) 0%, transparent 50%),
                        radial-gradient(circle at 40% 40%, rgba(0,219,222,0.12) 0%, transparent 50%);
            animation: stars 15s ease-in-out infinite;
            z-index: -1;
        }
        @keyframes stars {
            0%,100% { opacity: 0.8; }
            50% { opacity: 1; }
        }
        
        .glass {
            background: rgba(255,255,255,0.08);
            backdrop-filter: blur(28px);
            border-radius: 40px;
            padding: 60px 50px;
            max-width: 500px;
            width: 100%;
            box-shadow: 0 25px 60px rgba(0,0,0,0.6),
                        inset 0 0 80px rgba(0,255,136,0.12);
            border: 2px solid rgba(255,255,255,0.18);
            text-align: center;
            animation: float 8s ease-in-out infinite;
            position: relative;
            overflow: hidden;
        }
        @keyframes float {
            0%,100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-12px) rotate(0.5deg); }
        }
        
        .logo-container {
            margin-bottom: 30px;
            position: relative;
            display: inline-block;
        }
        .logo {
            font-size: 4.2rem;
            font-weight: 900;
            background: linear-gradient(90deg, var(--green), var(--cyan), var(--pink));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: 3px;
            position: relative;
            z-index: 2;
        }
        .ticket-icon {
            position: absolute;
            top: -20px; right: -30px;
            font-size: 4rem;
            color: var(--yellow);
            animation: ticket 3s ease-in-out infinite;
            text-shadow: 0 0 30px var(--yellow);
        }
        @keyframes ticket {
            0%,100% { transform: translateY(0) rotate(0); }
            50% { transform: translateY(-10px) rotate(5deg); }
        }
        
        h2 {
            font-size: 3.2rem;
            background: linear-gradient(90deg, #00ff88, #fc00ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 20px 0 40px;
            font-weight: 900;
        }
        
        .input-group {
            position: relative;
            margin: 35px 0;
        }
        .input-group i {
            position: absolute;
            left: 22px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--cyan);
            font-size: 1.4rem;
            transition: all 0.4s;
            z-index: 2;
        }
        .input-group input {
            width: 100%;
            padding: 22px 22px 22px 65px;
            background: rgba(255,255,255,0.08);
            border: 2px solid rgba(0,219,222,0.3);
            border-radius: 25px;
            color: white;
            font-size: 1.2rem;
            transition: all 0.4s;
        }
        .input-group input:focus {
            border-color: var(--pink);
            box-shadow: 0 0 35px rgba(255,0,200,0.5);
            transform: scale(1.03);
            background: rgba(255,255,255,0.15);
        }
        .input-group input:focus ~ i {
            color: var(--pink);
            transform: translateY(-50%) scale(1.3);
            text-shadow: 0 0 20px var(--pink);
        }
        
        #lock-icon {
            transition: transform 0.6s;
        }
        input:focus ~ #lock-icon {
            transform: translateY(-50%) rotate(30deg) scale(1.4);
        }
        
        .btn {
            background: linear-gradient(45deg, var(--pink), var(--purple));
            border: none;
            padding: 22px;
            width: 100%;
            border-radius: 50px;
            color: white;
            font-size: 1.6rem;
            font-weight: 900;
            cursor: pointer;
            margin-top: 30px;
            box-shadow: 0 15px 40px rgba(255,0,200,0.6);
            transition: all 0.4s;
            position: relative;
            overflow: hidden;
        }
        .btn::before {
            content: '';
            position: absolute;
            top: 0; left: -100%;
            width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.7s;
        }
        .btn:hover {
            transform: translateY(-6px);
            box-shadow: 0 25px 60px rgba(255,0,200,0.9);
        }
        .btn:hover::before {
            left: 100%;
        }
        
        .error, .exito {
            padding: 18px;
            border-radius: 20px;
            margin: 20px 0;
            font-weight: bold;
            font-size: 1.1rem;
            backdrop-filter: blur(10px);
        }
        .error {
            background: rgba(255,0,110,0.15);
            border: 2px solid #ff006e;
            color: #ff6699;
        }
        .exito {
            background: rgba(0,255,136,0.15);
            border: 2px solid var(--green);
            color: var(--green);
        }
        
        .register-link a {
            color: var(--cyan);
            text-decoration: none;
            font-weight: 700;
            padding: 10px 20px;
            border: 2px dashed var(--cyan);
            border-radius: 25px;
            transition: all 0.4s;
            display: inline-block;
            margin-top: 20px;
        }
        .register-link a:hover {
            background: rgba(0,219,222,0.2);
            color: white;
            border-color: white;
            transform: scale(1.05);
        }
        
        @media (max-width: 480px) {
            .glass { padding: 40px 30px; }
            .logo { font-size: 3.5rem; }
            h2 { font-size: 2.6rem; }
            .btn { font-size: 1.4rem; padding: 18px; }
        }
    </style>
</head>
<body>

<div class="glass">
    <div class="logo-container">
        <div class="logo">EVENTOSCR</div>
        <i class="fas fa-ticket-alt ticket-icon"></i>
    </div>
    
    <h2>INICIAR SESIÓN</h2>
    
    <% if(request.getParameter("error") != null) { %>
        <div class="error">Correo o contraseña incorrectos</div>
    <% } %>
    <% if(request.getParameter("exito") != null) { %>
        <div class="exito">¡Cuenta creada con éxito! Ahora inicia sesión</div>
    <% } %>
    
    <form action="LoginServlet" method="post" onsubmit="return validar()">
        <div class="input-group">
            <i class="fas fa-envelope"></i>
            <input type="email" name="correo" placeholder="tuemail@cr.com" required>
        </div>
        
        <div class="input-group">
            <i class="fas fa-lock" id="lock-icon"></i>
            <input type="password" name="clave" id="clave" placeholder="Contraseña (mín. 8 caracteres)" required>
        </div>
        
        <button type="submit" class="btn">
            ENTRAR A LA FIESTA
        </button>
    </form>
    
    <div class="register-link">
        <a href="registro.jsp">¿No tienes cuenta? Regístrate aquí</a>
    </div>
</div>

<script>
function validar() {
    const clave = document.getElementById("clave").value;
    if (clave.length < 8) {
        alert("La contraseña debe tener mínimo 8 caracteres");
        return false;
    }
    return true;
}
</script>
</body>
</html>