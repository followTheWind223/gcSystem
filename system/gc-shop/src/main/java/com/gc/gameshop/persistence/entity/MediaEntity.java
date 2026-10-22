package com.gc.gameshop.persistence.entity;

import java.time.LocalDateTime;

/** 仅由 Mapper 与 Service 使用的表实体。 */
public class MediaEntity {
  /** 自增主键；应用只使用正数，接口序列化为字符串 */
  private Long mediaId;

  /** 32 位小写十六进制随机名加 .png/.jpg/.webp */
  private String storedName;

  /** 从文件名生成同源 URL，不保存域名或磁盘绝对路径 */
  private String accessPath;

  /** 相对 UPLOAD_PATH 的服务器生成路径，例如 mall/2026/10/22/随机名.png；服务端规范化后必须在根目录内 */
  private String relativePath;

  /** 去除目录和控制字符后的原始文件名 */
  private String originalName;

  /** 重新编码后的实际 MIME：image/png、image/jpeg、image/webp */
  private String mimeType;

  /** 编码后字节数，1–5242880；头像额外限制为 2097152 */
  private Integer fileSize;

  /** 图片宽度，1–4096 像素 */
  private Integer width;

  /** 图片高度，1–4096 像素 */
  private Integer height;

  /** 编码后文件 SHA-256；用于完整性核对，不作为唯一键 */
  private String sha256;

  /** ADMIN 或 MEMBER；与 uploader_id 组成逻辑引用 */
  private String uploaderType;

  /** 按 uploader_type 关联 sys_user.user_id 或 mall_member.member_id，服务层验证，非物理外键 */
  private Long uploaderId;

  /** 上传者账号快照，账号之后更名/删除不改历史 */
  private String uploaderName;

  /** 上传完成时间 */
  private LocalDateTime createTime;

  public Long getMediaId() {
    return mediaId;
  }

  public void setMediaId(Long value) {
    this.mediaId = value;
  }

  public String getStoredName() {
    return storedName;
  }

  public void setStoredName(String value) {
    this.storedName = value;
  }

  public String getAccessPath() {
    return accessPath;
  }

  public void setAccessPath(String value) {
    this.accessPath = value;
  }

  public String getRelativePath() {
    return relativePath;
  }

  public void setRelativePath(String value) {
    this.relativePath = value;
  }

  public String getOriginalName() {
    return originalName;
  }

  public void setOriginalName(String value) {
    this.originalName = value;
  }

  public String getMimeType() {
    return mimeType;
  }

  public void setMimeType(String value) {
    this.mimeType = value;
  }

  public Integer getFileSize() {
    return fileSize;
  }

  public void setFileSize(Integer value) {
    this.fileSize = value;
  }

  public Integer getWidth() {
    return width;
  }

  public void setWidth(Integer value) {
    this.width = value;
  }

  public Integer getHeight() {
    return height;
  }

  public void setHeight(Integer value) {
    this.height = value;
  }

  public String getSha256() {
    return sha256;
  }

  public void setSha256(String value) {
    this.sha256 = value;
  }

  public String getUploaderType() {
    return uploaderType;
  }

  public void setUploaderType(String value) {
    this.uploaderType = value;
  }

  public Long getUploaderId() {
    return uploaderId;
  }

  public void setUploaderId(Long value) {
    this.uploaderId = value;
  }

  public String getUploaderName() {
    return uploaderName;
  }

  public void setUploaderName(String value) {
    this.uploaderName = value;
  }

  public LocalDateTime getCreateTime() {
    return createTime;
  }

  public void setCreateTime(LocalDateTime value) {
    this.createTime = value;
  }
}
