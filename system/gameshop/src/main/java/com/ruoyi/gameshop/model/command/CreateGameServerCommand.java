package com.ruoyi.gameshop.model.command;
public record CreateGameServerCommand(Long categoryId, String name, int sort, String status, String remark) {}

