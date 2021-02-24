package com.zxj.service.impl;

import com.zxj.domain.DicType;
import com.zxj.domain.DicValue;
import com.zxj.mapper.DicTypeDao;
import com.zxj.mapper.DicValueDao;
import com.zxj.mapper.UserMapper;
import com.zxj.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.servlet.ServletContext;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("dicTypeService")
public class DicTypeServiceImpl implements DicTypeService {
    @Autowired
    @Qualifier("dicTypeDao")
    private DicTypeDao dicTypeDao;

    @Autowired
    @Qualifier("dicValueDao")
    private DicValueDao dicValueDao;

    @Autowired
    @Qualifier("userMapper")
    private UserMapper userMapper;

    @Override
    public Map<String, List<DicValue>> getAll(ServletContext application) {

        Map<String, List<DicValue>> map = new HashMap<>();
        //将数据从数据字典中取出
       List<DicType> dicTypes =   dicTypeDao.getTypeList();


        return null;
    }

    @Override
    public Map<String, List<DicValue>> getAll() {
        List<DicType> daoTypeList = dicTypeDao.getTypeList();
        Map<String, List<DicValue>> map = new HashMap<>();
        for (DicType dicType : daoTypeList) {
            List<DicValue> valueList = dicValueDao.getValueList(dicType);
            String code = dicType.getCode();
            map.put(code,valueList);
        }
        return map;
    }
}
