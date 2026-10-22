package com.ruoyi.gameshop.service;
import com.ruoyi.gameshop.model.bo.Actor;
import com.ruoyi.gameshop.model.command.*;
import com.ruoyi.gameshop.model.query.GameServerQuery;
import com.ruoyi.gameshop.model.result.*;
import java.util.*;
public interface GameServerService {
  PageResult<GameServerResult> list(GameServerQuery query);
  GameServerResult get(Long id);
  GameServerResult create(CreateGameServerCommand command, Actor actor);
  GameServerResult update(Long id,UpdateGameServerCommand command,Actor actor);
  void delete(Long id,Actor actor);
  List<GameServerGroupResult> groups(Collection<Long> categoryIds);
  List<DeliveryServerResult> validateSelection(Collection<Long> categoryIds,List<String> serverIds,String legacyName);
}

