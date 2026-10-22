package com.gc.gameshop.model.bo;

public record UploadCommand(byte[] content, String originalName) {}
