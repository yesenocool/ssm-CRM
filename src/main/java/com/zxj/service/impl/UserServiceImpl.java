package com.zxj.service.impl;

import com.zxj.domain.User;
import com.zxj.mapper.UserMapper;
import com.zxj.service.UserService;
import com.zxj.utils.DateTimeUtil;

import javax.security.auth.login.LoginException;
import java.util.List;

public class UserServiceImpl implements UserService {
    private UserMapper userMapper;

    public void setUserMapper(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    @Override
    public User login(String loginAct, String loginpwd) throws LoginException {
        User user = userMapper.login(loginAct, loginpwd);
        if (user==null){
            throw new LoginException("账号密码错误");
        }

        //验证登录时间
        String expireTime = user.getExpireTime();
        String sysTime = DateTimeUtil.getSysTime();
        if (expireTime.compareTo(sysTime)<0){
            throw new LoginException("账号已失效");
        }

        //判定锁定状态
        if("0".equals(user.getLockState())){
            throw new LoginException("账号已锁定");
        }
        return user;
    }

    @Override
    public List<User> getAllUsers() {
        return userMapper.allUsers();
    }
}
