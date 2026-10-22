import { chromium, expect } from '@playwright/test'
import { execFileSync } from 'node:child_process'
import { writeFileSync } from 'node:fs'
import { join } from 'node:path'

const browser = await chromium.launch({ channel: 'chrome' })
const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } })
const errors = [], paths = []
page.on('pageerror', e => errors.push(e.message))
page.on('request', r => { if (r.url().includes('/api/')) paths.push(new URL(r.url()).pathname) })
const origin = 'http://127.0.0.1:15173', out = process.env.MALL_TEST_ARTIFACTS
let challenge
page.on('response', async r => { if (r.url().endsWith('/api/auth/captchaImage')) challenge = await r.json() })
async function fillCaptcha() {
  await expect.poll(() => challenge?.uuid).toBeTruthy()
  const answer = execFileSync(process.env.MALL_TEST_PYTHON, ['tests/live/run.py', 'ruoyi-captcha', challenge.uuid], { encoding: 'utf8' }).trim()
  await page.getByLabel('图形验证码', { exact: true }).fill(answer)
}
try {
  await page.goto(origin + '/register')
  await page.getByLabel('用户名', { exact: true }).fill('ui_ruoyi_player')
  await page.getByLabel('玩家昵称').fill('商城玩家')
  await page.getByLabel('邮箱地址').fill('ui_ruoyi_player@example.com')
  await page.getByLabel('密码', { exact: true }).fill('Example123!')
  await page.getByLabel('确认密码', { exact: true }).fill('Example123!')
  await fillCaptcha()
  await expect(page.getByLabel('邮箱验证码', { exact: true })).toHaveCount(0)
  challenge = null
  await page.getByRole('button', { name: '创建账号', exact: true }).click()
  await expect(page).toHaveURL(origin + '/login')
  await page.getByLabel('用户名', { exact: true }).fill('ui_ruoyi_player')
  await page.getByLabel('密码', { exact: true }).fill('Example123!')
  await fillCaptcha()
  await page.getByRole('button', { name: '登 录', exact: true }).click()
  await expect(page).toHaveURL(origin + '/')
  await page.getByRole('link', { name: '购物车', exact: true }).click()
  await expect(page).toHaveURL(origin + '/cart')
  await expect(page.getByRole('heading', { name: '购物车还是空的' })).toBeVisible()
  await page.screenshot({ path: join(out, 'ruoyi-user-cart.png') })
  expect(await page.evaluate(() => ({ local: { ...localStorage }, session: { ...sessionStorage } }))).toEqual({ local: {}, session: {} })
  await page.reload()
  await expect(page).toHaveURL(/\/login\?redirect=/)
  challenge = null
  await page.goto(origin + '/login')
  await page.getByLabel('用户名', { exact: true }).fill('admin')
  await page.getByLabel('密码', { exact: true }).fill('admin123')
  await fillCaptcha()
  await page.getByRole('button', { name: '登 录', exact: true }).click()
  await expect(page).toHaveURL(origin + '/')
  await expect(page.locator('.user-menu-trigger')).toBeVisible().catch(async () => { await expect(page.getByRole('link', { name: '购物车', exact: true })).toBeVisible() })
  await page.screenshot({ path: join(out, 'gc-admin-storefront.png') })
  expect(paths).toContain('/api/auth/register')
  expect(paths).toContain('/api/auth/login')
  expect(paths).toContain('/api/auth/getInfo')
  expect(paths.some(p => ['/api/mall/sessions', '/api/mall/members', '/api/mall/captcha'].includes(p))).toBeFalsy()
  expect(errors).toEqual([])
  // The running admin dev server uses the isolated backend for this browser only.
  const adminPage = await browser.newPage()
  let adminChallenge
  await adminPage.route('**/admin-api/**', async route => {
    const request = route.request(), url = new URL(request.url())
    const response = await adminPage.request.fetch('http://127.0.0.1:18090' + url.pathname.replace(/^\/admin-api/, '') + url.search, {
      method: request.method(), headers: request.headers(), data: request.postDataBuffer() || undefined,
    })
    if (url.pathname.endsWith('/captchaImage')) adminChallenge = await response.json()
    await route.fulfill({ response })
  })
  await adminPage.goto('http://127.0.0.1:5174/login')
  await adminPage.getByPlaceholder('账号', { exact: true }).fill('auth_user_b')
  await adminPage.getByPlaceholder('密码', { exact: true }).fill('Example123!')
  await expect.poll(() => adminChallenge?.uuid).toBeTruthy()
  const adminCode = execFileSync(process.env.MALL_TEST_PYTHON, ['tests/live/run.py', 'ruoyi-captcha', adminChallenge.uuid], { encoding: 'utf8' }).trim()
  await adminPage.getByPlaceholder('验证码', { exact: true }).fill(adminCode)
  const rejectedChallengeId = adminChallenge.uuid
  await adminPage.getByRole('button', { name: /登.*录/ }).click()
  await expect(adminPage.getByText('此账号为普通用户，请前往商城用户端登录。', { exact: true })).toBeVisible()
  await expect(adminPage).toHaveURL(/\/login/)
  await expect(adminPage.getByRole('button', { name: /登.*录/ })).toBeEnabled()
  await adminPage.screenshot({ path: join(out, 'ordinary-admin-denied.png') })
  // Rejection must leave the form usable, with a new captcha for the next login.
  await expect.poll(() => adminChallenge?.uuid).not.toBe(rejectedChallengeId)
  await adminPage.getByPlaceholder('账号', { exact: true }).fill('admin')
  await adminPage.getByPlaceholder('密码', { exact: true }).fill('admin123')
  const retryCode = execFileSync(process.env.MALL_TEST_PYTHON, ['tests/live/run.py', 'ruoyi-captcha', adminChallenge.uuid], { encoding: 'utf8' }).trim()
  await adminPage.getByPlaceholder('验证码', { exact: true }).fill(retryCode)
  await adminPage.getByRole('button', { name: /登.*录/ }).click()
  await expect(adminPage).not.toHaveURL(/\/login/)
  await adminPage.close()
  writeFileSync(join(out, 'ruoyi-auth-browser.json'), JSON.stringify({ passed: true, paths: [...new Set(paths)], errors }, null, 2))
  console.log('PASS: native registration, customer/admin storefront login, protected page and memory-only sessions.')
} finally { await browser.close() }
