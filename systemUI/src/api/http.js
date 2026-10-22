import axios from 'axios'

export class ApiError extends Error {
  constructor(message, { status = 0, errorCode = 'NETWORK_ERROR', details = null, retryAfter = 0, uncertain = false } = {}) {
    super(message)
    Object.assign(this, { status, errorCode, details, retryAfter, uncertain })
  }
}
let session = { getToken: () => null, onUnauthorized: () => {} }
const cooldowns = new Map()
const requestKey = (config) => `${config.method}:${config.url}`
function respectRateLimit(config, error) {
  if (config && error.status === 429 && error.retryAfter > 0) cooldowns.set(requestKey(config), Date.now() + Math.min(error.retryAfter, 86400) * 1000)
}
function currentSession(config) { return !config?.memberAuth || config.headers.Authorization === `Bearer ${session.getToken()}` }
export const configureHttp = (handlers) => { session = handlers }
export const http = axios.create({ baseURL: '/api/mall', timeout: 15000, headers: { Accept: 'application/json' } })
if (import.meta.env.VITE_USE_MOCK === 'true') http.defaults.adapter = async (config) => (await import('../mock/adapter.js')).mockAdapter(config)

http.interceptors.request.use((config) => {
  const retryAfter = Math.ceil(((cooldowns.get(requestKey(config)) || 0) - Date.now()) / 1000)
  if (retryAfter > 0) throw new ApiError(`操作较频繁，请在 ${retryAfter} 秒后重试。`, { status: 429, errorCode: 'MALL_RATE_LIMITED', retryAfter })
  if (config.memberAuth) {
    const token = session.getToken()
    if (!token) throw new ApiError('请先登录后继续。', { status: 401, errorCode: 'MALL_UNAUTHORIZED' })
    config.headers.Authorization = `Bearer ${token}`
  } else delete config.headers.Authorization
  return config
})
function parseError(error) {
  if (error instanceof ApiError) return error
  const data = error.response?.data
  const isObject = data && typeof data === 'object'
  const status = isObject ? Number(data.code || error.response.status) : Number(error.response?.status || 0)
  return new ApiError(isObject && typeof data.msg === 'string' && status < 500 ? data.msg : status >= 500 ? '服务暂不可用，请稍后重试。' : status === 404 ? '请求的内容不存在或暂未开放。' : '连接未完成，请检查网络后重试。', {
    status,
    errorCode: isObject ? data.errorCode || 'HTTP_ERROR' : 'NETWORK_ERROR',
    details: isObject ? data.data : null,
    retryAfter: Number(error.response?.headers?.['retry-after'] || data?.data?.retryAfterSeconds || 0),
    uncertain: !error.response || status >= 500,
  })
}
http.interceptors.response.use((response) => {
  if (!currentSession(response.config)) throw new ApiError('登录会话已变更，请重新操作。', { errorCode: 'SESSION_REPLACED' })
  if (response.config.responseType === 'blob') return response.data
  const reply = response.data
  if (!reply || typeof reply !== 'object' || typeof reply.code !== 'number') throw new ApiError('服务返回格式异常，请稍后重试。', { errorCode: 'INVALID_RESPONSE', uncertain: true })
  if (reply.code !== 200) {
    // RuoYi returns expected login/registration errors as HTTP 200 with code 500.
    if (response.config.baseURL === '/api/auth' && response.status === 200 && reply.code === 500
        && typeof reply.msg === 'string' && /验证码|密码|账号|账户|用户名|注册|昵称/.test(reply.msg)) {
      throw new ApiError(reply.msg, { status: 400, errorCode: 'AUTH_REJECTED' })
    }
    const error = parseError({ response: { ...response, status: reply.code } })
    respectRateLimit(response.config, error)
    if (error.status === 401 && response.config.memberAuth) session.onUnauthorized()
    throw error
  }
  return reply
}, (raw) => {
  if (raw.config && !currentSession(raw.config)) return Promise.reject(new ApiError('登录会话已变更，请重新操作。', { errorCode: 'SESSION_REPLACED' }))
  const error = parseError(raw)
  respectRateLimit(raw.config, error)
  if (error.status === 401 && (raw.config?.memberAuth || raw instanceof ApiError)) session.onUnauthorized()
  return Promise.reject(error)
})
