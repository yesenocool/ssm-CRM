package com.zxj.service;

import com.zxj.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {

    //查询要删除的条数
    int queryByActiveId(String[] ids);
    //返回删除的条数
    int delByActiveId(String[] ids);

    List<ActivityRemark> getRemarkList(String activityId);

    int deleteRemark(String id);

    Boolean addRematk(ActivityRemark activityRemark);

    Boolean updateRemark(ActivityRemark activityRemark);
}
