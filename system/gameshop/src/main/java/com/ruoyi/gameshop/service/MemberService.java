package com.ruoyi.gameshop.service;

import com.ruoyi.gameshop.model.bo.Actor;
import com.ruoyi.gameshop.model.command.*;
import com.ruoyi.gameshop.model.query.ShopQuery;
import com.ruoyi.gameshop.model.result.*;

public interface MemberService {
  MemberResult profile(Long id);

  MemberResult update(Long id, UpdateProfileCommand c);

  void password(Long id, ChangePasswordCommand c);

  AdminMemberResult admin(Long id);

  PageResult<AdminMemberResult> list(ShopQuery q);

  AdminMemberResult status(Long id, UpdateMemberStatusCommand c, Actor actor);
}
