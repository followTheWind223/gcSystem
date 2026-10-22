<script setup>
import { ElOption, ElSelect } from 'element-plus'
import Icon from './Icon.vue'

defineProps({
  modelValue: { type: [String, Number], default: '' },
  options: { type: Array, required: true },
  label: { type: String, required: true },
  id: { type: String, default: undefined },
  placeholder: { type: String, default: '请选择' },
  disabled: Boolean,
})
defineEmits(['update:modelValue'])
</script>

<template>
  <ElSelect
    :id="id"
    class="shop-select"
    :model-value="modelValue"
    :aria-label="label"
    :placeholder="placeholder"
    :disabled="disabled"
    :show-arrow="false"
    :offset="8"
    placement="bottom-end"
    :fallback-placements="['top-end', 'bottom-start', 'top-start']"
    popper-class="shop-select-dropdown"
    @update:model-value="$emit('update:modelValue', $event)"
  >
    <ElOption v-for="option in options" :key="option.value" :value="option.value" :label="option.label" :disabled="option.disabled">
      <span>{{ option.label }}</span>
      <Icon class="shop-select-check" name="check" :size="16" />
    </ElOption>
  </ElSelect>
</template>

<style>
.shop-select {
  width: 168px;
  max-width: 100%;
  --el-text-color-regular: #dce5e2;
  --el-text-color-placeholder: #8d9d97;
  --el-border-color-hover: #52685f;
}
.shop-select .el-select__wrapper {
  min-height: 42px;
  padding: 0 13px;
  border-radius: 8px;
  background: #181f22;
  font-size: 12px;
  box-shadow: 0 0 0 1px #34413c inset;
  transition: background-color .15s, box-shadow .15s;
}
.shop-select .el-select__wrapper:hover:not(.is-disabled) { background: #1e2728; }
.shop-select .el-select__wrapper.is-focused {
  box-shadow: 0 0 0 1px var(--accent) inset, 0 0 0 3px #68e4be14;
}
.shop-select .el-select__input { padding: 0; border: 0; background: transparent; }
.shop-select .el-select__input:focus-visible { outline: none; }
.shop-select .el-select__caret { color: #9bafa5; font-size: 16px; }

/* The options are teleported to body, so keep these styles globally namespaced. */
.shop-select-dropdown.el-popper {
  background: #1b2325;
  border: 1px solid #3a4b44;
  border-radius: 10px;
  box-shadow: 0 14px 36px #0006, 0 3px 8px #0003;
  overflow: hidden;
}
.shop-select-dropdown .el-select-dropdown__list { padding: 6px; }
.shop-select-dropdown .el-select-dropdown__item {
  display: flex;
  align-items: center;
  gap: 16px;
  height: 40px;
  padding: 0 11px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 400;
  line-height: 40px;
  color: #c2cfca;
  transition: background-color .15s, color .15s;
}
.shop-select-dropdown .el-select-dropdown__item.is-hovering:not(.is-disabled) { background: #2a3632; color: #edf5f0; }
.shop-select-dropdown .el-select-dropdown__item.is-selected { background: #254039; color: var(--accent); font-weight: 600; }
.shop-select-dropdown .el-select-dropdown__item.is-selected.is-hovering { background: #2d4d43; color: var(--accent); }
.shop-select-dropdown .el-select-dropdown__item.is-disabled { color: #697a73; }
.shop-select-check { margin-left: auto; opacity: 0; }
.shop-select-dropdown .is-selected .shop-select-check { opacity: 1; }
@media (prefers-reduced-motion: reduce) {
  .shop-select .el-select__wrapper, .shop-select .el-select__caret, .shop-select-dropdown .el-select-dropdown__item { transition: none; }
}
</style>
