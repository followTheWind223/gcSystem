package com.ruoyi.gameshop.service;

import com.ruoyi.gameshop.model.bo.Actor;
import com.ruoyi.gameshop.model.command.*;
import com.ruoyi.gameshop.model.query.ShopQuery;
import com.ruoyi.gameshop.model.result.*;
import java.util.List;

public interface CatalogService {
  HomeResult home();

  List<CategoryResult> categories();

  PageResult<PropSummaryResult> props(ShopQuery q);

  PropDetailResult detail(Long id);

  PageResult<AdminCategoryResult> categories(ShopQuery q);

  AdminCategoryResult category(Long id);

  AdminCategoryResult createCategory(CreateCategoryCommand c, Actor a);

  AdminCategoryResult updateCategory(Long id, UpdateCategoryCommand c, Actor a);

  void deleteCategory(Long id);

  PageResult<AdminBannerResult> banners(ShopQuery q);

  AdminBannerResult banner(Long id);

  AdminBannerResult createBanner(CreateBannerCommand c, Actor a);

  AdminBannerResult updateBanner(Long id, UpdateBannerCommand c, Actor a);

  void deleteBanner(Long id);

  PageResult<AdminPropResult> adminProps(ShopQuery q);

  AdminPropResult adminProp(Long id);

  AdminPropResult createProp(CreatePropCommand c, Actor a);

  AdminPropResult updateProp(Long id, UpdatePropCommand c, Actor a);

  AdminPropResult status(Long id, UpdatePropStatusCommand c, Actor a);

  void deleteProp(Long id);
}
