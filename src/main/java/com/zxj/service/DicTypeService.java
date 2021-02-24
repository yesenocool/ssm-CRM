package com.zxj.service;

import com.zxj.domain.DicValue;

import javax.servlet.ServletContext;
import java.util.List;
import java.util.Map;

public interface DicTypeService {
    Map<String, List<DicValue>> getAll(ServletContext application);


    Map<String, List<DicValue>> getAll();
}
