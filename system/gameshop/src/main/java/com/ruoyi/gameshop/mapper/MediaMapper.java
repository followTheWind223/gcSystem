package com.ruoyi.gameshop.mapper;

import com.ruoyi.gameshop.persistence.entity.*;
import org.apache.ibatis.annotations.*;

@Mapper
public interface MediaMapper {
  MediaEntity findMedia(@Param("id") Long id);

  MediaEntity lockMedia(@Param("id") Long id);

  int insertMedia(MediaEntity row);

  MediaEntity byPath(@Param("path") String path);

  MediaEntity byStoredName(@Param("name") String name);
}
