import { test, expect } from '@playwright/test'
import { readFileSync } from 'node:fs'

const contractText = readFileSync(new URL('../../../docs/api/openapi.yaml', import.meta.url), 'utf8')
// Read the endpoint index only; the shared OpenAPI remains authoritative.
const operations = []
let path, method
for (const line of contractText.split(/\r?\n/)) {
  const p = /^  (\/[^:]+):$/.exec(line), m = /^    (get|post|put|delete):$/.exec(line), op = /^      operationId: (.+)$/.exec(line)
  if (p) path = p[1]
  if (m) method = m[1].toUpperCase()
  if (op && path?.startsWith('/api/mall/')) operations.push({ path, method, id: op[1] })
}
function lookup(request) {
  const pathname = new URL(request.url()).pathname
  return operations.find(op => op.method === request.method() && new RegExp(`^${op.path.replace(/\{[^}]+\}/g, '[^/]+')}$`).test(pathname))
}
const publicOps = new Set(['memberGetCaptcha', 'memberSendEmailCode', 'memberRegister', 'memberLogin', 'memberResetPassword', 'mallGetHome', 'mallListCategories', 'mallListProps', 'mallGetProp', 'mallListPropReviews', 'mallGetPublicImage'])
test.use({ baseURL: 'http://127.0.0.1:5175' })

