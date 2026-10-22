package com.gc.gameshop.convert;
import static com.gc.gameshop.support.ShopValues.*;
import com.gc.gameshop.model.dto.*;
import com.gc.gameshop.model.command.*;
import com.gc.gameshop.model.query.*;
import com.gc.gameshop.model.result.*;
import com.gc.gameshop.model.vo.*;
public final class GameServerAssembler {
  private GameServerAssembler() {}
  public static GameServerQuery query(ListGameServersRequest r) {
    int page=r.pageNum()==null?1:r.pageNum(), size=r.pageSize()==null?10:r.pageSize();
    return new GameServerQuery((page-1)*size,size,clean(r.keyword()),r.categoryId()==null?null:id(r.categoryId()),r.status());
  }
  public static CreateGameServerCommand command(CreateGameServerRequest r) {return new CreateGameServerCommand(id(r.categoryId()),r.name(),r.sort(),r.status(),r.remark());}
  public static UpdateGameServerCommand command(UpdateGameServerRequest r) {return new UpdateGameServerCommand(id(r.categoryId()),r.name(),r.sort(),r.status(),r.remark(),r.version());}
  public static GameServerVo view(GameServerResult r) {return new GameServerVo(r.serverId(),r.categoryId(),r.categoryName(),r.name(),r.sort(),r.status(),r.remark(),r.version(),r.createdAt(),r.updatedAt());}
  public static GameServerGroupVo group(GameServerGroupResult r) {return new GameServerGroupVo(r.categoryId(),r.categoryName(),r.servers().stream().map(s->new GameServerOptionVo(s.serverId(),s.name())).toList());}
  public static DeliveryServerVo delivery(DeliveryServerResult r) {return new DeliveryServerVo(r.serverId(),r.categoryId(),r.categoryName(),r.serverName());}
}

