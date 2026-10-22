import { chromium, expect } from '@playwright/test'
import { execFileSync } from 'node:child_process'
import { writeFile } from 'node:fs/promises'
import path from 'node:path'

if (!process.env.MALL_TEST_OWNER) throw new Error('Run through tests/live/run.py with an isolated database')
const artifacts = process.env.MALL_TEST_ARTIFACTS
const browser = await chromium.launch({ channel: 'chrome', headless: true })
const context = await browser.newContext({ baseURL: 'http://127.0.0.1:15173', viewport: { width: 1440, height: 1000 } })
const page = await context.newPage()
page.setDefaultTimeout(12000)
const results = [], errors = []
page.on('pageerror', error => errors.push(error.message))
const helper = (...args) => execFileSync(process.env.MALL_TEST_PYTHON, ['tests/live/run.py', ...args], { encoding: 'utf8' }).trim()
const pass = name => { results.push(name); console.log(`PASS: ${name}`) }
async function action(method, endpoint, status, callback) {
  const response = page.waitForResponse(r => new URL(r.url()).pathname === `/api/mall${endpoint}` && r.request().method() === method)
  await callback()
  const actual = await response
  expect(actual.status(), `${method} ${endpoint}`).toBe(status)
  const body = await actual.json()
  expect(body.code).toBe(200)
  return body.data
}
async function fillCaptcha() {
  await expect(page.getByLabel('图形验证码', { exact: true })).toBeVisible()
  const captcha = await action('GET', '/captcha', 200, () => page.getByRole('button', { name: '刷新图形验证码' }).click())
  await page.getByLabel('图形验证码', { exact: true }).fill(helper('captcha', captcha.captchaId))
}
async function login(password, target = '/props/1001') {
  await page.goto(`/login?redirect=${encodeURIComponent(target)}`)
  await page.getByLabel('用户名', { exact: true }).fill('ui_live_player')
  await page.getByLabel('密码', { exact: true }).fill(password)
  await fillCaptcha()
  await action('POST', '/sessions', 200, () => page.getByRole('button', { name: '登 录', exact: true }).click())
  await expect(page).toHaveURL(new RegExp(`${target}$`))
}
async function account(section) {
  await page.locator('.avatar-button').click()
  await page.locator('.account-popover').getByRole('link', { name: '玩家中心' }).click()
  if (section !== '个人资料') await page.getByRole('navigation', { name: '玩家中心导航' }).getByRole('link', { name: section }).click()
}
async function checkout() {
  await page.getByLabel('游戏账号', { exact: true }).fill('live_player_account')
  for (const server of await page.getByRole('combobox', { name: /游戏区服/ }).all()) { await server.press('ArrowDown'); await page.getByRole('option', { name: '一区', exact: true }).click() }
  await page.getByLabel('角色名称', { exact: true }).fill('联调玩家')
  await page.getByRole('checkbox', { name: '我已确认当前价格、数量及交付信息' }).check()
  const data = await action('POST', '/orders', 201, () => page.getByRole('button', { name: '提交订单', exact: true }).click())
  await expect(page).toHaveURL(`/orders/${data.order.orderNo}/pay`)
  return data.order
}
try {
  await page.goto('/')
  await expect(page).toHaveTitle('探索商城 · gameshop')
  await expect(page.getByRole('link', { name: 'gameshop首页' })).toBeVisible()
  await expect(page.getByRole('button', { name: '演示模式' })).toHaveCount(0)
  await expect(page.locator('.product-card')).toHaveCount(1)
  await page.locator('.product-card').getByRole('link').first().click()
  await expect(page.getByRole('heading', { name: '星辉长剑', exact: true })).toBeVisible()
  await expect(page.locator('.detail-art img')).toBeVisible()
  expect(await page.locator('.detail-art img').evaluate(img => img.complete && img.naturalWidth > 0)).toBeTruthy()
  pass('真实首页、商品详情和图片通过 Vite 代理加载；品牌与非演示模式正确')

  await page.goto('/register')
  await page.getByLabel('用户名', { exact: true }).fill('ui_live_player')
  await page.getByLabel('玩家昵称').fill('联调玩家')
  await page.getByLabel('邮箱地址').fill('ui_live_player@example.com')
  await page.getByLabel('密码', { exact: true }).fill('Player123!')
  await page.getByLabel('确认密码', { exact: true }).fill('Player123!')
  await fillCaptcha()
  await action('POST', '/email-codes', 202, () => page.getByRole('button', { name: '获取验证码', exact: true }).click())
  await page.getByLabel('邮箱验证码', { exact: true }).fill(helper('mail', 'REGISTER', 'ui_live_player@example.com'))
  await action('POST', '/members', 201, () => page.getByRole('button', { name: '创建账号', exact: true }).click())
  await expect(page).toHaveURL('/login')
  await login('Player123!')
  pass('开启图形验证码的邮箱申请、注册、登录和受保护跳回')

  await action('POST', '/cart/items', 200, () => page.getByRole('button', { name: '加入购物车', exact: true }).click())
  await page.getByRole('link', { name: '购物车', exact: true }).click()
  await expect(page.locator('.cart-row')).toHaveCount(1)
  const quantityResponse = page.waitForResponse(r => /\/cart\/items\/\d+$/.test(r.url()) && r.request().method() === 'PUT')
  await page.getByRole('button', { name: '增加数量', exact: true }).click()
  expect((await quantityResponse).status()).toBe(200)
  await expect(page.locator('.summary-total')).toContainText('99.80')
  await page.getByRole('button', { name: '去结算', exact: true }).click()
  const order = await checkout()
  await expect(page.getByRole('heading', { name: '待支付', exact: true })).toBeVisible()
  await expect(page.getByRole('button', { name: '体验支付失败' })).toHaveCount(0)
  await expect(page.locator('.order-summary')).not.toContainText('模拟支付')
  await action('POST', `/orders/${order.orderNo}/payments`, 200, () => page.getByRole('button', { name: '去支付' }).click())
  await expect(page.getByRole('heading', { name: '待交付', exact: true })).toBeVisible()
  pass('购物车数量和报价99.80元、真实下单、去支付与支付成功')

  // Admin API is used only to supply the fulfilment event in this isolated fixture.
  const adminResponse = await context.request.post('http://127.0.0.1:18090/login', { data: { username: 'admin', password: 'admin123' } })
  const admin = (await adminResponse.json()).token
  expect(typeof admin).toBe('string')
  const delivered = await context.request.put(`http://127.0.0.1:18090/mall/orders/${order.orderId}/delivery`, {
    headers: { Authorization: `Bearer ${admin}` }, data: { deliveryNote: '真实联调：道具已交付到指定角色。' },
  })
  expect(delivered.status()).toBe(200)
  await page.getByRole('button', { name: '刷新状态', exact: true }).click()
  await expect(page.getByRole('heading', { name: '已完成', exact: true })).toBeVisible()
  await page.getByRole('button', { name: '评价道具', exact: true }).click()
  await page.getByLabel('你的评价').fill('真实接口联调，交付及时，道具符合预期。')
  await action('POST', '/reviews', 201, () => page.getByRole('button', { name: '发布评价', exact: true }).click())
  await expect(page.getByRole('button', { name: '评价道具', exact: true })).toHaveCount(0)
  await page.screenshot({ path: path.join(artifacts, 'completed-order.png'), fullPage: true })
  await account('我的评价')
  await expect(page.getByText('真实接口联调，交付及时，道具符合预期。')).toBeVisible()
  pass('后台交付后用户刷新已完成、提交一次评价、我的评价回读')

  await page.locator('.brand').first().click()
  await page.locator('.product-card').getByRole('link').first().click()
  await page.getByRole('button', { name: '立即购买', exact: true }).click()
  const cancelled = await checkout()
  await page.getByRole('button', { name: '取消订单', exact: true }).click()
  await action('PUT', `/orders/${cancelled.orderNo}/cancellation`, 200, () => page.getByRole('dialog').getByRole('button', { name: '取消订单', exact: true }).click())
  await expect(page.getByRole('heading', { name: '已取消', exact: true })).toBeVisible()
  pass('立即购买和用户取消订单')

  await account('个人资料')
  await page.getByLabel('玩家昵称').fill('真实接口玩家')
  await action('PUT', '/me', 200, () => page.getByRole('button', { name: '保存修改', exact: true }).click())
  await action('POST', '/me/avatar', 200, () => page.locator('input[type=file]').setInputFiles(path.join(artifacts, 'avatar.png')))
  await expect(page.locator('.avatar-upload img')).toBeVisible()
  await expect.poll(() => page.locator('.avatar-upload img').evaluate(img => img.complete && img.naturalWidth > 0)).toBeTruthy()
  await page.getByRole('navigation', { name: '玩家中心导航' }).getByRole('link', { name: '账号安全' }).click()
  await page.getByLabel('当前密码', { exact: true }).fill('Player123!')
  await page.getByLabel('新密码', { exact: true }).fill('Changed123!')
  await page.getByLabel('确认新密码', { exact: true }).fill('Changed123!')
  await action('PUT', '/me/password', 200, () => page.getByRole('button', { name: '更新密码', exact: true }).click())
  await expect(page).toHaveURL('/login')
  await login('Changed123!', '/me/profile')
  await expect(page.getByLabel('玩家昵称')).toHaveValue('真实接口玩家')
  await page.locator('.avatar-button').click()
  await action('DELETE', '/sessions/current', 200, () => page.getByRole('button', { name: '退出登录', exact: true }).click())
  pass('个人资料与头像持久化、修改密码后重新登录、退出会话')

  await page.goto('/forgot-password')
  await page.getByLabel('邮箱地址').fill('ui_live_player@example.com')
  await page.getByLabel('新密码', { exact: true }).fill('Recovered123!')
  await page.getByLabel('确认密码', { exact: true }).fill('Recovered123!')
  await fillCaptcha()
  await action('POST', '/email-codes', 202, () => page.getByRole('button', { name: '获取验证码', exact: true }).click())
  await page.getByLabel('邮箱验证码', { exact: true }).fill(helper('mail', 'RESET_PASSWORD', 'ui_live_player@example.com'))
  await action('POST', '/password-resets', 200, () => page.getByRole('button', { name: '重设密码', exact: true }).click())
  await expect(page).toHaveURL('/login')
  await login('Recovered123!', '/me/orders')
  await expect(page.locator('.order-card')).toHaveCount(2)
  expect(await page.evaluate(() => ({ local: { ...localStorage }, session: { ...sessionStorage } }))).toEqual({ local: {}, session: {} })
  expect((await context.cookies()).filter(c => /token|session|auth/i.test(c.name))).toEqual([])
  await page.reload()
  await expect(page).toHaveURL(/\/login\?redirect=/)
  expect(errors).toEqual([])
  pass('邮箱找回密码、新密码登录、订单持久化、无持久化令牌及刷新重新登录')
  await writeFile(path.join(artifacts, 'results.json'), JSON.stringify({ passed: results, runtimeErrors: errors }, null, 2))
} catch (error) {
  console.error(`Failed at ${new URL(page.url()).pathname}; successful stages: ${results.length}`)
  // Only write visible error messages; avoid screenshots or traces of credentials.
  console.error(await page.locator('[role=alert]').allTextContents())
  throw error
} finally {
  await browser.close()
}
