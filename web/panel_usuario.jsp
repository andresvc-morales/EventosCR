<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.miempresa.util.DBUtil" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
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
    <title>Mis Entradas - EventosCR</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;900&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
    <style>
        :root {
            --green:#00ff88; --purple:#fc00ff; --cyan:#00dbde;
            --pink:#ff006e; --gold:#ffd700; --dark:#0f0c29;
        }
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Space Grotesk',sans-serif; }
        body {
            background:linear-gradient(135deg,#0f0c29 0%,#302b63 50%,#24243e 100%);
            color:white; min-height:100vh; padding:20px;
        }
        h1 {
            text-align:center; font-size:5rem; font-weight:900;
            background:linear-gradient(90deg,var(--green),var(--purple));
            -webkit-background-clip:text; -webkit-text-fill-color:transparent;
            margin:40px 0 60px; text-shadow:0 0 40px rgba(252,0,255,.5);
        }
        .grid {
            display:grid; grid-template-columns:repeat(auto-fit,minmax(340px,1fr));
            gap:35px; max-width:1400px; margin:0 auto;
        }
        .ticket {
            background:rgba(255,255,255,0.08); backdrop-filter:blur(22px);
            border-radius:32px; padding:35px 30px; text-align:center;
            border:3px dashed var(--cyan); box-shadow:0 25px 60px rgba(0,0,0,0.5);
            animation:float 6s ease-in-out infinite; transition:all 0.4s;
        }
        .ticket:hover { transform:translateY(-15px) scale(1.03); border-color:var(--purple); }
        @keyframes float { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-20px)} }
        .event-name {
            font-size:2.2rem; font-weight:900;
            background:linear-gradient(90deg,#fff,var(--cyan));
            -webkit-background-clip:text; -webkit-text-fill-color:transparent;
            margin:15px 0;
        }
        .info { font-size:1.2rem; margin:12px 0; opacity:0.9; }
        .info i { color:var(--green); margin-right:10px; }
        .codigo {
            font-size:1.8rem; font-weight:900; color:var(--purple);
            letter-spacing:3px; margin:25px 0; padding:15px;
            background:rgba(252,0,255,0.15); border-radius:15px;
            text-shadow:0 0 20px var(--purple);
        }
        .btn {
            background:linear-gradient(45deg,#ff00c8,#8a2be2); color:white;
            border:none; padding:16px 40px; border-radius:50px;
            font-size:1.3rem; font-weight:900; cursor:pointer;
            margin:10px 8px; box-shadow:0 15px 40px rgba(138,43,226,0.6);
            transition:all 0.4s; text-decoration:none; display:inline-block;
        }
        .btn:hover { transform:scale(1.1); box-shadow:0 25px 60px rgba(138,43,226,0.9); }
        .btn-delete { background:linear-gradient(45deg,#ff006e,#ff3388); }
        .btn-delete:hover { background:linear-gradient(45deg,#ff3388,#ff006e); }
        .logout {
            position:fixed; top:25px; right:25px;
            background:linear-gradient(45deg,#ff006e,#ff3388);
            padding:16px 32px; border-radius:50px; color:white;
            text-decoration:none; font-weight:900; font-size:1.2rem;
            box-shadow:0 0 50px rgba(255,0,110,0.7); z-index:9999;
        }
        .logout:hover { transform:scale(1.1); }
        .no-entradas {
            grid-column:1/-1; text-align:center; font-size:2.5rem;
            color:#ff006e; margin:80px 0;
        }

        /* CORONA ADMIN EN PANEL_USUARIO.JSP */
        .admin-crown {
            position:fixed !important; bottom:20px !important; right:20px !important;
            width:85px !important; height:85px !important;
            background:linear-gradient(135deg,#8B00FF,#FF00FF) !important;
            border-radius:50% !important; box-shadow:0 0 90px rgba(255,0,255,0.9) !important;
            display:flex !important; align-items:center !important; justify-content:center !important;
            font-size:4rem !important; color:gold !important; z-index:9999 !important;
            border:6px solid gold !important; animation:pulse 2s infinite !important;
        }
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(255,215,0,0.8); }
            70% { box-shadow: 0 0 0 40px rgba(255,215,0,0); }
            100% { box-shadow: 0 0 0 0 rgba(255,215,0,0); }
        }
    </style>
</head>
<body>
    <h1>MIS ENTRADAS</h1>
    <a href="LogoutServlet" class="logout">CERRAR SESIÓN</a>

    <!-- CORONA ADMIN -->
    <% if (rol != null && rol == 1) { %>
    <a href="admin_panel.jsp" class="admin-crown">
        <i class="fas fa-crown"></i>
    </a>
    <% } %>

    <div class="grid">
        <%
            try (Connection c = DBUtil.getConnection()) {
                PreparedStatement ps = c.prepareStatement(
                    "SELECT r.id_reserva, r.cantidad, r.codigo_confirmacion, r.id_evento, " +
                    "e.nombre, e.fecha, e.ubicacion, e.precio " +
                    "FROM reservas r " +
                    "JOIN eventos e ON r.id_evento = e.id_evento " +
                    "WHERE r.id_usuario = ? " +
                    "ORDER BY r.fecha_reserva DESC"
                );
                ps.setInt(1, id_usuario);
                ResultSet rs = ps.executeQuery();
                boolean tieneEntradas = false;
                while (rs.next()) {
                    tieneEntradas = true;
                    int id_reserva = rs.getInt("id_reserva");
                    int id_evento = rs.getInt("id_evento");
                    String nombre = rs.getString("nombre");
                    String fecha = rs.getString("fecha").substring(0,16).replace("T"," ");
                    String ubicacion = rs.getString("ubicacion");
                    int cantidad = rs.getInt("cantidad");
                    String codigo = rs.getString("codigo_confirmacion");
                    double precio = rs.getDouble("precio");
        %>
        <div class="ticket">
            <div class="event-name"><%= nombre %></div>
            <p class="info"><i class="fas fa-calendar-alt"></i><%= fecha %></p>
            <p class="info"><i class="fas fa-map-marker-alt"></i><%= ubicacion %></p>
            <p class="info"><i class="fas fa-users"></i><%= cantidad %> entrada(s)</p>
            <p class="info"><i class="fas fa-money-bill-wave"></i>Total: ₡<%= String.format("%,.0f", precio * cantidad) %></p>
            <div class="codigo"><%= codigo %></div>
            <form action="EliminarReservaServlet" method="post" style="margin:25px 0;"
                  onsubmit="confetti({particleCount:400,spread:120}); return confirm('¿Desea eliminar esta reserva?');">
                <input type="hidden" name="id_reserva" value="<%= id_reserva %>">
                <input type="hidden" name="id_evento" value="<%= id_evento %>">
                <input type="hidden" name="cantidad" value="<%= cantidad %>">
                <button type="submit" class="btn btn-delete">
                    <i class="fas fa-trash-alt"></i> ELIMINAR
                </button>
            </form>
        </div>
        <%
                }
                if (!tieneEntradas) {
        %>
        <div class="no-entradas">
            <i class="fas fa-ticket-alt" style="font-size:5rem; color:#00ff88;"></i><br><br>
            No tiene entradas aún.<br><br>
            <a href="eventos.jsp" style="color:#00ff88; font-size:2rem; text-decoration:underline;">
                Comprar entradas
            </a>
        </div>
        <%
                }
            } catch (Exception e) {
                out.print("<div class='no-entradas'>Error del sistema: " + e.getMessage() + "</div>");
            }
        %>
    </div>
    <div style="text-align:center; margin:100px 0;">
        <a href="eventos.jsp" class="btn" style="background:linear-gradient(45deg,var(--green),var(--cyan)); color:black; padding:22px 70px; font-size:2rem;">
            <i class="fas fa-shopping-cart"></i> COMPRAR MÁS ENTRADAS
        </a>
    </div>
</body>
</html>