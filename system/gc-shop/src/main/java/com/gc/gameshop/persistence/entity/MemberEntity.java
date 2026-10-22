package com.gc.gameshop.persistence.entity;

import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class MemberEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long memberId;

  private Long sysUserId;
  public Long getSysUserId() { return sysUserId; }
  public void setSysUserId(Long value) { sysUserId = value; }

  /** trim 后小写，4–20 位字母/数字/下划线，首位字母；唯一 */
  private String username;

  /** BCrypt 密码散列，cost=12；禁止明文或 MD5；永不进入 VO */
  private String passwordHash;

  /** 2–30 字符的展示昵称，注册省略时采用 username */
  private String nickname;

  /** 头像关联受控媒体；默认无头像 */
  private Long avatarMediaId;

  /** trim 后整体小写；数据库二进制排序比较归一化值；唯一 */
  private String email;

  /** 0 未验证，1 已验证；注册验码成功明确写 1 */
  private Integer emailVerified;

  /** 可空联系方式；非空时 7–20 字符，格式由 DTO 校验 */
  private String phoneNumber;

  /** 0 正常，1 禁用，与商品状态含义相反 */
  private String status;

  /** 会话版本；禁用、改密和重置密码时递增，所有旧会话必须失效 */
  private Long sessionVersion;

  /** 最近一次启停原因；完整操作历史另留若依操作日志 */
  private String statusReason;

  /** 最近成功登录时间，首次未登录为空 */
  private LocalDateTime lastLoginTime;

  /** 记录创建时间，数据库会话为 +08:00 */
  private LocalDateTime createTime;

  /** 记录最近修改时间；更新行时由数据库刷新 */
  private LocalDateTime updateTime;

  public Long getMemberId() {
    return memberId;
  }

  public void setMemberId(Long value) {
    this.memberId = value;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String value) {
    this.username = value;
  }

  public String getPasswordHash() {
    return passwordHash;
  }

  public void setPasswordHash(String value) {
    this.passwordHash = value;
  }

  public String getNickname() {
    return nickname;
  }

  public void setNickname(String value) {
    this.nickname = value;
  }

  public Long getAvatarMediaId() {
    return avatarMediaId;
  }

  public void setAvatarMediaId(Long value) {
    this.avatarMediaId = value;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String value) {
    this.email = value;
  }

  public Integer getEmailVerified() {
    return emailVerified;
  }

  public void setEmailVerified(Integer value) {
    this.emailVerified = value;
  }

  public String getPhoneNumber() {
    return phoneNumber;
  }

  public void setPhoneNumber(String value) {
    this.phoneNumber = value;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String value) {
    this.status = value;
  }

  public Long getSessionVersion() {
    return sessionVersion;
  }

  public void setSessionVersion(Long value) {
    this.sessionVersion = value;
  }

  public String getStatusReason() {
    return statusReason;
  }

  public void setStatusReason(String value) {
    this.statusReason = value;
  }

  public LocalDateTime getLastLoginTime() {
    return lastLoginTime;
  }

  public void setLastLoginTime(LocalDateTime value) {
    this.lastLoginTime = value;
  }

  public LocalDateTime getCreateTime() {
    return createTime;
  }

  public void setCreateTime(LocalDateTime value) {
    this.createTime = value;
  }

  public LocalDateTime getUpdateTime() {
    return updateTime;
  }

  public void setUpdateTime(LocalDateTime value) {
    this.updateTime = value;
  }
}
