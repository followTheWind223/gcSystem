import { defineStore } from 'pinia'
import { authApi, memberApi } from '../api/mall.js'
export const useAuthStore = defineStore('mall-member', {
  state: () => ({ token: null, member: null, roles: [] }),
  getters: { loggedIn: (s) => Boolean(s.token && s.member) },
  actions: {
    async login(body) {
      const result = await authApi.login(body)
      if (typeof result.token !== 'string' || !result.token) throw new Error('登录响应异常，请重试。')
      this.token = result.token
      try {
        const info = await authApi.info()
        this.roles = info.roles || []
        this.member = (await memberApi.profile()).data
      } catch (error) {
        try { await authApi.logout() } catch { /* Preserve the original login error. */ }
        this.clear()
        throw error
      }
    },
    clear() { this.$reset() },
    async logout() { try { await authApi.logout() } finally { this.clear() } },
  },
})
