package com.ruoyi.gameshop.convert;

import com.ruoyi.gameshop.model.command.*;
import com.ruoyi.gameshop.model.dto.*;

/** 显式转换，避免实体直接暴露或反射复制越权字段。 */
public final class CommandAssembler {
  private CommandAssembler() {}

  public static AddCartCommand toAddCartCommand(AddCartRequest v) {
    return v == null ? null : new AddCartCommand(v.propId(), v.quantity());
  }

  public static AdjustStockCommand toAdjustStockCommand(AdjustStockRequest v) {
    return v == null ? null : new AdjustStockCommand(v.requestKey(), v.delta(), v.reason());
  }

  public static AdminCancelOrderCommand toAdminCancelOrderCommand(AdminCancelOrderRequest v) {
    return v == null ? null : new AdminCancelOrderCommand(v.reason());
  }

  public static CancelOrderCommand toCancelOrderCommand(CancelOrderRequest v) {
    return v == null ? null : new CancelOrderCommand(v.reason());
  }

  public static CartPreviewCommand toCartPreviewCommand(CartPreviewRequest v) {
    return v == null ? null : new CartPreviewCommand(v.source(), v.cartItemIds());
  }

  public static ChangePasswordCommand toChangePasswordCommand(ChangePasswordRequest v) {
    return v == null ? null : new ChangePasswordCommand(v.oldPassword(), v.newPassword());
  }

  public static CheckoutItemCommand toCheckoutItemCommand(CheckoutItemRequest v) {
    return v == null ? null : new CheckoutItemCommand(v.propId(), v.quantity());
  }

  public static CompleteOrderCommand toCompleteOrderCommand(CompleteOrderRequest v) {
    return v == null ? null : new CompleteOrderCommand(v.deliveryNote());
  }

  public static CreateBannerCommand toCreateBannerCommand(CreateBannerRequest v) {
    return v == null
        ? null
        : new CreateBannerCommand(v.title(), v.imageUrl(), v.targetPropId(), v.sort(), v.status());
  }

  public static CreateCategoryCommand toCreateCategoryCommand(CreateCategoryRequest v) {
    return v == null
        ? null
        : new CreateCategoryCommand(v.name(), v.iconUrl(), v.sort(), v.recommended(), v.status());
  }

  public static CreateOrderCommand toCreateOrderCommand(CreateOrderRequest v) {
    return v == null
        ? null
        : new CreateOrderCommand(
            v.requestKey(), v.quoteToken(), toDeliveryInfoCommand(v.deliveryInfo()), v.remark());
  }

  public static CreatePropCommand toCreatePropCommand(CreatePropRequest v) {
    return v == null
        ? null
        : new CreatePropCommand(
            v.categoryId(),
            v.name(),
            v.coverUrl(),
            v.price(),
            v.originalPrice(),
            v.images() == null
                ? null
                : v.images().stream().map(CommandAssembler::toPropImageCommand).toList(),
            v.detailHtml(),
            v.specs() == null
                ? null
                : v.specs().stream().map(CommandAssembler::toSpecificationCommand).toList(),
            v.deliveryFields(),
            v.status(),
            v.initialStock());
  }

  public static CreateReviewCommand toCreateReviewCommand(CreateReviewRequest v) {
    return v == null ? null : new CreateReviewCommand(v.orderItemId(), v.score(), v.content());
  }

  public static DeliveryInfoCommand toDeliveryInfoCommand(DeliveryInfo v) {
    return v == null
        ? null
        : new DeliveryInfoCommand(v.gameAccount(), v.serverName(), v.roleName(), v.serverIds());
  }

  public static DirectPreviewCommand toDirectPreviewCommand(DirectPreviewRequest v) {
    return v == null
        ? null
        : new DirectPreviewCommand(
            v.source(),
            v.items() == null
                ? null
                : v.items().stream().map(CommandAssembler::toCheckoutItemCommand).toList());
  }

