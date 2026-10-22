package com.ruoyi.gameshop.model.bo;

public record Actor(String type, Long id, String name) {
  public static Actor system() {
    return new Actor("SYSTEM", null, "system");
  }
}
