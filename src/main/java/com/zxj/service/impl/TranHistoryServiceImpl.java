package com.zxj.service.impl;

import com.zxj.domain.TranHistory;
import com.zxj.mapper.TranHistoryDao;
import com.zxj.service.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("tranHistoryService")
public class TranHistoryServiceImpl implements TranHistoryService {
    @Autowired
    @Qualifier("tranHistoryDao")
    private TranHistoryDao tranHistoryDao;

    @Override
    public List<TranHistory> getHistoryById(String id) {
        return tranHistoryDao.getHistoryById(id);
    }
}
