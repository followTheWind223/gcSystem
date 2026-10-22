package com.gc.gameshop.controller;

import static com.gc.gameshop.convert.CommandAssembler.*;
import static com.gc.gameshop.convert.ViewAssembler.*;
import static com.gc.gameshop.support.ShopValues.id;

import com.gc.common.annotation.Log;
import com.gc.common.enums.BusinessType;
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
