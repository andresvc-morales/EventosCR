<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.miempresa.util.DBUtil" %>
<%
    Integer rol = (Integer) session.getAttribute("rol");
    if (rol == null || rol != 1) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - EventosCR</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@700&display=swap');
        * { font-family: 'Space Grotesk', sans-serif; box-sizing: border-box; margin:0; padding:0; }
        body { background: linear-gradient(135deg, #0f0c29, #302b63, #24243e); color: white; min-height: 100vh; padding: 40px; }
        h1 { font-size: 4rem; text-align: center; background: linear-gradient(90deg, #00ff88, #fc00ff); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 40px; }
        .glass { background: rgba(255,255,255,0.1); backdrop-filter: blur(20px); border-radius: 30px; padding: 40px; max-width: 1000px; margin: 30px auto; border: 2px solid rgba(255,255,255,0.2); box-shadow: 0 0 50px rgba(252,0,255,0.5); }
        .btn { background: linear-gradient(45deg, #ff00c8, #8a2be2); padding: 15px 30px; border: none; border-radius: 50px; color: white; font-size: 1.3rem; cursor: pointer; margin: 10px; }
        .btn:hover { transform: scale(1.1); box-shadow: 0 0 30px #fc00ff; }
        .btn-delete { background: #ff006e; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 15px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.2); }
        th { background: rgba(252,0,255,0.3); }
    </style>
</head>
<body>
    <h1>PANEL ADMIN</h1>
    <div class="glass">
        <h2>CREAR NUEVO EVENTO</h2>
        <form action="AdminServlet" method="post">
            <input type="hidden" name="accion" value="crear">
            <input type="text" name="nombre" placeholder="Nombre del evento" required style="width:100%; padding:15px; margin:10px 0; border-radius:15px; border:none;"><br>
            <textarea name="descripcion" placeholder="Descripción" required style="width:100%; height:100px; padding:15px; margin:10px 0; border-radius:15px; border:none;"></textarea><br>
            <input type="datetime-local" name="fecha" required style="width:100%; padding:15px; margin:10px 0; border-radius:15px; border:none;"><br>
            <input type="text" name="ubicacion" placeholder="Ubicación" required style="width:100%; padding:15px; margin:10px 0; border-radius:15px; border:none;"><br>
            <input type="number" name="entradas" placeholder="Entradas totales" required style="width:100%; padding:15px; margin:10px 0; border-radius:15px; border:none;"><br>
            <input type="number" step="0.01" name="precio" placeholder="Precio ₡" required style="width:100%; padding:15px; margin:10px 0; border-radius:15px; border:none;"><br>
            <button type="submit" class="btn">CREAR EVENTO</button>
        </form>
    </div>

    <div class="glass">
        <h2>EVENTOS ACTUALES</h2>
        <table>
            <tr>
                <th>Nombre</th>
                <th>Fecha</th>
                <th>Disponibles</th>
                <th>Precio</th>
                <th>Acciones</th>
            </tr>
            <%
                try (Connection c = DBUtil.getConnection()) {
                    PreparedStatement ps = c.prepareStatement("SELECT * FROM eventos ORDER BY fecha");
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        int disponibles = rs.getInt("entradas_disponibles");
            %>
            <tr style="<%= disponibles == 0 ? "opacity:0.5; background:rgba(255,0,110,0.2);" : "" %>">
                <td><%= rs.getString("nombre") %></td>
                <td><%= rs.getString("fecha") %></td>
                <td><%= disponibles %> / <%= rs.getInt("entradas_totales") %></td>
                <td>₡<%= rs.getString("precio") %></td>
                <td>
                    <% if (disponibles > 0) { %>
                    <span style="color:#00ff88;">ACTIVO</span>
                    <% } else { %>
                    <span style="color:#ff006e;">AGOTADO</span>
                    <% } %>
                    <form action="AdminServlet" method="post" style="display:inline;">
                        <input type="hidden" name="accion" value="eliminar">
                        <input type="hidden" name="id" value="<%= rs.getInt("id_evento") %>">
                        <button type="submit" class="btn btn-delete">ELIMINAR</button>
                    </form>
                </td>
            </tr>
            <% }
            } catch(Exception e) { out.print("Error"); } %>
        </table>
    </div>
    <a href="eventos.jsp" style="display:block; text-align:center; margin:50px; color:#00ff88; font-size:1.5rem;">Volver al público</a>
</body>
</html>