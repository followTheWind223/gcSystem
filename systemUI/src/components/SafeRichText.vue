<script>
import { h } from 'vue'
const allowed = new Set(['P', 'BR', 'STRONG', 'EM', 'UL', 'OL', 'LI', 'H2', 'H3', 'BLOCKQUOTE', 'IMG', 'A'])
const drop = new Set(['SCRIPT', 'STYLE', 'IFRAME', 'SVG', 'OBJECT', 'TEMPLATE'])
function render(node, key) {
  if (node.nodeType === 3) return node.textContent
  if (node.nodeType !== 1 || drop.has(node.tagName)) return null
  const children = [...node.childNodes].map((child, i) => render(child, i))
  if (!allowed.has(node.tagName)) return children
  const attrs = { key }
  if (node.tagName === 'IMG') {
    const src = node.getAttribute('src') || ''
    if (!/^\/api\/mall\/media\/[a-f0-9]{32}\.(png|jpg|webp)$/.test(src)) return null
    attrs.src = src; attrs.alt = node.getAttribute('alt') || '商品详情图片'; attrs.loading = 'lazy'
  }
  if (node.tagName === 'A') {
    const href = node.getAttribute('href') || ''
    if (!/^\/(props(?:\/[1-9]\d{0,18})?)?(?:\?[^\\\s]*)?$/.test(href)) return children
    attrs.href = href
  }
  return h(node.tagName.toLowerCase(), attrs, ['IMG', 'BR'].includes(node.tagName) ? undefined : children)
}
export default { props: { html: String }, setup(props) { return () => h('div', { class: 'rich-text' }, [...new DOMParser().parseFromString(props.html || '', 'text/html').body.childNodes].map(render)) } }
</script>
