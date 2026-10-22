package com.ruoyi.framework.security;

import com.ruoyi.common.core.domain.model.LoginUser;
import org.springframework.security.core.Authentication;

/** 认证成功不等于拥有后台访问资格。普通用户只使用商城业务接口。 */
public final class BackofficeAccess {
    private BackofficeAccess() {}
    public static boolean allowed(Authentication authentication) {
        return authentication != null && authentication.getPrincipal() instanceof LoginUser user
            && (user.getUser().isAdmin() || (user.getPermissions() != null && !user.getPermissions().isEmpty()));
    }
}
