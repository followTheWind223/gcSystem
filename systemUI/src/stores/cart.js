import { defineStore } from 'pinia'
import { cartApi } from '../api/mall.js'
export const useCartStore = defineStore('mall-cart', {
  state: () => ({ cart: null }),
  getters: { count: (s) => s.cart?.summary.totalQuantity || 0 },
  actions: {
    clear() { this.$reset() },
    async load() { this.cart = (await cartApi.get()).data },
    async add(body) { try { this.cart = (await cartApi.add(body)).data } catch (error) { if (error.uncertain) await this.load().catch(() => {}); throw error } },
    async update(id, body) { this.cart = (await cartApi.update(id, body)).data },
    async remove(id) { this.cart = (await cartApi.remove(id)).data },
    async select(body) { this.cart = (await cartApi.select(body)).data },
  },
})
