package com.zxj.Filter;

import com.sun.deploy.net.HttpResponse;
import com.zxj.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        System.out.println("进入到验证有没有登录过的过滤器");

        HttpServletRequest request = ( HttpServletRequest)servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        String servletPath = request.getServletPath();
        System.out.println(servletPath);
        if("/user/userLogin".equals(servletPath) || "/login.jsp".equals(servletPath)){
            filterChain.doFilter(servletRequest,servletResponse);
        }else{
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if(user!=null){
                filterChain.doFilter(servletRequest,servletResponse);
            }else{
                response.sendRedirect(request.getContextPath()+"/login.jsp");
            }
        }

    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void destroy() {

    }
}
