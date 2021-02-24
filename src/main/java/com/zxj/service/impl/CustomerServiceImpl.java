package com.zxj.service.impl;

import com.zxj.mapper.CustomerDao;
import com.zxj.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("customerService")
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    @Qualifier("customerDao")
    private CustomerDao customerDao;

    @Override
    public List<String> getCustomerName(String name) {
        return customerDao.getCustomerByName2(name);
    }
}
