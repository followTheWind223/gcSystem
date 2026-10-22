package com.ruoyi.gameshop.mapper;
import com.ruoyi.gameshop.persistence.entity.*;
import com.ruoyi.gameshop.model.query.GameServerQuery;
import org.apache.ibatis.annotations.*;
import java.util.List;
@Mapper
public interface GameServerMapper {
  GameServerEntity find(@Param("id") Long id);
  GameServerEntity lock(@Param("id") Long id);
  GameServerRow row(@Param("id") Long id);
  GameServerEntity lockByName(@Param("categoryId") Long categoryId,@Param("name") String name);
  List<GameServerEntity> available(@Param("categoryId") Long categoryId);
  List<GameServerRow> list(GameServerQuery query);
  long count(GameServerQuery query);
  int insert(GameServerEntity entity);
  int update(GameServerEntity entity);
  int delete(@Param("id") Long id,@Param("actor") String actor);
}

