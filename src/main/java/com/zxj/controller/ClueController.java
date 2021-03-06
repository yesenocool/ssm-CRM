package com.zxj.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.zxj.domain.*;
import com.zxj.service.ActivityService;
import com.zxj.service.ClueActivityRelationService;
import com.zxj.service.ClueService;
import com.zxj.service.UserService;
import com.zxj.utils.DateTimeUtil;
import com.zxj.utils.UUIDUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/clue")
public class ClueController {
    @Autowired
    @Qualifier("clueService")
    private ClueService clueService;

    @Autowired
    @Qualifier("userServiceImpl")
    private UserService userService;


    @Autowired
    @Qualifier("activityService")
    private ActivityService activityService;

    @Autowired
    @Qualifier("clueActivityRelationServiceImpl")
    private ClueActivityRelationService clueActivityRelationServiceImpl;


    //保存修改结果
    @RequestMapping("/updateClue")
    @ResponseBody
    public boolean updateClue(HttpSession session,Clue clue){
        boolean flag = true;
        String editBy = ((User)session.getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        int count = clueService.updateClue(clue);
        if(count != 1){
            flag = false;
        }
        return flag;
    }


    //修改线索
    @RequestMapping("/getClueById")
    @ResponseBody
    public Map<String,Object> getClueById(String  id){

       //查询所有拥有者
        List<User> uList = userService.getAllUsers();
        //通过id来查线索
        Clue clue = clueService.queryById(id);

        Map<String,Object> map = new HashMap<>();
        map.put("uList",uList);
        map.put("clue",clue);
        return map;

    }

    @RequestMapping("/clueSearch")
    @ResponseBody
    public Map<String,Object> clueSearch(Clue clue,int pageNo,int pageSize){
        String fullname = clue.getFullname();
        String company = clue.getCompany();
        String phone = clue.getPhone();
        String source = clue.getSource();
        String owner = clue.getOwner();
        String mphone = clue.getMphone();
        String state = clue.getState();

        int skipCount = (pageNo-1) * pageSize;
        Map<String,Object> map = new HashMap<>();
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("mphone",mphone);
        map.put("state",state);

       Map<String,Object> clues =  clueService.getAllList(map);

        return clues;
    }

    @RequestMapping("/getUserList")
    @ResponseBody
    public List<User> getUserList(){
        List<User> allUsers = userService.getAllUsers();
        return allUsers;
    }

    //添加线索
    @RequestMapping("/saveBtn")
    @ResponseBody
    public Boolean saveBtn(Clue clue, HttpSession session){
        String id = UUIDUtil.getUUID();
        String createBy = ((User)session.getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        clue.setId(id);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);

        boolean flag = clueService.save(clue);

        return flag;
    }

    //跳转到详细页面
    @RequestMapping("/showDetail")

    public ModelAndView  showDetail(ModelAndView modelAndView, String id){
        Clue clue = clueService.detail(id);
        modelAndView.addObject("c",clue);
        modelAndView.setViewName("forward:/workbench/clue/detail.jsp");
        return modelAndView;
    }

    @RequestMapping("/ActivityListByClueId")
    @ResponseBody
    public String ActivityListByClueId(String id){
      List<Activity> activityList = activityService.getActivityListByClueId(id);
        ObjectMapper objectMapper = new ObjectMapper();
        String arList="";
        try {
            arList = objectMapper.writeValueAsString(activityList);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return arList;
    }

    @RequestMapping("/unbund")
    @ResponseBody
    public Boolean unbund(String id){
     Boolean flag=   clueActivityRelationServiceImpl.unbund(id);
     return flag;
    }


    //转换线索事件
    @RequestMapping("/convert.do")
    public void converClue(HttpServletRequest request, HttpServletResponse response) throws IOException {

        //通过判断flag是否等于a来决定是否创建交易
        String flag = request.getParameter("flag");
        String clueId = request.getParameter("clueId");//线索id
        String createBy = ((User)request.getSession().getAttribute("user")).getName();//创建者
        Tran t = null;

        if("a".equals(flag)){
            //创建一次交易,同时这里将交易的信息封装到t中，业务层通过判断 t 是否为空，来进行交易操作的添加
            // 接收交易表单中的参数
            String money = request.getParameter("money");
            String name = request.getParameter("name");
            String expectedDate = request.getParameter("expectedDate");
            String stage = request.getParameter("stage");
            String activityId = request.getParameter("activityId");
            String id = UUIDUtil.getUUID();
            String createTime = DateTimeUtil.getSysTime();

            t = new Tran();

            t.setId(id);
            t.setMoney(money);
            t.setName(name);
            t.setExpectedDate(expectedDate);
            t.setStage(stage);
            t.setActivityId(activityId);
            t.setCreateTime(createTime);
            t.setCreateBy(createBy);
        }

        boolean flag2 =  clueService.convert(clueId,t,createBy);
        if (flag2){
            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
        }


    }

}
