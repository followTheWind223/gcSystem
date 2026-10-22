// Explicit development transport. Never imported by the real production build.
import fixtures from './fixtures.json'
import { cents, fromCents, validPassword, validUsername, validEmail } from '../utils/format.js'

const clone = value => JSON.parse(JSON.stringify(value))
const stamp = (offset = 0) => new Date(Date.now() + offset + 8 * 3600000).toISOString().replace('Z', '+08:00')
const uid = () => crypto.randomUUID()
const image = i => `/images/item-atlas.png#${i % 6}`
let serial = 9000
let scenario = 'normal'
export const setScenario = value => { scenario = value }
export const getScenario = () => scenario
export const scenarios = [
  ['normal', '正常体验'], ['empty', '空商品列表'], ['network', '网络不可用'], ['session-expired', '会员会话过期'],
  ['stockout', '商品缺货'], ['off-shelf', '商品已下架'], ['invalid-cart', '购物车失效项'],
  ['quote-changed', '提交时价格变化'], ['quote-expired', '提交时报价过期'], ['create-timeout', '订单已创建但响应丢失'],
  ['order-expired', '待支付订单过期'], ['pay-conflict', '支付与取消竞争'], ['review-hidden', '评价已隐藏'],
]
const categoryNames = ['星海远征', '永恒之境', '霓虹战线', '秘境传说']
const categories = categoryNames.map((name, i) => ({ categoryId: String(101 + i), name, iconUrl: image(i), sort: i + 1, recommended: true }))
const items = [
  ['星辉长剑', '49.90', '69.90', 8, 5, 0, 0, '史诗'],
  ['逐日之弓', '129.00', '169.00', 16, 128, 1, 1, '传说'],
  ['月影蝶翼', '89.00', null, 12, 86, 1, 2, '史诗'],
  ['极寒星晶', '29.90', '39.90', 56, 236, 0, 3, '稀有'],
  ['冒险者宝箱', '19.90', null, 99, 365, 3, 4, '稀有'],
  ['赤焰战术头盔', '159.00', '199.00', 6, 52, 2, 5, '传说'],
  ['晨曦之刃', '79.00', '99.00', 24, 72, 3, 0, '史诗'],
  ['游侠长弓', '59.00', null, 0, 106, 3, 1, '稀有'],
  ['暮光星坠', '199.00', '239.00', 3, 35, 0, 2, '传说'],
  ['能量结晶', '9.90', null, 120, 450, 2, 3, '稀有'],
  ['远征补给箱', '39.00', '49.00', 30, 185, 0, 4, '史诗'],
  ['先锋装甲面罩', '109.00', null, 8, 63, 2, 5, '史诗'],
].map(([name, price, originalPrice, stock, sales, cat, art, rarity], i) => ({
  propId: String(1001 + i), categoryId: categories[cat].categoryId, categoryName: categories[cat].name,
  name, coverUrl: image(art), price, originalPrice, stock, sales, onSaleAt: stamp(-i * 86400000), canPurchase: stock > 0,
  images: [{ url: image(art), sort: 1 }], detailHtml: `<h2>${name}</h2><p>为下一场冒险，准备一件称心的装备。${name}是${categories[cat].name}中的精选虚拟道具。</p><h3>道具说明</h3><ul><li>商品规格仅用于展示，请确认适用游戏与区服。</li><li>支付完成后，由管理员核对游戏账号、区服与角色名并登记交付。</li><li>交付进度与说明可在订单详情查看。</li></ul><blockquote>本页面为演示商品，不对应真实游戏资产。</blockquote>`,
  specs: [{ name: '品质', value: rarity }, { name: '适用游戏', value: categories[cat].name }, { name: '交付方式', value: '人工交付' }],
  deliveryFields: ['gameAccount', 'serverName', 'roleName'], reviewCount: 1, averageScore: 5,
}))
const summary = p => { const { images, detailHtml, specs, deliveryFields, reviewCount, averageScore, ...rest } = p; return rest }
const presentProp = p => ({ ...p, stock: scenario === 'stockout' ? 0 : p.stock, canPurchase: scenario !== 'stockout' && p.stock > 0 })
const publicReviews = clone(fixtures.mallListPropReviews.rows).map(row => ({ ...row, propId: '1001' }))
const members = [{ ...clone(fixtures.memberGetProfile.data), nickname: '星海旅人', avatarUrl: null, passwordHash: null }]
const sessions = new Map(), captchas = new Map(), emailCodes = new Map(), quotes = new Map(), requests = new Map(), baskets = new Map(), orders = new Map(), reviews = new Map()
baskets.set('2001', [{ cartItemId: '4001', propId: '1001', quantity: 2, checked: true }, { cartItemId: '4002', propId: '1004', quantity: 1, checked: true }])
const initial = clone(fixtures.memberGetOrder.data)
initial.items[0].coverUrl = image(0)
initial.items[0].propName = items[0].name
initial.createdAt = stamp(); initial.expiresAt = stamp(1800000)
initial.serverTime = stamp()
const completed = clone(initial)
Object.assign(completed, { orderId: '5003', orderNo: 'GC202610222000000003', status: '4', createdAt: stamp(-86400000), paidAt: stamp(-86000000), completedAt: stamp(-85000000), canPay: false, canCancel: false, delivery: { note: '已核对区服与角色名称，道具已交付。祝冒险愉快！', deliveredAt: stamp(-85000000) }, payment: { paymentNo: 'MP202610222001000003', channel: 'MOCK', amount: '99.80', paidAt: stamp(-86000000) } })
Object.assign(completed.items[0], { orderItemId: '50031', canReview: true })
completed.logs = [{ fromStatus: null, toStatus: '1', reason: '创建订单', createdAt: completed.createdAt }, { fromStatus: '1', toStatus: '2', reason: '模拟支付成功', createdAt: completed.paidAt }, { fromStatus: '2', toStatus: '4', reason: '管理员登记交付', createdAt: completed.completedAt }]
orders.set('2001', [initial, completed]); reviews.set('2001', [])
async function hash(value) { return Array.from(new Uint8Array(await crypto.subtle.digest('SHA-256', new TextEncoder().encode(value)))).map(b => b.toString(16).padStart(2, '0')).join('') }
const ready = hash('Example123!').then(value => { members[0].passwordHash = value })
function fail(status, errorCode, msg, data = null) { throw { mockError: true, status, data: { code: status, errorCode, msg, data } } }
const requireThat = (condition, message, code = 'MALL_VALIDATION_FAILED', status = 400) => { if (!condition) fail(status, code, message) }
const publicMember = m => { const { passwordHash, ...rest } = m; return rest }
const page = (rows, params) => { const size = Math.min(50, Math.max(1, Number(params.pageSize) || 10)), n = Math.max(1, Number(params.pageNum) || 1); return { code: 200, msg: '查询成功', rows: rows.slice((n - 1) * size, n * size), total: rows.length } }
function captcha(body) {
  const entry = captchas.get(body.uuid); captchas.delete(body.uuid)
  requireThat(entry && entry > Date.now() && body.code === '7', '图形验证码错误或已过期，请重新输入。', 'MALL_CAPTCHA_INVALID')
}
function emailCode(body, scene) {
  const key = `${scene}:${body.email}`, entry = emailCodes.get(key)
  requireThat(entry && entry.expires > Date.now() && body.emailCode === '123456', '邮箱验证码错误或已过期。', 'MALL_EMAIL_CODE_INVALID')
  emailCodes.delete(key)
}
function invalidate(memberId) { for (const [key, value] of sessions) if (value.memberId === memberId) sessions.delete(key) }
function findProp(id) { const p = items.find(p => p.propId === id); if (!p || scenario === 'off-shelf') fail(404, 'MALL_PROP_NOT_FOUND', '商品已下架或不存在。'); return presentProp(p) }
function cart(memberId) {
  const rows = (baskets.get(memberId) || []).map((row, i) => {
    const p = presentProp(items.find(p => p.propId === row.propId))
    const availability = scenario === 'invalid-cart' && i === 0 ? 'OFF_SHELF' : p.stock < row.quantity ? 'OUT_OF_STOCK' : 'AVAILABLE'
    return { ...row, propName: p.name, categoryName: p.categoryName, coverUrl: p.coverUrl, unitPrice: p.price, stock: p.stock, availability, canCheckout: availability === 'AVAILABLE', subtotal: fromCents(cents(p.price) * BigInt(row.quantity)), updatedAt: stamp() }
  })
  const selected = rows.filter(i => i.checked && i.canCheckout)
  return { items: rows, summary: { totalItemCount: rows.length, totalQuantity: rows.reduce((s, i) => s + i.quantity, 0), selectedItemCount: selected.length, selectedQuantity: selected.reduce((s, i) => s + i.quantity, 0), selectedAmount: fromCents(selected.reduce((s, i) => s + cents(i.subtotal), 0n)), invalidItemCount: rows.filter(i => !i.canCheckout).length } }
}
function presentOrder(order) {
  const copy = clone(order)
  if (scenario === 'order-expired' && copy.status === '1') copy.expiresAt = stamp(-1000)
  copy.serverTime = stamp(); copy.canPay = copy.status === '1' && Date.parse(copy.expiresAt) > Date.now(); copy.canCancel = copy.status === '1'
  return copy
}
function getOrder(memberId, orderNo) { const order = (orders.get(memberId) || []).find(o => o.orderNo === orderNo); if (!order) fail(404, 'MALL_ORDER_NOT_FOUND', '订单不存在。'); return order }
function changeOrder(order, status, reason) { order.logs.push({ fromStatus: order.status, toStatus: status, reason, createdAt: stamp() }); order.status = status }
function cancelOrder(order, reason) {
  if (order.status === '3') return
  requireThat(order.status === '1', '订单状态已变化，请查看最新订单。', 'MALL_ORDER_STATUS_CONFLICT', 409)
  changeOrder(order, '3', reason); order.cancelReason = reason; order.cancelledAt = stamp()
  for (const row of order.items) items.find(p => p.propId === row.propId).stock += row.quantity
}
async function dispatch(config) {
  await ready
  if (scenario === 'network') throw new Error('Mock network unavailable')
  const method = config.method.toUpperCase(), path = config.url, query = config.params || {}
  const body = typeof config.data === 'string' ? JSON.parse(config.data) : config.data || {}
  let member = null, memberId = null
  if (config.memberAuth) {
    const token = config.headers.get?.('Authorization') || config.headers.Authorization
    const auth = sessions.get(String(token).replace('Bearer ', ''))
    requireThat(auth && auth.expires > Date.now() && scenario !== 'session-expired', '登录已过期，请重新登录。', 'MALL_UNAUTHORIZED', 401)
    member = members.find(m => m.memberId === auth.memberId); memberId = member.memberId
  }
  let data = null, status = 200
  if (path === '/captchaImage') {
    const uuid = uid(); captchas.set(uuid, Date.now() + 120000)
    return { status: 200, reply: { code: 200, captchaEnabled: true, uuid, img: fixtures.memberGetCaptcha.data.imageBase64 } }
  } else if (path === '/register') {
    captcha(body)
    requireThat(body.username?.length >= 2 && body.username.length <= 20 && validPassword(body.password) && validEmail(body.email), '请检查用户名、邮箱和密码格式。')
    requireThat(!members.some(m => m.username === body.username), '该用户名暂不可用。', 'MALL_MEMBER_EXISTS', 409)
    members.push({ memberId: String(++serial), username: body.username, nickname: body.nickname || body.username, avatarUrl: null, email: body.email, emailVerified: false, phoneNumber: null, createdAt: stamp(), passwordHash: await hash(body.password) })
  } else if (path === '/login') {
    captcha(body)
    const candidate = members.find(m => m.username === body.username)
    requireThat(candidate && candidate.passwordHash === await hash(body.password), '用户名或密码不正确。', 'MALL_LOGIN_FAILED', 401)
    const token = `mock.ruoyi.${uid()}`; sessions.set(token, { memberId: candidate.memberId, expires: Date.now() + 1800000 })
    return { status: 200, reply: { code: 200, token } }
  } else if (path === '/getInfo') {
    return { status: 200, reply: { code: 200, user: { userId: memberId, userName: member.username, nickName: member.nickname }, roles: ['common'], permissions: [] } }
  } else if (path === '/logout') {
    const token = config.headers.get?.('Authorization') || config.headers.Authorization; sessions.delete(token.replace('Bearer ', ''))
  } else if (path === '/me') {
    if (method === 'PUT') { requireThat(body.nickname?.trim().length >= 2 && body.nickname.length <= 30, '昵称需要 2–30 个字符。'); member.nickname = body.nickname; member.phoneNumber = body.phoneNumber }
    data = publicMember(member)
  } else if (path === '/me/password') {
    requireThat(member.passwordHash === await hash(body.oldPassword), '当前密码不正确。', 'MALL_PASSWORD_INVALID')
    requireThat(validPassword(body.newPassword), '新密码格式不正确。'); member.passwordHash = await hash(body.newPassword); invalidate(memberId)
  } else if (path === '/me/avatar') {
    const file = body.get('file'); requireThat(file instanceof Blob && ['image/png', 'image/jpeg', 'image/webp'].includes(file.type) && file.size <= 2097152, '请选择 2MB 以内的 PNG、JPG 或 WebP 图片。')
    if (member.avatarUrl?.startsWith('blob:')) URL.revokeObjectURL(member.avatarUrl)
    member.avatarUrl = URL.createObjectURL(file); data = publicMember(member)
  } else if (path === '/home') {
    data = { banners: [{ bannerId: '301', title: '星辉长剑', imageUrl: '/images/hero-sword.png', targetPropId: '1001', sort: 1 }], hotCategories: categories, hotProps: scenario === 'empty' ? [] : items.slice(0, 6).map(p => summary(presentProp(p))), serverTime: stamp() }
  } else if (path === '/categories') data = categories
  else if (path === '/props') {
    let rows = scenario === 'empty' ? [] : items.map(p => summary(presentProp(p)))
    if (query.keyword) rows = rows.filter(p => (p.name + p.categoryName).includes(query.keyword))
    if (query.categoryId) rows = rows.filter(p => p.categoryId === query.categoryId)
    if (query.minPrice) rows = rows.filter(p => cents(p.price) >= cents(query.minPrice))
    if (query.maxPrice) rows = rows.filter(p => cents(p.price) <= cents(query.maxPrice))
    if (query.sort === 'sales_desc') rows.sort((a, b) => b.sales - a.sales)
    else if (query.sort === 'price_asc') rows.sort((a, b) => Number(cents(a.price) - cents(b.price)))
    else if (query.sort === 'price_desc') rows.sort((a, b) => Number(cents(b.price) - cents(a.price)))
    else if (query.sort === 'on_sale_desc') rows.sort((a, b) => Date.parse(b.onSaleAt) - Date.parse(a.onSaleAt))
    return { status, reply: page(rows, query) }
  } else if (/^\/props\/[^/]+\/reviews$/.test(path)) {
    const propId = path.split('/')[2]; findProp(propId)
    return { status, reply: page(scenario === 'review-hidden' ? [] : publicReviews.filter(r => r.propId === propId).map(({ propId, ...review }) => review), query) }
  } else if (/^\/props\/[^/]+$/.test(path)) {
    data = findProp(path.split('/')[2]); const rows = scenario === 'review-hidden' ? [] : publicReviews.filter(r => r.propId === data.propId)
    data.reviewCount = rows.length; data.averageScore = rows.length ? rows.reduce((sum, r) => sum + r.score, 0) / rows.length : 0
  }
  else if (path.startsWith('/cart/')) {
    const basket = baskets.get(memberId) || []; baskets.set(memberId, basket)
    if (path === '/cart/items' && method === 'POST') {
      const p = findProp(body.propId), row = basket.find(i => i.propId === body.propId), quantity = (row?.quantity || 0) + body.quantity
      requireThat(Number.isInteger(quantity) && quantity > 0 && quantity <= Math.min(p.stock, 99), '库存不足，请调整数量。', 'MALL_STOCK_INSUFFICIENT', 409)
      if (row) { row.quantity = quantity; row.checked = true } else basket.unshift({ cartItemId: String(++serial), propId: body.propId, quantity, checked: true })
    } else if (path === '/cart/selection') {
      requireThat(body.cartItemIds.every(id => basket.some(i => i.cartItemId === id)), '购物车已变化，请刷新。', 'MALL_CART_CHANGED', 409)
      basket.forEach(i => { if (body.cartItemIds.includes(i.cartItemId)) i.checked = body.checked })
    } else if (method === 'DELETE') baskets.set(memberId, basket.filter(i => i.cartItemId !== path.split('/')[3]))
    else if (method === 'PUT') {
      const row = basket.find(i => i.cartItemId === path.split('/')[3]); requireThat(row, '购物车条目不存在。', 'MALL_CART_CHANGED', 409)
      requireThat(Number.isInteger(body.quantity) && body.quantity >= 1 && body.quantity <= 99, '数量需要为 1–99 的整数。')
      if (body.quantity > row.quantity) requireThat(body.quantity <= findProp(row.propId).stock, '库存不足，请调整数量。', 'MALL_STOCK_INSUFFICIENT', 409)
      row.quantity = body.quantity; row.checked = body.checked
    }
    data = cart(memberId)
  } else if (path === '/order-quotes') {
    const basket = cart(memberId)
    let rows
    if (body.source === 'CART') {
      requireThat(body.cartItemIds?.length > 0 && body.cartItemIds.length <= 50, '请选择 1–50 件道具。')
      rows = body.cartItemIds.map(id => { const row = basket.items.find(i => i.cartItemId === id); requireThat(row?.canCheckout, '购物车存在不可结算的道具。', 'MALL_CART_CHANGED', 409); return row })
    } else rows = body.items.map(i => ({ ...i, cartItemId: null }))
    rows = rows.map(row => { const p = findProp(row.propId); requireThat(Number.isInteger(row.quantity) && row.quantity >= 1 && row.quantity <= Math.min(p.stock, 99), '道具库存不足，请调整购买数量。', 'MALL_STOCK_INSUFFICIENT', 409); return { propId: p.propId, cartItemId: row.cartItemId, propName: p.name, coverUrl: p.coverUrl, specs: p.specs, unitPrice: p.price, quantity: row.quantity, subtotal: fromCents(cents(p.price) * BigInt(row.quantity)), stock: p.stock } })
    data = { quoteToken: uid(), quoteExpiresAt: stamp(300000), source: body.source, items: rows, totalAmount: fromCents(rows.reduce((s, i) => s + cents(i.subtotal), 0n)), totalQuantity: rows.reduce((s, i) => s + i.quantity, 0), currency: 'CNY', deliveryFields: ['gameAccount', 'serverName', 'roleName'], serverTime: stamp(), serverGroups: [...new Set(rows.map(row => findProp(row.propId).categoryId))].map(categoryId => ({categoryId, categoryName: categories.find(category => category.categoryId === categoryId).name, servers: ['一区','二区','三区'].map((name,index) => ({serverId: String(Number(categoryId)*100+index+1),name}))})) }
    quotes.set(data.quoteToken, { memberId, data: clone(data) })
  } else if (path === '/orders' && method === 'POST') {
    const key = `${memberId}:${body.requestKey}`, previous = requests.get(key)
    if (previous) { requireThat(previous.body === JSON.stringify(body), '同一请求不能修改订单内容。', 'MALL_IDEMPOTENCY_CONFLICT', 409); return { status: 200, reply: { code: 200, msg: '操作成功', data: { order: presentOrder(previous.order), replayed: true } } } }
    const quote = quotes.get(body.quoteToken)
    requireThat(quote?.memberId === memberId && Date.parse(quote.data.quoteExpiresAt) > Date.now() && scenario !== 'quote-expired', '报价已到期，请重新获取并确认。', 'MALL_QUOTE_EXPIRED', 409)
    requireThat(scenario !== 'quote-changed', '商品价格发生变化，请重新确认报价。', 'MALL_QUOTE_CHANGED', 409)
    const preview = quote.data
    preview.deliveryFields.filter(f => f !== 'serverName').forEach(f => requireThat(body.deliveryInfo?.[f]?.trim().length >= 1 && body.deliveryInfo[f].length <= 100, '请完整填写交付信息。'))
    const serverIds = body.deliveryInfo?.serverIds
    const selectedServers = preview.serverGroups.map(group => {
      const matched = group.servers.filter(server => serverIds ? serverIds.includes(server.serverId) : server.name === body.deliveryInfo?.serverName)
      requireThat(matched.length === 1, '请选择游戏对应的有效区服。', 'MALL_SERVER_UNAVAILABLE', 409)
      return {serverId: matched[0].serverId,categoryId: group.categoryId,categoryName: group.categoryName,serverName: matched[0].name}
    })
    if (serverIds) requireThat(serverIds.length === selectedServers.length && new Set(serverIds).size === serverIds.length, '每个游戏只能选择一个区服。')
    const deliveryInfo = {gameAccount: body.deliveryInfo.gameAccount,roleName: body.deliveryInfo.roleName,serverName: selectedServers.map(server => `${server.categoryName}：${server.serverName}`).join('；').slice(0,100),servers:selectedServers}
    for (const row of preview.items) {
      const p = findProp(row.propId)
      requireThat(p.stock >= row.quantity, '库存不足，请重新确认。', 'MALL_STOCK_INSUFFICIENT', 409)
      requireThat(p.price === row.unitPrice, '价格已变化，请重新确认。', 'MALL_QUOTE_CHANGED', 409)
      if (preview.source === 'CART') requireThat((baskets.get(memberId) || []).some(i => i.cartItemId === row.cartItemId && i.quantity === row.quantity), '购物车已变化，请重新确认。', 'MALL_CART_CHANGED', 409)
    }
    const orderId = String(++serial)
    const order = { orderId, orderNo: `GC${Date.now()}${orderId}`, status: '1', totalAmount: preview.totalAmount, totalQuantity: preview.totalQuantity, itemCount: preview.items.length, currency: 'CNY', createdAt: stamp(), expiresAt: stamp(1800000), paidAt: null, cancelledAt: null, completedAt: null, serverTime: stamp(), canPay: true, canCancel: true, items: preview.items.map(({ stock, cartItemId, ...row }, i) => ({ ...row, orderItemId: `${orderId}${i + 1}`, canReview: false, reviewId: null })), deliveryInfo: clone(deliveryInfo), remark: body.remark, cancelReason: null, payment: null, delivery: null, logs: [{ fromStatus: null, toStatus: '1', reason: '创建订单', createdAt: stamp() }] }
    preview.items.forEach(row => { items.find(p => p.propId === row.propId).stock -= row.quantity })
    const list = orders.get(memberId) || []; list.unshift(order); orders.set(memberId, list)
    if (preview.source === 'CART') baskets.set(memberId, (baskets.get(memberId) || []).filter(i => !preview.items.some(row => row.cartItemId === i.cartItemId)))
    requests.set(key, { body: JSON.stringify(body), order }); data = { order: presentOrder(order), replayed: false }; status = 201
    if (scenario === 'create-timeout') throw new Error('Simulated lost response after commit')
  } else if (path === '/orders') return { status, reply: page((orders.get(memberId) || []).filter(o => !query.status || o.status === query.status).map(presentOrder), query) }
  else if (path.startsWith('/orders/')) {
    const [, , orderNo, action] = path.split('/'), order = getOrder(memberId, orderNo)
    if (action === 'cancellation') cancelOrder(order, body.reason || '会员取消订单')
    else if (action === 'payments') {
      if (scenario === 'pay-conflict' && order.status === '1') cancelOrder(order, '演示：取消操作先完成')
      if (body.result === 'SUCCESS' && ['2', '4'].includes(order.status)) data = { outcome: 'SUCCESS', order: presentOrder(order) }
      else {
        requireThat(order.status === '1', '订单状态已变化，请查看最新状态。', 'MALL_ORDER_STATUS_CONFLICT', 409)
        requireThat(presentOrder(order).canPay, '订单已过期，无法继续支付。', 'MALL_ORDER_EXPIRED', 409)
        if (body.result === 'SUCCESS') {
          changeOrder(order, '2', '模拟支付成功'); order.paidAt = stamp(); order.payment = { paymentNo: `MP${Date.now()}${++serial}`, channel: 'MOCK', amount: order.totalAmount, paidAt: order.paidAt }
          order.items.forEach(row => { items.find(p => p.propId === row.propId).sales += row.quantity })
        }
        data = { outcome: body.result === 'SUCCESS' ? 'SUCCESS' : 'FAILED', order: presentOrder(order) }
      }
    }
    if (!data) data = presentOrder(order)
  } else if (path === '/me/reviews') {
    const rows = clone(reviews.get(memberId) || [])
    if (scenario === 'review-hidden') rows.forEach(row => { row.status = 'HIDDEN'; row.hideReason = '演示：评价包含不适宜内容。' })
    return { status, reply: page(rows, query) }
  } else if (path === '/reviews') {
    const order = (orders.get(memberId) || []).find(o => o.items.some(i => i.orderItemId === body.orderItemId)), row = order?.items.find(i => i.orderItemId === body.orderItemId)
    requireThat(order?.status === '4' && row.canReview, '该订单明细无法评价或已评价。', 'MALL_REVIEW_EXISTS', 409)
    requireThat(Number.isInteger(body.score) && body.score >= 1 && body.score <= 5 && body.content.trim().length >= 5 && body.content.length <= 1000, '评价至少 5 个字符，并选择评分。')
    data = { reviewId: String(++serial), propId: row.propId, propName: row.propName, coverUrl: row.coverUrl, orderNo: order.orderNo, orderItemId: row.orderItemId, score: body.score, content: body.content, status: 'VISIBLE', hideReason: null, createdAt: stamp() }
    row.canReview = false; row.reviewId = data.reviewId; const list = reviews.get(memberId) || []; list.unshift(data); reviews.set(memberId, list)
    publicReviews.unshift({ propId: data.propId, reviewId: data.reviewId, reviewer: { displayName: member.nickname, avatarUrl: member.avatarUrl }, score: data.score, content: data.content, createdAt: data.createdAt }); status = 201
  } else if (path.startsWith('/media/')) return { status: 200, reply: await (await fetch('/images/hero-sword.png')).blob() }
  else fail(404, 'MOCK_ROUTE_NOT_FOUND', '演示接口不存在。')
  return { status, reply: { code: 200, msg: path === '/email-codes' ? '如符合条件，验证码将发送至邮箱。' : '操作成功', data: clone(data) } }
}
export async function mockAdapter(config) {
  await new Promise(resolve => setTimeout(resolve, 180))
  try {
    const { status, reply } = await dispatch(config)
    return { data: reply, status, statusText: 'OK', headers: {}, config }
  } catch (error) {
    if (error.mockError) throw { config, response: { status: error.status, data: error.data, headers: { 'retry-after': String(error.data.data?.retryAfterSeconds || 0) }, config } }
    throw Object.assign(new Error('网络未完成'), { config, code: 'ERR_NETWORK' })
  }
}
