package com.zxj.mapper;

import com.zxj.domain.Customer;

import java.util.List;

public interface CustomerDao {

    Customer getCustomerByName(String company);
    List<String> getCustomerByName2(String name);

    int save(Customer cus);
}
