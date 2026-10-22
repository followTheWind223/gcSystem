import { test, expect } from '@playwright/test'

test.use({ baseURL: 'http://127.0.0.1:5175' })

async function openCarousel(page, count = 3) {
  const banners = Array.from({ length: count }, (_, i) => ({
    bannerId: String(i + 1), title: `推荐装备 ${i + 1}`, targetPropId: String(i + 1),
    imageUrl: `/api/mall/media/${String(i + 1).padStart(32, '0')}.png`, sort: i,
  }))
  await page.route('**/api/mall/home', route => route.fulfill({ json: { code: 200, data: { banners, hotCategories: [], hotProps: [] } } }))
  await page.route('**/api/mall/categories', route => route.fulfill({ json: { code: 200, data: [] } }))
  await page.route('**/api/mall/media/*', route => route.fulfill({ path: 'public/images/hero-sword.png', contentType: 'image/png' }))
  await page.goto('/')
  const carousel = page.getByRole('region', { name: '精选道具推荐' })
  await expect(carousel).toBeVisible()
  return carousel
}

async function selected(carousel, value, count = 3) {
  await expect(carousel.locator('.hero-counter')).toHaveText(`${String(value).padStart(2, '0')} / ${String(count).padStart(2, '0')}`)
  await expect(carousel.getByRole('button', { name: `查看推荐：推荐装备 ${value}`, exact: true })).toHaveAttribute('aria-pressed', 'true')
  await expect(carousel.getByRole('link', { name: '探索精选道具' })).toHaveAttribute('href', `/props/${value}`)
}

async function swipe(page, carousel, distance) {
  const box = await carousel.boundingBox()
  const x = box.x + box.width * .6, y = box.y + box.height * .45
  await page.mouse.move(x, y)
  await page.mouse.down()
  await page.mouse.move(x + distance, y, { steps: 10 })
  await page.mouse.up()
}

test('mouse drag follows the pointer, loops both ways, rebounds and does not activate a dragged link', async ({ page }) => {
  const carousel = await openCarousel(page)
  const box = await carousel.boundingBox()
  const startX = box.x + box.width * .65, y = box.y + 90
  const trackX = await carousel.locator('.hero-track').evaluate(el => new DOMMatrixReadOnly(getComputedStyle(el).transform).m41)
  await page.mouse.move(startX, y)
  await page.mouse.down()
  await page.mouse.move(startX - 135, y, { steps: 8 })
  await expect.poll(() => carousel.locator('.hero-track').evaluate(el => new DOMMatrixReadOnly(getComputedStyle(el).transform).m41)).toBeCloseTo(trackX - 135, 0)
  await page.mouse.up()
  await selected(carousel, 2)
  await swipe(page, carousel, -160)
  await selected(carousel, 3)
  await swipe(page, carousel, -160)
  await selected(carousel, 1)
  await swipe(page, carousel, 160)
  await selected(carousel, 3)

  await swipe(page, carousel, -16)
  await expect(carousel).not.toHaveClass(/is-animating/)
  await selected(carousel, 3)

  const cta = carousel.getByRole('link', { name: '探索精选道具' })
  const link = await cta.boundingBox()
  await page.mouse.move(link.x + link.width / 2, link.y + link.height / 2)
  await page.mouse.down()
  await page.mouse.move(link.x + link.width / 2 + 145, link.y + link.height / 2, { steps: 10 })
  await page.mouse.up()
  await selected(carousel, 2)
  await expect(page).toHaveURL('/')
  await cta.click()
  await expect(page).toHaveURL('/props/2')
})

test('buttons, nonadjacent dots, keyboard and reduced motion keep the matching destination', async ({ page }) => {
  const carousel = await openCarousel(page, 5)
  await carousel.getByRole('button', { name: '下一张推荐' }).click()
  await selected(carousel, 2, 5)
  await carousel.getByRole('button', { name: '查看推荐：推荐装备 5', exact: true }).click()
  await selected(carousel, 5, 5)
  await carousel.getByRole('button', { name: '上一张推荐' }).click()
  await selected(carousel, 4, 5)
  await carousel.focus()
  await page.keyboard.press('ArrowRight')
  await selected(carousel, 5, 5)
  await page.keyboard.press('ArrowRight')
  await selected(carousel, 1, 5)
  await page.emulateMedia({ reducedMotion: 'reduce' })
  await page.keyboard.press('ArrowLeft')
  await selected(carousel, 5, 5)
  await expect(carousel).not.toHaveClass(/is-animating/)
  expect(await carousel.locator('.hero-track').evaluate(el => parseFloat(getComputedStyle(el).transitionDuration))).toBeLessThanOrEqual(.001)
})

