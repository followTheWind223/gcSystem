package com.gc.gameshop.mapper;

import com.gc.gameshop.persistence.entity.*;
import java.util.List;
import org.apache.ibatis.annotations.*;

@Mapper
public interface CartMapper {
  CartItemEntity findCartItem(@Param("id") Long id);

  CartItemEntity lockCartItem(@Param("id") Long id);

  int insertCartItem(CartItemEntity row);

  List<CartItemEntity> items(@Param("memberId") Long memberId);

  CartItemEntity byProp(@Param("memberId") Long memberId, @Param("propId") Long propId);

  int update(CartItemEntity row);

  int remove(@Param("id") Long id, @Param("memberId") Long memberId);
}
