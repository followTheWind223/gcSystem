import { http } from './http.js'
const id = encodeURIComponent
const protectedRequest = { memberAuth: true }
const ruoyi = { baseURL: '/api/auth' }
export const authApi = {
  captcha: () => http.get('/captchaImage', ruoyi),
  register: (body) => http.post('/register', body, ruoyi),
  login: (body) => http.post('/login', body, ruoyi),
  info: () => http.get('/getInfo', { ...ruoyi, ...protectedRequest }),
  logout: () => http.post('/logout', null, { ...ruoyi, ...protectedRequest }),
}
export const catalogApi = {
  home: () => http.get('/home'),
  categories: () => http.get('/categories'),
  props: (params) => http.get('/props', { params }),
  prop: (propId) => http.get(`/props/${id(propId)}`),
  reviews: (propId, params) => http.get(`/props/${id(propId)}/reviews`, { params }),
  media: (fileName) => http.get(`/media/${id(fileName)}`, { responseType: 'blob' }),
}
export const memberApi = {
  profile: () => http.get('/me', protectedRequest),
  update: (body) => http.put('/me', body, protectedRequest),
  password: (body) => http.put('/me/password', body, protectedRequest),
  avatar: (file) => { const body = new FormData(); body.append('file', file); return http.post('/me/avatar', body, protectedRequest) },
  reviews: (params) => http.get('/me/reviews', { ...protectedRequest, params }),
  review: (body) => http.post('/reviews', body, protectedRequest),
}
export const cartApi = {
  get: () => http.get('/cart/items', protectedRequest),
  add: (body) => http.post('/cart/items', body, protectedRequest),
  update: (cartItemId, body) => http.put(`/cart/items/${id(cartItemId)}`, body, protectedRequest),
  remove: (cartItemId) => http.delete(`/cart/items/${id(cartItemId)}`, protectedRequest),
  select: (body) => http.put('/cart/selection', body, protectedRequest),
}
export const orderApi = {
  preview: (body) => http.post('/order-quotes', body, protectedRequest),
  create: (body) => http.post('/orders', body, protectedRequest),
  list: (params) => http.get('/orders', { ...protectedRequest, params }),
  detail: (orderNo) => http.get(`/orders/${id(orderNo)}`, protectedRequest),
  cancel: (orderNo, body) => http.put(`/orders/${id(orderNo)}/cancellation`, body, protectedRequest),
  pay: (orderNo, result) => http.post(`/orders/${id(orderNo)}/payments`, { result }, protectedRequest),
}
