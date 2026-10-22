package com.ruoyi.gameshop.controller;

import static com.ruoyi.gameshop.convert.CommandAssembler.*;
import static com.ruoyi.gameshop.convert.ViewAssembler.*;
import static com.ruoyi.gameshop.support.ShopValues.id;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.gameshop.convert.*;
import com.ruoyi.gameshop.exception.ShopException;
import com.ruoyi.gameshop.model.bo.UploadCommand;
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
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@Validated
public class AdminCatalogController {
  private final CatalogService catalog;
  private final OrderService orders;
  private final MediaService media;

  public AdminCatalogController(CatalogService catalog, OrderService orders, MediaService media) {
    this.catalog = catalog;
    this.orders = orders;
    this.media = media;
  }

  private UploadCommand upload(MultipartFile file, int max) throws IOException {
    if (file.getSize() > max) throw new ShopException(413, "MALL_UPLOAD_TOO_LARGE", "图片过大。");
    return new UploadCommand(file.getBytes(), file.getOriginalFilename());
  }

  @GetMapping(value = "/mall/categories")
  @PreAuthorize("@ss.hasPermi('mall:category:list')")
  public ResponseEntity<PageResponse<AdminCategoryVo>> adminListCategories(
      @Valid @ModelAttribute ListQueryRequest query) throws IOException {
    var page = catalog.categories(QueryAssembler.toQuery(query, false));
    return ResponseEntity.ok(
        new PageResponse<>(
            200,
            "查询成功",
            page.rows().stream().map(ViewAssembler::toAdminCategoryVo).toList(),
            page.total()));
  }

