package com.gc.gameshop.service.impl;

import static com.gc.gameshop.support.ShopValues.*;
import com.gc.gameshop.exception.ShopException;
import com.gc.gameshop.mapper.*;
import com.gc.gameshop.model.bo.Actor;
import com.gc.gameshop.model.command.*;
import com.gc.gameshop.model.query.GameServerQuery;
import com.gc.gameshop.model.result.*;
import com.gc.gameshop.persistence.entity.*;
import com.gc.gameshop.service.GameServerService;
import java.util.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class GameServerServiceImpl implements GameServerService {
  private final GameServerMapper db;
  private final CatalogMapper catalog;
  public GameServerServiceImpl(GameServerMapper db,CatalogMapper catalog){this.db=db;this.catalog=catalog;}

  private GameServerResult result(GameServerRow row){
    return new GameServerResult(id(row.getServerId()),id(row.getCategoryId()),row.getCategoryName(),row.getName(),
        row.getSort(),row.getStatus(),row.getRemark(),row.getVersion(),time(row.getCreateTime()),time(row.getUpdateTime()));
  }
  public PageResult<GameServerResult> list(GameServerQuery query){return new PageResult<>(db.list(query).stream().map(this::result).toList(),db.count(query));}
  public GameServerResult get(Long id){var row=db.row(id);if(row==null)throw ShopException.missing();return result(row);}

  private String name(String value){
    String name=clean(value);
    if(name==null || name.length()>50)throw ShopException.invalid("区服名称应为1至50个字符。");
    return name;
  }
  private void category(Long id){
    var category=catalog.lockGameCategory(id);
    if(category==null || !"0".equals(category.getDelFlag()))throw ShopException.missing();
  }
  @Transactional
  public GameServerResult create(CreateGameServerCommand command,Actor actor){
    category(command.categoryId());
    var row=new GameServerEntity();row.setCategoryId(command.categoryId());row.setName(name(command.name()));
    row.setSort(command.sort());row.setStatus(command.status());row.setRemark(clean(command.remark()));
    row.setCreateBy(actor.name());row.setUpdateBy(actor.name());db.insert(row);return get(row.getServerId());
  }
  @Transactional
  public GameServerResult update(Long id,UpdateGameServerCommand command,Actor actor){
    var old=db.find(id);if(old==null || !"0".equals(old.getDelFlag()))throw ShopException.missing();
    category(old.getCategoryId());var row=db.lock(id);
    if(!"0".equals(row.getDelFlag()))throw ShopException.missing();
    if(!row.getCategoryId().equals(command.categoryId()))throw ShopException.invalid("区服所属游戏不可变更，请在目标游戏中新建区服。");
    if(!row.getVersion().equals(command.version()))throw ShopException.conflict("MALL_VERSION_CONFLICT","区服已被修改，请刷新后重试。");
    row.setName(name(command.name()));row.setSort(command.sort());row.setStatus(command.status());
    row.setRemark(clean(command.remark()));row.setUpdateBy(actor.name());
    if(db.update(row)!=1)throw ShopException.conflict("MALL_VERSION_CONFLICT","区服已被修改，请刷新后重试。");
    return get(id);
  }
  @Transactional
  public void delete(Long id,Actor actor){
    var old=db.find(id);if(old==null || !"0".equals(old.getDelFlag()))return;
    catalog.lockGameCategory(old.getCategoryId());db.lock(id);db.delete(id,actor.name());
  }
  public List<GameServerGroupResult> groups(Collection<Long> categoryIds){
    var result=new ArrayList<GameServerGroupResult>();
    for(Long cid:new TreeSet<>(categoryIds)){
      var category=catalog.findGameCategory(cid);
      if(category==null || !"0".equals(category.getDelFlag()) || !"1".equals(category.getStatus()))continue;
      result.add(new GameServerGroupResult(id(cid),category.getName(),db.available(cid).stream().map(s->new GameServerOptionResult(id(s.getServerId()),s.getName())).toList()));
    }
    return result;
  }
  /** 调用方已按分类ID排序锁定游戏，再按区服ID加锁；停用和下单采用同一锁序。 */
  @Transactional(propagation=org.springframework.transaction.annotation.Propagation.MANDATORY)
  public List<DeliveryServerResult> validateSelection(Collection<Long> categoryIds,List<String> serverIds,String legacyName){
    Set<Long> required=new TreeSet<>(categoryIds);
    Map<Long,GameServerEntity> selected=new TreeMap<>();
    if(serverIds!=null){
      if(clean(legacyName)!=null)throw ShopException.invalid("serverIds 与旧版 serverName 不能同时提交。");
      if(serverIds.isEmpty() || serverIds.size()>50)throw ShopException.invalid("请选择有效的游戏区服。");
      Set<Long> ids=new TreeSet<>();for(String sid:serverIds)if(!ids.add(id(sid)))throw ShopException.invalid("区服不能重复选择。");
      for(Long sid:ids){
        var row=db.lock(sid);checkAvailable(row);
        if(!required.contains(row.getCategoryId()) || selected.put(row.getCategoryId(),row)!=null)
          throw ShopException.invalid("所选区服必须对应订单游戏，每个游戏只能选择一个区服。");
      }
    }else if(!required.isEmpty()){
      // 兼容旧客户端，但名称仍必须命中每个游戏中真实启用的区服，不接受任意文本。
      String name=clean(legacyName);if(name==null)throw ShopException.invalid("请选择游戏区服。");
      for(Long cid:required){var row=db.lockByName(cid,name);checkAvailable(row);selected.put(cid,row);}
    }
    if(!selected.keySet().equals(required))throw ShopException.invalid("请为每个需要区服的游戏选择区服。");
    return selected.values().stream().map(row->new DeliveryServerResult(id(row.getServerId()),id(row.getCategoryId()),catalog.lockGameCategory(row.getCategoryId()).getName(),row.getName())).toList();
  }
  private void checkAvailable(GameServerEntity row){
    if(row==null || !"0".equals(row.getDelFlag()) || !"1".equals(row.getStatus()))
      throw ShopException.conflict("MALL_SERVER_UNAVAILABLE","所选游戏区服已停用或不存在，请重新选择。");
  }
}