  public static EmailCodeCommand toEmailCodeCommand(EmailCodeRequest v) {
    return v == null
        ? null
        : new EmailCodeCommand(v.email(), v.scene(), v.captchaId(), v.captchaCode());
  }

  public static HideReviewCommand toHideReviewCommand(HideReviewRequest v) {
    return v == null ? null : new HideReviewCommand(v.reason());
  }

  public static LoginCommand toLoginCommand(LoginRequest v) {
    return v == null
        ? null
        : new LoginCommand(v.username(), v.password(), v.captchaId(), v.captchaCode());
  }

  public static MockPayCommand toMockPayCommand(MockPayRequest v) {
    return v == null ? null : new MockPayCommand(v.result());
  }

  public static OrderPreviewCommand toOrderPreviewCommand(OrderPreviewRequest v) {
    return v == null
        ? null
        : new OrderPreviewCommand(
            v.source(),
            v.items() == null
                ? null
                : v.items().stream().map(CommandAssembler::toCheckoutItemCommand).toList(),
            v.cartItemIds());
  }

  public static PropImageCommand toPropImageCommand(PropImage v) {
    return v == null ? null : new PropImageCommand(v.url(), v.sort());
  }

  public static RegisterCommand toRegisterCommand(RegisterRequest v) {
    return v == null
        ? null
        : new RegisterCommand(v.username(), v.password(), v.nickname(), v.email(), v.emailCode(),
            v.captchaId(), v.captchaCode());
  }

  public static ResetPasswordCommand toResetPasswordCommand(ResetPasswordRequest v) {
    return v == null ? null : new ResetPasswordCommand(v.email(), v.emailCode(), v.newPassword());
  }

  public static SelectCartCommand toSelectCartCommand(SelectCartRequest v) {
    return v == null ? null : new SelectCartCommand(v.cartItemIds(), v.checked());
  }

  public static SpecificationCommand toSpecificationCommand(Specification v) {
    return v == null ? null : new SpecificationCommand(v.name(), v.value());
  }

  public static UpdateBannerCommand toUpdateBannerCommand(UpdateBannerRequest v) {
    return v == null
        ? null
        : new UpdateBannerCommand(
            v.title(), v.imageUrl(), v.targetPropId(), v.sort(), v.status(), v.version());
  }

  public static UpdateCartCommand toUpdateCartCommand(UpdateCartRequest v) {
    return v == null ? null : new UpdateCartCommand(v.quantity(), v.checked());
  }

  public static UpdateCategoryCommand toUpdateCategoryCommand(UpdateCategoryRequest v) {
    return v == null
        ? null
        : new UpdateCategoryCommand(
            v.name(), v.iconUrl(), v.sort(), v.recommended(), v.status(), v.version());
  }

  public static UpdateMemberStatusCommand toUpdateMemberStatusCommand(UpdateMemberStatusRequest v) {
    return v == null ? null : new UpdateMemberStatusCommand(v.status(), v.reason());
  }

  public static UpdateProfileCommand toUpdateProfileCommand(UpdateProfileRequest v) {
    return v == null ? null : new UpdateProfileCommand(v.nickname(), v.phoneNumber());
  }

  public static UpdatePropCommand toUpdatePropCommand(UpdatePropRequest v) {
    return v == null
        ? null
        : new UpdatePropCommand(
            v.categoryId(),
            v.name(),
            v.coverUrl(),
            v.price(),
            v.originalPrice(),
            v.images() == null
                ? null
                : v.images().stream().map(CommandAssembler::toPropImageCommand).toList(),
            v.detailHtml(),
            v.specs() == null
                ? null
                : v.specs().stream().map(CommandAssembler::toSpecificationCommand).toList(),
            v.deliveryFields(),
            v.status(),
            v.version());
  }

  public static UpdatePropStatusCommand toUpdatePropStatusCommand(UpdatePropStatusRequest v) {
    return v == null ? null : new UpdatePropStatusCommand(v.status(), v.version());
  }
}
