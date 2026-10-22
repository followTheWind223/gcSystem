package com.ruoyi.common.core.domain.model;

/**
 * 用户注册对象
 * 
 * @author ruoyi
 */
public class RegisterBody extends LoginBody
{
    @jakarta.validation.constraints.Size(max = 30)
    private String nickname;
    @jakarta.validation.constraints.Email
    @jakarta.validation.constraints.Size(max = 254)
    private String email;
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
