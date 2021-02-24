package com.zxj.service.impl;

import com.zxj.mapper.DicValueDao;
import com.zxj.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service("dicValueService")
public class DicValueServiceImpl implements DicValueService {
    @Autowired
    @Qualifier("dicValueDao")
    private DicValueDao dicValueDao;
}
