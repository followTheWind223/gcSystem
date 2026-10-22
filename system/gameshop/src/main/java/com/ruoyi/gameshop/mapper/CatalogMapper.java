package com.ruoyi.gameshop.mapper;

import com.ruoyi.gameshop.model.query.ShopQuery;
import com.ruoyi.gameshop.persistence.entity.*;
import java.util.List;
import org.apache.ibatis.annotations.*;

@Mapper
public interface CatalogMapper {
  GameCategoryEntity findGameCategory(@Param("id") Long id);

  GameCategoryEntity lockGameCategory(@Param("id") Long id);

  int insertGameCategory(GameCategoryEntity row);

  PropEntity findProp(@Param("id") Long id);

  PropEntity lockProp(@Param("id") Long id);

  int insertProp(PropEntity row);

  PropImageEntity findPropImage(@Param("id") Long id);

  PropImageEntity lockPropImage(@Param("id") Long id);

  int insertPropImage(PropImageEntity row);

  BannerEntity findBanner(@Param("id") Long id);

  BannerEntity lockBanner(@Param("id") Long id);

  int insertBanner(BannerEntity row);

  int updateGameCategory(GameCategoryEntity row);

  int deleteGameCategory(@Param("id") Long id);

  int updateBanner(BannerEntity row);

  int deleteBanner(@Param("id") Long id);

  int updateProp(PropEntity row);

  int deleteProp(@Param("id") Long id);

  int setPropStatus(PropEntity row);

  int changeStock(@Param("id") Long id, @Param("delta") int delta);

  int addSales(@Param("id") Long id, @Param("quantity") int quantity);

  int countCategoryProps(@Param("id") Long id);

  List<PropImageEntity> images(@Param("id") Long id);

  int deleteImages(@Param("id") Long id);

  List<GameCategoryEntity> listGameCategory(ShopQuery query);

  long countGameCategory(ShopQuery query);

  List<PropEntity> listProp(ShopQuery query);

  long countProp(ShopQuery query);

  List<BannerEntity> listBanner(ShopQuery query);

  long countBanner(ShopQuery query);
}
