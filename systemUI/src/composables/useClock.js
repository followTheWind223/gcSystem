import { ref, computed, onUnmounted } from 'vue'
export function useClock() {
  const now = ref(Date.now()), offset = ref(0)
  const timer = setInterval(() => { now.value = Date.now() }, 1000)
  onUnmounted(() => clearInterval(timer))
  const sync = (serverTime) => { offset.value = Date.parse(serverTime) - Date.now(); now.value = Date.now() }
  const remaining = (expiresAt) => Math.max(0, Math.ceil((Date.parse(expiresAt || '') - now.value - offset.value) / 1000)) || 0
  const display = (seconds) => `${String(Math.floor(seconds / 60)).padStart(2, '0')}:${String(seconds % 60).padStart(2, '0')}`
  return { now: computed(() => now.value + offset.value), sync, remaining, display }
}
