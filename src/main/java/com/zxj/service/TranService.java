package com.zxj.service;

import com.zxj.domain.Tran;
import com.zxj.domain.User;
import org.springframework.stereotype.Service;

import javax.security.auth.login.LoginException;
import java.util.List;
import java.util.Map;

@Service
public interface TranService {


    boolean save(Tran tran, String customerId);

    Tran detail(String id);

    Map<String, Object> getChars();

}
