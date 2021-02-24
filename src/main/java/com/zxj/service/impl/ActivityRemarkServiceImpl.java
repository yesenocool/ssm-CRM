package com.zxj.service.impl;

import com.zxj.domain.ActivityRemark;
import com.zxj.mapper.ActivityRemarkMapper;
import com.zxj.service.ActivityRemarkService;

import java.util.List;

public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    private ActivityRemarkMapper activityRemarkMapper;

    public void setActivityRemarkMapper(ActivityRemarkMapper activityRemarkMapper) {
        this.activityRemarkMapper = activityRemarkMapper;
    }

    @Override
    public int queryByActiveId(String[] ids) {
        return activityRemarkMapper.queryByActiveId(ids);
    }

    @Override
    public int delByActiveId(String[] ids) {
        return activityRemarkMapper.delByActiveId(ids);
    }

    @Override
    public List<ActivityRemark> getRemarkList(String activityId) {
        return activityRemarkMapper.getRemarkList(activityId);
    }

    @Override
    public int deleteRemark(String id) {
        return activityRemarkMapper.deleteRemark(id);
    }

    @Override
    public Boolean addRematk(ActivityRemark activityRemark) {
        int i = activityRemarkMapper.addRemark(activityRemark);
        if (i>0){
            return true;
        }
        return false;
    }

    @Override
    public Boolean updateRemark(ActivityRemark activityRemark) {
      int i=    activityRemarkMapper.updateRemark(activityRemark);
        return  i>0?true:false;
    }
}
