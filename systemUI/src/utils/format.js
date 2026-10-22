export function cents(value) {
  if (!/^\d+\.\d{2}$/.test(String(value))) throw new TypeError('金额必须为两位小数字符串')
  const [whole, decimal] = value.split('.')
  return BigInt(whole) * 100n + BigInt(decimal)
}
export function fromCents(value) {
  const n = BigInt(value)
  return `${n / 100n}.${String(n % 100n).padStart(2, '0')}`
}
export const money = (value) => typeof value === 'string' && /^\d+\.\d{2}$/.test(value) ? value.replace(/\B(?=(\d{3})+\.)/g, ',') : '—'
export const dateTime = (value) => value ? new Intl.DateTimeFormat('zh-CN', { timeZone: 'Asia/Shanghai', dateStyle: 'medium', timeStyle: 'short', hour12: false }).format(new Date(value)) : '—'
export const dateOnly = (value) => value ? new Intl.DateTimeFormat('zh-CN', { timeZone: 'Asia/Shanghai', dateStyle: 'medium' }).format(new Date(value)) : '—'
export const statusText = { '1': '待支付', '2': '待交付', '3': '已取消', '4': '已完成' }
export function deliveryServerText(info) { return info?.servers?.length ? info.servers.map(server => `${server.categoryName}：${server.serverName}`).join('；') : info?.serverName || '—' }
export const deliveryLabels = { gameAccount: '游戏账号', serverName: '游戏区服', roleName: '角色名称' }
export const availabilityText = { AVAILABLE: '可购买', OUT_OF_STOCK: '库存不足', OFF_SHELF: '商品已下架', CATEGORY_DISABLED: '游戏暂不可用', DELETED: '商品已失效', LIMIT_EXCEEDED: '超出购买上限' }
export function safeRedirect(value) {
  if (typeof value !== 'string' || !value.startsWith('/') || value.startsWith('//') || /[\\\u0000-\u0020]/.test(value)) return '/'
  try {
    const decoded = decodeURIComponent(value)
    if (decoded.startsWith('//') || /[\\\u0000-\u0020]/.test(decoded)) return '/'
    const url = new URL(value, 'https://mall.local')
    if (url.origin !== 'https://mall.local' || /^\/(login|register|forgot-password)(\/|$)/.test(url.pathname)) return '/'
    return url.pathname + url.search + url.hash
  } catch { return '/' }
}
export const validUsername = (v) => /^[a-z][a-z0-9_]{3,19}$/.test(v)
export const validPassword = (v) => /^(?=.*[A-Za-z])(?=.*[0-9])[!-~]{8,64}$/.test(v)
export const validEmail = (v) => v.length <= 254 && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v)
export function mediaUrl(value) {
  if (typeof value !== 'string') return ''
  if (/^\/api\/mall\/media\/[a-f0-9]{32}\.(png|jpg|webp)$/.test(value)) return value
  if (import.meta.env?.VITE_USE_MOCK === 'true' && (/^\/images\/[a-z0-9-]+\.(png|webp)(#[0-5])?$/.test(value) || value.startsWith('blob:'))) return value
  return ''
}
