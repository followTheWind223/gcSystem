package com.gc.gameshop.model.command;

import java.util.List;

/** Service 业务输入；不作为数据库实体。 */
public record CartPreviewCommand(String source, List<String> cartItemIds) {}
