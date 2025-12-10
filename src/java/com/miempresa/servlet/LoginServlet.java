package com.miempresa.servlet;

import com.miempresa.util.DBUtil;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");

        try (Connection c = DBUtil.getConnection()) {
            String sql = "SELECT id_usuario, nombre, rol FROM usuarios WHERE correo = ? AND contrasena = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, correo);
            ps.setString(2, clave);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("id_usuario", rs.getInt("id_usuario"));
                session.setAttribute("nombre", rs.getString("nombre"));

                // GUARDAR ROL COMO NÚMERO (1 = admin)
                String rolStr = rs.getString("rol");
                int rol = "admin".equals(rolStr) ? 1 : 0;
                session.setAttribute("rol", rol);

                // REDIRECCIÓN SEGÚN ROL
                if (rol == 1) {
                    response.sendRedirect("admin_panel.jsp");
                } else {
                    response.sendRedirect("eventos.jsp");
                }
            } else {
                response.sendRedirect("login.jsp?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=1");
        }
    }
}