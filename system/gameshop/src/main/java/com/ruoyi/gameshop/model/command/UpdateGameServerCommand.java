package com.ruoyi.gameshop.model.command;
public record UpdateGameServerCommand(Long categoryId, String name, int sort, String status, String remark, int version) {}

