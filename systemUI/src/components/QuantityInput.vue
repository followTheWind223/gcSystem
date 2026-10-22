<script setup>
defineProps({ modelValue: Number, max: { type: Number, default: 99 }, disabled: Boolean })
const emit = defineEmits(['update:modelValue'])
function change(event, max) { const n = Math.min(max, Math.max(1, Math.trunc(Number(event.target.value) || 1))); emit('update:modelValue', n); event.target.value = n }
</script>
<template><div class="quantity-input"><button aria-label="减少数量" :disabled="disabled || modelValue <= 1" @click="emit('update:modelValue', modelValue - 1)">−</button><input :value="modelValue" type="number" min="1" :max="max" :disabled="disabled" aria-label="购买数量" @change="change($event, max)" /><button aria-label="增加数量" :disabled="disabled || modelValue >= max" @click="emit('update:modelValue', modelValue + 1)">+</button></div></template>
