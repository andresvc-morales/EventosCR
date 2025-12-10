package com.miempresa.servlet;

import com.miempresa.util.DBUtil;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class RegistroServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");

        try (Connection c = DBUtil.getConnection()) {
            // Verificar si existe
            PreparedStatement psCheck = c.prepareStatement("SELECT * FROM usuarios WHERE correo = ?");
            psCheck.setString(1, correo);
            if (psCheck.executeQuery().next()) {
                request.setAttribute("error", "Este correo ya está registrado");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
                return;
            }

            // Insertar
            PreparedStatement ps = c.prepareStatement(
                "INSERT INTO usuarios (nombre, correo, contrasena, rol) VALUES (?, ?, ?, 'usuario')");
            ps.setString(1, usuario);
            ps.setString(2, correo);
            ps.setString(3, clave);
            ps.executeUpdate();

            response.sendRedirect("login.jsp?exito=1");

        } catch (Exception e) {
            request.setAttribute("error", "Error en base de datos");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }
}