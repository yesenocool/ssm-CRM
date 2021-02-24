package com.zxj.Filter;

import com.zxj.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        System.out.println("进入到验证有没有登录过的拦截器");

        HttpSession session = request.getSession();

        String servletPath = request.getServletPath();
        User user = (User) session.getAttribute("user");
        System.out.println("interceptorUser----"+user);
        System.out.println("interceptor----"+servletPath);
        if("/user/userLogin".equals(servletPath) || user!=null  ){


            return true;
        }else{

                // 重定向到登录页
                System.out.println("应该跳转的地址1："+request.getContextPath()+"/login.jsp");
                response.sendRedirect(request.getContextPath()+"/login.jsp");
                 System.out.println("应该跳转的地址2："+request.getContextPath()+"/login.jsp");
                return false;





        }

    }
}
