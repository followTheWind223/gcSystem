<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { mediaUrl } from '../utils/format.js'
import Icon from './Icon.vue'

const props = defineProps({ banners: { type: Array, default: () => [] } })
const viewport = ref(null), index = ref(0), offset = ref(0), dragging = ref(false), animating = ref(false)
const target = ref(null), direction = ref(0), reducedMotion = ref(false)
const count = computed(() => props.banners.length)
const featured = computed(() => props.banners[index.value])
const wrap = value => count.value ? (value + count.value) % count.value : 0
const slides = computed(() => {
  if (!count.value) return []
  if (count.value === 1) return [{ position: 0, banner: featured.value }]
  return [-1, 0, 1].map(position => ({
    position,
    banner: props.banners[position === direction.value && target.value !== null ? target.value : wrap(index.value + position)],
  }))
})
const trackStyle = computed(() => ({ transform: count.value > 1 ? `translate3d(calc(-100% + ${offset.value}px), 0, 0)` : 'none' }))
let pointer = null, width = 0, timeout, resizeObserver, motionQuery, suppressClickUntil = 0

function finish() {
  clearTimeout(timeout)
  if (target.value !== null) index.value = target.value
  animating.value = false
  target.value = null
  direction.value = 0
  offset.value = 0
}
function moveTo(next, step) {
  if (count.value < 2 || animating.value) return
  const nextIndex = wrap(next)
  if (nextIndex === index.value && !offset.value) return
  target.value = nextIndex
  direction.value = step
  if (reducedMotion.value) { finish(); return }
  animating.value = true
  offset.value = step ? -step * width : 0
  // Also settle if a transition is interrupted by a resize or backgrounded tab.
  timeout = setTimeout(finish, 500)
}
function select(next) {
  if (dragging.value || next === index.value) return
  const distance = wrap(next - index.value)
  moveTo(next, distance <= count.value / 2 ? 1 : -1)
}
function releasePointer() {
  const previous = pointer
  pointer = null
  if (previous && viewport.value?.hasPointerCapture(previous.id)) viewport.value.releasePointerCapture(previous.id)
  return previous
}
function start(event) {
  if (count.value < 2 || animating.value || pointer || !event.isPrimary || event.button !== 0 || event.target.closest('button')) return
  suppressClickUntil = 0
  pointer = { id: event.pointerId, x: event.clientX, y: event.clientY, time: event.timeStamp, horizontal: false }
}
function drag(event) {
  if (!pointer || event.pointerId !== pointer.id) return
  const dx = event.clientX - pointer.x, dy = event.clientY - pointer.y
  if (!pointer.horizontal) {
    if (Math.max(Math.abs(dx), Math.abs(dy)) < 8) return
    if (Math.abs(dy) > Math.abs(dx)) { releasePointer(); return }
    pointer.horizontal = true
    dragging.value = true
    viewport.value.setPointerCapture(event.pointerId)
  }
  if (event.cancelable) event.preventDefault()
  offset.value = Math.max(-width, Math.min(width, dx))
}
function end(event) {
  if (!pointer || event.pointerId !== pointer.id) return
  const previous = releasePointer()
  if (!previous.horizontal) return
  dragging.value = false
  suppressClickUntil = Date.now() + 400
  const distance = offset.value, elapsed = Math.max(1, event.timeStamp - previous.time)
  const advance = Math.abs(distance) >= Math.min(100, width * .18) || (Math.abs(distance) > 22 && Math.abs(distance) / elapsed > .55)
  const step = advance ? (distance < 0 ? 1 : -1) : 0
  moveTo(index.value + step, step)
}
function cancel(event) {
  if (!pointer || (event?.pointerId !== undefined && event.pointerId !== pointer.id)) return
  const previous = releasePointer()
  dragging.value = false
  if (previous.horizontal) {
    suppressClickUntil = Date.now() + 400
    moveTo(index.value, 0)
  }
}
function guardClick(event) {
  if (dragging.value || animating.value || (event.detail > 0 && Date.now() < suppressClickUntil)) {
    event.preventDefault()
    event.stopPropagation()
  }
}
function keydown(event) {
  if (count.value < 2 || event.altKey || event.ctrlKey || event.metaKey || !['ArrowLeft', 'ArrowRight'].includes(event.key)) return
  event.preventDefault()
  moveTo(index.value + (event.key === 'ArrowRight' ? 1 : -1), event.key === 'ArrowRight' ? 1 : -1)
}
function syncMotion() {
  reducedMotion.value = motionQuery.matches
  if (reducedMotion.value && animating.value) finish()
}
watch(() => props.banners, () => {
  releasePointer()
  clearTimeout(timeout)
  index.value = 0
  target.value = null
  dragging.value = false
  finish()
})
onMounted(() => {
  width = viewport.value.clientWidth
  resizeObserver = new ResizeObserver(() => {
    const nextWidth = viewport.value.clientWidth
    if (nextWidth !== width) {
      releasePointer()
      dragging.value = false
      finish()
      width = nextWidth
    }
  })
  resizeObserver.observe(viewport.value)
  motionQuery = window.matchMedia('(prefers-reduced-motion: reduce)')
  syncMotion()
  motionQuery.addEventListener('change', syncMotion)
  window.addEventListener('blur', cancel)
  window.addEventListener('pointerup', end)
  window.addEventListener('pointercancel', cancel)
})
onBeforeUnmount(() => {
  clearTimeout(timeout)
  releasePointer()
  resizeObserver?.disconnect()
  motionQuery?.removeEventListener('change', syncMotion)
  window.removeEventListener('blur', cancel)
  window.removeEventListener('pointerup', end)
  window.removeEventListener('pointercancel', cancel)
})
</script>