test('all 23 storefront business operations follow current OpenAPI paths/methods and auth boundaries', async ({ page }) => {
  const seen = []
  await page.route('**/api/mall/**', async route => {
    const req = route.request(), op = lookup(req)
    seen.push({ id: op?.id, path: new URL(req.url()).pathname, method: req.method(), headers: req.headers(), body: req.postData() })
    if (op?.id === 'mallGetPublicImage') await route.fulfill({ contentType: 'image/png', body: Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/nJ0AAAAASUVORK5CYII=', 'base64') })
    else await route.fulfill({ status: op?.id === 'memberRegister' || op?.id === 'memberCreateOrder' ? 201 : op?.id === 'memberSendEmailCode' ? 202 : 200, json: { code: 200, msg: '操作成功', data: null } })
  })
  await page.goto('/transport-check')
  await expect(page.getByRole('button', { name: '演示模式' })).toHaveCount(0)
  const results = await page.evaluate(async () => {
    const { configureHttp } = await import('/src/api/http.js')
    configureHttp({ getToken: () => 'test-memory-member', onUnauthorized: () => {} })
    const { authApi: a, catalogApi: p, memberApi: m, cartApi: c, orderApi: o } = await import('/src/api/mall.js')
    const orderNo = 'GC202610222000000001'
    const calls = [
      () => m.profile(), () => m.update({ nickname: '玩家', phoneNumber: null }), () => m.password({ oldPassword: 'TestPassword1!', newPassword: 'NewPassword1!' }),
      () => m.avatar(new File([new Uint8Array([1, 2, 3])], 'avatar.png', { type: 'image/png' })),
      () => p.home(), () => p.categories(), () => p.props({ pageNum: 1, pageSize: 12, sort: 'price_asc' }),
      () => p.prop('9223372036854775807'), () => p.reviews('1001', { pageNum: 1, pageSize: 10 }), () => p.media('0123456789abcdef0123456789abcdef.png'),
      () => c.get(), () => c.add({ propId: '1001', quantity: 1 }), () => c.update('4001', { quantity: 2, checked: true }), () => c.remove('4001'), () => c.select({ cartItemIds: ['4001'], checked: true }),
      () => o.preview({ source: 'DIRECT', items: [{ propId: '1001', quantity: 1 }] }), () => o.create({ requestKey: crypto.randomUUID(), quoteToken: 'test-quote-token-0001', deliveryInfo: { gameAccount: 'demo', serverName: '一区', roleName: '玩家' }, remark: null }),
      () => o.list({ pageNum: 1, pageSize: 10 }), () => o.detail(orderNo), () => o.cancel(orderNo, { reason: '取消' }), () => o.pay(orderNo, 'FAIL'),
      () => m.reviews({ pageNum: 1, pageSize: 10 }), () => m.review({ orderItemId: '50031', score: 5, content: '道具符合预期。' }),
    ]
    let passed = 0
    for (const call of calls) { const result = await call(); if (result?.code === 200 || result instanceof Blob) passed++ }
    return passed
  })
  expect(results).toBe(23)
  expect(seen.map(r => r.id).sort()).toEqual(operations.map(op => op.id).sort())
  for (const req of seen) expect(req.headers.authorization, req.id).toBe(publicOps.has(req.id) ? undefined : 'Bearer test-memory-member')
  expect(seen.find(r => r.id === 'memberUploadAvatar').headers['content-type']).toMatch(/^multipart\/form-data; boundary=/)
  expect(seen.find(r => r.id === 'memberUploadAvatar').body).toContain('name="file"; filename="avatar.png"')
  expect(seen.find(r => r.id === 'mallGetProp').path).toContain('9223372036854775807')
})

test('real HTTP errors, pagination and Retry-After retain their semantics without mock fallback', async ({ page }) => {
  await page.route('**/api/mall/home', route => route.abort())
  await page.route('**/api/mall/categories', route => route.fulfill({ json: { code: 200, msg: 'ok', data: [] } }))
  await page.goto('/')
  await expect(page.getByRole('heading', { name: '暂时无法加载' })).toBeVisible()
  await expect(page.locator('.product-card')).toHaveCount(0)
  await expect(page.getByRole('button', { name: '演示模式' })).toHaveCount(0)
  let hits = 0
  await page.route('**/api/mall/props*', route => { hits++; return route.fulfill({ status: 429, headers: { 'Retry-After': '60' }, json: { code: 429, errorCode: 'MALL_RATE_LIMITED', msg: '请求过于频繁', data: null } }) })
  const rate = await page.evaluate(async () => {
    const { catalogApi } = await import('/src/api/mall.js')
    const failures = []
    for (let i = 0; i < 2; i++) { try { await catalogApi.props({ pageNum: 1 }) } catch (e) { failures.push({ status: e.status, retry: e.retryAfter, code: e.errorCode }) } }
    return failures
  })
  expect(hits).toBe(1)
  expect(rate.every(e => e.status === 429 && e.retry > 0 && e.code === 'MALL_RATE_LIMITED')).toBeTruthy()
  await page.unroute('**/api/mall/props*')
  await page.goto('/transport-check') // Clears in-memory cooldown.
  await page.route('**/api/mall/props*', route => route.fulfill({ json: { code: 200, msg: 'ok', rows: [], total: 123 } }))
  const result = await page.evaluate(async () => (await import('/src/api/mall.js')).catalogApi.props({ pageNum: 20 }))
  expect(result).toEqual({ code: 200, msg: 'ok', rows: [], total: 123 })
})

test('sanitized product details reject executable HTML and external links', async ({ page }) => {
  const fixture = JSON.parse(readFileSync(new URL('../../src/mock/fixtures.json', import.meta.url), 'utf8')).mallGetProp
  fixture.data.detailHtml = '<h2>可安全阅读的说明</h2><p>普通文字<strong>强调内容</strong></p><script>window.xss=true</script><img src="x" onerror="window.xss=true"><svg onload="window.xss=true"></svg><a href="javascript:alert(1)">危险链接</a><a href="https://evil.test">外部链接</a><a href="/props/1001">内部链接</a>'
  await page.route('**/api/mall/media/**', route => route.fulfill({ status: 404, body: '' }))
  await page.route('**/api/mall/props/1001', route => route.fulfill({ json: fixture }))
  await page.route('**/api/mall/props/1001/reviews*', route => route.fulfill({ json: { code: 200, msg: 'ok', rows: [], total: 0 } }))
  await page.goto('/props/1001')
  await expect(page.getByRole('heading', { name: '可安全阅读的说明' })).toBeVisible()
  await expect(page.locator('.rich-text script, .rich-text svg, .rich-text img, .rich-text [onerror]')).toHaveCount(0)
  await expect(page.locator('.rich-text a')).toHaveCount(1)
  expect(await page.evaluate(() => window.xss)).toBeUndefined()
})
