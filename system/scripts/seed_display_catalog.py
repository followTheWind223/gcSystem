"""通过正式 REST 接口导入显示商品；执行前由操作者备份应用库。

依赖 requests。令牌仅从进程变量 GAMESHOP_ADMIN_TOKEN 读取，不写入断点文件。
默认连接本机后端；不生成会员、订单、支付、销量或评价。
"""
from pathlib import Path
import argparse
import hashlib
import json
import os
import requests

SYSTEM = Path(__file__).resolve().parents[1]
ASSETS = SYSTEM / 'assets/display-catalog'


def seed_catalog(client, base_url='http://127.0.0.1:8080', state_file=None):
    base_url = base_url.rstrip('/')
    state_file = Path(state_file or SYSTEM / 'data/display-catalog-state.json')
    manifest = json.loads((ASSETS / 'catalog.json').read_text(encoding='utf-8'))
    state = json.loads(state_file.read_text(encoding='utf-8')) if state_file.exists() else {
        'dataset': manifest['dataset'], 'images': {}, 'categories': {}, 'products': {}, 'banners': {}
    }
    if state['dataset'] != manifest['dataset']:
        raise RuntimeError('断点文件属于其他数据集，请使用独立的 --state 路径。')
    state_file.parent.mkdir(parents=True, exist_ok=True)

    def checkpoint():
        temporary = state_file.with_suffix('.json.tmp')
        temporary.write_text(json.dumps(state, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        temporary.replace(state_file)

    def request(method, path, **kwargs):
        response = client.request(method, base_url + path, timeout=90, **kwargs)
        if response.status_code not in (200, 201) or response.json().get('code') != 200:
            raise RuntimeError(f'{method} {path} 失败（HTTP {response.status_code}），已保存断点。')
        return response.json()

    def listing(resource):
        result = []
        page = 1
        while True:
            reply = request('GET', '/mall/' + resource, params={'pageNum': page, 'pageSize': 50})
            result += reply['rows']
            if len(result) >= reply['total']:
                return result
            if not reply['rows']:
                raise RuntimeError('分页结果不完整，停止导入。')
            page += 1

    # 已有同名内容但不在本数据集断点中时停止，不覆盖用户维护的商品。
    definitions = [('categories', 'categories', 'categoryId', 'name'),
                   ('products', 'props', 'propId', 'name'), ('banners', 'banners', 'bannerId', 'title')]
    for group, resource, id_field, name_field in definitions:
        existing = listing(resource)
        for item in manifest[group]:
            saved = state[group].get(item['key'])
            if saved:
                if not any(row[id_field] == saved[id_field] for row in existing):
                    raise RuntimeError(f'{group}/{item["key"]} 已被移除，不自动重建。')
            elif any(row[name_field] == item[name_field] for row in existing):
                raise RuntimeError(f'存在非本数据集维护的同名内容：{item[name_field]}，未覆盖。')

    image_keys = sorted({item['key'] for item in manifest['products']} |
                        {item['image'] for item in manifest['banners']})
    for key in image_keys:
        path = ASSETS / (key + '.png')
        content = path.read_bytes()
        digest = hashlib.sha256(content).hexdigest()
        saved = state['images'].get(key)
        if saved:
            if saved['sourceSha256'] != digest:
                raise RuntimeError(f'{key} 素材已变化，请建立新的数据集版本，不覆盖现有引用。')
            image = client.get(base_url + saved['url'], timeout=30)
            if image.status_code != 200 or not image.headers.get('Content-Type', '').startswith('image/'):
                raise RuntimeError(f'{key} 图片不可访问，请检查 UPLOAD_PATH 和媒体文件。')
            continue
        reply = request('POST', '/mall/media/images', files={'file': (path.name, content, 'image/png')})
        state['images'][key] = {'sourceSha256': digest, **reply['data']}
        checkpoint()

    def image_url(key):
        return state['images'][key]['url']

    for item in manifest['categories']:
        if item['key'] not in state['categories']:
            payload = {'name': item['name'], 'iconUrl': image_url(item['icon']), 'sort': item['sort'],
                       'recommended': True, 'status': '1'}
            state['categories'][item['key']] = request('POST', '/mall/categories', json=payload)['data']
            checkpoint()

    categories = {item['key']: item for item in manifest['categories']}
    for item in manifest['products']:
        if item['key'] in state['products']:
            continue
        cover = image_url(item['key'])
        game = categories[item['category']]['name']
        payload = {
            'categoryId': state['categories'][item['category']]['categoryId'], 'name': item['name'],
            'coverUrl': cover, 'price': item['price'], 'originalPrice': item['originalPrice'],
            'images': [{'url': cover, 'sort': 0}],
            'detailHtml': f'<h2>{item["name"]}</h2><p>{item["description"]}</p>'
                          f'<p><img src="{cover}" alt="{item["name"]}"></p>'
                          '<h3>交付说明</h3><p>请填写游戏账号、区服和角色名称。支付后由管理员手动交付，请核对资料后下单。</p>'
                          '<p>本商品为原创虚构游戏道具，用于商城演示。请勿填写游戏密码。</p>',
            'specs': [{'name': '所属游戏', 'value': game}, {'name': '道具类型', 'value': item['type']},
                      {'name': '道具品质', 'value': item['quality']}, {'name': '交付方式', 'value': '游戏内手动交付'}],
            'deliveryFields': ['gameAccount', 'serverName', 'roleName'], 'status': '1', 'initialStock': item['stock']
        }
        state['products'][item['key']] = request('POST', '/mall/props', json=payload)['data']
        checkpoint()

    for item in manifest['banners']:
        if item['key'] not in state['banners']:
            payload = {'title': item['title'], 'imageUrl': image_url(item['image']),
                       'targetPropId': state['products'][item['product']]['propId'],
                       'sort': item['sort'], 'status': '1'}
            state['banners'][item['key']] = request('POST', '/mall/banners', json=payload)['data']
            checkpoint()
    return state


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--base-url', default='http://127.0.0.1:8080')
    parser.add_argument('--state', type=Path)
    args = parser.parse_args()
    token = os.environ.get('GAMESHOP_ADMIN_TOKEN')
    if not token:
        parser.error('请在当前进程配置 GAMESHOP_ADMIN_TOKEN；不要把令牌写入源码或参数。')
    with requests.Session() as session:
        session.headers['Authorization'] = 'Bearer ' + token
        result = seed_catalog(session, args.base_url, args.state)
    print(json.dumps({key: len(result[key]) for key in ['images', 'categories', 'products', 'banners']}, ensure_ascii=False))
