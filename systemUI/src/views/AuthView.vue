<script setup>
import { computed, reactive, ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { authApi } from '../api/mall.js'
import { useAuthStore } from '../stores/auth.js'
import { useClock } from '../composables/useClock.js'
import { safeRedirect, validPassword, validEmail } from '../utils/format.js'
import Icon from '../components/Icon.vue'
import BrandLogo from '../components/BrandLogo.vue'
const route = useRoute(), router = useRouter(), auth = useAuthStore(), clock = useClock()
const mode = computed(() => route.name), login = computed(() => mode.value === 'login'), register = computed(() => mode.value === 'register')
const demo = import.meta.env.VITE_USE_MOCK === 'true'
const form = reactive({ username: '', password: '', confirm: '', nickname: '', email: '', emailCode: '', captchaCode: '' })
const captcha = ref(null), captchaError = ref(''), busy = ref(false), error = ref(''), reveal = ref(false), submitRetryAt = ref(0)
const emailVerificationEnabled = computed(() => false)
const recoveryDisabled = computed(() => !login.value && !register.value)
const submitWait = computed(() => Math.max(0, Math.ceil((submitRetryAt.value - clock.now.value) / 1000)))
const titles = { login: ['账号登录', '欢迎回来，发现属于你的下一件装备。'], register: ['注册账号', '加入 gameshop，开启你的装备之旅。'], 'forgot-password': ['找回密码', '验证注册邮箱，重新设置登录密码。'] }
async function getCaptcha() { captchaError.value = ''; form.captchaCode = ''; try { const reply = await authApi.captcha(); captcha.value = { captchaEnabled: reply.captchaEnabled !== false, captchaId: reply.uuid, imageBase64: reply.img } } catch (e) { captcha.value = null; captchaError.value = e.message } }
function captchaBody() {
  if (!captcha.value) throw new Error('请先获取图形验证码。')
  if (!captcha.value.captchaEnabled) return {}
  if (!form.captchaCode.trim()) throw new Error('请输入图形验证码。')
  return { uuid: captcha.value.captchaId, code: form.captchaCode.trim() }
}
async function submit() {
  if (busy.value) return
  error.value = ''; busy.value = true
  try {
    const username = form.username.trim(), email = form.email.trim().toLowerCase()
    if (username.length < 2 || username.length > 20) throw new Error('用户名需为 2–20 个字符。')
    if (!login.value && !validPassword(form.password)) throw new Error('密码需为 8–64 位，包含字母和数字，不含空格或中文。')
    if (login.value) { await auth.login({ username, password: form.password, ...captchaBody() }); await router.replace(safeRedirect(route.query.redirect)); return }
    if (!validEmail(email)) throw new Error('请输入有效的邮箱地址。')
    if (recoveryDisabled.value) throw new Error('暂不支持邮箱找回密码。')
    if (form.password !== form.confirm) throw new Error('两次输入的密码不一致。')
    if (register.value) {
      if (form.nickname.trim() && (form.nickname.trim().length < 2 || form.nickname.trim().length > 30)) throw new Error('昵称需为 2–30 个字符。')
      await authApi.register({ username, password: form.password, email, ...captchaBody(), ...(form.nickname.trim() ? { nickname: form.nickname.trim() } : {}) })
      ElMessage.success('注册成功，请登录账号')
    }
    form.password = ''; form.confirm = ''; await router.replace({ name: 'login', query: route.query.redirect ? { redirect: safeRedirect(route.query.redirect) } : {} })
  } catch (e) { error.value = e.message; if (e.retryAfter) submitRetryAt.value = Date.now() + e.retryAfter * 1000; if (login.value || (register.value && !emailVerificationEnabled.value)) await getCaptcha() }
  finally { busy.value = false }
}
function demoFill() { form.username = 'demo_member'; form.password = 'Example123!'; form.captchaCode = '7' }
onMounted(() => { if (!recoveryDisabled.value) getCaptcha() })
</script>
<template><div class="auth-layout"><aside class="auth-art"><div class="auth-art-copy"><span class="eyebrow">EQUIP YOUR PASSION</span><h2>为热爱集结。<br />为冒险而来。</h2><p>你的游戏世界，值得更好的装备。</p></div><RouterLink to="/" class="auth-art-bottom brand" aria-label="gameshop 首页"><BrandLogo /></RouterLink></aside><section class="auth-panel"><div class="auth-form-content"><RouterLink to="/" class="brand auth-mobile-brand" aria-label="gameshop 首页"><BrandLogo /></RouterLink><RouterLink to="/" class="btn secondary small auth-home-link"><Icon name="arrow" :size="16" />返回首页</RouterLink><span class="eyebrow">{{ login ? 'WELCOME BACK' : register ? 'JOIN THE ADVENTURE' : 'RESET YOUR PASSWORD' }}</span><h1>{{ titles[mode][0] }}</h1><p class="auth-intro">{{ recoveryDisabled ? '你可以使用原密码登录后，在个人中心修改密码。' : titles[mode][1] }}</p><form v-if="!recoveryDisabled" @submit.prevent="submit">
  <label v-if="login || register" class="field">用户名<input v-model="form.username" autocomplete="username" maxlength="20" placeholder="请输入用户名" required /></label>
  <label v-if="register" class="field">玩家昵称<span class="optional">选填</span><input v-model="form.nickname" autocomplete="nickname" maxlength="30" placeholder="你的玩家称呼" /></label>
  <label v-if="!login" class="field">邮箱地址<input v-model="form.email" type="email" autocomplete="email" maxlength="254" :placeholder="emailVerificationEnabled ? '用于验证账号和找回密码' : '填写你的联系邮箱'" required /></label>
  <div class="field"><label for="member-password">{{ login || register ? '密码' : '新密码' }}</label><div class="input-with-action"><input id="member-password" v-model="form.password" :type="reveal ? 'text' : 'password'" :autocomplete="login ? 'current-password' : 'new-password'" :minlength="login ? 5 : 8" maxlength="64" :placeholder="login ? '请输入密码' : '8–64 位，包含字母和数字'" required /><button type="button" :aria-label="reveal ? '隐藏密码' : '显示密码'" @click="reveal = !reveal"><Icon name="eye" :size="18" /></button></div></div>
  <label v-if="!login" class="field">确认密码<input v-model="form.confirm" type="password" autocomplete="new-password" minlength="8" maxlength="64" placeholder="再次输入密码" required /></label>
  <div v-if="captcha?.captchaEnabled" class="field"><label for="captcha-code">图形验证码</label><div class="captcha-row"><input id="captcha-code" v-model="form.captchaCode" maxlength="8" autocomplete="off" placeholder="输入图形验证码" :required="login || (register && !emailVerificationEnabled)" /><button type="button" class="captcha-image" title="点击刷新验证码" aria-label="刷新图形验证码" @click="getCaptcha"><img :src="`data:image/jpeg;base64,${captcha.imageBase64}`" alt="图形验证码，点击刷新" /></button></div></div>
  <div v-if="captchaError" class="form-error" role="alert">{{ captchaError }}<button type="button" @click="getCaptcha">重新获取验证码</button></div>

  <div v-if="login" class="form-options"><span>使用账号密码登录</span><RouterLink v-if="captcha && emailVerificationEnabled" to="/forgot-password">忘记密码？</RouterLink></div>
  <p v-if="error" class="form-error" role="alert">{{ error }}</p><button class="btn full" :disabled="busy || submitWait > 0 || !captcha">{{ submitWait ? `${submitWait}s 后重试` : busy ? '正在处理…' : login ? '登 录' : register ? '创建账号' : '重设密码' }}<Icon name="arrow" :size="18" /></button>
  </form><p v-else class="notice" role="status">如忘记密码，请联系管理员重置。</p><p class="auth-switch">{{ login ? '还没有账号？' : '已有账号？' }}<RouterLink :to="{ name: login ? 'register' : 'login', query: route.query.redirect ? { redirect: safeRedirect(route.query.redirect) } : {} }">{{ login ? '立即注册' : '返回登录' }}</RouterLink></p><div v-if="demo" class="demo-login-note"><span>演示环境 · 图形码 7</span><button v-if="login" class="text-button" @click="demoFill">填入演示账号<Icon name="arrow" :size="13" /></button><p v-else>演示账号仅在当前会话有效。</p></div><p class="auth-footnote"><Icon name="lock" :size="13" />请妥善保管你的账号和密码。</p></div></section></div></template>
