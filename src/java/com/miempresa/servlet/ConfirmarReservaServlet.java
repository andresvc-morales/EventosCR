package com.miempresa.servlet;

import com.miempresa.util.DBUtil;
import javax.servlet.*; import javax.servlet.http.*; import java.io.IOException; import java.sql.*;

public class ConfirmarReservaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer id_usuario = (Integer) session.getAttribute("id_usuario");
        Integer id_evento = (Integer) session.getAttribute("compra_id_evento");
        Integer cantidad = (Integer) session.getAttribute("compra_cantidad");

        if (id_usuario == null || id_evento == null || cantidad == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection c = DBUtil.getConnection()) {
            c.setAutoCommit(false);

            PreparedStatement ps = c.prepareStatement(
                "UPDATE eventos SET entradas_disponibles = entradas_disponibles - ? WHERE id_evento = ? AND entradas_disponibles >= ?");
            ps.setInt(1, cantidad);
            ps.setInt(2, id_evento);
            ps.setInt(3, cantidad);
            if (ps.executeUpdate() == 0) {
                c.rollback();
                response.sendRedirect("eventos.jsp?error=sin_entradas");
                return;
            }

            String codigo = "CR" + System.currentTimeMillis();
            ps = c.prepareStatement(
                "INSERT INTO reservas (id_usuario, id_evento, cantidad, codigo_confirmacion) VALUES (?,?,?,?)");
            ps.setInt(1, id_usuario);
            ps.setInt(2, id_evento);
            ps.setInt(3, cantidad);
            ps.setString(4, codigo);
            ps.executeUpdate();

            c.commit();

            session.removeAttribute("compra_id_evento");
            session.removeAttribute("compra_nombre");
            session.removeAttribute("compra_precio");
            session.removeAttribute("compra_cantidad");
            session.removeAttribute("compra_total");

            response.sendRedirect("panel_usuario.jsp?exito=Compra_exitosa");
        } catch (Exception e) {
            response.sendRedirect("eventos.jsp?error=1");
        }
    }
}