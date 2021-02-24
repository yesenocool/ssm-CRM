package com.zxj.service;

import com.zxj.domain.Clue;
import com.zxj.domain.Tran;

public interface ClueService {
    boolean save(Clue clue);

    Clue detail(String id);


    boolean convert(String clueId, Tran t, String createBy);
}
