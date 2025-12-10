<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventosCR - Costa Rica</title>
    <link rel="stylesheet" href="bootstrap.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700;800&display=swap" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700;800&display=swap');
        * { font-family: 'Space Grotesk', sans-serif !important; box-sizing: border-box; }
        body { background: linear-gradient(135deg, #0f0c29, #302b63, #24243e) !important; min-height: 100vh; margin: 0; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .container { background: rgba(255,255,255,0.08) !important; backdrop-filter: blur(24px) !important; border-radius: 32px !important; border: 1px solid rgba(255,255,255,0.15) !important; box-shadow: 0 8px 32px rgba(0,0,0,0.37), 0 0 60px rgba(138,43,226,0.3) !important; padding: 70px 50px !important; max-width: 520px !important; position: relative; animation: float 8s ease-in-out infinite; overflow: hidden; }
        .container::before { content: ''; position: absolute; top: -2px; left: -2px; right: -2px; bottom: -2px; background: linear-gradient(45deg, #00ff88, #00dbde, #fc00ff, #8a2be2); border-radius: 34px; z-index: -1; animation: neon 4s linear infinite; opacity: 0.7; }
        @keyframes float { 0%,100% { transform: translateY(0) rotate(0deg); } 50% { transform: translateY(-20px) rotate(1deg); } }
        @keyframes neon { 0% { filter: hue-rotate(0deg); } 100% { filter: hue-rotate(360deg); } }
        h1 { font-size: 4.2rem !important; background: linear-gradient(90deg, #00ff88, #00dbde, #fc00ff, #ff00c8) !important; -webkit-background-clip: text !important; -webkit-text-fill-color: transparent !important; text-align: center !important; font-weight: 800 !important; text-shadow: 0 0 30px rgba(0,255,136,0.5); margin-bottom: 15px !important; }
        .btn { display: flex !important; align-items: center !important; justify-content: center !important; gap: 15px !important; width: 100% !important; padding: 22px !important; margin: 18px 0 !important; background: linear-gradient(45deg, #8a2be2, #ff00c8, #00dbde) !important; color: white !important; border: none !important; border-radius: 50px !important; font-weight: 700 !important; font-size: 1.35rem !important; text-decoration: none !important; cursor: pointer !important; transition: all 0.4s ease !important; box-shadow: 0 15px 35px rgba(138,43,226,0.6), 0 0 40px rgba(0,255,136,0.4) !important; position: relative; overflow: hidden; text-transform: uppercase; letter-spacing: 1px; }
        .btn::before { content: ''; position: absolute; top: 0; left: -100%; width: 100%; height: 100%; background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent); transition: 0.7s; }
        .btn:hover::before { left: 100%; }
        .btn:hover { transform: translateY(-10px) scale(1.08) !important; box-shadow: 0 25px 60px rgba(138,43,226,0.8), 0 0 60px rgba(0,255,136,0.7) !important; }
    </style>
</head>
<body>
<div class="container text-center">
    <h1>EventosCR</h1>
    <p style="color:#ccc; font-size:1.2rem; margin-bottom:40px;">La plataforma #1 de eventos en Costa Rica</p>
    <a href="login.jsp" class="btn">Iniciar Sesión</a>
    <a href="registro.jsp" class="btn">Crear Cuenta</a>
    <a href="eventos.jsp" class="btn">Ver Eventos</a>
</div>
</body>
</html>