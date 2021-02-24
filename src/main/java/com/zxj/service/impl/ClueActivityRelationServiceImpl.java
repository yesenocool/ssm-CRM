package com.zxj.service.impl;

import com.zxj.mapper.ClueActivityRelationDao;
import com.zxj.mapper.ClueDao;
import com.zxj.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service("clueActivityRelationServiceImpl")
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {
    @Autowired
    @Qualifier("clueActivityRelationDao")
    private ClueActivityRelationDao clueActivityRelationDao;


    @Override
    public Boolean unbund(String id) {
        int i =  clueActivityRelationDao.unbund(id);
        if(i>0){
            return true;
        }
        return false;
    }
}
