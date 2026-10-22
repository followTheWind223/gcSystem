<template>
  <span class="brand-lockup">
    <img class="brand-mark" src="/gs-logo.svg?v=2" alt="" />
    <span class="brand-copy">
      <span class="brand-wordmark"><span>game</span><span class="brand-wordmark-accent">shop</span></span>
      <small class="brand-caption">游戏道具商城</small>
    </span>
  </span>
</template>

<style scoped>
.brand-lockup { display: inline-flex; align-items: center; gap: 11px; vertical-align: middle; }
.brand-mark { display: block; flex-shrink: 0; width: var(--brand-symbol-size, 48px); height: var(--brand-symbol-size, 48px); object-fit: contain; }
.brand-copy { display: flex; flex-direction: column; gap: 6px; }
.brand-wordmark { display: block; color: #f0f7f5; font-family: 'Segoe UI', Arial, sans-serif; font-size: var(--brand-word-size, 24px); font-weight: 800; line-height: 1; letter-spacing: -.8px; }
.brand-wordmark-accent { color: #68e4be; }
.brand-caption { display: block; color: #a1b6ae; font-size: var(--brand-caption-size, 9px); font-weight: 500; line-height: 1.2; letter-spacing: 2.5px; }
</style>
