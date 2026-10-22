package com.ruoyi.gameshop.web;

import com.ruoyi.gameshop.model.vo.ErrorDetailsVo;

public record ApiError(int code, String msg, String errorCode, ErrorDetailsVo data) {}
