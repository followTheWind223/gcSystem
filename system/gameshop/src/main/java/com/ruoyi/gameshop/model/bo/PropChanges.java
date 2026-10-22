package com.ruoyi.gameshop.model.bo;

import com.ruoyi.gameshop.model.command.*;
import java.util.List;

public record PropChanges(
    String categoryId,
    String name,
    String coverUrl,
    String price,
    String originalPrice,
    List<PropImageCommand> images,
    String detailHtml,
    List<SpecificationCommand> specs,
    List<String> deliveryFields,
    String status) {}