test('pointer cancellation and resize recover without a stuck gesture', async ({ page }) => {
  const errors = []; page.on('pageerror', error => errors.push(error.message))
  const carousel = await openCarousel(page)
  const box = await carousel.boundingBox()
  await page.mouse.move(box.x + 280, box.y + 100)
  await page.mouse.down()
  await page.mouse.move(box.x + 140, box.y + 100, { steps: 8 })
  await page.evaluate(() => window.dispatchEvent(new Event('blur')))
  await page.mouse.up()
  await expect(carousel).not.toHaveClass(/is-dragging|is-animating/)
  await selected(carousel, 1)
  await page.mouse.move(box.x + 280, box.y + 100)
  await page.mouse.down()
  await page.mouse.move(box.x + 140, box.y + 100, { steps: 8 })
  await page.setViewportSize({ width: 390, height: 844 })
  await page.mouse.up()
  await expect(carousel).not.toHaveClass(/is-dragging|is-animating/)
  await selected(carousel, 1)
  await carousel.getByRole('button', { name: '下一张推荐' }).click()
  await selected(carousel, 2)
  expect(errors).toEqual([])
})

test('touch swipe changes slides while vertical touch still scrolls the page', async ({ browser }) => {
  const context = await browser.newContext({ viewport: { width: 390, height: 844 }, isMobile: true, hasTouch: true, baseURL: 'http://127.0.0.1:5175' })
  const page = await context.newPage()
  try {
    const carousel = await openCarousel(page)
    const cdp = await context.newCDPSession(page)
    const box = await carousel.boundingBox()
    async function touch(dx, dy) {
      const x = box.x + box.width * .78, y = box.y + box.height * .5
      await cdp.send('Input.dispatchTouchEvent', { type: 'touchStart', touchPoints: [{ x, y }] })
      for (let i = 1; i <= 8; i++) {
        await cdp.send('Input.dispatchTouchEvent', { type: 'touchMove', touchPoints: [{ x: x + dx * i / 8, y: y + dy * i / 8 }] })
        await page.waitForTimeout(20)
      }
      await cdp.send('Input.dispatchTouchEvent', { type: 'touchEnd', touchPoints: [] })
    }
    await touch(-160, 4)
    await selected(carousel, 2)
    expect(await page.evaluate(() => window.scrollY)).toBe(0)
    await touch(2, -170)
    await expect.poll(() => page.evaluate(() => window.scrollY)).toBeGreaterThan(50)
    await selected(carousel, 2)
    await expect(carousel).not.toHaveClass(/is-dragging|is-animating/)
  } finally { await context.close() }
})

test('empty, single and many banners fit a narrow viewport', async ({ page }) => {
  const errors = []; page.on('pageerror', error => errors.push(error.message))
  await page.setViewportSize({ width: 320, height: 568 })
  for (const count of [0, 1, 10]) {
    const carousel = await openCarousel(page, count)
    if (count < 2) {
      await expect(carousel.getByRole('button')).toHaveCount(0)
      await swipe(page, carousel, -100)
      await expect(carousel).not.toHaveClass(/is-dragging|is-animating/)
      await expect(carousel.getByRole('link')).toHaveAttribute('href', count ? '/props/1' : '/props')
    } else {
      await carousel.getByRole('button', { name: '上一张推荐' }).click()
      await selected(carousel, 10, 10)
    }
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBeTruthy()
    for (const button of await carousel.getByRole('button').all()) {
      const box = await button.boundingBox()
      expect(box.x).toBeGreaterThanOrEqual(0)
      expect(box.x + box.width).toBeLessThanOrEqual(320)
    }
  }
  expect(errors).toEqual([])
})
