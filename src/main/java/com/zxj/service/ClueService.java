package com.zxj.service;

import com.zxj.domain.Clue;
import com.zxj.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean save(Clue clue);

    Clue detail(String id);


    boolean convert(String clueId, Tran t, String createBy);

    Map<String,Object>  getAllList(Map map);
    //查询线索
    Clue queryById(String id);

    int updateClue(Clue clue);
}
