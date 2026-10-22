package com.ruoyi.gameshop.controller;

import static com.ruoyi.gameshop.convert.CommandAssembler.*;
import static com.ruoyi.gameshop.convert.ViewAssembler.*;
import static com.ruoyi.gameshop.support.ShopValues.id;

import com.ruoyi.gameshop.convert.*;
import com.ruoyi.gameshop.model.dto.*;
import com.ruoyi.gameshop.model.vo.*;
import com.ruoyi.gameshop.security.*;
import com.ruoyi.gameshop.service.*;
import com.ruoyi.gameshop.web.*;
import jakarta.validation.Valid;
import java.io.IOException;
import java.net.URI;
import java.util.*;
import org.springframework.http.*;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@Validated
public class ReviewsController {
  private final ReviewService reviews;

  public ReviewsController(ReviewService reviews) {
    this.reviews = reviews;
  }

  private Long mid() {
    return ShopIdentity.member().memberId();
  }

  @GetMapping(value = "/api/mall/props/{propId}/reviews")
  public ResponseEntity<PageResponse<PublicReviewVo>> mallListPropReviews(
      @PathVariable String propId, @Valid @ModelAttribute ListQueryRequest query)
      throws IOException {
    var page = reviews.publicReviews(id(propId), QueryAssembler.toQuery(query, true));
    return ResponseEntity.ok(
        new PageResponse<>(
            200,
            "查询成功",
            page.rows().stream().map(ViewAssembler::toPublicReviewVo).toList(),
            page.total()));
  }

  @GetMapping(value = "/api/mall/me/reviews")
  public ResponseEntity<PageResponse<MemberReviewVo>> memberListMyReviews(
      @Valid @ModelAttribute ListQueryRequest query) throws IOException {
    var page = reviews.myReviews(mid(), QueryAssembler.toQuery(query, false));
    return ResponseEntity.ok(
        new PageResponse<>(
            200,
            "查询成功",
            page.rows().stream().map(ViewAssembler::toMemberReviewVo).toList(),
            page.total()));
  }

  @PostMapping(value = "/api/mall/reviews")
  public ResponseEntity<ApiResponse<MemberReviewVo>> memberCreateReview(
      @Valid @RequestBody CreateReviewRequest body) throws IOException {
    var result = reviews.create(mid(), toCreateReviewCommand(body));
    return ResponseEntity.status(201)
        .location(URI.create("/api/mall/me/reviews"))
        .body(ApiResponse.ok(toMemberReviewVo(result)));
  }
}
