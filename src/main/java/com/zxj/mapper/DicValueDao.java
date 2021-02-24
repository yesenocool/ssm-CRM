package com.zxj.mapper;

import com.zxj.domain.DicType;
import com.zxj.domain.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getValueList(DicType dicType);
}
