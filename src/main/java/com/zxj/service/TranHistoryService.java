package com.zxj.service;

import com.zxj.domain.TranHistory;

import java.util.List;

public interface TranHistoryService {
    List<TranHistory> getHistoryById(String id);

}
