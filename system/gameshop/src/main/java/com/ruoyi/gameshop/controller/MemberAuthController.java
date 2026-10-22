package com.ruoyi.gameshop.controller;

import static com.ruoyi.gameshop.convert.CommandAssembler.*;
import static com.ruoyi.gameshop.convert.ViewAssembler.*;

import com.ruoyi.gameshop.convert.*;
import com.ruoyi.gameshop.exception.ShopException;
import com.ruoyi.gameshop.model.bo.UploadCommand;
import com.ruoyi.gameshop.model.dto.*;
import com.ruoyi.gameshop.model.vo.*;
import com.ruoyi.gameshop.security.*;
import com.ruoyi.gameshop.service.*;
import com.ruoyi.gameshop.web.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import java.io.IOException;
import java.net.URI;
import java.util.*;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.*;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@Validated
public class MemberAuthController {
  private final MemberService members;
  private final MediaService media;

  public MemberAuthController(
      MemberService members, MediaService media) {
    this.members = members;
    this.media = media;
  }

  private Long mid() {
    return ShopIdentity.member().memberId();
  }

  private UploadCommand upload(MultipartFile file, int max) throws IOException {
    if (file.getSize() > max) throw new ShopException(413, "MALL_UPLOAD_TOO_LARGE", "图片过大。");
    return new UploadCommand(file.getBytes(), file.getOriginalFilename());
  }

  @GetMapping(value = "/api/mall/me")
  public ResponseEntity<ApiResponse<MemberVo>> memberGetProfile() throws IOException {
    var result = members.profile(mid());
    return ResponseEntity.status(200).body(ApiResponse.ok(toMemberVo(result)));
  }

  @PutMapping(value = "/api/mall/me")
  public ResponseEntity<ApiResponse<MemberVo>> memberUpdateProfile(
      @Valid @RequestBody UpdateProfileRequest body) throws IOException {
    var result = members.update(mid(), toUpdateProfileCommand(body));
    return ResponseEntity.status(200).body(ApiResponse.ok(toMemberVo(result)));
  }

  @PutMapping(value = "/api/mall/me/password")
  public ResponseEntity<ApiResponse<Void>> memberChangePassword(
      @Valid @RequestBody ChangePasswordRequest body) throws IOException {
    members.password(mid(), toChangePasswordCommand(body));
    return ResponseEntity.ok(ApiResponse.ok(null));
  }

  @PostMapping(value = "/api/mall/me/avatar", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
  public ResponseEntity<ApiResponse<MemberVo>> memberUploadAvatar(
      @RequestPart("file") MultipartFile file) throws IOException {
    var result = media.avatar(upload(file, 2097152), mid());
    return ResponseEntity.status(200).body(ApiResponse.ok(toMemberVo(result)));
  }

  @GetMapping(value = "/api/mall/media/{fileName}")
  public ResponseEntity<FileSystemResource> mallGetPublicImage(@PathVariable String fileName)
      throws IOException {
    var f = media.file(fileName);
    return ResponseEntity.ok()
        .contentType(MediaType.parseMediaType(f.getMimeType()))
        .header("X-Content-Type-Options", "nosniff")
        .cacheControl(CacheControl.maxAge(java.time.Duration.ofDays(365)).cachePublic().immutable())
        .body(new FileSystemResource(media.path(f)));
  }
}
