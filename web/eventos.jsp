<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.miempresa.util.DBUtil" %>
<%
    Integer id_usuario = (Integer) session.getAttribute("id_usuario");
    Integer rol = (Integer) session.getAttribute("rol");
    if (id_usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventosCR</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;600;700;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --cyan: #00dbde; --purple: #8a2be2; --pink: #ff00c8;
            --green: #00ff88; --yellow: #ffd700; --dark: #0a0a1f;
            --card: rgba(20, 20, 50, 0.95);
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            background: linear-gradient(135deg, #0a0a1f 0%, #1a1a3a 50%, #0f0c29 100%);
            color: white;
            font-family: 'Space Grotesk', sans-serif;
            min-height: 100vh;
            padding: 100px 20px 80px;
            position: relative;
        }
        header {
            position: fixed;
            top: 0; left: 0; right: 0;
            height: 80px;
            background: var(--card);
            backdrop-filter: blur(20px);
            border-bottom: 2px solid var(--cyan);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 30px;
            z-index: 1000;
            box-shadow: 0 8px 32px rgba(0, 219, 222, 0.2);
        }
        header h1 {
            font-size: 2.4rem;
            font-weight: 900;
            background: linear-gradient(90deg, var(--green), var(--cyan));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .header-buttons {
            display: flex;
            gap: 16px;
            align-items: center;
        }
        .btn-mis-entradas {
            background: linear-gradient(45deg, var(--green), var(--cyan));
            color: black;
            padding: 12px 28px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 900;
            font-size: 1rem;
            border: 3px solid black;
            box-shadow: 0 0 30px rgba(0, 255, 136, 0.7);
        }
        .btn-cerrar {
            background: linear-gradient(45deg, #ff006e, #ff3388);
            color: white;
            padding: 12px 28px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 700;
            font-size: 1rem;
            box-shadow: 0 0 30px rgba(255, 0, 110, 0.6);
        }
        .eventos-grid {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 32px;
            padding: 20px;
        }
        .evento-card {
            background: var(--card);
            border-radius: 28px;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0, 219, 222, 0.2);
            border: 1px solid rgba(0, 219, 222, 0.3);
            transition: all 0.4s ease;
            display: flex;
            flex-direction: column;
        }
        .evento-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 25px 60px rgba(0, 219, 222, 0.4);
        }
        .evento-img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            display: block;
        }
        .evento-img[src=""], .evento-img:not([src]) {
            display: none;
        }
        .evento-body {
            padding: 28px 24px;
            text-align: center;
            flex-grow: 1;
        }
        .evento-titulo {
            font-size: 1.65rem;
            font-weight: 900;
            margin: 10px 0 16px;
            color: white;
            line-height: 1.2;
        }
        .evento-info {
            font-size: 0.98rem;
            margin: 10px 0;
            color: #ddd;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .evento-info i { color: var(--cyan); }
        .disponibles {
            color: var(--yellow);
            font-weight: 800;
            font-size: 1.05rem;
            margin: 14px 0;
        }
        .precio {
            font-size: 2.4rem;
            font-weight: 900;
            color: var(--green);
            margin: 18px 0;
            text-shadow: 0 0 25px var(--green);
        }
        .cantidad {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 16px;
            margin: 22px 0;
        }
        .btn-cantidad {
            width: 50px; height: 50px;
            border-radius: 50%;
            background: linear-gradient(45deg, var(--purple), var(--pink));
            color: white;
            border: none;
            font-size: 1.7rem;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 10px 30px rgba(138, 43, 226, 0.7);
        }
        .cantidad-num {
            width: 76px;
            height: 56px;
            background: rgba(0, 219, 222, 0.2);
            border: 3px solid var(--cyan);
            border-radius: 28px;
            color: white;
            text-align: center;
            font-size: 1.8rem;
            font-weight: 900;
        }
        .btn-comprar {
            background: linear-gradient(45deg, var(--pink), var(--purple));
            color: white;
            border: none;
            padding: 18px 40px;
            border-radius: 50px;
            font-size: 1.3rem;
            font-weight: 800;
            cursor: pointer;
            width: 85%;
            box-shadow: 0 15px 40px rgba(255, 0, 200, 0.6);
            transition: all 0.3s;
        }
        .btn-comprar:hover {
            transform: scale(1.06);
            box-shadow: 0 22px 55px rgba(255, 0, 200, 0.9);
        }

        /* CORONA ADMIN EN EVENTOS.JSP */
        .admin-crown {
            position: fixed !important;
            bottom: 30px !important;
            right: 30px !important;
            width: 90px !important;
            height: 90px !important;
            background: linear-gradient(135deg, #8B00FF, #FF00FF) !important;
            border-radius: 50% !important;
            box-shadow: 0 0 100px rgba(255,0,255,0.9) !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            font-size: 4.5rem !important;
            color: gold !important;
            z-index: 9999 !important;
            border: 6px solid gold !important;
            animation: pulse 2s infinite !important;
            text-decoration: none !important;
        }
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(255,215,0,0.8); }
            70% { box-shadow: 0 0 0 40px rgba(255,215,0,0); }
            100% { box-shadow: 0 0 0 0 rgba(255,215,0,0); }
        }

        @media (max-width: 768px) {
            .eventos-grid { grid-template-columns: repeat(2, 1fr); gap: 24px; }
            header h1 { font-size: 2rem; }
        }
        @media (max-width: 480px) {
            .eventos-grid { grid-template-columns: 1fr; }
            header { padding: 0 15px; }
            header h1 { font-size: 1.8rem; }
            .header-buttons { gap: 10px; }
            .btn-mis-entradas, .btn-cerrar { padding: 10px 18px; font-size: 0.9rem; }
        }
    </style>
    <script>
        function ajustarCantidad(input, delta, max) {
            let val = parseInt(input.value) || 1;
            val = Math.max(1, Math.min(val + delta, max));
            input.value = val;
        }
    </script>
