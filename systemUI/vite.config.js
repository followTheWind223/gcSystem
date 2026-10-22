import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')
  return {
    plugins: [vue()],
    server: {
      host: env.DEV_HOST || '127.0.0.1',
      port: Number(env.DEV_PORT || 5173),
      strictPort: true,
      proxy: {
        '/api/mall': { target: env.DEV_PROXY_TARGET || 'http://127.0.0.1:8080', changeOrigin: true },
        '/api/auth': { target: env.DEV_PROXY_TARGET || 'http://127.0.0.1:8080', changeOrigin: true, rewrite: path => path.replace(/^\/api\/auth/, '') },
      },
      headers: { 'X-Content-Type-Options': 'nosniff', 'Referrer-Policy': 'same-origin' },
    },
    preview: { host: '127.0.0.1', port: 4173, strictPort: true },
    build: { rollupOptions: { output: { manualChunks: { vue: ['vue', 'vue-router', 'pinia'], ui: ['element-plus'] } } } },
  }
})
