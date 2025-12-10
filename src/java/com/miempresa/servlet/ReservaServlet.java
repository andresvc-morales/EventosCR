package com.miempresa.servlet;

import com.miempresa.util.DBUtil;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class ReservaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer id_usuario = (Integer) session.getAttribute("id_usuario");
        if (id_usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int id_evento = Integer.parseInt(request.getParameter("id_evento"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));

        try (Connection c = DBUtil.getConnection()) {
            PreparedStatement ps = c.prepareStatement(
                "SELECT nombre, precio, entradas_disponibles FROM eventos WHERE id_evento = ?");
            ps.setInt(1, id_evento);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String nombre = rs.getString("nombre");
                double precio = rs.getDouble("precio");
                int disponibles = rs.getInt("entradas_disponibles");

                if (cantidad > disponibles || cantidad < 1) {
                    response.sendRedirect("eventos.jsp?error=entradas_insuficientes");
                    return;
                }

                double total = precio * cantidad;

                // GUARDAR TODO EN SESIÓN
                session.setAttribute("compra_id_evento", id_evento);
                session.setAttribute("compra_nombre", nombre);
                session.setAttribute("compra_precio", precio);
                session.setAttribute("compra_cantidad", cantidad);
                session.setAttribute("compra_total", total);

                // REDIRIGIR A CONFIRMAR
                response.sendRedirect("confirmar_compra.jsp");
            } else {
                response.sendRedirect("eventos.jsp?error=evento_no_encontrado");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("eventos.jsp?error=servidor");
        }
    }
}