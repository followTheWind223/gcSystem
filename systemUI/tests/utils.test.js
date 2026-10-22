import { test } from 'node:test'
import assert from 'node:assert/strict'
import { cents, fromCents, money, safeRedirect, validUsername, validPassword, mediaUrl } from '../src/utils/format.js'
test('decimal amounts retain exact cents including maximum database amount', () => {
  assert.equal(fromCents(cents('49.90') * 3n + cents('0.10')), '149.80')
  assert.equal(fromCents(cents('9999999999.99')), '9999999999.99')
  assert.equal(money('9999999999.99'), '9,999,999,999.99')
  assert.throws(() => cents(49.9))
  assert.throws(() => cents('NaN'))
})
test('redirect accepts internal routes and rejects protocol, slash and encoded escape tricks', () => {
  assert.equal(safeRedirect('/orders/GC202610222000000001?from=cart'), '/orders/GC202610222000000001?from=cart')
  for (const value of ['https://evil.test', '//evil.test', '/\\evil.test', '/%2fevil.test', '/%5cevil.test', 'javascript:alert(1)', '/login', '/register?x=1', '/\n/evil', '/%00evil', '%', null, ['/props']]) assert.equal(safeRedirect(value), '/', String(value))
})
test('contract validation preserves password case, whitespace and length rules', () => {
  assert.equal(validUsername('demo_member'), true)
  assert.equal(validUsername('1demo'), false)
  assert.equal(validUsername('ab'), false)
  assert.equal(validPassword('Example123!'), true)
  for (const value of ['abcdefgh', '12345678', 'Abc 1234', '中文abc1234', 'A1' + 'x'.repeat(63)]) assert.equal(validPassword(value), false)
})
test('media accepts only same-origin contract paths in real mode', () => {
  assert.equal(mediaUrl('/api/mall/media/0123456789abcdef0123456789abcdef.png'), '/api/mall/media/0123456789abcdef0123456789abcdef.png')
  for (const value of ['https://evil.test/x.png', 'javascript:alert(1)', '//evil.test/x.png', '/api/mall/media/../x.png', 'data:image/svg+xml,hi']) assert.equal(mediaUrl(value), '')
})
