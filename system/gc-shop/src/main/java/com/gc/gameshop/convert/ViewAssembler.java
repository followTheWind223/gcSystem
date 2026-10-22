package com.gc.gameshop.convert;

import com.gc.gameshop.model.result.*;
import com.gc.gameshop.model.vo.*;

/** 显式转换，避免实体直接暴露或反射复制越权字段。 */
public final class ViewAssembler {
  private ViewAssembler() {}

  public static AdminBannerVo toAdminBannerVo(AdminBannerResult v) {
    return v == null
        ? null
        : new AdminBannerVo(
            v.bannerId(),
            v.title(),
            v.imageUrl(),
            v.targetPropId(),
            v.sort(),
            v.status(),
            v.version(),
            v.createdAt(),
            v.updatedAt());
  }

  public static AdminCategoryVo toAdminCategoryVo(AdminCategoryResult v) {
    return v == null
        ? null
        : new AdminCategoryVo(
            v.categoryId(),
            v.name(),
            v.iconUrl(),
            v.sort(),
            v.recommended(),
            v.status(),
            v.version(),
            v.createdAt(),
            v.updatedAt());
  }

  public static AdminMemberVo toAdminMemberVo(AdminMemberResult v) {
    return v == null
        ? null
        : new AdminMemberVo(
            v.memberId(),
            v.username(),
            v.nickname(),
            v.avatarUrl(),
            v.emailMasked(),
            v.phoneMasked(),
            v.status(),
            v.createdAt(),
            v.lastLoginAt());
  }

  public static AdminOrderVo toAdminOrderVo(AdminOrderResult v) {
    return v == null
        ? null
        : new AdminOrderVo(
            v.orderId(),
            v.orderNo(),
            v.status(),
            v.totalAmount(),
            v.totalQuantity(),
            v.itemCount(),
            v.currency(),
            v.createdAt(),
            v.expiresAt(),
            v.paidAt(),
            v.cancelledAt(),
            v.completedAt(),
            v.serverTime(),
            v.canPay(),
            v.canCancel(),
            v.items() == null
                ? null
                : v.items().stream().map(ViewAssembler::toOrderItemVo).toList(),
            toDeliveryInfoVo(v.deliveryInfo()),
            v.remark(),
            v.cancelReason(),
            toPaymentVo(v.payment()),
            toDeliveryRecordVo(v.delivery()),
            v.logs() == null ? null : v.logs().stream().map(ViewAssembler::toOrderLogVo).toList(),
            toAdminMemberVo(v.member()));
  }

  public static AdminPropVo toAdminPropVo(AdminPropResult v) {
    return v == null
        ? null
        : new AdminPropVo(
            v.propId(),
            v.categoryId(),
            v.categoryName(),
            v.name(),
            v.coverUrl(),
            v.price(),
            v.originalPrice(),
            v.stock(),
            v.sales(),
            v.onSaleAt(),
            v.canPurchase(),
            v.images() == null
                ? null
                : v.images().stream().map(ViewAssembler::toPropImageVo).toList(),
            v.detailHtml(),
            v.specs() == null
                ? null
                : v.specs().stream().map(ViewAssembler::toSpecificationVo).toList(),
            v.deliveryFields(),
            v.reviewCount(),
            v.averageScore(),
            v.status(),
            v.version(),
            v.createdAt(),
            v.updatedAt());
  }

  public static AdminReviewVo toAdminReviewVo(AdminReviewResult v) {
    return v == null
        ? null
        : new AdminReviewVo(
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
            v.memberId(),
            v.username());
  }

  public static AuthSessionVo toAuthSessionVo(AuthSessionResult v) {
    return v == null
        ? null
        : new AuthSessionVo(v.token(), v.tokenType(), v.expiresAt(), toMemberVo(v.member()));
  }

  public static BannerVo toBannerVo(BannerResult v) {
    return v == null
        ? null
        : new BannerVo(v.bannerId(), v.title(), v.imageUrl(), v.targetPropId(), v.sort());
  }

  public static CaptchaVo toCaptchaVo(CaptchaResult v) {
    return v == null
        ? null
        : new CaptchaVo(v.captchaEnabled(), v.captchaId(), v.imageBase64(), v.expiresInSeconds(),
            v.emailVerificationEnabled());
  }

  public static CartVo toCartVo(CartResult v) {
    return v == null
        ? null
        : new CartVo(
            v.items() == null ? null : v.items().stream().map(ViewAssembler::toCartItemVo).toList(),
            toCartSummaryVo(v.summary()));
  }

  public static CartItemVo toCartItemVo(CartItemResult v) {
    return v == null
        ? null
        : new CartItemVo(
            v.cartItemId(),
            v.propId(),
            v.propName(),
            v.categoryName(),
            v.coverUrl(),
            v.unitPrice(),
            v.quantity(),
            v.checked(),
            v.stock(),
            v.availability(),
            v.canCheckout(),
            v.subtotal(),
            v.updatedAt());
  }

