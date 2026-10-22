package com.ruoyi.gameshop.service;

import com.ruoyi.gameshop.model.bo.Actor;
import com.ruoyi.gameshop.model.command.*;
import com.ruoyi.gameshop.model.query.ShopQuery;
import com.ruoyi.gameshop.model.result.*;

public interface ReviewService {
  PageResult<PublicReviewResult> publicReviews(Long prop, ShopQuery query);

  PageResult<MemberReviewResult> myReviews(Long member, ShopQuery query);

  MemberReviewResult create(Long member, CreateReviewCommand command);

  PageResult<AdminReviewResult> list(ShopQuery query);

  AdminReviewResult get(Long id);

  AdminReviewResult hide(Long id, HideReviewCommand command, Actor actor);
}
