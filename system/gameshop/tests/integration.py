"""真实 MySQL/Redis/HTTP 集成验证；只创建并清理本脚本自己的隔离库和空 Redis DB。"""
import concurrent.futures
import hashlib
import hmac
import io
import json
import os
from pathlib import Path
import re
import secrets
import socket
import subprocess
import time
import uuid
import sys

import pymysql
from pymysql.constants import CLIENT
import requests
from PIL import Image
import yaml
from jsonschema import RefResolver
from openapi_schema_validator import OAS30Validator

SYSTEM = Path(__file__).resolve().parents[2]
REPO = SYSTEM.parent
ARTIFACTS = REPO.parent / '.work' / 'gameshop-integration'
ARTIFACTS.mkdir(parents=True, exist_ok=True)
cfg = {}
for line in (SYSTEM / '.env').read_text(encoding='utf-8-sig').splitlines():
    if line and not line.startswith('#') and '=' in line:
        k, v = line.split('=', 1)
        cfg[k.strip()] = v.strip()
db_name = 'gc_api_test_' + uuid.uuid4().hex[:12]
assert re.fullmatch(r'gc_api_test_[0-9a-f]{12}', db_name) and db_name != cfg['DB_NAME']
mysql = pymysql.connect(host=cfg['DB_HOST'], port=int(cfg['DB_PORT']), user=cfg['DB_USERNAME'], password=cfg['DB_PASSWORD'], charset='utf8mb4', autocommit=True, client_flag=CLIENT.MULTI_STATEMENTS)
results = []
process = None
redis_db = None
BASE = 'http://127.0.0.1:18089'
spec = yaml.safe_load((REPO/'docs/api/openapi.yaml').read_text(encoding='utf-8'))
resolver = RefResolver.from_schema(spec)
documented = [(method.upper(),re.compile('^'+re.sub(r'\{[^}]+\}',r'[^/]+',path)+'$'),op) for path,methods in spec['paths'].items() for method,op in methods.items() if path.startswith(('/api/mall/','/mall/'))]
schema_checks = 0


def redis(*args, database=None):
    with socket.create_connection((cfg.get('REDIS_HOST', '127.0.0.1'), int(cfg.get('REDIS_PORT', '6379')))) as sock:
        f = sock.makefile('rb')
        def read():
            t = f.read(1); raw = f.readline().rstrip(b'\r\n')
            if t == b'+': return raw.decode()
            if t == b':': return int(raw)
            if t == b'-': raise RuntimeError('Redis command rejected')
            if t == b'$':
                n = int(raw)
                if n < 0: return None
                value = f.read(n); f.read(2); return value.decode()
            if t == b'*': return [read() for _ in range(int(raw))]
            raise RuntimeError('Redis protocol')
        def send(command):
            data = [str(a).encode() for a in command]
            sock.sendall(b'*'+str(len(data)).encode()+b'\r\n'+b''.join(b'$'+str(len(x)).encode()+b'\r\n'+x+b'\r\n' for x in data))
            return read()
        if cfg.get('REDIS_PASSWORD'): send(['AUTH', cfg['REDIS_PASSWORD']])
        send(['SELECT', redis_db if database is None else database])
        return send(args)


def sql(query, args=None):
    with mysql.cursor() as cursor:
        cursor.execute(query, args)
        return cursor.fetchall() if cursor.description else cursor.rowcount


def script(path):
    with mysql.cursor() as cursor:
        cursor.execute(path.read_text(encoding='utf-8'))
        while cursor.nextset(): pass


def api(method, path, body=None, token=None, expected=200, error=None, label=None, files=None):
    global schema_checks
    headers = {'Authorization': 'Bearer '+token} if token else {}
    r = requests.request(method, BASE+path, json=body, headers=headers, files=files, timeout=20)
    try: value = r.json()
    except ValueError: value = None
    assert r.status_code == expected, (label or path, r.status_code, {k: value.get(k) for k in ['code','msg','errorCode']} if isinstance(value,dict) else r.text[:100])
    if error: assert value['errorCode'] == error, (label or path, value.get('errorCode'))
    if isinstance(value, dict) and path.startswith(('/api/mall', '/mall/')):
        assert value['code'] == (200 if expected < 300 else expected), (path, value['code'])
        operation=next((op for m,pattern,op in documented if m==method and pattern.fullmatch(path.split('?')[0])),None)
        if operation:
            response=operation['responses'].get(str(expected))
            assert response, (path, expected, 'undocumented status')
            errors=list(OAS30Validator(response['content']['application/json']['schema'],resolver=resolver,format_checker=OAS30Validator.FORMAT_CHECKER).iter_errors(value))
            assert not errors, (path,[(list(e.path),e.message) for e in errors])
            schema_checks+=1
    if label: results.append({'case': label, 'result': 'passed', 'http': r.status_code})
    return value


