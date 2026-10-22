"""Real RuoYi authentication checks; called only inside run.py's owned test stack."""
import concurrent.futures
import json
import requests
from run import redis

BASE = 'http://127.0.0.1:18090'

def verify(mysql, redis_db, artifacts):
    checks = []
    def sql(statement, args=None):
        with mysql.cursor() as cursor:
            cursor.execute(statement, args)
            return cursor.fetchall() if cursor.description else cursor.rowcount
    def request(method, path, body=None, token=None):
        response = requests.request(method, BASE + path, json=body,
            headers={'Authorization': 'Bearer ' + token} if token else {}, timeout=15)
        return response, response.json() if response.headers.get('content-type', '').startswith('application/json') else {}
    def captcha():
        _, value = request('GET', '/captchaImage')
        assert value['captchaEnabled'] and value['img']
        return {'uuid': value['uuid'], 'code': json.loads(redis(redis_db, 'GET', 'captcha_codes:' + value['uuid']))}
    def login(name, password='Example123!'):
        _, value = request('POST', '/login', {'username': name, 'password': password, **captcha()})
        assert value['code'] == 200, (name, value.get('msg'))
        assert isinstance(value.get('token'), str) and 'data' not in value
        return value['token']
    def ok(name, condition):
        assert condition, name
        checks.append(name)

    ok('V007 preserves all legacy member links and removes duplicate password storage', sql('SELECT COUNT(*) FROM mall_member WHERE sys_user_id IS NULL OR password_hash IS NOT NULL')[0][0] == 0)
    ok('ordinary role has no menus or department grants', sql("SELECT (SELECT COUNT(*) FROM sys_role_menu m JOIN sys_role r ON r.role_id=m.role_id WHERE r.role_key='common')+(SELECT COUNT(*) FROM sys_role_dept d JOIN sys_role r ON r.role_id=d.role_id WHERE r.role_key='common')")[0][0] == 0)
    challenge = captcha()
    _, wrong = request('POST', '/register', {'username': 'auth_wrong', 'password': 'Example123!', **challenge, 'code': 'invalid'})
    _, reused = request('POST', '/register', {'username': 'auth_wrong', 'password': 'Example123!', **challenge})
    ok('bad and consumed captchas reject registration', wrong['code'] != 200 and reused['code'] != 200 and not sql("SELECT user_id FROM sys_user WHERE user_name='auth_wrong'"))
    for name in ('auth_user_a', 'auth_user_b'):
        _, value = request('POST', '/register', {'username': name, 'password': 'Example123!', 'nickname': '测试玩家', 'email': name + '@example.com', 'roleIds': [1], 'roles': ['admin'], 'userId': 1, 'deptId': 103, **captcha()})
        ok(name + ' registered', value['code'] == 200)
        ok(name + ' cannot request admin role', sql('SELECT r.role_key FROM sys_user u JOIN sys_user_role ur ON ur.user_id=u.user_id JOIN sys_role r ON r.role_id=ur.role_id WHERE u.user_name=%s', (name,)) == (('common',),))
    _, duplicate = request('POST', '/register', {'username': 'auth_user_a', 'password': 'Example123!', **captcha()})
    ok('duplicate username rejected', duplicate['code'] != 200)
    a, b, admin = login('auth_user_a'), login('auth_user_b'), login('admin', 'admin123')
    _, info = request('GET', '/getInfo', token=a)
    assert info.get('code') == 200, {k: info.get(k) for k in ('code', 'msg')}
    ok('native getInfo exposes only ordinary role and no admin permissions', info['roles'] == ['common'] and info['permissions'] == [] and 'password' not in info['user'])
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        profiles = list(pool.map(lambda _: request('GET', '/api/mall/me', token=a), range(4)))
    ok('concurrent first requests bind one member profile', all(r.status_code == 200 for r, _ in profiles) and len({v['data']['memberId'] for _, v in profiles}) == 1)
    mid = profiles[0][1]['data']['memberId']
    ok('member and system IDs are explicitly associated', str(sql('SELECT sys_user_id FROM mall_member WHERE member_id=%s', (mid,))[0][0]) == str(info['user']['userId']))
    for path in ('/getRouters', '/system/user/list', '/system/role/list', '/system/user/profile', '/monitor/online/list', '/tool/gen/list', '/mall/members', '/mall/props', '/mall/dashboard'):
        response, _ = request('GET', path, token=a)
        ok('ordinary account denied ' + path, response.status_code == 403)
    for path in ('/getRouters', '/mall/props', '/api/mall/me', '/api/mall/cart/items'):
        response, value = request('GET', path, token=admin)
        ok('admin still allowed ' + path, response.status_code == 200 and value['code'] == 200)
    legacy = login('demo_member')
    _, profile = request('GET', '/api/mall/me', token=legacy)
    ok('legacy password and member primary key retained', profile['data']['memberId'] == '2001')
    _, order = request('GET', '/api/mall/orders/GC202610222000000001', token=legacy)
    ok('legacy order remains owned by migrated account', order['code'] == 200)
    response, _ = request('GET', '/api/mall/orders/GC202610222000000001', token=a)
    ok('other user cannot read legacy order', response.status_code == 404)
    _, cart = request('POST', '/api/mall/cart/items', {'propId': '1001', 'quantity': 1}, a)
    row = cart['data']['items'][0]['cartItemId']
    response, _ = request('PUT', '/api/mall/cart/items/' + row, {'quantity': 2, 'checked': True}, b)
    ok('cart ownership enforced with native token', response.status_code == 404)
    _, quote = request('POST', '/api/mall/order-quotes', {'source': 'DIRECT', 'items': [{'propId': '1001', 'quantity': 1}]}, a)
    import uuid
    body = {'quoteToken': quote['data']['quoteToken'], 'requestKey': str(uuid.uuid4()), 'deliveryInfo': {'gameAccount': 'game_test', 'roleName': '测试玩家', 'serverIds': [group['servers'][0]['serverId'] for group in quote['data']['serverGroups']]}}
    _, created = request('POST', '/api/mall/orders', body, a)
    number = created['data']['order']['orderNo']
    ok('native account can create an owned order', created['code'] == 200)
    response, _ = request('GET', '/api/mall/orders/' + number, token=b)
    ok('cross-account order access denied', response.status_code == 404)
    _, cancelled = request('PUT', '/api/mall/orders/' + number + '/cancellation', {'reason': '测试取消'}, a)
    ok('owned order cancellation still works', cancelled['code'] == 200)
    _, updated = request('PUT', '/api/mall/me', {'nickname': '统一账号昵称', 'phoneNumber': None}, a)
    ok('profile update reaches sys_user', updated['code'] == 200 and sql("SELECT nick_name FROM sys_user WHERE user_name='auth_user_a'")[0][0] == '统一账号昵称')
    a_second = login('auth_user_a')
    _, changed = request('PUT', '/api/mall/me/password', {'oldPassword': 'Example123!', 'newPassword': 'Changed123!'}, a)
    ok('password change uses RuoYi password', changed['code'] == 200)
    for token in (a, a_second):
        response, _ = request('GET', '/api/mall/me', token=token)
        ok('old session invalidated after password change', response.status_code == 401)
    a = login('auth_user_a', 'Changed123!')
    uid = sql("SELECT user_id FROM sys_user WHERE user_name='auth_user_a'")[0][0]
    _, disabled = request('PUT', '/system/user/changeStatus', {'userId': uid, 'status': '1'}, admin)
    response, _ = request('GET', '/api/mall/me', token=a)
    ok('backend account disable revokes storefront access', disabled['code'] == 200 and response.status_code == 401)
    request('POST', '/logout', token=b)
    response, _ = request('GET', '/api/mall/cart/items', token=b)
    ok('native logout invalidates protected access', response.status_code == 401)
    for path in ('/api/mall/sessions', '/api/mall/members', '/api/mall/password-resets'):
        response, _ = request('POST', path, {'username': 'auth_legacy', 'password': 'Example123!'})
        ok('retired authentication endpoint cannot issue identities ' + path, response.status_code != 200)
    (artifacts / 'ruoyi-auth-http.json').write_text(json.dumps({'passed': len(checks), 'checks': checks}, ensure_ascii=False, indent=2), encoding='utf-8')
    print(f'PASS: {len(checks)} real RuoYi HTTP/database checks.', flush=True)
