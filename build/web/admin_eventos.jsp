<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.miempresa.util.DBUtil" %>
<%
    // FORZAR NO CACHE 
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventosCR - Eventos Disponibles</title>
    <link rel="stylesheet" href="bootstrap.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap');
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Space Grotesk', sans-serif;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            min-height: 100vh;
            color: #e0e0ff;
            padding: 40px 20px;
        }
        h2 {
            background: linear-gradient(90deg, #00ff88, #00dbde, #fc00ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-align: center;
            font-weight: 700;
            font-size: 3.8rem;
            margin-bottom: 60px;
        }
        .glass {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
            padding: 40px;
            max-width: 560px;
            margin: 40px auto;
            animation: float 8s ease-in-out infinite;
            position: relative;
            overflow: hidden;
        }
        .glass::before {
            content: '';
            position: absolute;
            top: -2px; left: -2px; right: -2px; bottom: -2px;
            background: linear-gradient(45deg, #00ff88, #00dbde, #fc00ff, #8a2be2);
            border-radius: 26px;
            z-index: -1;
            opacity: 0;
            transition: opacity 0.5s;
        }
        .glass:hover::before { opacity: 0.7; }
        .glass:hover { transform: translateY(-15px) scale(1.03); }
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-15px); }
        }
        .evento-titulo {
            background: linear-gradient(90deg, #00ff88, #fc00ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 2.8rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 20px;
        }
        .info {
            font-size: 1.3rem;
            text-align: center;
            margin: 12px 0;
            color: #e0e0ff;
        }
        .precio {
            font-size: 2.2rem;
            font-weight: 700;
            color: #fc00ff;
            text-align: center;
            margin: 20px 0;
            text-shadow: 0 0 20px rgba(252,0,255,0.5);
        }
        .btn-pro {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            width: 100%;
            padding: 18px;
            margin: 25px 0 10px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.3rem;
            cursor: pointer;
            transition: all 0.4s ease;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
        }
        .btn-pro:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 20px 50px rgba(102, 126, 234, 0.6);
        }
        .volver {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: rgba(255,255,255,0.2);
            padding: 15px 30px;
            border-radius: 50px;
            color: white;
            text-decoration: none;
            font-weight: 600;
            backdrop-filter: blur(10px);
            box-shadow: 0 0 30px rgba(0,255,136,0.5);
            z-index: 999;
        }
        .volver:hover {
            background: #00ff88;
            color: black;
            transform: scale(1.1);
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
</head>
<body>

    <h2>Eventos disponibles</h2>

    <%
        try (Connection c = DBUtil.getConnection()) {
            String sql = "SELECT * FROM eventos WHERE entradas_disponibles > 0 ORDER BY fecha ASC";
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
    %>
    <div class="glass">
        <h3 class="evento-titulo"><%= rs.getString("nombre") %></h3>
        <p class="info"><%= rs.getString("descripcion") %></p>
        <p class="info">Fecha: <%= rs.getString("fecha") %></p>
        <p class="info">Disponibles: <%= rs.getInt("entradas_disponibles") %></p>
        <p class="precio">₡<%= String.format("%.2f", rs.getDouble("precio")) %></p>

        <form action="CompraServlet" method="post">
            <input type="hidden" name="id_evento" value="<%= rs.getInt("id_evento") %>">
            <button type="submit" class="btn-pro"
                    onclick="confetti({particleCount: 200, spread: 80, origin: { y: 0.6 }})">
                <i class="fas fa-ticket-alt"></i> RESERVAR ENTRADAS
            </button>
        </form>
    </div>
    <%
            }
        } catch (Exception e) {
            out.println("<div class='glass'><p style='color:#ff006e; text-align:center; font-size:1.5rem;'>Error: " + e.getMessage() + "</p></div>");
        }
    %>

    <a href="index.jsp" class="volver">Volver al inicio</a>

</body>
</html>