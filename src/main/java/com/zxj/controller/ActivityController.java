package com.zxj.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.zxj.domain.Activity;
import com.zxj.domain.ActivityRemark;
import com.zxj.domain.User;
import com.zxj.service.ActivityRemarkService;
import com.zxj.service.ActivityService;
import com.zxj.service.UserService;
import com.zxj.utils.DateTimeUtil;
import com.zxj.utils.UUIDUtil;
import com.zxj.vo.PaginationVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/active")
public class ActivityController {

    @Autowired
    @Qualifier("userServiceImpl")
    private UserService userService;

    @Autowired
    @Qualifier("activityService")
    private ActivityService activityService;

    @Autowired
    @Qualifier("activityRemarkService")
    private ActivityRemarkService activityRemarkService;

    @RequestMapping(value = "/activeUsers",method = RequestMethod.GET)
    @ResponseBody
    public String getActiveUsers(){
        List<User> allUsers = userService.getAllUsers();
        ObjectMapper objectMapper = new ObjectMapper();
        String s="";
        try {
            s = objectMapper.writeValueAsString(allUsers);
            System.out.println(s);
            return s;
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return s;
    }

    //添加市场活动
    @RequestMapping("/activeAdd")
    @ResponseBody
    public boolean activeAdd(HttpSession session, Activity activity){

        String id = UUIDUtil.getUUID();
        //创建时间
        String createTime=  DateTimeUtil.getSysTime();
        //创建人
        String createBy = ((User) session.getAttribute("user")).getName();
        activity.setId(id);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);
        int i = activityService.addActivity(activity);
        if (i>0){
            return true;
        }
        return false;


    }

    //查找市场活动
    @RequestMapping(value="/activitySearch",method = RequestMethod.GET)
    @ResponseBody
    public String activitySearch(Activity activity,Integer pageNo,Integer pageSize){
        String name = activity.getName();
        String owner = activity.getOwner();
        String startDate = activity.getStartDate();
        String endDate = activity.getEndDate();
        // 计算出略过的记录数
        int skipCount = (pageNo - 1) * pageSize;
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        // 因为以下两条信息不在domain类中,所以选择使用map进行传值(<parameterType>传值不能使用vo类,<resultType>传值可以使用vo类)
        map.put("pageSize", pageSize);
        map.put("skipCount", skipCount);

        PaginationVo<Activity> vo = activityService.pageList(map);
        ObjectMapper objectMapper = new ObjectMapper();
        String s ="";
        try {
            s = objectMapper.writeValueAsString(vo);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }

        return s;

    }

    //删除市场活动
    @RequestMapping("/activeDel")
    @ResponseBody
    public Boolean activeDel(@RequestParam(value = "id") String[] ids){
        Boolean flag=true;
        //查询id对应的备注表信息数量
        int count1 = activityRemarkService.queryByActiveId(ids);
        //删除对应的备注表信息数量
        int count2 = activityRemarkService.delByActiveId(ids);
        //比较数量是否相同
        if(count1!=count2){
            return false;
        }
        //删除市场活动表的信息数量
        int count3 = activityService.delById(ids);
        //和传过来的数组的长度相比较，
        if(count3!=ids.length){
            flag=false;
        }
        return flag;

    }

    //修改信息
    @RequestMapping("/activeEdit")
    @ResponseBody
    public Map<String,Object> activeEdit(String id){
        //查询所有用户信息
        List<User> uList = userService.getAllUsers();
        //通过id来查询单条市场活动信息
        Activity a = activityService.getById(id);
        Map<String,Object> map = new HashMap<>();
        map.put("uList",uList);
        map.put("a",a);
        return map;
    }
    //更新市场活动
    @RequestMapping("/ativeUpdate")
    @ResponseBody
    public Boolean activeUpdate(HttpSession session,Activity activity){
        String editTime = DateTimeUtil.getSysTime();
        String editBy  = ((User)session.getAttribute("user")).getName();

        activity.setEditTime(editTime);
        activity.setEditBy(editBy);

        boolean update = activityService.update(activity);
        return update;
    }

    //进入到市场详细页
    @RequestMapping("/activeDetail")
    public ModelAndView activeDetail(ModelAndView modelAndView,String id){
        Activity activity = activityService.detailById(id);
        modelAndView.addObject("activity",activity);
        modelAndView.setViewName("forward:/workbench/activity/detail.jsp");
        return modelAndView;
    }

    //获取备注列表
    @RequestMapping("/getRemarkListByAid")
    @ResponseBody
    public String getRemarkListByAid(String activityId){
       List<ActivityRemark>  remarkList = activityRemarkService.getRemarkList(activityId);
        ObjectMapper objectMapper = new ObjectMapper();
        String arList="";
        try {
             arList = objectMapper.writeValueAsString(remarkList);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return arList;
    }

    //删除备注
    @RequestMapping("/deleteRemark")
    @ResponseBody
    public Boolean deleteRemark(String id){
        int i = activityRemarkService.deleteRemark(id);
        if (i>0){
            return true;
        }
        return false;
    }

    //添加备注
    @RequestMapping("/saveRemark")
    @ResponseBody
    public Map<String,Object> saveRemark(HttpSession session,ActivityRemark activityRemark){
        //获取创建时间
        String sysTime = DateTimeUtil.getSysTime();
        //获取创建人
        String name = ((User) session.getAttribute("user")).getName();
        //修改位
        String flag="0";
        //生成ID
        String uuid = UUIDUtil.getUUID();
        activityRemark.setId(uuid);
        activityRemark.setCreateBy(name);
        activityRemark.setEditFlag(flag);
        activityRemark.setCreateTime(sysTime);
        Boolean falg = activityRemarkService.addRematk(activityRemark);
        Map<String,Object> map = new HashMap<>();
        map.put("success",falg);
        map.put("ar",activityRemark);
        return map;
    }
    @RequestMapping("/updateRemark")
    @ResponseBody
    public Map<String,Object> updateRemark(HttpSession session,ActivityRemark activityRemark){
        //获取修改时间
        String editTime = DateTimeUtil.getSysTime();
//        修改人
        String editBy = ((User) session.getAttribute("user")).getName();
        //修改位
        String editFlag="1";
        activityRemark.setEditFlag(editFlag);
        activityRemark.setEditBy(editBy);
        activityRemark.setEditTime(editTime);

      Boolean  flag=  activityRemarkService.updateRemark(activityRemark);
        Map<String ,Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("ar",activityRemark);
        return map  ;

    }

    @RequestMapping("/getActivityListByNameAndNotByClueId")
    @ResponseBody
    public String getActivityListByNameAndNotByClueId(String name,String clueId){

        HashMap<String,String> map = new HashMap<>();
        map.put("name",name);
        map.put("clueId",clueId);
       List<Activity> activityList = activityService.getActivityListByNameAndNotByClueId(map);
       ObjectMapper objectMapper = new ObjectMapper();
       String List="";
        try {
           List= objectMapper.writeValueAsString(activityList);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return List;
    }

    @RequestMapping("/bundActivity")
    @ResponseBody
    public Boolean bundActivity(String cid,String[] aid){
       Boolean flag = activityService.bundActivity(cid,aid);
       return flag;
    }

    @RequestMapping("/searchActivityByName")
    @ResponseBody
    public String searchActivityByName(String name){
        List<Activity> activityList= activityService.getSearchActivityByName(name);
        ObjectMapper objectMapper = new ObjectMapper();
        String value = "";
        try {
            value = objectMapper.writeValueAsString(activityList);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return value;
    }


}
