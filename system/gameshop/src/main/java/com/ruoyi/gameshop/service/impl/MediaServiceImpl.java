package com.ruoyi.gameshop.service.impl;

import static com.ruoyi.gameshop.support.ShopValues.*;

import com.ruoyi.gameshop.exception.ShopException;
import com.ruoyi.gameshop.mapper.*;
import com.ruoyi.gameshop.model.bo.*;
import com.ruoyi.gameshop.model.result.*;
import com.ruoyi.gameshop.persistence.entity.*;
import com.ruoyi.gameshop.service.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.*;
import java.util.*;
import javax.imageio.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.*;

@Service
public class MediaServiceImpl implements MediaService {
  private final MediaMapper mapper;
  private final MemberMapper members;
  private final MemberService memberService;
  private final Path root;

  public MediaServiceImpl(
      MediaMapper mapper,
      MemberMapper members,
      MemberService memberService,
      @Value("${ruoyi.profile}") String root) {
    this.mapper = mapper;
    this.members = members;
    this.memberService = memberService;
    this.root = Path.of(root).toAbsolutePath().normalize();
  }

  @Transactional
  public ImageUploadResult upload(UploadCommand c, Actor actor, boolean avatar) {
    int max = avatar ? 2097152 : 5242880;
    if (c.content() == null || c.content().length == 0) throw ShopException.invalid("图片不能为空。");
    if (c.content().length > max)
      throw new ShopException(413, "MALL_UPLOAD_TOO_LARGE", "图片超过大小限制。");
    String original = c.originalName() == null ? "image" : c.originalName().replace('\\', '/');
    original = original.substring(original.lastIndexOf('/') + 1).replaceAll("[\\p{Cntrl}]", "");
    if (original.length() > 255) original = original.substring(0, 255);
    String lower = original.toLowerCase(Locale.ROOT);
    if (!lower.matches(".+\\.(png|jpe?g|webp)")) throw unsupported();
    Path target = null;
    try (var input = ImageIO.createImageInputStream(new ByteArrayInputStream(c.content()))) {
      var readers = ImageIO.getImageReaders(input);
      if (!readers.hasNext()) throw unsupported();
      ImageReader reader = readers.next();
      String format = reader.getFormatName().toLowerCase(Locale.ROOT);
      if (!Set.of("png", "jpeg", "jpg", "webp").contains(format)) throw unsupported();
      if (!(lower.endsWith("." + format) || (format.equals("jpeg") && lower.endsWith(".jpg"))))
        throw unsupported();
      reader.setInput(input, true, true);
      int w = reader.getWidth(0), h = reader.getHeight(0);
      if (w < 1 || h < 1 || w > 4096 || h > 4096)
        throw new ShopException(413, "MALL_UPLOAD_TOO_LARGE", "图片像素超过限制。");
      BufferedImage image;
      try {
        image = reader.read(0);
      } finally {
        reader.dispose();
      }
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      if (!ImageIO.write(image, "png", out)) throw unsupported();
      byte[] bytes = out.toByteArray();
      if (bytes.length > max) throw new ShopException(413, "MALL_UPLOAD_TOO_LARGE", "编码后图片超过大小限制。");
      String stored = UUID.randomUUID().toString().replace("-", "") + ".png";
      String relative = "mall/" + now().toLocalDate().toString().replace('-', '/') + "/" + stored;
      target = root.resolve(relative).normalize();
      if (!target.startsWith(root)) throw unsupported();
      Files.createDirectories(target.getParent());
      Files.write(target, bytes, StandardOpenOption.CREATE_NEW);
      final Path own = target;
      if (TransactionSynchronizationManager.isSynchronizationActive())
        TransactionSynchronizationManager.registerSynchronization(
            new TransactionSynchronization() {
              @Override
              public void afterCompletion(int status) {
                if (status != STATUS_COMMITTED)
                  try {
                    Files.deleteIfExists(own);
                  } catch (IOException ignored) {
                  }
              }
            });
      MediaEntity m = new MediaEntity();
      m.setStoredName(stored);
      m.setRelativePath(relative);
      m.setOriginalName(original);
      m.setMimeType("image/png");
      m.setFileSize(bytes.length);
      m.setWidth(w);
      m.setHeight(h);
      m.setSha256(
          java.util.HexFormat.of()
              .formatHex(java.security.MessageDigest.getInstance("SHA-256").digest(bytes)));
      m.setUploaderType(actor.type());
      m.setUploaderId(actor.id());
      m.setUploaderName(actor.name());
      mapper.insertMedia(m);
      return new ImageUploadResult(
          stored, "/api/mall/media/" + stored, original, "image/png", bytes.length);
    } catch (ShopException e) {
      throw e;
    } catch (Exception e) {
      if (target != null)
        try {
          Files.deleteIfExists(target);
        } catch (IOException ignored) {
        }
      throw unsupported();
    }
  }

  private ShopException unsupported() {
    return new ShopException(415, "MALL_UPLOAD_TYPE_UNSUPPORTED", "图片格式或内容不支持。");
  }

  @Transactional
  public MemberResult avatar(UploadCommand c, Long mid) {
    var member = members.lockMember(mid);
    if (member == null) throw ShopException.missing();
    var image = upload(c, new Actor("MEMBER", mid, member.getUsername()), true);
    member.setAvatarMediaId(mediaId(image.url()));
    members.updateAvatar(member);
    return memberService.profile(mid);
  }

  public Long mediaId(String url) {
    if (url == null) return null;
    var m = mapper.byPath(url);
    if (m == null || !Files.isRegularFile(path(m))) throw ShopException.invalid("必须使用已上传的本系统图片。");
    return m.getMediaId();
  }

  public String url(Long mid) {
    if (mid == null) return null;
    var m = mapper.findMedia(mid);
    return m == null ? null : m.getAccessPath();
  }

  public MediaEntity file(String name) {
    if (name == null || !name.matches("[0-9a-f]{32}\\.(png|jpg|webp)"))
      throw ShopException.missing();
    var m = mapper.byStoredName(name);
    if (m == null || !Files.isRegularFile(path(m))) throw ShopException.missing();
    return m;
  }

  public Path path(MediaEntity m) {
    Path p = root.resolve(m.getRelativePath()).normalize();
    if (!p.startsWith(root)) throw ShopException.missing();
    return p;
  }
}
