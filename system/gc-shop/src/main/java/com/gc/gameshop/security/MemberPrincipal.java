package com.gc.gameshop.security;

public record MemberPrincipal(Long memberId, long sessionVersion, String jti) {}
