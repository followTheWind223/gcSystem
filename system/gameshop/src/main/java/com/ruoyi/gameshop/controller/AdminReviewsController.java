package com.ruoyi.gameshop.controller;

import static com.ruoyi.gameshop.convert.CommandAssembler.*;
import static com.ruoyi.gameshop.convert.ViewAssembler.*;
import static com.ruoyi.gameshop.support.ShopValues.id;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.gameshop.convert.*;
import com.ruoyi.gameshop.model.dto.*;
import com.ruoyi.gameshop.model.vo.*;
import com.ruoyi.gameshop.security.*;
import com.ruoyi.gameshop.service.*;
import com.ruoyi.gameshop.web.*;
import jakarta.validation.Valid;
import java.io.IOException;
import java.util.*;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@Validated
public class AdminReviewsController {
  private final ReviewService reviews;

  public AdminReviewsController(ReviewService reviews) {
    this.reviews = reviews;
  }

  @GetMapping(value = "/mall/reviews")
  @PreAuthorize("@ss.hasPermi('mall:review:list')")
  public ResponseEntity<PageResponse<AdminReviewVo>> adminListReviews(
      @Valid @ModelAttribute ListQueryRequest query) throws IOException {
    var page = reviews.list(QueryAssembler.toQuery(query, false));
    return ResponseEntity.ok(
        new PageResponse<>(
            200,
            "查询成功",
            page.rows().stream().map(ViewAssembler::toAdminReviewVo).toList(),
            page.total()));
  }

  @GetMapping(value = "/mall/reviews/{reviewId}")
  @PreAuthorize("@ss.hasPermi('mall:review:query')")
  public ResponseEntity<ApiResponse<AdminReviewVo>> adminGetReview(@PathVariable String reviewId)
      throws IOException {
    var result = reviews.get(id(reviewId));
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminReviewVo(result)));
  }

  @PutMapping(value = "/mall/reviews/{reviewId}/visibility")
  @PreAuthorize("@ss.hasPermi('mall:review:remove')")
  @Log(
      title = "商城：后台隐藏违规评价",
      businessType = BusinessType.UPDATE,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<AdminReviewVo>> adminHideReview(
      @PathVariable String reviewId, @Valid @RequestBody HideReviewRequest body)
      throws IOException {
    var result = reviews.hide(id(reviewId), toHideReviewCommand(body), ShopIdentity.admin());
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminReviewVo(result)));
  }
}
