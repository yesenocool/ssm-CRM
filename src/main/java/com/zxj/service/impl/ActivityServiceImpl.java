package com.zxj.service.impl;

import com.zxj.domain.Activity;
import com.zxj.domain.ClueActivityRelation;
import com.zxj.mapper.ActivityMapper;
import com.zxj.mapper.ClueActivityRelationDao;
import com.zxj.service.ActivityService;
import com.zxj.utils.UUIDUtil;
import com.zxj.vo.PaginationVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {

    @Autowired
    @Qualifier("clueActivityRelationDao")
    private ClueActivityRelationDao clueActivityRelationDao;

    private ActivityMapper activityMapper;

    public void setActivityMapper(ActivityMapper activityMapper) {
        this.activityMapper = activityMapper;
    }

    @Override
    public int addActivity(Activity activity) {
        return activityMapper.addActivity(activity);
    }

    //分页查询
    @Override
    public PaginationVo<Activity> pageList(Map<String, Object> map) {
        //获取数据总数
        Integer total = activityMapper.getTotalCondition(map);
        //获取总信息数
        List<Activity> aList = activityMapper.pageList(map);
        PaginationVo<Activity> vo = new PaginationVo<>(total, aList);
        return vo;
    }

    //    通过id删除市场活动
    @Override
    public int delById(String[] ids) {
        return activityMapper.delById(ids);
    }

    //通过id来查询单条数据

    @Override
    public Activity getById(String id) {
        return activityMapper.getById(id);
    }

    @Override
    public boolean update(Activity activity) {
        return  activityMapper.update(activity)>0? true:false;
    }

    @Override
    public Activity detailById(String id) {
        return activityMapper.detailById(id);
    }

    @Override
    public List<Activity> getActivityListByClueId(String id) {
        return activityMapper.getActivityListByClueId(id);
    }

    @Override
    public List<Activity> getActivityListByNameAndNotByClueId(HashMap<String, String> map) {
        return activityMapper.getActivityListByNameAndNotByClueId(map);
    }

    @Override
    public Boolean bundActivity(String cid, String[] aid) {
        boolean flag = true;
        ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
        for (String s : aid) {
            clueActivityRelation.setId(UUIDUtil.getUUID());
            clueActivityRelation.setActivityId(s);
            clueActivityRelation.setClueId(cid);
            // 添加关联关系表中的记录
            int count = clueActivityRelationDao.bund(clueActivityRelation);
            if(count != 1){
                flag = false;
            }
        }

        return flag;
    }

    //通过名字来进行模糊查询，返回市场活动列表
    @Override
    public List<Activity> getSearchActivityByName(String name) {
        return activityMapper.getSearchActivityByName(name);
    }
}
