package com.gc.gameshop.mapper;

import com.gc.gameshop.model.query.ShopQuery;
import com.gc.gameshop.persistence.entity.*;
import java.util.List;
import org.apache.ibatis.annotations.*;

@Mapper
public interface ReviewMapper {
  ReviewEntity findReview(@Param("id") Long id);

  ReviewEntity lockReview(@Param("id") Long id);

  int insertReview(ReviewEntity row);

  ReviewEntity byItem(@Param("id") Long id);

  int hide(ReviewEntity row);

  long countVisible(@Param("id") Long id);

  Double averageScore(@Param("id") Long id);

  List<ReviewEntity> listReview(ShopQuery query);

  long countReview(ShopQuery query);
}
