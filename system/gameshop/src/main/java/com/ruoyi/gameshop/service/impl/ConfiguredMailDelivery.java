package com.ruoyi.gameshop.service.impl;

import com.ruoyi.gameshop.exception.ShopException;
import com.ruoyi.gameshop.service.MailDelivery;
import com.ruoyi.gameshop.support.ShopValues;
import java.nio.file.*;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class ConfiguredMailDelivery implements MailDelivery {
  private final String mode, path, from;
  private final ObjectProvider<JavaMailSender> sender;
  private final Environment env;

  public ConfiguredMailDelivery(
      @Value("${gameshop.mail-mode:disabled}") String mode,
      @Value("${gameshop.mailbox-path:./data/test-mailbox}") String path,
      @Value("${gameshop.mail-from:}") String from,
      ObjectProvider<JavaMailSender> sender,
      Environment env) {
    this.mode = mode;
    this.path = path;
    this.from = from;
    this.sender = sender;
    this.env = env;
  }

  public void send(String email, String scene, String code) {
    ensureReady();
    try {
      if ("file".equals(mode) && java.util.Arrays.asList(env.getActiveProfiles()).contains("dev")) {
        Path root = Path.of(path).toAbsolutePath().normalize();
        Files.createDirectories(root);
        Files.writeString(
            root.resolve(ShopValues.hash(email + ":" + scene) + ".txt"),
            "To: " + email + "\nScene: " + scene + "\nCode: " + code + "\n",
            StandardOpenOption.CREATE,
            StandardOpenOption.TRUNCATE_EXISTING);
      } else if ("smtp".equals(mode) && sender.getIfAvailable() != null && !from.isBlank()) {
        SimpleMailMessage m = new SimpleMailMessage();
        m.setFrom(from);
        m.setTo(email);
        m.setSubject("游戏商城邮箱验证");
        m.setText("本次" + scene + "验证码：" + code + "，5分钟内有效，请勿转发。");
        sender.getObject().send(m);
      } else throw new IllegalStateException();
    } catch (Exception e) {
      throw new ShopException(503, "MALL_MAIL_UNAVAILABLE", "邮件通道暂不可用。");
    }
  }

  public void ensureReady() {
    boolean developmentMailbox =
        "file".equals(mode) && java.util.Arrays.asList(env.getActiveProfiles()).contains("dev");
    boolean smtp = "smtp".equals(mode) && sender.getIfAvailable() != null && !from.isBlank();
    if (!developmentMailbox && !smtp)
      throw new ShopException(503, "MALL_MAIL_UNAVAILABLE", "邮件通道暂不可用。");
  }
}
