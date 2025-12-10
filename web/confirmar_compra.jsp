<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    private Integer getIdUsuario(HttpSession session) {
        Object obj = session.getAttribute("id_usuario");
        if (obj == null) return null;
        try {
            if (obj instanceof Number) return ((Number)obj).intValue();
            return Integer.valueOf(obj.toString());
        } catch (Exception e) { return null; }
    }
%>
<%
    Integer id_usuario = getIdUsuario(session);
    if (id_usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String nombre = (String) session.getAttribute("compra_nombre");
    Double precio = (Double) session.getAttribute("compra_precio");
    Integer cantidad = (Integer) session.getAttribute("compra_cantidad");
    Double total = (Double) session.getAttribute("compra_total");
    if (nombre == null || precio == null || cantidad == null || total == null) {
        response.sendRedirect("eventos.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirmar Compra - EventosCR</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;700;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --green: #00ff88;
            --purple: #ff00ff;
            --cyan: #00dbde;
            --pink: #ff006e;
            --gold: #ffd700;
            --dark: #0f0c29;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
            color: white;
            font-family: 'Space Grotesk', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(25px);
            border-radius: 35px;
            padding: 60px 50px;
            width: 100%;
            max-width: 560px;
            text-align: center;
            border: 2px solid rgba(255, 255, 255, 0.15);
            box-shadow:
                0 0 80px rgba(252, 0, 255, 0.4),
                0 30px 80px rgba(0, 0, 0, 0.6),
                inset 0 0 60px rgba(255, 255, 255, 0.05);
            animation: fadeIn 1s ease-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        h1 {
            font-size: 4.2rem;
            font-weight: 900;
            background: linear-gradient(90deg, var(--cyan), var(--green), var(--purple));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 40px;
            text-shadow: 0 0 30px rgba(0, 255, 136, 0.5);
            letter-spacing: 2px;
        }
        .detalle {
            font-size: 1.55rem;
            margin: 22px 0;
            font-weight: 500;
            opacity: 0.95;
        }
        .detalle strong {
            font-weight: 900;
            color: var(--cyan);
            text-shadow: 0 0 15px rgba(0, 219, 222, 0.6);
        }
        .total-container {
            margin: 50px 0 60px;
            padding: 30px 20px;
            background: rgba(0, 255, 136, 0.1);
            border-radius: 25px;
            border: 2px dashed var(--green);
            animation: pulseGlow 3s infinite;
        }
        @keyframes pulseGlow {
            0%, 100% { box-shadow: 0 0 30px rgba(0, 255, 136, 0.4); }
            50% { box-shadow: 0 0 60px rgba(0, 255, 136, 0.8); }
        }
        .total-label {
            font-size: 1.8rem;
            color: #ccc;
            margin-bottom: 10px;
            font-weight: 700;
        }
        .total {
            font-size: 4.5rem;
            font-weight: 900;
            background: linear-gradient(90deg, var(--green), #00ffaa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow:
                0 0 20px rgba(0, 255, 136, 0.8),
                0 0 40px rgba(0, 255, 136, 0.6);
            letter-spacing: 3px;
        }
        .botones {
            display: flex;
            flex-direction: column;
            gap: 25px;
            margin-top: 20px;
        }
        .btn {
            padding: 22px 40px;
            border: none;
            border-radius: 50px;
            font-size: 1.65rem;
            font-weight: 900;
            cursor: pointer;
            transition: all 0.4s ease;
            text-transform: uppercase;
            letter-spacing: 1.5px;
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
        .btn:hover::before {
            left: 100%;
        }
        .confirm {
            background: linear-gradient(45deg, #00ff88, #00cc66);
            color: black;
            box-shadow:
                0 15px 40px rgba(0, 255, 136, 0.5),
                0 0 40px rgba(0, 255, 136, 0.3);
        }
        .confirm:hover {
            transform: translateY(-8px) scale(1.05);
            box-shadow:
                0 25px 60px rgba(0, 255, 136, 0.7),
                0 0 60px rgba(0, 255, 136, 0.6);
        }
        .cancel {
            background: linear-gradient(45deg, #ff006e, #ff3388);
            color: white;
            box-shadow: 0 15px 40px rgba(255, 0, 110, 0.5);
        }
        .cancel:hover {
            transform: translateY(-6px);
            box-shadow: 0 25px 60px rgba(255, 0, 110, 0.8);
        }
        .icon {
            margin-right: 12px;
            font-size: 1.8rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>¡CASI LISTO!</h1>
       
        <div class="detalle">
            Evento: <strong><%= nombre %></strong>
        </div>
        <div class="detalle">
            Cantidad: <strong><%= cantidad %> entrada(s)</strong>
        </div>
        <div class="detalle">
            Precio unitario: <strong>₡<%= String.format("%,.0f", precio) %></strong>
        </div>
        <div class="total-container">
            <div class="total-label">TOTAL A PAGAR</div>
            <div class="total">₡<%= String.format("%,.0f", total) %></div>
        </div>
        <div class="botones">
            <form action="ConfirmarReservaServlet" method="post">
                <button type="submit" class="btn confirm">
                    <i class="fas fa-check-circle icon"></i>
                    SÍ, COMPRAR YA
                </button>
            </form>
            <a href="eventFestival Transitarte" class="btn cancel">
                <i class="fas fa-times-circle icon"></i>
                Cancelar
            </a>
        </div>
    </div>
</body>
</html>