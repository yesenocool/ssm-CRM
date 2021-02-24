package com.zxj.mapper;

import com.zxj.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    int save(TranHistory th);

    List<TranHistory> getHistoryById(String id);
}
