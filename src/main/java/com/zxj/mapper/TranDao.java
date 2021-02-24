package com.zxj.mapper;

import com.zxj.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int save(Tran t);

    Tran detail(String id);

    int getTotal();

    List<Map<String, Object>> getChars();
}
