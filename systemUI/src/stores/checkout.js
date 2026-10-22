import { defineStore } from 'pinia'
export const useCheckoutStore = defineStore('mall-checkout', {
  state: () => ({ source: null, payload: null }),
  actions: {
    begin(source) { this.source = source; this.payload = null },
    clear() { this.$reset() },
  },
})
