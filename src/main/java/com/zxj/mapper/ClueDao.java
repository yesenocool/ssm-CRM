package com.zxj.mapper;


import com.zxj.domain.Clue;

public interface ClueDao {

    //添加线索
    int save(Clue clue);

    //查询线索
    Clue queryById(String id);
    //通过id来解除线索-市场活动的关联
    int unbund(String id);

    //通过id来查询线索
    Clue getById(String clueId);

    int delete(String clueId);
}