def captcha():
    body = api('GET', '/api/mall/captcha')['data']
    digest = redis('GET', 'mall:captcha:'+body['captchaId'])
    answer = next(str(n) for n in range(19) if hmac.new(cfg['GAMESHOP_CODE_SECRET'].encode(), (body['captchaId']+':'+str(n)).encode(), hashlib.sha256).hexdigest() == digest)
    return {'captchaId': body['captchaId'], 'captchaCode': answer}


def login(username='demo_member', password='Example123!'):
    return api('POST', '/api/mall/sessions', {'username': username, 'password': password, **captcha()})['data']['token']


def quote(token, quantity=1):
    return api('POST','/api/mall/order-quotes', {'source':'DIRECT','items':[{'propId':'1001','quantity':quantity}]}, token)['data']['quoteToken']


def create(token, quantity=1, key=None):
    payload={'requestKey':key or str(uuid.uuid4()), 'quoteToken':quote(token,quantity), 'deliveryInfo':{'gameAccount':'player001','serverName':'一区','roleName':'测试玩家'}, 'remark':None}
    value=api('POST','/api/mall/orders',payload,token,201)['data']
    return value['order'],payload


try:
    for candidate in range(15,6,-1):
        if redis('DBSIZE',database=candidate)==0:
            redis_db=candidate
            break
    assert redis_db is not None, '没有可用的空 Redis DB 7-15，未清理任何已有数据'
    sql('CREATE DATABASE `'+db_name+'` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci')
    sql('USE `'+db_name+'`')
    for name in ['upstream/ry_20260417.sql','upstream/quartz.sql','migrations/V001__create_mall_tables.sql','demo/D001__mall_demo.sql','migrations/V002__register_order_expiry_job.sql','migrations/V003__register_admin_menus.sql','migrations/V004__customize_admin_brand.sql','migrations/V005__prune_admin_menus.sql','migrations/V006__game_servers.sql']:
        script(SYSTEM/'sql'/name)
    sql("UPDATE sys_config SET config_value='false' WHERE config_key='sys.account.captchaEnabled'")
    sql("UPDATE sys_user SET password=(SELECT password_hash FROM mall_member WHERE member_id=2001) WHERE user_id=2")
    # Keep the fixture stable while transaction tests manipulate dates; exercise the task explicitly below.
    sql("UPDATE sys_job SET status='1' WHERE invoke_target='gameshopOrderExpiry.closeExpired()'")
    env=os.environ.copy(); env.update(cfg)
    env.update({'DB_NAME':db_name,'DB_URL':f"jdbc:mysql://{cfg['DB_HOST']}:{cfg['DB_PORT']}/{db_name}?useUnicode=true&characterEncoding=UTF-8&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia%2FShanghai",'REDIS_DATABASE':str(redis_db),'SERVER_PORT':'18089','GAMESHOP_MAILBOX_PATH':str(ARTIFACTS/'mailbox'),'LOG_PATH':str(ARTIFACTS/'logs'),'UPLOAD_PATH':str(ARTIFACTS/'uploads'),'SPRING_PROFILES_ACTIVE':'dev','GAMESHOP_MAIL_MODE':'file','GAMESHOP_CAPTCHA_ENABLED':'true','GAMESHOP_EMAIL_VERIFICATION_ENABLED':'true'})
    java=Path(env.get('JAVA_HOME','D:/java'))/'bin/java.exe'
    with (ARTIFACTS/'server.log').open('w',encoding='utf-8') as log:
        process=subprocess.Popen([str(java),'-Duser.timezone=Asia/Shanghai','-jar',str(SYSTEM/'ruoyi-admin/target/ruoyi-admin.jar')],cwd=SYSTEM,env=env,stdout=log,stderr=subprocess.STDOUT,creationflags=getattr(subprocess,'CREATE_NO_WINDOW',0))
    for attempt in range(120):
        if process.poll() is not None:
            raise RuntimeError('测试服务启动失败，请查看 .work/gameshop-integration/server.log')
        try:
            if requests.get(BASE+'/api/mall/captcha',timeout=1).status_code==200: break
        except requests.RequestException: pass
        time.sleep(0.5)
    else: raise RuntimeError('测试服务启动超时')
    print('Started isolated integration service; executing real HTTP checks.',flush=True)
    admin=api('POST','/login',{'username':'admin','password':'admin123'})['token']
    routers=api('GET','/getRouters',token=admin)['data']
    shop_route=next(r for r in routers if r['path']=='/gameshop')
    assert len(shop_route['children'])==8 and {r['component'] for r in shop_route['children']}=={'gameshop/'+p+'/index' for p in ['categories','props','banners','members','orders','reviews','stock-logs','game-servers']}
    results.append({'case':'后台八个真实菜单路由与组件完整','result':'passed'})
    limited=api('POST','/login',{'username':'ry','password':'Example123!'})['token']
    buyer=login(); other=login('other_member')
    from game_server_cases import run_server_cases
    run_server_cases(api,sql,admin,buyer,limited,BASE,results)
    api('GET','/api/mall/home',label='公开首页')
    api('GET','/api/mall/categories',label='分类列表为数组')
    api('GET','/api/mall/props?sort=price_asc&pageSize=1',label='公开分页和白名单排序')
    api('GET','/api/mall/props/1001',label='商品详情及金额字符串')
    api('GET','/api/mall/props/1001/reviews',label='公开评价脱敏')
    api('GET','/api/mall/me',expected=401,error='MALL_UNAUTHENTICATED',label='会员未登录拒绝')
    api('GET','/api/mall/me',token=admin,expected=401,error='MALL_UNAUTHENTICATED',label='后台令牌不能充当会员')
    api('GET','/mall/props',token=buyer,expected=401,error='MALL_UNAUTHENTICATED',label='会员令牌不能充当后台')
    api('GET','/mall/props',token=limited,expected=403,error='MALL_FORBIDDEN',label='后台缺少商城权限')
    api('GET','/mall/props',token=admin,label='后台分页列表资源路径')
    api('POST','/api/mall/cart/items',{'propId':1001,'quantity':1},buyer,400,'MALL_VALIDATION_FAILED',label='拒绝数字ID')
    api('POST','/api/mall/cart/items',{'propId':'1001','quantity':1,'memberId':'2002'},buyer,400,'MALL_VALIDATION_FAILED',label='拒绝越权未知字段')
    api('POST','/api/mall/cart/items',{'propId':'1001','quantity':0},buyer,400,'MALL_VALIDATION_FAILED',label='拒绝零数量')
    api('PUT','/api/mall/me',{'nickname':'演示会员'},buyer,400,'MALL_VALIDATION_FAILED',label='必有可空字段不允许遗漏')
    api('PUT','/api/mall/me',{'nickname':'演示会员','phoneNumber':None},buyer,label='本人资料修改')
    api('GET','/api/mall/orders/GC202610222000000005',token=buyer,expected=404,error='MALL_RESOURCE_NOT_FOUND',label='他人订单统一404')
    api('PUT','/api/mall/cart/items/4001',{'quantity':1,'checked':True},other,404,'MALL_RESOURCE_NOT_FOUND',label='购物车归属校验')
    api('GET','/api/mall/cart/items',token=buyer,label='购物车实时汇总')
    api('POST','/api/mall/cart/items',{'propId':'1001','quantity':1},buyer,label='加购增量合并')
    api('PUT','/api/mall/cart/selection',{'cartItemIds':['4001'],'checked':True},buyer,label='购物车批量勾选')
    api('POST','/api/mall/order-quotes',{'source':'CART','cartItemIds':['4001'],'items':[{'propId':'1001','quantity':1}]},buyer,400,'MALL_VALIDATION_FAILED',label='报价来源互斥')
    api('PATCH','/api/mall/me',{},buyer,405,'MALL_METHOD_NOT_ALLOWED',label='不支持的方法返回405')
    api('GET','/api/mall/me/not-a-resource',token=buyer,expected=404,error='MALL_RESOURCE_NOT_FOUND',label='未知资源返回404')
    wrong_type=requests.put(BASE+'/api/mall/me',headers={'Authorization':'Bearer '+buyer,'Content-Type':'text/plain'},data='{}',timeout=5)
    assert wrong_type.status_code==415 and wrong_type.json()['errorCode']=='MALL_CONTENT_TYPE_UNSUPPORTED'
    results.append({'case':'请求Content-Type错误返回415','result':'passed'})
    order,payload=create(buyer)
    replay=api('POST','/api/mall/orders',payload,buyer,label='创建订单幂等重放')['data']
    assert replay['replayed'] and replay['order']['orderNo']==order['orderNo']
    api('POST','/api/mall/orders',{**payload,'remark':'改变内容'},buyer,409,'MALL_IDEMPOTENCY_CONFLICT',label='同键异内容冲突')
    api('POST','/api/mall/orders',{**payload,'totalAmount':'0.01'},buyer,400,'MALL_VALIDATION_FAILED',label='拒绝前端总金额')
    before=sql('SELECT stock,sales FROM mall_prop WHERE prop_id=1001')[0]
    failed=api('POST',f"/api/mall/orders/{order['orderNo']}/payments",{'result':'FAIL'},buyer,label='模拟失败不改订单')['data']
    assert failed['outcome']=='FAILED' and failed['order']['status']=='1'
    paid=api('POST',f"/api/mall/orders/{order['orderNo']}/payments",{'result':'SUCCESS'},buyer,label='模拟成功支付')['data']
    api('POST',f"/api/mall/orders/{order['orderNo']}/payments",{'result':'SUCCESS'},buyer,label='支付重复不增销量')
    assert sql('SELECT stock,sales FROM mall_prop WHERE prop_id=1001')[0]==(before[0],before[1]+1)
    delivered=api('PUT',f"/mall/orders/{order['orderId']}/delivery",{'deliveryNote':'道具已经交付到角色背包。'},admin,label='后台登记交付完成')['data']
    api('PUT',f"/mall/orders/{order['orderId']}/delivery",{'deliveryNote':'道具已经交付到角色背包。'},admin,label='交付相同请求幂等')
    review=api('POST','/api/mall/reviews',{'orderItemId':delivered['items'][0]['orderItemId'],'score':5,'content':'交付及时，商品符合预期。'},buyer,201,label='本人已完成明细评价')['data']
    api('POST','/api/mall/reviews',{'orderItemId':delivered['items'][0]['orderItemId'],'score':5,'content':'重复评价不被允许。'},buyer,409,'MALL_REVIEW_ALREADY_EXISTS',label='评价唯一约束')
    api('PUT',f"/mall/reviews/{review['reviewId']}/visibility",{'reason':'测试违规内容隐藏。'},admin,label='后台隐藏评价留原因')
    api('POST','/api/mall/reviews',{'orderItemId':delivered['items'][0]['orderItemId'],'score':5,'content':'隐藏后再次评价。'},buyer,409,'MALL_REVIEW_ALREADY_EXISTS',label='隐藏不释放评价额度')
    cancelled,_=create(buyer)
    before=sql('SELECT stock FROM mall_prop WHERE prop_id=1001')[0][0]
    api('PUT',f"/api/mall/orders/{cancelled['orderNo']}/cancellation",{'reason':'不再购买'},buyer,label='取消订单回补库存')
    api('PUT',f"/api/mall/orders/{cancelled['orderNo']}/cancellation",{'reason':'不再购买'},buyer,label='重复取消不重复回补')
    assert sql('SELECT stock FROM mall_prop WHERE prop_id=1001')[0][0]==before+1
    # 价格变更必须重新报价，失败请求没有扣库存。
    stale=quote(buyer)
    before=sql('SELECT stock FROM mall_prop WHERE prop_id=1001')[0][0]
    sql('UPDATE mall_prop SET price=50.00 WHERE prop_id=1001')
    api('POST','/api/mall/orders',{'requestKey':str(uuid.uuid4()),'quoteToken':stale,'deliveryInfo':{'gameAccount':'player001','serverName':'一区','roleName':'测试'}},buyer,409,'MALL_QUOTE_CHANGED',label='报价变化整单拒绝')
    assert sql('SELECT stock FROM mall_prop WHERE prop_id=1001')[0][0]==before
    sql('UPDATE mall_prop SET price=49.90 WHERE prop_id=1001')
    # 上传后访问实际重编码图片；错误内容不能仅凭后缀通过。
    buf=io.BytesIO();Image.new('RGB',(32,32),(70,120,200)).save(buf,'PNG')
    uploaded=api('POST','/mall/media/images',token=admin,expected=201,files={'file':('safe.png',buf.getvalue(),'image/png')},label='后台图片真实上传')['data']
    image=requests.get(BASE+uploaded['url'],timeout=5);assert image.status_code==200 and image.headers['Content-Type'].startswith('image/png')
    results.append({'case':'公开图片返回二进制','result':'passed'})
    api('POST','/mall/media/images',token=admin,expected=415,error='MALL_UPLOAD_TYPE_UNSUPPORTED',files={'file':('fake.png',b'<script>alert(1)</script>','image/png')},label='拒绝伪造图片内容')
    api('POST','/api/mall/me/avatar',token=buyer,files={'file':('avatar.png',buf.getvalue(),'image/png')},label='会员头像上传保存')
    # CRUD uses actual uploaded media, not the D001 metadata placeholder.
    cat=api('POST','/mall/categories',{'name':'接口验证分类','iconUrl':uploaded['url'],'sort':0,'recommended':True,'status':'1'},admin,201,label='创建分类')['data']
    prop_payload={'categoryId':cat['categoryId'],'name':'接口测试道具','coverUrl':uploaded['url'],'price':'9.90','originalPrice':None,'images':[{'url':uploaded['url'],'sort':0}],'detailHtml':'<p onclick="x()">详情<script>alert(1)</script><a href="https://bad.example">链接</a></p>','specs':[{'name':'品质','value':'普通'}],'deliveryFields':['roleName'],'status':'1','initialStock':3}
    product=api('POST','/mall/props',prop_payload,admin,201,label='创建商品和初始库存流水')['data']
    assert 'script' not in product['detailHtml'] and 'onclick' not in product['detailHtml'] and 'https://bad' not in product['detailHtml']
    results.append({'case':'富文本允许列表清洗','result':'passed'})
    api('PUT',f"/mall/props/{product['propId']}/status",{'status':'0','version':product['version']+99},admin,409,'MALL_VERSION_CONFLICT',label='乐观锁拒绝旧版本')
    stock_payload={'requestKey':str(uuid.uuid4()),'delta':2,'reason':'测试人工补货'}
    first=api('POST',f"/mall/props/{product['propId']}/stock-adjustments",stock_payload,admin,label='库存增减独立动作')['data']
    again=api('POST',f"/mall/props/{product['propId']}/stock-adjustments",stock_payload,admin,label='库存调整幂等')['data']
    assert first==again
    api('GET','/mall/categories',token=admin,label='后台分类列表')
    api('GET',f"/mall/categories/{cat['categoryId']}",token=admin,label='后台分类详情')
    api('PUT',f"/mall/categories/{cat['categoryId']}",{'name':cat['name'],'iconUrl':uploaded['url'],'sort':2,'recommended':True,'status':'1','version':cat['version']},admin,label='后台分类更新')
    banner=api('POST','/mall/banners',{'title':'验证轮播','imageUrl':uploaded['url'],'targetPropId':'1001','sort':1,'status':'1'},admin,201,label='后台创建轮播')['data']
    api('GET','/mall/banners',token=admin,label='后台轮播列表')
    api('GET',f"/mall/banners/{banner['bannerId']}",token=admin,label='后台轮播详情')
    api('PUT',f"/mall/banners/{banner['bannerId']}",{'title':'更新轮播','imageUrl':uploaded['url'],'targetPropId':'1001','sort':2,'status':'0','version':banner['version']},admin,label='后台轮播更新')
    api('DELETE',f"/mall/banners/{banner['bannerId']}",token=admin,label='后台软删除轮播')
    latest=api('GET',f"/mall/props/{product['propId']}",token=admin,label='后台商品详情')['data']
    update={k:v for k,v in prop_payload.items() if k!='initialStock'};update['version']=latest['version']
    latest=api('PUT',f"/mall/props/{product['propId']}",update,admin,label='普通编辑不覆盖库存')['data']
    assert latest['stock']==5
    api('GET','/mall/members',token=admin,label='后台会员脱敏列表')
    api('GET','/mall/members/2001',token=admin,label='后台会员详情')
    api('GET','/mall/orders',token=admin,label='后台订单列表')
    api('GET',f"/mall/orders/{order['orderId']}",token=admin,label='后台订单详情')
    api('GET','/mall/reviews',token=admin,label='后台评价列表')
    api('GET',f"/mall/reviews/{review['reviewId']}",token=admin,label='后台评价详情')
    api('GET','/mall/stock-logs?bizType=ADMIN_ADJUST',token=admin,label='后台库存流水过滤')
    api('GET','/api/mall/orders?status=4',token=buyer,label='本人订单分页过滤')
    api('GET',f"/api/mall/orders/{order['orderNo']}",token=buyer,label='本人订单详情')
    api('GET','/api/mall/me/reviews',token=buyer,label='本人评价含隐藏原因')
    expiry,_=create(buyer)
    sql("UPDATE mall_order SET create_time=DATE_SUB(NOW(3),INTERVAL 2 MINUTE),expire_time=DATE_SUB(NOW(3),INTERVAL 1 MINUTE) WHERE order_id=%s",(expiry['orderId'],))
    api('POST',f"/api/mall/orders/{expiry['orderNo']}/payments",{'result':'SUCCESS'},buyer,409,'MALL_ORDER_EXPIRED',label='过期但尚待任务关闭不能支付')
    jobid=sql("SELECT job_id FROM sys_job WHERE invoke_target='gameshopOrderExpiry.closeExpired()'")[0][0]
    api('PUT','/monitor/job/run',{'jobId':jobid,'jobGroup':'DEFAULT'},admin,label='Quartz任务真实触发')
    for _ in range(40):
        if sql('SELECT status FROM mall_order WHERE order_id=%s',(expiry['orderId'],))[0][0]=='3':break
        time.sleep(.1)
    else:raise AssertionError('Quartz超时关单未完成')
    results.append({'case':'Quartz关单与回补真实事务','result':'passed'})
    admin_cancel,_=create(buyer)
    api('PUT',f"/mall/orders/{admin_cancel['orderId']}/cancellation",{'reason':'管理员测试关单'},admin,label='后台取消订单')
    # Payment/cancellation race must produce exactly one legal state and one set of side effects.
    raced,_=create(buyer); before=sql('SELECT stock,sales FROM mall_prop WHERE prop_id=1001')[0]
    with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
        one=pool.submit(requests.post,BASE+f"/api/mall/orders/{raced['orderNo']}/payments",headers={'Authorization':'Bearer '+buyer},json={'result':'SUCCESS'},timeout=10)
        two=pool.submit(requests.put,BASE+f"/api/mall/orders/{raced['orderNo']}/cancellation",headers={'Authorization':'Bearer '+buyer},json={'reason':'并发取消'},timeout=10)
        race=[one.result(),two.result()]
    assert sorted(x.status_code for x in race)==[200,409]
    final=sql('SELECT status FROM mall_order WHERE order_id=%s',(raced['orderId'],))[0][0]
    assert sql('SELECT stock,sales FROM mall_prop WHERE prop_id=1001')[0]==((before[0],before[1]+1) if final=='2' else (before[0]+1,before[1]))
    results.append({'case':'支付取消并发只能一个状态及一次副作用','result':'passed'})
    api('DELETE',f"/mall/categories/{cat['categoryId']}",token=admin,expected=409,error='MALL_CATEGORY_IN_USE',label='有关联商品不能删分类')
    # One remaining unit, concurrent requests from different members: only one order commits.
    prior_stock=sql('SELECT stock FROM mall_prop WHERE prop_id=1001')[0][0]
    sql('UPDATE mall_prop SET stock=999999999 WHERE prop_id=1001')
    api('POST','/mall/props/1001/stock-adjustments',{'requestKey':str(uuid.uuid4()),'delta':1,'reason':'验证待支付回补容量'},admin,400,'MALL_VALIDATION_FAILED',label='人工补货为待支付取消保留回补容量')
    sql('UPDATE mall_prop SET stock=%s WHERE prop_id=1001',(prior_stock,))
    sql('UPDATE mall_prop SET stock=1 WHERE prop_id=1001')
    qs=[quote(buyer),quote(other)]
    def compete(pair):
        token,qt=pair
        return requests.post(BASE+'/api/mall/orders',headers={'Authorization':'Bearer '+token},json={'requestKey':str(uuid.uuid4()),'quoteToken':qt,'deliveryInfo':{'gameAccount':'player','serverName':'一区','roleName':'并发角色'}},timeout=20)
    with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
        rr=list(pool.map(compete,zip([buyer,other],qs)))
    assert sorted(r.status_code for r in rr)==[201,409],[(r.status_code,r.json().get('errorCode')) for r in rr]
    assert sql('SELECT stock FROM mall_prop WHERE prop_id=1001')[0][0]==0
    results.append({'case':'真实MySQL并发不超卖且失败整单回滚','result':'passed'})
    # Member status changes revoke previously issued sessions immediately.
    api('PUT','/mall/members/2002/status',{'status':'1','reason':'测试禁用会员'},admin,label='后台禁用会员')
    api('GET','/api/mall/me',token=other,expected=401,error='MALL_UNAUTHENTICATED',label='禁用立即使旧会员令牌失效')
    # Production-facing registration/reset paths still require out-of-band email codes.
    email='registered@example.com'
    api('POST','/api/mall/email-codes',{'email':email,'scene':'REGISTER',**captcha()},expected=202,label='邮箱发码不在HTTP回显')
    out=(ARTIFACTS/'mailbox'/(hashlib.sha256((email+':REGISTER').encode()).hexdigest()+'.txt')).read_text(encoding='utf-8')
    code=re.search(r'Code: (\d{6})',out)[1]
    api('POST','/api/mall/members',{'username':'registered','password':'NewExample123!','email':email,'emailCode':code},expected=201,label='邮箱验证注册独立会员')
    api('POST','/api/mall/members',{'username':'registered2','password':'NewExample123!','email':email,'emailCode':code},expected=400,error='MALL_EMAIL_CODE_INVALID',label='邮箱码单次消费')
    new_token=login('registered','NewExample123!')
    api('PUT','/api/mall/me/password',{'oldPassword':'NewExample123!','newPassword':'ChangedExample123!'},new_token,label='修改密码')
    api('GET','/api/mall/me',token=new_token,expected=401,error='MALL_UNAUTHENTICATED',label='改密撤销全部旧会话')
    api('POST','/api/mall/email-codes',{'email':email,'scene':'RESET_PASSWORD',**captcha()},expected=202,label='重置邮箱码绑定独立场景')
    resetmail=(ARTIFACTS/'mailbox'/(hashlib.sha256((email+':RESET_PASSWORD').encode()).hexdigest()+'.txt')).read_text(encoding='utf-8')
    resetcode=re.search(r'Code: (\d{6})',resetmail)[1]
    api('POST','/api/mall/password-resets',{'email':email,'emailCode':resetcode,'newPassword':'ResetExample123!'},label='邮箱验证找回密码')
    assert login('registered','ResetExample123!')
    api('PUT',f"/mall/props/{product['propId']}/status",{'status':'0','version':latest['version']},admin,label='后台独立下架')
    api('DELETE',f"/mall/props/{product['propId']}",token=admin,label='后台商品软删除')
    api('DELETE',f"/mall/categories/{cat['categoryId']}",token=admin,label='移除商品后分类软删除')
    api('PUT','/api/mall/cart/items/4001',{'quantity':1,'checked':True},buyer,label='购物车绝对数量修改')
    api('DELETE','/api/mall/cart/items/4001',token=buyer,label='移除本人购物车条目')
    api('DELETE','/api/mall/cart/items/4001',token=buyer,label='重复移除购物车幂等')
    api('DELETE','/api/mall/sessions/current',token=buyer,label='会员退出当前会话')
    api('GET','/api/mall/me',token=buyer,expected=401,error='MALL_UNAUTHENTICATED',label='退出后令牌不可复用')
    if '--ui' in sys.argv:
        from ui_smoke import run_ui
        run_ui(REPO,ARTIFACTS,admin,results)
    print(json.dumps({'passedCases':len(results),'realMySQLConcurrency':'passed'},ensure_ascii=False),flush=True)
finally:
    if process is not None:
        process.terminate()
        try: process.wait(timeout=20)
        except subprocess.TimeoutExpired: process.kill();process.wait(timeout=10)
    if redis_db is not None:
        # The selected DB was empty and reserved exclusively for this process; no FLUSHALL.
        keys=redis('KEYS','*')
        if keys: redis('DEL',*keys)
    if re.fullmatch(r'gc_api_test_[0-9a-f]{12}',db_name): sql('DROP DATABASE IF EXISTS `'+db_name+'`')
    mysql.close()
    report={'cases':results,'passedCases':len(results),'liveResponseSchemaChecks':schema_checks,'isolatedDatabaseCleaned':True,'isolatedRedisDbCleaned':redis_db is not None,'applicationDatabaseModified':False}
    (ARTIFACTS/'result.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
