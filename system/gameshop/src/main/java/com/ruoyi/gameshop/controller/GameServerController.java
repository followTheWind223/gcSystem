package com.ruoyi.gameshop.controller;
import static com.ruoyi.gameshop.support.ShopValues.id;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.gameshop.convert.GameServerAssembler;
import com.ruoyi.gameshop.model.dto.*;
import com.ruoyi.gameshop.model.vo.GameServerVo;
import com.ruoyi.gameshop.security.ShopIdentity;
import com.ruoyi.gameshop.service.GameServerService;
import com.ruoyi.gameshop.web.*;
import jakarta.validation.Valid;
import java.net.URI;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
@RestController
@RequestMapping("/mall/game-servers")
public class GameServerController {
  private final GameServerService service;
  public GameServerController(GameServerService service){this.service=service;}
  @GetMapping @PreAuthorize("@ss.hasPermi('mall:server:list')")
  public PageResponse<GameServerVo> list(@Valid @ModelAttribute ListGameServersRequest query){
    var page=service.list(GameServerAssembler.query(query));
    return new PageResponse<>(200,"查询成功",page.rows().stream().map(GameServerAssembler::view).toList(),page.total());
  }
  @GetMapping("/{serverId}") @PreAuthorize("@ss.hasPermi('mall:server:query')")
  public ApiResponse<GameServerVo> get(@PathVariable String serverId){return ApiResponse.ok(GameServerAssembler.view(service.get(id(serverId))));}
  @PostMapping @PreAuthorize("@ss.hasPermi('mall:server:add')")
  @Log(title="商城：新增游戏区服",businessType=BusinessType.INSERT,isSaveRequestData=false,isSaveResponseData=false)
  public ResponseEntity<ApiResponse<GameServerVo>> create(@Valid @RequestBody CreateGameServerRequest body){
    var r=service.create(GameServerAssembler.command(body),ShopIdentity.admin());
    return ResponseEntity.created(URI.create("/mall/game-servers/"+r.serverId())).body(ApiResponse.ok(GameServerAssembler.view(r)));
  }
  @PutMapping("/{serverId}") @PreAuthorize("@ss.hasPermi('mall:server:edit')")
  @Log(title="商城：修改游戏区服",businessType=BusinessType.UPDATE,isSaveRequestData=false,isSaveResponseData=false)
  public ApiResponse<GameServerVo> update(@PathVariable String serverId,@Valid @RequestBody UpdateGameServerRequest body){return ApiResponse.ok(GameServerAssembler.view(service.update(id(serverId),GameServerAssembler.command(body),ShopIdentity.admin())));}
  @DeleteMapping("/{serverId}") @PreAuthorize("@ss.hasPermi('mall:server:remove')")
  @Log(title="商城：删除游戏区服",businessType=BusinessType.DELETE,isSaveRequestData=false,isSaveResponseData=false)
  public ApiResponse<Void> delete(@PathVariable String serverId){service.delete(id(serverId),ShopIdentity.admin());return ApiResponse.ok(null);}
}