  @PostMapping(value = "/mall/categories")
  @PreAuthorize("@ss.hasPermi('mall:category:add')")
  @Log(
      title = "商城：后台创建分类",
      businessType = BusinessType.INSERT,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<AdminCategoryVo>> adminCreateCategory(
      @Valid @RequestBody CreateCategoryRequest body) throws IOException {
    var result = catalog.createCategory(toCreateCategoryCommand(body), ShopIdentity.admin());
    return ResponseEntity.status(201)
        .location(URI.create("/mall/categories/" + result.categoryId()))
        .body(ApiResponse.ok(toAdminCategoryVo(result)));
  }

  @GetMapping(value = "/mall/categories/{categoryId}")
  @PreAuthorize("@ss.hasPermi('mall:category:query')")
  public ResponseEntity<ApiResponse<AdminCategoryVo>> adminGetCategory(
      @PathVariable String categoryId) throws IOException {
    var result = catalog.category(id(categoryId));
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminCategoryVo(result)));
  }

  @PutMapping(value = "/mall/categories/{categoryId}")
  @PreAuthorize("@ss.hasPermi('mall:category:edit')")
  @Log(
      title = "商城：后台完整修改分类",
      businessType = BusinessType.UPDATE,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<AdminCategoryVo>> adminUpdateCategory(
      @PathVariable String categoryId, @Valid @RequestBody UpdateCategoryRequest body)
      throws IOException {
    var result =
        catalog.updateCategory(id(categoryId), toUpdateCategoryCommand(body), ShopIdentity.admin());
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminCategoryVo(result)));
  }

  @DeleteMapping(value = "/mall/categories/{categoryId}")
  @PreAuthorize("@ss.hasPermi('mall:category:remove')")
  @Log(
      title = "商城：后台移除分类",
      businessType = BusinessType.DELETE,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<Void>> adminDeleteCategory(@PathVariable String categoryId)
      throws IOException {
    catalog.deleteCategory(id(categoryId));
    return ResponseEntity.ok(ApiResponse.ok(null));
  }

  @GetMapping(value = "/mall/banners")
  @PreAuthorize("@ss.hasPermi('mall:banner:list')")
  public ResponseEntity<PageResponse<AdminBannerVo>> adminListBanners(
      @Valid @ModelAttribute ListQueryRequest query) throws IOException {
    var page = catalog.banners(QueryAssembler.toQuery(query, false));
    return ResponseEntity.ok(
        new PageResponse<>(
            200,
            "查询成功",
            page.rows().stream().map(ViewAssembler::toAdminBannerVo).toList(),
            page.total()));
  }

  @PostMapping(value = "/mall/banners")
  @PreAuthorize("@ss.hasPermi('mall:banner:add')")
  @Log(
      title = "商城：后台创建轮播",
      businessType = BusinessType.INSERT,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<AdminBannerVo>> adminCreateBanner(
      @Valid @RequestBody CreateBannerRequest body) throws IOException {
    var result = catalog.createBanner(toCreateBannerCommand(body), ShopIdentity.admin());
    return ResponseEntity.status(201)
        .location(URI.create("/mall/banners/" + result.bannerId()))
        .body(ApiResponse.ok(toAdminBannerVo(result)));
  }

  @GetMapping(value = "/mall/banners/{bannerId}")
  @PreAuthorize("@ss.hasPermi('mall:banner:query')")
  public ResponseEntity<ApiResponse<AdminBannerVo>> adminGetBanner(@PathVariable String bannerId)
      throws IOException {
    var result = catalog.banner(id(bannerId));
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminBannerVo(result)));
  }

  @PutMapping(value = "/mall/banners/{bannerId}")
  @PreAuthorize("@ss.hasPermi('mall:banner:edit')")
  @Log(
      title = "商城：后台完整修改轮播",
      businessType = BusinessType.UPDATE,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<AdminBannerVo>> adminUpdateBanner(
      @PathVariable String bannerId, @Valid @RequestBody UpdateBannerRequest body)
      throws IOException {
    var result =
        catalog.updateBanner(id(bannerId), toUpdateBannerCommand(body), ShopIdentity.admin());
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminBannerVo(result)));
  }

  @DeleteMapping(value = "/mall/banners/{bannerId}")
  @PreAuthorize("@ss.hasPermi('mall:banner:remove')")
  @Log(
      title = "商城：后台移除轮播",
      businessType = BusinessType.DELETE,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<Void>> adminDeleteBanner(@PathVariable String bannerId)
      throws IOException {
    catalog.deleteBanner(id(bannerId));
    return ResponseEntity.ok(ApiResponse.ok(null));
  }

  @GetMapping(value = "/mall/props")
  @PreAuthorize("@ss.hasPermi('mall:prop:list')")
  public ResponseEntity<PageResponse<AdminPropVo>> adminListProps(
      @Valid @ModelAttribute ListQueryRequest query) throws IOException {
    var page = catalog.adminProps(QueryAssembler.toQuery(query, false));
    return ResponseEntity.ok(
        new PageResponse<>(
            200,
            "查询成功",
            page.rows().stream().map(ViewAssembler::toAdminPropVo).toList(),
            page.total()));
  }

  @PostMapping(value = "/mall/props")
  @PreAuthorize("@ss.hasPermi('mall:prop:add')")
  @Log(
      title = "商城：后台创建道具",
      businessType = BusinessType.INSERT,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<AdminPropVo>> adminCreateProp(
      @Valid @RequestBody CreatePropRequest body) throws IOException {
    var result = catalog.createProp(toCreatePropCommand(body), ShopIdentity.admin());
    return ResponseEntity.status(201)
        .location(URI.create("/mall/props/" + result.propId()))
        .body(ApiResponse.ok(toAdminPropVo(result)));
  }

  @GetMapping(value = "/mall/props/{propId}")
  @PreAuthorize("@ss.hasPermi('mall:prop:query')")
  public ResponseEntity<ApiResponse<AdminPropVo>> adminGetProp(@PathVariable String propId)
      throws IOException {
    var result = catalog.adminProp(id(propId));
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminPropVo(result)));
  }

  @PutMapping(value = "/mall/props/{propId}")
  @PreAuthorize("@ss.hasPermi('mall:prop:edit')")
  @Log(
      title = "商城：后台完整修改道具",
      businessType = BusinessType.UPDATE,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<AdminPropVo>> adminUpdateProp(
      @PathVariable String propId, @Valid @RequestBody UpdatePropRequest body) throws IOException {
    var result = catalog.updateProp(id(propId), toUpdatePropCommand(body), ShopIdentity.admin());
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminPropVo(result)));
  }

  @DeleteMapping(value = "/mall/props/{propId}")
  @PreAuthorize("@ss.hasPermi('mall:prop:remove')")
  @Log(
      title = "商城：后台移除道具",
      businessType = BusinessType.DELETE,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<Void>> adminDeleteProp(@PathVariable String propId)
      throws IOException {
    catalog.deleteProp(id(propId));
    return ResponseEntity.ok(ApiResponse.ok(null));
  }

  @PutMapping(value = "/mall/props/{propId}/status")
  @PreAuthorize("@ss.hasPermi('mall:prop:edit')")
  @Log(
      title = "商城：后台上架或下架道具",
      businessType = BusinessType.UPDATE,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<AdminPropVo>> adminSetPropStatus(
      @PathVariable String propId, @Valid @RequestBody UpdatePropStatusRequest body)
      throws IOException {
    var result = catalog.status(id(propId), toUpdatePropStatusCommand(body), ShopIdentity.admin());
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminPropVo(result)));
  }

  @PostMapping(value = "/mall/media/images", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
  @PreAuthorize("@ss.hasPermi('mall:media:upload')")
  @Log(
      title = "商城：后台上传商城图片",
      businessType = BusinessType.INSERT,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<ImageUploadVo>> adminUploadMallImage(
      @RequestPart("file") MultipartFile file) throws IOException {
    var result = media.upload(upload(file, 5242880), ShopIdentity.admin(), false);
    return ResponseEntity.status(201)
        .location(URI.create(result.url()))
        .body(ApiResponse.ok(toImageUploadVo(result)));
  }

  @PostMapping(value = "/mall/props/{propId}/stock-adjustments")
  @PreAuthorize("@ss.hasPermi('mall:prop:stock')")
  @Log(
      title = "商城：后台原子调整可售库存",
      businessType = BusinessType.INSERT,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<StockLogVo>> adminAdjustStock(
      @PathVariable String propId, @Valid @RequestBody AdjustStockRequest body) throws IOException {
    var result = orders.adjust(id(propId), toAdjustStockCommand(body), ShopIdentity.admin());
    return ResponseEntity.status(200).body(ApiResponse.ok(toStockLogVo(result)));
  }
}
