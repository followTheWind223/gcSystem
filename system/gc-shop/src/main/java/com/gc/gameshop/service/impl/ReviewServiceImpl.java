package com.gc.gameshop.service.impl;

import static com.gc.gameshop.support.ShopValues.*;

import com.gc.gameshop.exception.ShopException;
import com.gc.gameshop.mapper.*;
import com.gc.gameshop.model.bo.Actor;
import com.gc.gameshop.model.command.*;
import com.gc.gameshop.model.query.ShopQuery;
import com.gc.gameshop.model.result.*;
import com.gc.gameshop.persistence.entity.*;
import com.gc.gameshop.service.*;
import java.util.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ReviewServiceImpl implements ReviewService {
  private final ReviewMapper reviews;
  private final OrderMapper orders;
  private final MemberMapper members;
  private final CatalogService catalog;
  private final MediaService media;

  public ReviewServiceImpl(
      ReviewMapper reviews,
      OrderMapper orders,
      MemberMapper members,
      CatalogService catalog,
      MediaService media) {
    this.reviews = reviews;
    this.orders = orders;
    this.members = members;
    this.catalog = catalog;
    this.media = media;
  }

  private ShopQuery filter(ShopQuery q, Long mid, Long pid, boolean pub) {
    return new ShopQuery(
        q.offset(),
        q.limit(),
        null,
        null,
        mid,
        pid,
        q.status(),
        null,
        null,
        null,
        null,
        null,
        q.createdFrom(),
        q.createdTo(),
        pub);
  }

  public PageResult<PublicReviewResult> publicReviews(Long pid, ShopQuery q) {
    catalog.detail(pid);
    var f = filter(q, null, pid, true);
    return new PageResult<>(
        reviews.listReview(f).stream()
            .map(
                r -> {
                  var m = members.findMember(r.getMemberId());
                  return new PublicReviewResult(
                      id(r.getReviewId()),
                      new ReviewerResult(m.getNickname(), media.url(m.getAvatarMediaId())),
                      r.getScore(),
                      r.getContent(),
                      time(r.getCreateTime()));
                })
            .toList(),
        reviews.countReview(f));
  }

  private MemberReviewResult value(ReviewEntity r) {
    var item = orders.findOrderItem(r.getOrderItemId());
    var order = orders.findOrder(r.getOrderId());
    return new MemberReviewResult(
        id(r.getReviewId()),
        id(r.getPropId()),
        item.getPropName(),
        item.getCoverUrl(),
        order.getOrderNo(),
        id(r.getOrderItemId()),
        r.getScore(),
        r.getContent(),
        r.getStatus(),
        r.getHideReason(),
        time(r.getCreateTime()));
  }

  public PageResult<MemberReviewResult> myReviews(Long mid, ShopQuery q) {
    var f = filter(q, mid, null, false);
    return new PageResult<>(
        reviews.listReview(f).stream().map(this::value).toList(), reviews.countReview(f));
  }

  @Transactional
  public MemberReviewResult create(Long mid, CreateReviewCommand c) {
    var item = orders.findOrderItem(id(c.orderItemId()));
    if (item == null) throw ShopException.missing();
    var o = orders.lockOrder(item.getOrderId());
    if (o == null || !mid.equals(o.getMemberId())) throw ShopException.missing();
    if (!"4".equals(o.getStatus()))
      throw ShopException.conflict("MALL_REVIEW_NOT_ALLOWED", "订单完成后才能评价。");
    if (reviews.byItem(item.getOrderItemId()) != null)
      throw ShopException.conflict("MALL_REVIEW_ALREADY_EXISTS", "该订单明细已评价。");
    String text = c.content().trim();
    if (text.codePointCount(0, text.length()) < 5) throw ShopException.invalid("评价至少5个字符。");
    ReviewEntity r = new ReviewEntity();
    r.setMemberId(mid);
    r.setOrderId(o.getOrderId());
    r.setOrderItemId(item.getOrderItemId());
    r.setPropId(item.getPropId());
    r.setScore(c.score());
    r.setContent(text);
    r.setStatus("VISIBLE");
    reviews.insertReview(r);
    return value(reviews.findReview(r.getReviewId()));
  }

  public AdminReviewResult get(Long rid) {
    var r = reviews.findReview(rid);
    if (r == null) throw ShopException.missing();
    var v = value(r);
    return new AdminReviewResult(
        v.reviewId(),
        v.propId(),
        v.propName(),
        v.coverUrl(),
        v.orderNo(),
        v.orderItemId(),
        v.score(),
        v.content(),
        v.status(),
        v.hideReason(),
        v.createdAt(),
        id(r.getMemberId()),
        members.findMember(r.getMemberId()).getUsername());
  }

  public PageResult<AdminReviewResult> list(ShopQuery q) {
    if (q.status() != null && !Set.of("VISIBLE", "HIDDEN").contains(q.status()))
      throw ShopException.invalid("评价状态不合法。");
    return new PageResult<>(
        reviews.listReview(q).stream().map(r -> get(r.getReviewId())).toList(),
        reviews.countReview(q));
  }

  @Transactional
  public AdminReviewResult hide(Long rid, HideReviewCommand c, Actor a) {
    var r = reviews.lockReview(rid);
    if (r == null) throw ShopException.missing();
    if ("HIDDEN".equals(r.getStatus())) return get(rid);
    String reason = c.reason().trim();
    if (reason.length() < 2) throw ShopException.invalid("隐藏原因至少2字符。");
    r.setHideReason(reason);
    r.setHiddenBy(a.id());
    r.setHiddenTime(now());
    reviews.hide(r);
    return get(rid);
  }
}
