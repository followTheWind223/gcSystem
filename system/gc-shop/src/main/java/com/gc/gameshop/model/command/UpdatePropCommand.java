package com.gc.gameshop.model.command;

import java.util.List;

/** Service 业务输入；不作为数据库实体。 */
public record UpdatePropCommand(
    String categoryId,
    String name,
    String coverUrl,
    String price,
    String originalPrice,
    List<PropImageCommand> images,
    String detailHtml,
    List<SpecificationCommand> specs,
    List<String> deliveryFields,
    String status,
    Integer version) {}
