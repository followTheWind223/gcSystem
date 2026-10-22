package com.ruoyi.gameshop.model.dto;

import jakarta.validation.constraints.*;

/** HTTP 请求允许字段；不作为数据库实体。 */
public record DeliveryInfo(
    @Size(min = 1, max = 100) String gameAccount,
    @Size(min = 1, max = 100) String serverName,
    @Size(min = 1, max = 100) String roleName,
    @Size(min=1,max=50) java.util.List<@NotNull @Pattern(regexp="^[1-9][0-9]{0,18}$") String> serverIds) {}
