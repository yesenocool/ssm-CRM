package com.zxj.service.impl;

import com.zxj.domain.Customer;
import com.zxj.domain.Tran;
import com.zxj.domain.TranHistory;
import com.zxj.mapper.CustomerDao;
import com.zxj.mapper.TranDao;
import com.zxj.mapper.TranHistoryDao;
import com.zxj.service.TranService;
import com.zxj.utils.DateTimeUtil;
import com.zxj.utils.UUIDUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("tranServiceImpl")
public class TranServiceImpl implements TranService {

    @Autowired
    @Qualifier("tranDao")
    private TranDao tranDao;

    @Autowired
    @Qualifier("tranHistoryDao")
    private TranHistoryDao tranHistoryDao;

    @Autowired
    @Qualifier("customerDao")
    private CustomerDao customerDao;


    @Override
    public boolean save(Tran tran, String customerName) {

        /**
         * 交易添加业务
         *      在做添加之前,参数t里面就少了一项信息,就是客户的主键,customerId
         *
         *      先处理客户相关的需求
         *      (1) 判断customerName,根据客户名称在客户表进行精确查询
         *          如果有这个客户,则取出这个客户的id,封装到t对象中
         *          如果没有这个客户,则在客户表新建一条客户信息,然后将新建的客户的id取出,封装到t对象中
         *
         *      (2) 经过以上操作后,t对象中的信息就全了,需要执行添加交易的操作
         *
         *      (3) 添加交易完毕后,需要创建一条交易历史
         */

        boolean flag = true;
        Customer cus = customerDao.getCustomerByName(customerName);
        if (cus == null) {
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateTime(DateTimeUtil.getSysTime());
            cus.setCreateBy(tran.getCreateBy());
            cus.setContactSummary(tran.getContactSummary());
            cus.setNextContactTime(tran.getNextContactTime());
            cus.setOwner(tran.getOwner());
            // 添加客户
            int count1 = customerDao.save(cus);
            if (count1 != 1) {
                flag = false;
            }
        }
        // 通过以上对于客户的处理,不论是查询出来已有的客户,还是以前没有我们新增的客户,总之客户已经有了,客户的id就有了
        // 将客户的id封装到t对象中
        tran.setCustomerId(cus.getId());

        int count2 = tranDao.save(tran);
        if (count2 != 1) {

            flag = false;

        }

// 添加交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(tran.getId());
        th.setStage(tran.getStage());
        th.setMoney(tran.getMoney());
        th.setExpectedDate(tran.getExpectedDate());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(tran.getCreateBy());
        int count3 = tranHistoryDao.save(th);

        if (count3 != 1) {

            flag = false;

        }

        return flag;
    }

    @Override
    public Tran detail(String id) {
        return tranDao.detail(id);
    }

    @Override
    public Map<String, Object> getChars() {
        // 取得total
        int total = tranDao.getTotal();

        // 取得dataList
        List<Map<String,Object>> dataList = tranDao.getChars();

        // 将total和dataList保存到map中
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("total",total);
        map.put("dataList",dataList);
        return map;
    }
}

