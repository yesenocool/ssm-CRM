package com.zxj.mapper;

import com.zxj.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {
    //查询要删除的条数
    int queryByActiveId(String[] ids);
    //返回删除的条数
    int delByActiveId(String[] ids);
    //通过activityId获取备注信息
    List<ActivityRemark> getRemarkList(String activityId);
    //通过id来删除备注
    int deleteRemark(String id);

    int addRemark(ActivityRemark activityRemark);

    int updateRemark(ActivityRemark activityRemark);
}
