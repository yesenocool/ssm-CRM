package com.zxj.mapper;

import com.zxj.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {

    //登录：通过账号和密码来查询用户是否存在
    User login(@Param("loginAct")String loginAct,@Param("loginpwd") String loginPwd);

    List<User> allUsers();

}
