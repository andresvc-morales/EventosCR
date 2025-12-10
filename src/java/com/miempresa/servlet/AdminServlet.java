package com.miempresa.servlet;

import com.miempresa.util.DBUtil;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer rol = (Integer) session.getAttribute("rol");
        if (rol == null || rol != 1) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        
        try (Connection c = DBUtil.getConnection()) {
            if ("crear".equals(accion)) {
                String sql = "INSERT INTO eventos (nombre, descripcion, fecha, ubicacion, entradas_totales, entradas_disponibles, precio) VALUES (?,?,?,?,?,?,?)";
                PreparedStatement ps = c.prepareStatement(sql);
                ps.setString(1, request.getParameter("nombre"));
                ps.setString(2, request.getParameter("descripcion"));
                ps.setString(3, request.getParameter("fecha"));
                ps.setString(4, request.getParameter("ubicacion"));
                int entradas = Integer.parseInt(request.getParameter("entradas"));
                ps.setInt(5, entradas);
                ps.setInt(6, entradas);
                ps.setDouble(7, Double.parseDouble(request.getParameter("precio")));
                ps.executeUpdate();
            }
            else if ("eliminar".equals(accion)) {
                PreparedStatement ps = c.prepareStatement("DELETE FROM eventos WHERE id_evento = ?");
                ps.setInt(1, Integer.parseInt(request.getParameter("id")));
                ps.executeUpdate();
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("admin_panel.jsp");
    }
}