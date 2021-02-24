package com.zxj.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.zxj.domain.Tran;
import com.zxj.domain.TranHistory;
import com.zxj.domain.User;
import com.zxj.service.CustomerService;
import com.zxj.service.TranHistoryService;
import com.zxj.service.TranService;
import com.zxj.service.UserService;
import com.zxj.service.impl.TranServiceImpl;
import com.zxj.utils.DateTimeUtil;
import com.zxj.utils.PrintJson;
import com.zxj.utils.UUIDUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/tranController")
public class TranController {
    @Autowired
    @Qualifier("userServiceImpl")
    private UserService userService;

    @Autowired
    @Qualifier("customerService")
    private CustomerService customerService;

    @Autowired
    @Qualifier("tranServiceImpl")
    private TranService tranService;

    @Autowired
    @Qualifier("tranHistoryService")
    private TranHistoryService tranHistoryService;



    @RequestMapping("/add.do")
    public void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> allUsers = userService.getAllUsers();
        request.setAttribute("uList",allUsers);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request,response);
    }

    @RequestMapping("/getCustomerName")
    @ResponseBody
    public String getCustomerName(String name){
       List<String> sList= customerService.getCustomerName(name);
        ObjectMapper objectMapper = new ObjectMapper();
        String s = "";
        try {
            s = objectMapper.writeValueAsString(sList);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return s;

    }

    @RequestMapping("/save.do")
    public void saveTranBtn(Tran tran,HttpServletRequest request,HttpServletResponse response) throws IOException {

        String id = UUIDUtil.getUUID();
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        tran.setId(id);
        tran.setCreateBy(createBy);
        tran.setCreateTime(createTime);
        String customerName = request.getParameter("customerName"); // 此处我们暂时只有客户名称,还没有id

        //保存交易
      boolean flag =    tranService.save(tran,customerName);

        if(flag){
            // 如果添加交易成功,跳转到列表页
            response.sendRedirect(request.getContextPath()+"/workbench/transaction/index.jsp");
        }
    }

    @RequestMapping("/detail.do")

    public void getDetail(String id,HttpServletRequest req,HttpServletResponse resp) throws ServletException, IOException {
        Tran t = tranService.detail(id);
        String stage = t.getStage();

        req.setAttribute("t",t);

        req.getRequestDispatcher( "/workbench/transaction/detail.jsp").forward(req,resp);
    }

    @RequestMapping("/showHistory")
    @ResponseBody
    public String showHistory(String id){
      List<TranHistory> historyList=  tranHistoryService.getHistoryById(id);
        ObjectMapper objectMapper = new ObjectMapper();
        String s = "";
        try {

            s = objectMapper.writeValueAsString(historyList);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return s;
    }
    @RequestMapping("/getChars.do")
    @ResponseBody
    public String  getChars(){
        System.out.println("取得交易阶段数量统计图标的数据");

        /**
         * 业务层为我们返回
         *  total
         *  dataList
         *
         *  通过map打包以上两项进行返回
         */
        Map<String,Object> map = tranService.getChars();

        ObjectMapper objectMapper = new ObjectMapper();
        String s = "";
        try {
            s = objectMapper.writeValueAsString(map);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return s;


    }


}
