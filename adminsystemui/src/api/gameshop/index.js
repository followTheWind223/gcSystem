import request from '@/utils/request'
// 商城使用 REST 资源地址；独立动作保留服务端幂等键，表单忙碌状态防连点。
const call = (method, url, data, params) => request({ method, url: `/mall${url}`, data, params, headers: { repeatSubmit: false } })
export const listShop = (resource, params) => call('get', `/${resource}`, undefined, params)
export const getShop = (resource, id) => call('get', `/${resource}/${encodeURIComponent(id)}`)
export const createShop = (resource, data) => call('post', `/${resource}`, data)
export const updateShop = (resource, id, data) => call('put', `/${resource}/${encodeURIComponent(id)}`, data)
export const deleteShop = (resource, id) => call('delete', `/${resource}/${encodeURIComponent(id)}`)
export const setPropStatus = (id, data) => call('put', `/props/${encodeURIComponent(id)}/status`, data)
export const setMemberStatus = (id, data) => call('put', `/members/${encodeURIComponent(id)}/status`, data)
export const cancelOrder = (id, data) => call('put', `/orders/${encodeURIComponent(id)}/cancellation`, data)
export const deliverOrder = (id, data) => call('put', `/orders/${encodeURIComponent(id)}/delivery`, data)
export const hideReview = (id, data) => call('put', `/reviews/${encodeURIComponent(id)}/visibility`, data)
export const adjustStock = (id, data) => call('post', `/props/${encodeURIComponent(id)}/stock-adjustments`, data)
export const uploadShopImage = (file) => { const data = new FormData(); data.append('file', file); return request({ url: '/mall/media/images', method: 'post', data, headers: { 'Content-Type': 'multipart/form-data', repeatSubmit: false } }) }
