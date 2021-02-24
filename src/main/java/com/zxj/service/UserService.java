package com.zxj.service;

import com.zxj.domain.User;

import javax.security.auth.login.LoginException;
import java.util.List;

public interface UserService {

    User login(String loginAct, String loginpwd) throws LoginException;

    List<User> getAllUsers();
}