  public static CartSummaryVo toCartSummaryVo(CartSummaryResult v) {
    return v == null
        ? null
        : new CartSummaryVo(
            v.totalItemCount(),
            v.totalQuantity(),
            v.selectedItemCount(),
            v.selectedQuantity(),
            v.selectedAmount(),
            v.invalidItemCount());
  }

  public static CategoryVo toCategoryVo(CategoryResult v) {
    return v == null
        ? null
        : new CategoryVo(v.categoryId(), v.name(), v.iconUrl(), v.sort(), v.recommended());
  }

  public static DeliveryInfoVo toDeliveryInfoVo(DeliveryInfoResult v) {
    return v == null ? null : new DeliveryInfoVo(v.gameAccount(), v.serverName(), v.roleName(),
        v.servers()==null?java.util.List.of():v.servers().stream().map(GameServerAssembler::delivery).toList());
  }

  public static DeliveryRecordVo toDeliveryRecordVo(DeliveryRecordResult v) {
    return v == null ? null : new DeliveryRecordVo(v.note(), v.deliveredAt());
  }

  public static EmailCodeAcceptedVo toEmailCodeAcceptedVo(EmailCodeAcceptedResult v) {
    return v == null ? null : new EmailCodeAcceptedVo(v.retryAfterSeconds());
  }

  public static ErrorDetailsVo toErrorDetailsVo(ErrorDetailsResult v) {
    return v == null
        ? null
        : new ErrorDetailsVo(
            v.fieldErrors() == null
                ? null
                : v.fieldErrors().stream().map(ViewAssembler::toFieldErrorVo).toList(),
            v.items() == null
                ? null
                : v.items().stream().map(ViewAssembler::toItemErrorVo).toList(),
            v.orderStatus());
  }

  public static FieldErrorVo toFieldErrorVo(FieldErrorResult v) {
    return v == null ? null : new FieldErrorVo(v.field(), v.message());
  }

  public static HomeVo toHomeVo(HomeResult v) {
    return v == null
        ? null
        : new HomeVo(
            v.banners() == null
                ? null
                : v.banners().stream().map(ViewAssembler::toBannerVo).toList(),
            v.hotCategories() == null
                ? null
                : v.hotCategories().stream().map(ViewAssembler::toCategoryVo).toList(),
            v.hotProps() == null
                ? null
                : v.hotProps().stream().map(ViewAssembler::toPropSummaryVo).toList(),
            v.serverTime());
  }

  public static ImageUploadVo toImageUploadVo(ImageUploadResult v) {
    return v == null
        ? null
        : new ImageUploadVo(v.fileName(), v.url(), v.originalName(), v.mimeType(), v.size());
  }

  public static ItemErrorVo toItemErrorVo(ItemErrorResult v) {
    return v == null
        ? null
        : new ItemErrorVo(
            v.propId(), v.cartItemId(), v.reason(), v.availableStock(), v.currentUnitPrice());
  }

  public static MemberVo toMemberVo(MemberResult v) {
    return v == null
        ? null
        : new MemberVo(
            v.memberId(),
            v.username(),
            v.nickname(),
            v.avatarUrl(),
            v.email(),
            v.emailVerified(),
            v.phoneNumber(),
            v.createdAt());
  }

  public static MemberReviewVo toMemberReviewVo(MemberReviewResult v) {
    return v == null
        ? null
        : new MemberReviewVo(
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
            v.createdAt());
  }

  public static MockPayResultVo toMockPayResultVo(MockPayResultResult v) {
    return v == null
        ? null
        : new MockPayResultVo(v.outcome(), toOrderDetailVo(v.order()), v.paymentNo());
  }

  public static OrderCreatedVo toOrderCreatedVo(OrderCreatedResult v) {
    return v == null ? null : new OrderCreatedVo(toOrderDetailVo(v.order()), v.replayed());
  }

  public static OrderDetailVo toOrderDetailVo(OrderDetailResult v) {
    return v == null
        ? null
        : new OrderDetailVo(
            v.orderId(),
            v.orderNo(),
            v.status(),
            v.totalAmount(),
            v.totalQuantity(),
            v.itemCount(),
            v.currency(),
            v.createdAt(),
            v.expiresAt(),
            v.paidAt(),
            v.cancelledAt(),
            v.completedAt(),
            v.serverTime(),
            v.canPay(),
            v.canCancel(),
            v.items() == null
                ? null
                : v.items().stream().map(ViewAssembler::toOrderItemVo).toList(),
            toDeliveryInfoVo(v.deliveryInfo()),
            v.remark(),
            v.cancelReason(),
            toPaymentVo(v.payment()),
            toDeliveryRecordVo(v.delivery()),
            v.logs() == null ? null : v.logs().stream().map(ViewAssembler::toOrderLogVo).toList());
  }

