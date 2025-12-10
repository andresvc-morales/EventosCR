package com.miempresa.servlet;

import com.miempresa.util.DBUtil;
import javax.servlet.*; import javax.servlet.http.*; import java.io.IOException; import java.sql.*;

public class EliminarReservaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer id_usuario = (Integer) session.getAttribute("id_usuario");
        if (id_usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int id_reserva = Integer.parseInt(request.getParameter("id_reserva"));
        int id_evento = Integer.parseInt(request.getParameter("id_evento"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));

        try (Connection c = DBUtil.getConnection()) {
            c.setAutoCommit(false);

            // Devolver entradas al evento
            PreparedStatement ps = c.prepareStatement(
                "UPDATE eventos SET entradas_disponibles = entradas_disponibles + ? WHERE id_evento = ?");
            ps.setInt(1, cantidad);
            ps.setInt(2, id_evento);
            ps.executeUpdate();

            // Borrar reserva
            ps = c.prepareStatement("DELETE FROM reservas WHERE id_reserva = ? AND id_usuario = ?");
            ps.setInt(1, id_reserva);
            ps.setInt(2, id_usuario);
            ps.executeUpdate();

            c.commit();
            response.sendRedirect("panel_usuario.jsp?exito=Entrada_borrada");
        } catch (Exception e) {
            response.sendRedirect("panel_usuario.jsp?error=1");
        }
    }
}