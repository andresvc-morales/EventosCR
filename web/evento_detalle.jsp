<%@ page import="java.sql.*,com.miempresa.util.DBUtil" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
  int id_evento = Integer.parseInt(request.getParameter("id_evento"));
  try (Connection c = DBUtil.getConnection()) {
    String sql = "SELECT * FROM eventos WHERE id_evento = ?";
    PreparedStatement ps = c.prepareStatement(sql);
    ps.setInt(1, id_evento);
    ResultSet rs = ps.executeQuery();
    if (!rs.next()) { out.println("Evento no encontrado"); return; }
%>
<html>
<head><title><%=rs.getString("nombre")%></title><link rel="stylesheet" href="css/bootstrap.min.css"></head>
<body>
<div class="container">
  <h2><%=rs.getString("nombre")%></h2>
  <p><%=rs.getString("descripcion")%></p>
  <p>Fecha: <%=rs.getString("fecha")%></p>
  <p>Disponibles: <%=rs.getInt("entradas_disponibles")%></p>
  <form action="reservar" method="post">
    <input type="hidden" name="id_evento" value="<%=id_evento%>">
    <div><label>Cantidad</label><input name="cantidad" type="number" min="1" max="<%=rs.getInt("entradas_disponibles")%>" required></div>
    <button type="submit">Reservar</button>
  </form>
  <p><a href="eventos.jsp">Volver</a></p>
</div>
</body>
</html>
<%
  } catch(Exception e) { out.println("Error: "+e.getMessage()); }
%>
