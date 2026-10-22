package com.ruoyi.gameshop.service;

public interface MailDelivery {
  void ensureReady();

  void send(String email, String scene, String code);
}