<template>
  <div ref="viewport" class="hero-main" :class="{ 'is-draggable': count > 1, 'is-dragging': dragging, 'is-animating': animating }"
    role="region" aria-roledescription="轮播图" aria-label="精选道具推荐" :tabindex="count > 1 ? 0 : undefined"
    @pointerdown="start" @pointermove="drag" @pointerup="end" @pointercancel="cancel" @lostpointercapture.self="cancel"
    @dragstart.prevent @click.capture="guardClick" @keydown="keydown">
    <div class="hero-track" :class="{ 'is-animating': animating }" :style="trackStyle" aria-hidden="true"
      @transitionend.self="finish">
      <div v-for="slide in slides" :key="slide.position" class="hero-slide"
        :style="{ backgroundImage: `url('${mediaUrl(slide.banner.imageUrl)}')` }" />
    </div>
    <div class="hero-shade" aria-hidden="true" />
    <div class="hero-copy">
      <span class="eyebrow"><span /> 本周精选 · FEATURED DROP</span>
      <h1>下一场冒险，<br />从<span>好装备</span>开始。</h1>
      <p>发现心仪道具，让每一份热爱有所装备。<br />你的专属补给，现在开启。</p>
      <RouterLink :to="featured?.targetPropId ? `/props/${featured.targetPropId}` : '/props'" class="btn" :aria-disabled="animating || dragging || undefined">
        探索精选道具<Icon name="arrow" :size="18" />
      </RouterLink>
    </div>
    <div class="hero-bottom">
      <div class="hero-caption" aria-live="polite" aria-atomic="true"><span class="tiny-line" />
        <Transition name="hero-caption" mode="out-in"><span :key="featured?.bannerId || 'empty'">{{ featured?.title || '探索新的游戏装备' }}</span></Transition>
      </div>
      <div v-if="count" class="hero-index">
        <span class="hero-counter" aria-hidden="true">{{ String(index + 1).padStart(2, '0') }} / {{ String(count).padStart(2, '0') }}</span>
        <template v-if="count > 1">
          <div class="hero-dots"><button v-for="(banner, i) in banners" :key="banner.bannerId" :class="{ active: i === index }"
            :aria-label="`查看推荐：${banner.title}`" :aria-pressed="i === index" :disabled="animating" @click="select(i)" /></div>
          <div class="hero-arrows"><button class="hero-arrow previous" aria-label="上一张推荐" :disabled="animating" @click="moveTo(index - 1, -1)"><Icon name="chevron" :size="16" /></button><button class="hero-arrow" aria-label="下一张推荐" :disabled="animating" @click="moveTo(index + 1, 1)"><Icon name="chevron" :size="16" /></button></div>
        </template>
      </div>
    </div>
  </div>
