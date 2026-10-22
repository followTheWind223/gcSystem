package com.gc.gameshop.model.result;

/** Service 业务输出；不作为数据库实体。 */
public record ImageUploadResult(
    String fileName, String url, String originalName, String mimeType, Integer size) {}
