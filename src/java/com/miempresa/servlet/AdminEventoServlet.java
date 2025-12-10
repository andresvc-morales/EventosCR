package com.miempresa.servlet;

import com.miempresa.util.DBUtil;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminEventoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        String accion = req.getParameter("accion");

        try (Connection c = DBUtil.getConnection()) {

            if ("crear".equals(accion)) {

                String nombre = req.getParameter("nombre");
                String descripcion = req.getParameter("descripcion");
                String fecha = req.getParameter("fecha");
                String foto = req.getParameter("foto");
                String ubicacion = req.getParameter("ubicacion");
                int entradas_totales = Integer.parseInt(req.getParameter("entradas_totales"));
                double precio = Double.parseDouble(req.getParameter("precio"));

                String sql = "INSERT INTO eventos(nombre, descripcion, fecha, foto, ubicacion, entradas_totales, entradas_disponibles, precio) VALUES(?,?,?,?,?,?,?,?)";
                PreparedStatement ps = c.prepareStatement(sql);
                ps.setString(1, nombre);
                ps.setString(2, descripcion);
                ps.setString(3, fecha);
                ps.setString(4, foto);
                ps.setString(5, ubicacion);
                ps.setInt(6, entradas_totales);
                ps.setInt(7, entradas_totales);
                ps.setDouble(8, precio);
                ps.executeUpdate();

            } else if ("eliminar".equals(accion)) {

                int id_evento = Integer.parseInt(req.getParameter("id_evento"));
                String del = "DELETE FROM eventos WHERE id_evento = ?";
                PreparedStatement ps = c.prepareStatement(del);
                ps.setInt(1, id_evento);
                ps.executeUpdate();

            } else if ("editar".equals(accion)) {

                int id_evento = Integer.parseInt(req.getParameter("id_evento"));
                String nombre = req.getParameter("nombre");
                String descripcion = req.getParameter("descripcion");
                String fecha = req.getParameter("fecha");
                String foto = req.getParameter("foto");
                String ubicacion = req.getParameter("ubicacion");
                int entradas_totales = Integer.parseInt(req.getParameter("entradas_totales"));
                double precio = Double.parseDouble(req.getParameter("precio"));

                String upd = "UPDATE eventos SET nombre=?, descripcion=?, fecha=?, foto=?, ubicacion=?, entradas_totales=?, precio=? WHERE id_evento=?";
                PreparedStatement ps = c.prepareStatement(upd);

                ps.setString(1, nombre);
                ps.setString(2, descripcion);
                ps.setString(3, fecha);
                ps.setString(4, foto);
                ps.setString(5, ubicacion);
                ps.setInt(6, entradas_totales);
                ps.setDouble(7, precio);
                ps.setInt(8, id_evento);

                ps.executeUpdate();
            }

            resp.sendRedirect("admin_eventos.jsp");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
