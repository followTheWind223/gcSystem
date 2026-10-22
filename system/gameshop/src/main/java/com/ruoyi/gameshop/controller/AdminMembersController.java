package com.ruoyi.gameshop.controller;

import static com.ruoyi.gameshop.convert.CommandAssembler.*;
import static com.ruoyi.gameshop.convert.ViewAssembler.*;
import static com.ruoyi.gameshop.support.ShopValues.id;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.gameshop.convert.*;
import com.ruoyi.gameshop.model.dto.*;
import com.ruoyi.gameshop.model.vo.*;
import com.ruoyi.gameshop.security.*;
import com.ruoyi.gameshop.service.*;
import com.ruoyi.gameshop.web.*;
import jakarta.validation.Valid;
import java.io.IOException;
import java.util.*;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@Validated
public class AdminMembersController {
  private final MemberService members;

  public AdminMembersController(MemberService members) {
    this.members = members;
  }

  @GetMapping(value = "/mall/members")
  @PreAuthorize("@ss.hasPermi('mall:member:list')")
  public ResponseEntity<PageResponse<AdminMemberVo>> adminListMembers(
      @Valid @ModelAttribute ListQueryRequest query) throws IOException {
    var page = members.list(QueryAssembler.toQuery(query, false));
    return ResponseEntity.ok(
        new PageResponse<>(
            200,
            "查询成功",
            page.rows().stream().map(ViewAssembler::toAdminMemberVo).toList(),
            page.total()));
  }

  @GetMapping(value = "/mall/members/{memberId}")
  @PreAuthorize("@ss.hasPermi('mall:member:query')")
  public ResponseEntity<ApiResponse<AdminMemberVo>> adminGetMember(@PathVariable String memberId)
      throws IOException {
    var result = members.admin(id(memberId));
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminMemberVo(result)));
  }

  @PutMapping(value = "/mall/members/{memberId}/status")
  @PreAuthorize("@ss.hasPermi('mall:member:status')")
  @Log(
      title = "商城：后台启停会员",
      businessType = BusinessType.UPDATE,
      isSaveRequestData = false,
      isSaveResponseData = false)
  public ResponseEntity<ApiResponse<AdminMemberVo>> adminSetMemberStatus(
      @PathVariable String memberId, @Valid @RequestBody UpdateMemberStatusRequest body)
      throws IOException {
    var result =
        members.status(id(memberId), toUpdateMemberStatusCommand(body), ShopIdentity.admin());
    return ResponseEntity.status(200).body(ApiResponse.ok(toAdminMemberVo(result)));
  }
}
