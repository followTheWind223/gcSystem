package com.gc.gameshop.service;

import com.gc.gameshop.model.bo.Actor;
import com.gc.gameshop.model.command.*;
import com.gc.gameshop.model.query.ShopQuery;
import com.gc.gameshop.model.result.*;

public interface MemberService {
  MemberResult profile(Long id);

  MemberResult update(Long id, UpdateProfileCommand c);

  void password(Long id, ChangePasswordCommand c);

  AdminMemberResult admin(Long id);

  PageResult<AdminMemberResult> list(ShopQuery q);

  AdminMemberResult status(Long id, UpdateMemberStatusCommand c, Actor actor);
}
