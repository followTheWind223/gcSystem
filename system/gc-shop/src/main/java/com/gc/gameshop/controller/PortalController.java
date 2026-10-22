package com.gc.gameshop.controller;

import static com.gc.gameshop.convert.CommandAssembler.*;
import static com.gc.gameshop.convert.ViewAssembler.*;
import static com.gc.gameshop.support.ShopValues.id;

import com.gc.gameshop.convert.*;
import com.gc.gameshop.model.dto.*;
import com.gc.gameshop.model.vo.*;
import com.gc.gameshop.security.*;
import com.gc.gameshop.service.*;
import com.gc.gameshop.web.*;
import jakarta.validation.Valid;
import java.io.IOException;
import java.util.*;
import org.springframework.http.*;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@Validated
public class PortalController {
  private final CatalogService catalog;

  public PortalController(CatalogService catalog) {
    this.catalog = catalog;
  }

  @GetMapping(value = "/api/mall/home")
  public ResponseEntity<ApiResponse<HomeVo>> mallGetHome() throws IOException {
    var result = catalog.home();
    return ResponseEntity.status(200).body(ApiResponse.ok(toHomeVo(result)));
  }

  @GetMapping(value = "/api/mall/categories")
  public ResponseEntity<ApiResponse<List<CategoryVo>>> mallListCategories() throws IOException {
    var result = catalog.categories();
    return ResponseEntity.status(200)
        .body(ApiResponse.ok(result.stream().map(ViewAssembler::toCategoryVo).toList()));
  }

  @GetMapping(value = "/api/mall/props")
  public ResponseEntity<PageResponse<PropSummaryVo>> mallListProps(
      @Valid @ModelAttribute ListQueryRequest query) throws IOException {
    var page = catalog.props(QueryAssembler.toQuery(query, true));
    return ResponseEntity.ok(
        new PageResponse<>(
            200,
            "查询成功",
            page.rows().stream().map(ViewAssembler::toPropSummaryVo).toList(),
            page.total()));
  }

  @GetMapping(value = "/api/mall/props/{propId}")
  public ResponseEntity<ApiResponse<PropDetailVo>> mallGetProp(@PathVariable String propId)
      throws IOException {
    var result = catalog.detail(id(propId));
    return ResponseEntity.status(200).body(ApiResponse.ok(toPropDetailVo(result)));
  }
}
