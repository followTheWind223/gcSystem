package com.ruoyi.gameshop.model.dto;
public record CreateGameServerRequest(@com.fasterxml.jackson.annotation.JsonProperty(value="categoryId",required=true) @jakarta.validation.constraints.NotNull @jakarta.validation.constraints.Pattern(regexp="^[1-9][0-9]{0,18}$") String categoryId,
    @com.fasterxml.jackson.annotation.JsonProperty(value="name",required=true) @jakarta.validation.constraints.NotBlank @jakarta.validation.constraints.Size(max=50) String name,
    @com.fasterxml.jackson.annotation.JsonProperty(value="sort",required=true) @jakarta.validation.constraints.NotNull @jakarta.validation.constraints.Min(0) @jakarta.validation.constraints.Max(9999) Integer sort,
    @com.fasterxml.jackson.annotation.JsonProperty(value="status",required=true) @jakarta.validation.constraints.NotNull @jakarta.validation.constraints.Pattern(regexp="^[01]$") String status,
    @com.fasterxml.jackson.annotation.JsonProperty(value="remark",required=true) @jakarta.validation.constraints.Size(max=200) String remark) {}

