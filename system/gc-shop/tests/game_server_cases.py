"""区服管理、结算及历史快照验证；由 integration.py 注入隔离 SQL/HTTP 环境。"""
import concurrent.futures
import hashlib
import io
import json
import uuid
import requests
from PIL import Image


def run_server_cases(api, sql, admin, buyer, limited, base, results):
    root = '/mall/game-servers'
    original_cart=sql('SELECT * FROM mall_cart_item WHERE cart_item_id=4001')[0]
    cart_columns=[row[0] for row in sql('DESCRIBE mall_cart_item')]
    api('GET', root, expected=401, error='MALL_UNAUTHENTICATED', label='区服管理未登录拒绝')
    api('GET', root, token=buyer, expected=401, error='MALL_UNAUTHENTICATED', label='会员不能访问区服管理')
    api('GET', root, token=limited, expected=403, error='MALL_FORBIDDEN', label='区服查询按权限拒绝')
    valid={'categoryId':'101','name':'一区','sort':0,'status':'1','remark':None}
    for method, path, body in [('POST',root,valid),('PUT',root+'/1',{**valid,'version':0}),('DELETE',root+'/1',None)]:
        api(method,path,body,limited,403,'MALL_FORBIDDEN',label='区服写操作按权限拒绝 '+method)
    initial=api('GET',root+'?categoryId=101&status=1&pageSize=1',token=admin,label='区服分页按游戏状态筛选')
    assert len(initial['rows'])==1 and initial['total']==3
    api('GET',root+'?pageSize=51',token=admin,expected=400,error='MALL_VALIDATION_FAILED',label='区服分页上限校验')
    cat=api('POST','/mall/categories',{'name':'区服测试游戏','iconUrl':None,'sort':9,'recommended':False,'status':'1'},admin,201)['data']
    payload={'categoryId':cat['categoryId'],'name':'测试一区','sort':2,'status':'1','remark':None}
    for patch in [{'name':'   '},{'sort':10000},{'categoryId':'99999999'},{'status':'2'}]:
        expected=404 if 'categoryId' in patch else 400
        api('POST',root,{**payload,**patch},admin,expected,'MALL_RESOURCE_NOT_FOUND' if expected==404 else 'MALL_VALIDATION_FAILED',label='区服字段或所属游戏校验 '+next(iter(patch)))
    first=api('POST',root,payload,admin,201,label='区服新增返回完整资源')['data'];sid=first['serverId']
    assert first['categoryName']==cat['name'] and first['version']==0
    api('POST',root,payload,admin,409,'MALL_DUPLICATE_VALUE',label='同游戏区服名称唯一')
    api('GET',root+'/'+sid,token=admin,label='区服详情')
    def update_body(row,**patch):return {**{k:row[k] for k in ['categoryId','name','sort','status','remark','version']},**patch}
    api('PUT',root+'/'+sid,update_body(first,categoryId='101'),admin,400,'MALL_VALIDATION_FAILED',label='区服不允许变更所属游戏')
    first=api('PUT',root+'/'+sid,update_body(first,name='测试新区'),admin,label='区服编辑与版本递增')['data']
    api('PUT',root+'/'+sid,update_body(first,version=0),admin,409,'MALL_VERSION_CONFLICT',label='区服旧版本修改冲突')
    image=io.BytesIO();Image.new('RGB',(16,16),(60,120,160)).save(image,'PNG')
    media=api('POST','/mall/media/images',token=admin,expected=201,files={'file':('server-test.png',image.getvalue(),'image/png')})['data']['url']
    prop=api('POST','/mall/props',{'categoryId':cat['categoryId'],'name':'区服测试道具','coverUrl':media,'price':'1.00','originalPrice':None,'images':[{'url':media,'sort':0}],'detailHtml':'<p>区服验证</p>','specs':[],'deliveryFields':['gameAccount','serverName','roleName'],'status':'1','initialStock':30},admin,201)['data'];pid=prop['propId']
    items=[{'propId':'1001','quantity':1},{'propId':pid,'quantity':1}]
    def preview(rows=items):
        if len(rows)==1:body={'source':'DIRECT','items':rows}
        else:
            ids=[]
            for row in rows:
                item=api('POST','/api/mall/cart/items',row,buyer)['data']
                cid=next(x['cartItemId'] for x in item['items'] if x['propId']==row['propId'])
                api('PUT','/api/mall/cart/items/'+cid,{'quantity':1,'checked':True},buyer)
                ids.append(cid)
            body={'source':'CART','cartItemIds':ids}
        return api('POST','/api/mall/order-quotes',body,buyer)['data']
    q=preview();groups=q['serverGroups'];assert len(groups)==2 and groups[1]['servers']==[{'serverId':sid,'name':'测试新区'}]
    results.append({'case':'跨游戏报价分别返回对应启用区服','result':'passed'})
    sid1=groups[0]['servers'][0]['serverId']
    request={'quoteToken':q['quoteToken'],'requestKey':str(uuid.uuid4()),'deliveryInfo':{'gameAccount':'server-test','roleName':'角色','serverIds':[sid1,sid]},'remark':None}
    before=sql('SELECT prop_id,stock FROM mall_prop WHERE prop_id IN (1001,%s) ORDER BY prop_id',(pid,))
    for info in [ {'serverIds':[sid1]}, {'serverIds':[sid1,sid1]}, {'serverIds':[sid1,groups[0]['servers'][1]['serverId']]}, {'serverIds':[sid1,sid],'serverName':'一区'}, {'serverIds':['99999999999']}, {'serverName':'随意输入的区服'} ]:
        status=409 if info in ({'serverIds':['99999999999']},{'serverName':'随意输入的区服'}) else 400
        api('POST','/api/mall/orders',{**request,'requestKey':str(uuid.uuid4()),'deliveryInfo':{'gameAccount':'server-test','roleName':'角色',**info}},buyer,status,'MALL_SERVER_UNAVAILABLE' if status==409 else 'MALL_VALIDATION_FAILED',label='下单拒绝错误区服 '+json.dumps(info,ensure_ascii=False))
        assert sql('SELECT prop_id,stock FROM mall_prop WHERE prop_id IN (1001,%s) ORDER BY prop_id',(pid,))==before
    order=api('POST','/api/mall/orders',request,buyer,201,label='跨游戏选择区服真实下单')['data']['order']
    snap=order['deliveryInfo']['servers'];assert len(snap)==2 and snap[1]['serverName']=='测试新区'
    assert sql('SELECT JSON_LENGTH(delivery_info_json,\'$.servers\') FROM mall_order WHERE order_id=%s',(order['orderId'],))[0][0]==2
    unused_quote=preview([{'propId':pid,'quantity':1}])
    pending={'quoteToken':unused_quote['quoteToken'],'requestKey':str(uuid.uuid4()),'deliveryInfo':{'gameAccount':'server-test','roleName':'角色','serverIds':[sid]}}
    first=api('PUT',root+'/'+sid,update_body(first,status='0',name='新区已改名'),admin,label='区服停用并改名')['data']
    assert preview()['serverGroups'][1]['servers']==[]
    api('POST','/api/mall/orders',pending,buyer,409,'MALL_SERVER_UNAVAILABLE',label='旧报价不能下单到已停用区服')
    replay=api('POST','/api/mall/orders',request,buyer,label='停用区服后相同请求仍幂等返回原订单')['data'];assert replay['replayed'] and replay['order']['deliveryInfo']['servers']==snap
    api('DELETE',root+'/'+sid,token=admin,label='区服软删除')
    api('DELETE',root+'/'+sid,token=admin,label='重复删除区服幂等')
    api('GET',root+'/'+sid,token=admin,expected=404,error='MALL_RESOURCE_NOT_FOUND',label='软删除区服不再查询到')
    detail=api('GET','/api/mall/orders/'+order['orderNo'],token=buyer,label='区服删除后订单保留原游戏名称快照')['data'];assert detail['deliveryInfo']['servers']==snap
    api('PUT','/api/mall/orders/'+order['orderNo']+'/cancellation',{'reason':'隔离区服测试结束'},buyer)
    assert sql('SELECT prop_id,stock FROM mall_prop WHERE prop_id IN (1001,%s) ORDER BY prop_id',(pid,))==before
    new=api('POST',root,payload,admin,201,label='删除后可重新创建同名区服')['data'];newid=new['serverId'];assert newid!=sid
    # Existing pending orders remain payable even after the configured server is removed.
    q2=preview([{'propId':pid,'quantity':1}]);single={'quoteToken':q2['quoteToken'],'requestKey':str(uuid.uuid4()),'deliveryInfo':{'gameAccount':'server-test','serverIds':[newid],'roleName':'角色'},'remark':None}
    paid=api('POST','/api/mall/orders',single,buyer,201)['data']['order']
    api('DELETE',root+'/'+newid,token=admin)
    api('POST','/api/mall/orders/'+paid['orderNo']+'/payments',{'result':'SUCCESS'},buyer,label='既有订单区服删除后仍可按快照支付')
    # Legacy client validates configured names and retains its original fingerprint shape.
    legacy_q=preview([{'propId':'1001','quantity':1}]);legacy={'quoteToken':legacy_q['quoteToken'],'requestKey':str(uuid.uuid4()),'deliveryInfo':{'gameAccount':'legacy','serverName':'一区','roleName':'角色'},'remark':None}
    old=api('POST','/api/mall/orders',legacy,buyer,201,label='旧客户端名称匹配真实区服兼容')['data']['order']
    expected_hash=hashlib.sha256(json.dumps([legacy['quoteToken'],legacy['deliveryInfo'],''],ensure_ascii=False,separators=(',',':')).encode()).hexdigest()
    assert sql('SELECT request_hash FROM mall_order WHERE order_id=%s',(old['orderId'],))[0][0]==expected_hash
    api('PUT','/api/mall/orders/'+old['orderNo']+'/cancellation',{'reason':'隔离区服测试结束'},buyer)
    results.append({'case':'旧客户端请求摘要保持兼容且取消恢复库存','result':'passed'})
    # A concurrent stop and creation must serialize; any successful order has a valid snapshot.
    race=api('POST',root,payload,admin,201)['data'];q3=preview([{'propId':pid,'quantity':1}]);race_body={**single,'quoteToken':q3['quoteToken'],'requestKey':str(uuid.uuid4()),'deliveryInfo':{**single['deliveryInfo'],'serverIds':[race['serverId']]}}
    with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
        one=pool.submit(requests.post,base+'/api/mall/orders',headers={'Authorization':'Bearer '+buyer},json=race_body,timeout=20)
        two=pool.submit(requests.put,base+root+'/'+race['serverId'],headers={'Authorization':'Bearer '+admin},json=update_body(race,status='0'),timeout=20)
        created,stopped=one.result(),two.result()
    assert stopped.status_code==200 and created.status_code in (201,409)
    if created.status_code==201:
        o=created.json()['data']['order'];assert o['deliveryInfo']['servers'][0]['serverId']==race['serverId']
        api('PUT','/api/mall/orders/'+o['orderNo']+'/cancellation',{'reason':'并发验证结束'},buyer)
    else:assert created.json()['errorCode']=='MALL_SERVER_UNAVAILABLE'
    assert sql('SELECT stock FROM mall_prop WHERE prop_id=%s',(pid,))[0][0]==29
    results.append({'case':'区服停用与下单并发串行且失败不扣库存','result':'passed'})
    api('DELETE',root+'/'+race['serverId'],token=admin)
    api('DELETE','/mall/props/'+pid,token=admin)
    api('DELETE','/mall/categories/'+cat['categoryId'],token=admin)
    sql('DELETE FROM mall_cart_item WHERE member_id=2001 AND prop_id IN (1001,%s)',(pid,))
    sql('INSERT INTO mall_cart_item ('+','.join(cart_columns)+') VALUES ('+','.join(['%s']*len(cart_columns))+')',original_cart)
