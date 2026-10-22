package com.ruoyi.gameshop.service;

import com.ruoyi.gameshop.model.bo.*;
import com.ruoyi.gameshop.model.result.*;
import com.ruoyi.gameshop.persistence.entity.MediaEntity;
import java.nio.file.Path;

public interface MediaService {
  ImageUploadResult upload(UploadCommand command, Actor actor, boolean avatar);

  MemberResult avatar(UploadCommand command, Long memberId);

  Long mediaId(String url);

  String url(Long id);

  MediaEntity file(String name);

  Path path(MediaEntity file);
}