  public static OrderItemVo toOrderItemVo(OrderItemResult v) {
    return v == null
        ? null
        : new OrderItemVo(
            v.propId(),
            v.propName(),
            v.coverUrl(),
            v.specs() == null
                ? null
                : v.specs().stream().map(ViewAssembler::toSpecificationVo).toList(),
            v.unitPrice(),
            v.quantity(),
            v.subtotal(),
            v.orderItemId(),
            v.canReview(),
            v.reviewId());
  }

  public static OrderLogVo toOrderLogVo(OrderLogResult v) {
    return v == null
        ? null
        : new OrderLogVo(v.fromStatus(), v.toStatus(), v.reason(), v.createdAt());
  }

  public static OrderPreviewVo toOrderPreviewVo(OrderPreviewResult v) {
    return v == null
        ? null
        : new OrderPreviewVo(
            v.quoteToken(),
            v.quoteExpiresAt(),
            v.source(),
            v.items() == null
                ? null
                : v.items().stream().map(ViewAssembler::toQuoteItemVo).toList(),
            v.totalAmount(),
            v.totalQuantity(),
            v.currency(),
            v.deliveryFields(),
            v.serverTime(),
            v.serverGroups().stream().map(GameServerAssembler::group).toList());
  }

  public static OrderSummaryVo toOrderSummaryVo(OrderSummaryResult v) {
    return v == null
        ? null
        : new OrderSummaryVo(
            v.orderId(),
            v.orderNo(),
            v.status(),
            v.totalAmount(),
            v.totalQuantity(),
            v.itemCount(),
            v.currency(),
            v.createdAt(),
            v.expiresAt(),
            v.paidAt(),
            v.cancelledAt(),
            v.completedAt(),
            v.serverTime(),
            v.canPay(),
            v.canCancel(),
            v.items() == null
                ? null
                : v.items().stream().map(ViewAssembler::toOrderItemVo).toList());
  }

  public static PaymentVo toPaymentVo(PaymentResult v) {
    return v == null ? null : new PaymentVo(v.paymentNo(), v.channel(), v.amount(), v.paidAt());
  }

  public static PropDetailVo toPropDetailVo(PropDetailResult v) {
    return v == null
        ? null
        : new PropDetailVo(
            v.propId(),
            v.categoryId(),
            v.categoryName(),
            v.name(),
            v.coverUrl(),
            v.price(),
            v.originalPrice(),
            v.stock(),
            v.sales(),
            v.onSaleAt(),
            v.canPurchase(),
            v.images() == null
                ? null
                : v.images().stream().map(ViewAssembler::toPropImageVo).toList(),
            v.detailHtml(),
            v.specs() == null
                ? null
                : v.specs().stream().map(ViewAssembler::toSpecificationVo).toList(),
            v.deliveryFields(),
            v.reviewCount(),
            v.averageScore());
  }

  public static PropImageVo toPropImageVo(PropImageResult v) {
    return v == null ? null : new PropImageVo(v.url(), v.sort());
  }

  public static PropSummaryVo toPropSummaryVo(PropSummaryResult v) {
    return v == null
        ? null
        : new PropSummaryVo(
            v.propId(),
            v.categoryId(),
            v.categoryName(),
            v.name(),
            v.coverUrl(),
            v.price(),
            v.originalPrice(),
            v.stock(),
            v.sales(),
            v.onSaleAt(),
            v.canPurchase());
  }

  public static PublicReviewVo toPublicReviewVo(PublicReviewResult v) {
    return v == null
        ? null
        : new PublicReviewVo(
            v.reviewId(), toReviewerVo(v.reviewer()), v.score(), v.content(), v.createdAt());
  }

  public static QuoteItemVo toQuoteItemVo(QuoteItemResult v) {
    return v == null
        ? null
        : new QuoteItemVo(
            v.propId(),
            v.cartItemId(),
            v.propName(),
            v.coverUrl(),
            v.specs() == null
                ? null
                : v.specs().stream().map(ViewAssembler::toSpecificationVo).toList(),
            v.unitPrice(),
            v.quantity(),
            v.subtotal(),
            v.stock());
  }

  public static ReviewerVo toReviewerVo(ReviewerResult v) {
    return v == null ? null : new ReviewerVo(v.displayName(), v.avatarUrl());
  }

  public static SpecificationVo toSpecificationVo(SpecificationResult v) {
    return v == null ? null : new SpecificationVo(v.name(), v.value());
  }

  public static StockLogVo toStockLogVo(StockLogResult v) {
    return v == null
        ? null
        : new StockLogVo(
            v.stockLogId(),
            v.propId(),
            v.propName(),
            v.changeQty(),
            v.beforeStock(),
            v.afterStock(),
            v.bizType(),
            v.bizKey(),
            v.operatorType(),
            v.operatorId(),
            v.reason(),
            v.createdAt());
  }
}
