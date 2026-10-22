package com.ruoyi.gameshop.service.impl;

import com.ruoyi.gameshop.exception.ShopException;
import com.ruoyi.gameshop.mapper.MemberMapper;
import com.ruoyi.gameshop.persistence.entity.MemberEntity;
import com.ruoyi.system.service.ISysUserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/** 将已经由若依验证的账号关联到商城业务档案；不验证密码、不签发令牌。 */
@Service
public class RuoyiMemberService {
  private final MemberMapper members;
  private final ISysUserService users;
  public RuoyiMemberService(MemberMapper members, ISysUserService users) {
    this.members = members;
    this.users = users;
  }

  @Transactional
  public MemberEntity resolve(Long userId) {
    var member = members.bySysUserId(userId);
    if (member == null) {
      // Serialize concurrent first visits using the existing account row.
      if (members.lockSysUser(userId) == null) throw ShopException.missing();
      // A locking read sees the latest committed row under MySQL REPEATABLE READ.
      member = members.lockMemberBySysUserId(userId);
      if (member == null) {
        var user = users.selectUserById(userId);
        if (user == null || !"0".equals(user.getStatus()) || !"0".equals(user.getDelFlag()))
          throw new ShopException(401, "MALL_UNAUTHENTICATED", "请重新登录。");
        member = new MemberEntity();
        member.setSysUserId(userId);
        member.setUsername(user.getUserName());
        String nickname = user.getNickName();
        member.setNickname(nickname != null && nickname.length() >= 2 ? nickname : "玩家" + userId);
        member.setEmail(user.getEmail());
        member.setEmailVerified(0);
        member.setPhoneNumber(user.getPhonenumber());
        member.setStatus("0");
        member.setSessionVersion(0L);
        members.insertMember(member);
      }
    }
    if (!"0".equals(member.getStatus()))
      throw new ShopException(403, "MALL_MEMBER_DISABLED", "商城账号已停用，请联系管理员。");
    return member;
  }
}
