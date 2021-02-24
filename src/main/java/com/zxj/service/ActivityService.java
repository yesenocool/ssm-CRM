package com.zxj.service;

import com.zxj.domain.Activity;
import com.zxj.vo.PaginationVo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public  interface ActivityService {
    //添加市场活动
     int addActivity(Activity activity);
    //获取页面信息
     PaginationVo<Activity> pageList(Map<String, Object> map);
    //删除市场活动
     int delById(String[] ids);

     Activity getById(String id);

     boolean update(Activity activity);

     Activity detailById(String id);

     List<Activity> getActivityListByClueId(String id);

     List<Activity> getActivityListByNameAndNotByClueId(HashMap<String, String> map);

    Boolean bundActivity(String cid, String[] aid);

    List<Activity> getSearchActivityByName(String name);
}
