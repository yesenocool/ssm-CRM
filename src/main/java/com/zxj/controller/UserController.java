package com.zxj.controller;

import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.deploy.net.HttpResponse;
import com.zxj.domain.User;
import com.zxj.service.UserService;
import com.zxj.utils.MD5Util;
import com.zxj.utils.PrintJson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.security.auth.login.LoginException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    @Qualifier("userServiceImpl")
    private UserService userService;

    @RequestMapping(value = "/userLogin",method = RequestMethod.POST)
    @ResponseBody
    public String userLogin(@RequestBody Map<String,String> map, HttpServletRequest request, HttpServletResponse response){
        String loginAct = map.get("loginAct");
        String loginpwd = MD5Util.getMD5(map.get("loginpwd"));
        JSONObject json = null;
        String s = null;
        ObjectMapper objectMapper = new ObjectMapper();

        try {
            User user = userService.login(loginAct, loginpwd);
            request.getSession().setAttribute("user",user);
            Map<String,Boolean> map2 = new HashMap<String,Boolean>();
            map2.put("success",true);

            s = objectMapper.writeValueAsString(map2);

        } catch (LoginException e) {
            e.printStackTrace();
            String message = e.getMessage();
            Map<String,Object> stringMap = new HashMap<>();
            stringMap.put("success",false);
            stringMap.put("msg",message);
            try {
                String s1 = objectMapper.writeValueAsString(stringMap);
                return s1;
            } catch (JsonProcessingException ex) {
                ex.printStackTrace();
            }
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return s;
    }


}
