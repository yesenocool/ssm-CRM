package com.zxj.listener;

import com.zxj.domain.DicValue;
import com.zxj.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {


    /**
     * 该方法是用来监听上下文域对象的方法,当服务器启动,上下文域对象创建
     * 对象创建完毕后,马上执行该方法
     *
     * event: 该参数能够取得监听的对象
     *      监听的是什么对象,就可以通过该参数取得什么对象
     *      例如我们现在监听的是上下文域对象,通过该参数就可以取得上下文域对象
     */
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {

        System.out.println("服务器处理缓存数据字典开始");
        ServletContext application = servletContextEvent.getServletContext();
        DicTypeService dicTypeService = (DicTypeService) WebApplicationContextUtils.getWebApplicationContext(servletContextEvent.getServletContext()).getBean("dicTypeService");


        Map<String, List<DicValue>> map = dicTypeService.getAll();
        Set<String> strings = map.keySet();
        for (String key : strings) {
            application.setAttribute(key,map.get(key));
        }

        //解析properties文件
        Map<String ,Object> hashMap = new HashMap<String, Object>();
        ResourceBundle stage2Possibility = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> keys = stage2Possibility.getKeys();
        while(keys.hasMoreElements()){
            //阶段
            String key = keys.nextElement();
            //可能性
            String value = stage2Possibility.getString(key);

            hashMap.put(key,value);
        }
        application.setAttribute("pMap",hashMap);


    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
