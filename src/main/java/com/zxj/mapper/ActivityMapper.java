package com.zxj.mapper;


import com.zxj.domain.Activity;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    //添加市场活动
    int addActivity(Activity activity);
    //分页查找数据并返回前端
    List<Activity> pageList(Map<String, Object> map);
    //获取记录总数
    Integer getTotalCondition(Map<String, Object> map);
    //删除市场活动
    int delById(String[] ids);
    //通过ID来查询数据
    Activity getById(String id);
    //更新市场活动
    int update(Activity activity);
    //通过id查询市场活动详细
    Activity detailById(String id);
    //通过线索id查询对应的市场活动
    List<Activity> getActivityListByClueId(String id);
    //通过名字查询没有关联的市场活动列表
    List<Activity> getActivityListByNameAndNotByClueId(HashMap<String, String> map);

    List<Activity> getSearchActivityByName(String name);
}
