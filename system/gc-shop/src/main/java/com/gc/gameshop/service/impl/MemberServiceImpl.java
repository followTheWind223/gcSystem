package com.gc.gameshop.service.impl;

import static com.gc.gameshop.support.ShopValues.*;
import com.gc.gameshop.exception.ShopException;
import com.gc.gameshop.mapper.*;
import com.gc.gameshop.model.bo.Actor;
import com.gc.gameshop.model.command.*;
import com.gc.gameshop.model.query.ShopQuery;
import com.gc.gameshop.model.result.*;
import com.gc.gameshop.persistence.entity.*;
import com.gc.gameshop.service.*;
import com.gc.common.utils.SecurityUtils;
import com.gc.system.service.ISysUserService;
import java.util.Set;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MemberServiceImpl implements MemberService {
  private final MemberMapper members;
  private final MediaMapper media;
  private final ISysUserService users;
  public MemberServiceImpl(MemberMapper members, MediaMapper media, ISysUserService users) {
    this.members = members;
    this.media = media;
    this.users = users;
  }

  public MemberResult profile(Long mid) {
    var m = require(mid);
    return new MemberResult(
        id(m.getMemberId()),
        m.getUsername(),
        m.getNickname(),
        avatar(m),
        m.getEmail(),
        m.getEmailVerified() == 1,
        m.getPhoneNumber(),
        time(m.getCreateTime()));
  }

  @Transactional
  public MemberResult update(Long mid, UpdateProfileCommand c) {
    var m = members.lockMember(mid);
    if (m == null) throw ShopException.missing();
    m.setNickname(c.nickname().trim());
    m.setPhoneNumber(clean(c.phoneNumber()));
    var user = users.selectUserById(m.getSysUserId());
    user.setNickName(m.getNickname());
    user.setPhonenumber(m.getPhoneNumber());
    if (m.getPhoneNumber() != null && !users.checkPhoneUnique(user))
      throw ShopException.conflict("MALL_PHONE_EXISTS", "手机号码已被使用。");
    users.updateUserProfile(user);
    members.updateProfile(m);
    return profile(mid);
  }

  @Transactional
  public void password(Long mid, ChangePasswordCommand c) {
    var m = members.lockMember(mid);
    if (m == null) throw ShopException.missing();
    var user = users.selectUserById(m.getSysUserId());
    if (!SecurityUtils.matchesPassword(c.oldPassword(), user.getPassword()))
      throw new ShopException(400, "MALL_OLD_PASSWORD_INVALID", "原密码不正确。");
    users.resetUserPwd(user.getUserId(), SecurityUtils.encryptPassword(c.newPassword()));
  }

  private MemberEntity require(Long mid) {
    var m = members.findMember(mid);
    if (m == null) throw ShopException.missing();
    var user = users.selectUserById(m.getSysUserId());
    if (user != null) {
      m.setUsername(user.getUserName());
      m.setNickname(user.getNickName());
      m.setEmail(user.getEmail());
      m.setPhoneNumber(user.getPhonenumber());
    }
    return m;
  }

  private String avatar(MemberEntity m) {
    var f = m.getAvatarMediaId() == null ? null : media.findMedia(m.getAvatarMediaId());
    return f == null ? null : f.getAccessPath();
  }

  public AdminMemberResult admin(Long mid) {
    var m = require(mid);
    String email = m.getEmail();
    String masked = email != null && email.indexOf('@') > 0 ? email.substring(0, 1) + "***" + email.substring(email.indexOf('@')) : null;
    String p = m.getPhoneNumber();
    if (p != null)
      p = p.length() >= 7 ? p.substring(0, 3) + "****" + p.substring(p.length() - 4) : "***";
    return new AdminMemberResult(
        id(mid),
        m.getUsername(),
        m.getNickname(),
        avatar(m),
        masked,
        p,
        m.getStatus(),
        time(m.getCreateTime()),
        time(m.getLastLoginTime()));
  }

  public PageResult<AdminMemberResult> list(ShopQuery q) {
    if (q.status() != null && !Set.of("0", "1").contains(q.status()))
      throw ShopException.invalid("会员状态不合法。");
    return new PageResult<>(
        members.listMember(q).stream().map(m -> admin(m.getMemberId())).toList(),
        members.countMember(q));
  }

  @Transactional
  public AdminMemberResult status(Long mid, UpdateMemberStatusCommand c, Actor actor) {
    var m = members.lockMember(mid);
    if (m == null) throw ShopException.missing();
    m.setStatus(c.status());
    m.setStatusReason(c.reason().trim());
    members.setStatus(m);
    return admin(mid);
  }
}