</template>

<style scoped>
.hero-main { display: flex; flex-direction: column; min-width: 0; touch-action: pan-y pinch-zoom; }
.is-draggable { cursor: grab; user-select: none; -webkit-user-select: none; }
.is-dragging, .is-dragging :deep(*) { cursor: grabbing; }
.hero-main:focus-visible { outline-offset: 4px; }
.hero-track { position: absolute; inset: 0; display: flex; will-change: transform; }
.hero-track.is-animating { transition: transform 420ms cubic-bezier(.22, .7, .25, 1); }
.hero-slide { flex: 0 0 100%; height: 100%; background-size: cover; background-position: center; }
.hero-shade { position: absolute; inset: 0; background: linear-gradient(90deg, #0c1315f5 0%, #0c1315ad 39%, transparent 72%); pointer-events: none; }
.hero-copy { flex: 1; padding-bottom: 0; }
.hero-bottom { position: relative; z-index: 2; display: flex; align-items: flex-end; justify-content: space-between; flex-wrap: wrap; gap: 14px; padding: 18px 24px 20px 39px; }
.hero-caption { min-width: 0; flex: 1 1 180px; margin: 0; min-height: 36px; line-height: 1.6; }
.hero-caption > span:last-child { overflow-wrap: anywhere; }
.tiny-line { flex-shrink: 0; }
.hero-caption-enter-active, .hero-caption-leave-active { transition: opacity 160ms ease, transform 160ms ease; }
.hero-caption-enter-from { opacity: 0; transform: translateY(5px); }
.hero-caption-leave-to { opacity: 0; transform: translateY(-5px); }
.hero-index { display: flex; align-items: center; flex-wrap: wrap; justify-content: flex-end; gap: 12px; margin-left: auto; max-width: 100%; color: #b7ccc7; font-size: 9px; }
.hero-counter { font-variant-numeric: tabular-nums; white-space: nowrap; }
.hero-dots, .hero-arrows { display: flex; align-items: center; }
.hero-dots { flex-wrap: wrap; gap: 2px; }
.hero-dots button { width: 25px; height: 36px; padding: 0 3px; display: grid; align-items: center; }
.hero-dots button::before { content: ''; height: 3px; border-radius: 3px; background: #82998d70; transition: background-color .2s, transform .2s; }
.hero-dots button:hover::before { background: #b3ccbf; }
.hero-dots button.active::before { background: var(--accent); transform: scaleY(1.35); }
.hero-arrows { gap: 6px; }
.hero-arrow { display: grid; place-items: center; width: 36px; height: 36px; border-radius: 50%; border: 1px solid #8ba69a40; background: #101a1b80; color: #d4e4dc; transition: background-color .2s, border-color .2s; }
.hero-arrow.previous svg { transform: rotate(180deg); }
.hero-arrow:hover:not(:disabled) { background: #28473cdc; border-color: #68e4be80; }
.hero-index button:disabled { opacity: 1; cursor: default; }
@media (max-width: 960px) { .hero-bottom { padding-left: 28px; } }
@media (max-width: 700px) {
  .hero-slide { background-position: 62% center; }
  .hero-bottom { padding: 16px 25px 20px; gap: 8px; }
  .hero-caption { flex-basis: 100%; min-height: 20px; }
  .hero-arrow, .hero-dots button { height: 40px; }
  .hero-arrow { width: 40px; }
  .hero-dots { gap: 0; }
}
@media (prefers-reduced-motion: reduce) { .hero-track.is-animating, .hero-caption-enter-active, .hero-caption-leave-active { transition: none; } }
</style>
