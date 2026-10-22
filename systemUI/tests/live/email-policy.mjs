import { chromium, expect } from '@playwright/test'
import { execFileSync } from 'node:child_process'
import { writeFile } from 'node:fs/promises'
import path from 'node:path'

if (!process.env.MALL_TEST_OWNER) throw new Error('Use the isolated tests/live/run.py harness')
const enabled = process.env.MALL_TEST_EMAIL_POLICY === 'on'
const browser = await chromium.launch({ channel: 'chrome', headless: true })
const context = await browser.newContext({ baseURL: 'http://127.0.0.1:15173', viewport: { width: 1440, height: 1000 } })
const page = await context.newPage()
page.setDefaultTimeout(12000)
const results = [], errors = []
page.on('pageerror', error => errors.push(error.message))
const helper = (...args) => execFileSync(process.env.MALL_TEST_PYTHON, ['tests/live/run.py', ...args], { encoding: 'utf8' }).trim()
const pass = name => { results.push(name); console.log(`PASS: ${name}`) }
const member = { username: 'email_policy_user', email: 'email_policy_user@example.com', password: 'Policy123!' }

async function call(method, endpoint, data, status, errorCode, token) {
  const response = await context.request.fetch(`/api/mall${endpoint}`, {
    method, data, ...(token ? { headers: { Authorization: `Bearer ${token}` } } : {}),
  })
  expect(response.status(), `${method} ${endpoint}`).toBe(status)
  const body = await response.json()
  if (errorCode) expect(body.errorCode).toBe(errorCode)
  return body.data
}
async function captcha() {
  const data = await call('GET', '/captcha', undefined, 200)
  expect(data.emailVerificationEnabled).toBe(enabled)
  expect(data.captchaEnabled).toBe(true)
  return { captchaId: data.captchaId, captchaCode: helper('captcha', data.captchaId) }
}
async function fillCaptcha() {
  const pending = page.waitForResponse(r => r.url().endsWith('/api/mall/captcha'))
  await page.getByRole('button', { name: '刷新图形验证码' }).click()
  const data = (await (await pending).json()).data
  await page.getByLabel('图形验证码', { exact: true }).fill(helper('captcha', data.captchaId))
}
async function submitPage(endpoint, status, button) {
  const pending = page.waitForResponse(r => new URL(r.url()).pathname === `/api/mall${endpoint}` && r.request().method() === 'POST')
  await page.getByRole('button', { name: button, exact: true }).click()
  const response = await pending
  expect(response.status()).toBe(status)
  return (await response.json()).data
}
try {
  await captcha()
  pass(`public authentication policy: email verification ${enabled ? 'on' : 'off'}`)
  if (!enabled) {
    await call('POST', '/members', member, 400, 'MALL_CAPTCHA_INVALID')
    const wrong = await captcha()
    await call('POST', '/members', { ...member, ...wrong, captchaCode: '999' }, 400, 'MALL_CAPTCHA_INVALID')
    await call('POST', '/members', { ...member, ...await captcha(), emailVerified: true }, 400, 'MALL_VALIDATION_FAILED')
    const proof = await captcha()
    await call('POST', '/sessions', { username: 'absent_member', password: member.password, ...proof }, 401, 'MALL_INVALID_CREDENTIALS')
    await call('POST', '/members', { ...member, ...proof }, 400, 'MALL_CAPTCHA_INVALID')
    await call('POST', '/email-codes', { email: member.email, scene: 'REGISTER', ...await captcha() }, 503, 'MALL_EMAIL_VERIFICATION_DISABLED')
    await call('POST', '/password-resets', { email: member.email, emailCode: '123456', newPassword: 'Changed123!' }, 503, 'MALL_EMAIL_VERIFICATION_DISABLED')
    pass('registration rejects missing/wrong/reused captcha and forged verification status; email endpoints disabled')
  } else {
    await call('POST', '/members', { ...member, ...await captcha() }, 400, 'MALL_EMAIL_CODE_INVALID')
    await call('POST', '/members', { ...member, emailCode: '000000' }, 400, 'MALL_EMAIL_CODE_INVALID')
    pass('enabled policy rejects absent or invalid email codes even with a valid image captcha')
  }

  await page.goto('/register')
  await expect(page.getByLabel('图形验证码', { exact: true })).toBeVisible()
  await expect(page.getByLabel('邮箱验证码', { exact: true })).toHaveCount(enabled ? 1 : 0)
  await expect(page.getByRole('button', { name: '获取验证码', exact: true })).toHaveCount(enabled ? 1 : 0)
  await page.getByLabel('用户名', { exact: true }).fill(member.username)
  await page.getByLabel('邮箱地址', { exact: true }).fill(member.email)
  await page.getByLabel('密码', { exact: true }).fill(member.password)
  await page.getByLabel('确认密码', { exact: true }).fill(member.password)
  await fillCaptcha()
  if (enabled) {
    await submitPage('/email-codes', 202, '获取验证码')
    await page.getByLabel('邮箱验证码', { exact: true }).fill(helper('mail', 'REGISTER', member.email))
  }
  await page.screenshot({ path: path.join(process.env.MALL_TEST_ARTIFACTS, 'register.png'), fullPage: true })
  const profile = await submitPage('/members', 201, '创建账号')
  expect(profile.emailVerified).toBe(enabled)
  await expect(page).toHaveURL('/login')
  await expect(page.getByLabel('图形验证码', { exact: true })).toBeVisible()
  await expect(page.getByRole('link', { name: '忘记密码？' })).toHaveCount(enabled ? 1 : 0)
  await page.getByLabel('用户名', { exact: true }).fill(member.username)
  await page.getByLabel('密码', { exact: true }).fill(member.password)
  await fillCaptcha()
  const session = await submitPage('/sessions', 200, '登 录')
  await expect(page).toHaveURL('/')
  pass('browser registration and login follow server policy; profile verification flag is truthful')

  if (!enabled) {
    await call('PUT', '/me/password', { oldPassword: member.password, newPassword: 'Changed123!' }, 200, undefined, session.token)
    await call('GET', '/me', undefined, 401, 'MALL_UNAUTHENTICATED', session.token)
    await call('POST', '/sessions', { username: member.username, password: 'Changed123!', ...await captcha() }, 200)
    await page.goto('/forgot-password')
    await expect(page.getByRole('status')).toHaveText('暂不支持邮箱找回密码。')
    await expect(page.locator('form')).toHaveCount(0)
    pass('original-password change still works and revokes old sessions; direct recovery page blocks reset')
  } else {
    await page.goto('/forgot-password')
    await page.getByLabel('邮箱地址').fill(member.email)
    await page.getByLabel('新密码', { exact: true }).fill('Changed123!')
    await page.getByLabel('确认密码', { exact: true }).fill('Changed123!')
    await fillCaptcha()
    await submitPage('/email-codes', 202, '获取验证码')
    await page.getByLabel('邮箱验证码', { exact: true }).fill(helper('mail', 'RESET_PASSWORD', member.email))
    await submitPage('/password-resets', 200, '重设密码')
    await expect(page).toHaveURL('/login')
    await call('GET', '/me', undefined, 401, 'MALL_UNAUTHENTICATED', session.token)
    await call('POST', '/sessions', { username: member.username, password: 'Changed123!', ...await captcha() }, 200)
    pass('enabled email recovery works and revokes old sessions')
  }
  expect(errors).toEqual([])
  await writeFile(path.join(process.env.MALL_TEST_ARTIFACTS, 'email-policy-report.json'), JSON.stringify({ enabled, results }, null, 2))
} finally {
  await context.close()
  await browser.close()
}
