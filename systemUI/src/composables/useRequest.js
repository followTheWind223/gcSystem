import { ref } from 'vue'
export function useRequest(fn) {
  const data = ref(null), error = ref(null), loading = ref(false)
  let sequence = 0
  async function load(...args) {
    const run = ++sequence
    loading.value = true; error.value = null
    try { const result = await fn(...args); if (run === sequence) data.value = result; return result }
    catch (e) { if (run === sequence) error.value = e; return null }
    finally { if (run === sequence) loading.value = false }
  }
  return { data, error, loading, load }
}
