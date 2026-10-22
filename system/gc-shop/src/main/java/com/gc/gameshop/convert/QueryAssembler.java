package com.gc.gameshop.convert;

import static com.gc.gameshop.support.ShopValues.*;

import com.gc.gameshop.exception.ShopException;
import com.gc.gameshop.model.dto.ListQueryRequest;
import com.gc.gameshop.model.query.ShopQuery;
import java.time.*;

public final class QueryAssembler {
  private QueryAssembler() {}

  private static LocalDateTime date(String v) {
    if (v == null) return null;
    try {
      OffsetDateTime d = OffsetDateTime.parse(v);
      if (!d.getOffset().equals(ZoneOffset.ofHours(8))) throw new IllegalArgumentException();
      return d.toLocalDateTime();
    } catch (RuntimeException e) {
      throw ShopException.invalid("日期必须携带 +08:00 偏移。");
    }
  }

  public static ShopQuery toQuery(ListQueryRequest v, boolean publicOnly) {
    int page = v.pageNum() == null ? 1 : v.pageNum(),
        size = v.pageSize() == null ? 10 : v.pageSize();
    var min = v.minPrice() == null ? null : amount(v.minPrice());
    var max = v.maxPrice() == null ? null : amount(v.maxPrice());
    if (min != null && max != null && min.compareTo(max) > 0)
      throw ShopException.invalid("价格下界不能大于上界。");
    var from = date(v.createdFrom());
    var to = date(v.createdTo());
    if (from != null && to != null && !from.isBefore(to)) throw ShopException.invalid("时间范围错误。");
    if (v.sort() != null
        && !java.util.Set.of("sales_desc", "price_asc", "price_desc", "on_sale_desc")
            .contains(v.sort())) throw ShopException.invalid("排序字段不合法。");
    return new ShopQuery(
        (page - 1) * size,
        size,
        clean(v.keyword()),
        v.categoryId() == null ? null : id(v.categoryId()),
        v.memberId() == null ? null : id(v.memberId()),
        v.propId() == null ? null : id(v.propId()),
        v.status(),
        v.orderNo(),
        v.bizType(),
        v.sort(),
        min,
        max,
        from,
        to,
        publicOnly);
  }
}