</head>
<body>
    <header>
        <h1>EVENTOS</h1>
        <div class="header-buttons">
            <a href="panel_usuario.jsp" class="btn-mis-entradas">MIS ENTRADAS</a>
            <a href="LogoutServlet" class="btn-cerrar">CERRAR SESIÓN</a>
        </div>
    </header>

    <!-- CORONA ADMIN EN EVENTOS.JSP -->
    <% if (rol != null && rol == 1) { %>
    <a href="admin_panel.jsp" class="admin-crown">
        <i class="fas fa-crown"></i>
    </a>
    <% } %>

    <div class="eventos-grid">
        <%
            try (Connection c = DBUtil.getConnection()) {
                PreparedStatement ps = c.prepareStatement(
                    "SELECT * FROM eventos WHERE entradas_disponibles > 0 ORDER BY fecha ASC"
                );
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    int id = rs.getInt("id_evento");
                    String nombre = rs.getString("nombre");
                    String foto = rs.getString("foto");
                    String fecha = rs.getString("fecha").substring(0,16).replace("T"," ");
                    String ubicacion = rs.getString("ubicacion");
                    int disponibles = rs.getInt("entradas_disponibles");
                    double precio = rs.getDouble("precio");
        %>
        <div class="evento-card">
            <img src="<%= foto %>" class="evento-img" onerror="this.style.display='none'">
            <div class="evento-body">
                <h3 class="evento-titulo"><%= nombre %></h3>
                <p class="evento-info"><i class="fas fa-calendar-alt"></i> <%= fecha %></p>
                <p class="evento-info"><i class="fas fa-map-marker-alt"></i> <%= ubicacion %></p>
                <p class="disponibles">Disponibles: <%= disponibles %></p>
                <p class="precio">₡<%= precio == 0 ? "GRATIS" : String.format("%,.0f", precio) %></p>
                <form action="ReservaServlet" method="post">
                    <input type="hidden" name="id_evento" value="<%= id %>">
                    <div class="cantidad">
                        <button type="button" class="btn-cantidad" onclick="ajustarCantidad(this.nextElementSibling, -1, <%= disponibles %>)">−</button>
                        <input type="number" name="cantidad" value="1" min="1" max="<%= disponibles %>" class="cantidad-num" readonly>
                        <button type="button" class="btn-cantidad" onclick="ajustarCantidad(this.previousElementSibling, 1, <%= disponibles %>)">+</button>
                    </div>
                    <button type="submit" class="btn-comprar">COMPRAR</button>
                </form>
            </div>
        </div>
        <%
                }
            } catch (Exception e) {
                out.print("<p style='text-align:center; color:#ff3366; font-size:1.5rem; grid-column:1/-1;'>Error al cargar eventos</p>");
            }
        %>
    </div>
</body>
</html>