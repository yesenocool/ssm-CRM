package com.zxj.mapper;

import com.zxj.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {


    //解除绑定
    int unbund(String id);
    //绑定市场活动
    int bund(ClueActivityRelation clueActivityRelation);

    List<ClueActivityRelation> getListByClueId(String clueId);

    int delete(ClueActivityRelation clueActivityRelation);
}
