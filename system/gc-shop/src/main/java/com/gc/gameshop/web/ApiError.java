package com.gc.gameshop.web;

import com.gc.gameshop.model.vo.ErrorDetailsVo;

public record ApiError(int code, String msg, String errorCode, ErrorDetailsVo data) {}
