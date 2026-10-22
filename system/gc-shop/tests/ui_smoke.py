import os
from pathlib import Path
import subprocess
import time
import requests
from PIL import Image
from playwright.sync_api import sync_playwright, expect


def run_ui(repo, artifacts, admin_token, results):
    """访问 V003 动态路由，执行真实管理页面操作；服务由调用方隔离。"""
    env=os.environ.copy();env.update({'DEV_HOST':'127.0.0.1','DEV_PORT':'15174','DEV_PROXY_TARGET':'http://127.0.0.1:18089'})
    log=(artifacts/'vite.log').open('w',encoding='utf-8')
    process=subprocess.Popen(['cmd','/c','npm','run','dev'],cwd=repo/'adminsystemui',env=env,stdout=log,stderr=subprocess.STDOUT,creationflags=getattr(subprocess,'CREATE_NO_WINDOW',0))
    try:
        for _ in range(120):
            if process.poll() is not None:raise RuntimeError('Vite 启动失败，见隔离验证 vite.log')
            try:
                if requests.get('http://127.0.0.1:15174',timeout=1).status_code==200:break
            except requests.RequestException:pass
            time.sleep(.5)
        else:raise RuntimeError('Vite 启动超时')
        with sync_playwright() as p:
            browser=p.chromium.launch(executable_path=r'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',headless=True)
            context=browser.new_context(viewport={'width':1440,'height':1000})
            context.add_cookies([{'name':'Admin-Token','value':admin_token,'url':'http://127.0.0.1:15174'}])
            page=context.new_page();errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
            for route,title in [('categories','游戏分类'),('props','道具商品'),('banners','首页轮播'),('members','商城会员'),('orders','商城订单'),('reviews','商品评价'),('stock-logs','库存流水'),('game-servers','游戏区服')]:
                page.goto('http://127.0.0.1:15174/gameshop/'+route,wait_until='networkidle')
                expect(page.get_by_role('heading',name=title,exact=True)).to_be_visible()
                expect(page.get_by_label('操作区域')).to_be_visible()
                expect(page.locator('.el-table__header').get_by_text('操作',exact=True)).to_be_visible()
                assert not page.locator('.error-alert').count(), title
                results.append({'case':'浏览器路由、操作区及真实列表：'+title,'result':'passed'})
            page.goto('http://127.0.0.1:15174/gameshop/game-servers',wait_until='networkidle')
            page.get_by_role('button',name='新增区服',exact=True).click()
            dialog=page.get_by_role('dialog',name='新增区服')
            dialog.locator('.el-form-item').filter(has_text='所属游戏').locator('.el-select').click()
            page.get_by_role('option',name='星海远征',exact=True).click()
            dialog.locator('.el-form-item').filter(has_text='区服名称').locator('input').fill('浏览器测试区服')
            with page.expect_response(lambda r:r.request.method=='POST' and r.url.endswith('/mall/game-servers')) as response:dialog.get_by_role('button',name='保存',exact=True).click()
            assert response.value.status==201;expect(dialog).not_to_be_visible()
            row=page.locator('.el-table__body-wrapper tr').filter(has_text='浏览器测试区服')
            expect(row).to_be_visible();row.get_by_role('button',name='停用',exact=True).click()
            with page.expect_response(lambda r:r.request.method=='PUT' and '/mall/game-servers/' in r.url) as response:page.get_by_role('button',name='确定',exact=True).click()
            assert response.value.status==200;expect(row).to_contain_text('停用')
            row.get_by_role('button',name='修改',exact=True).click()
            dialog=page.get_by_role('dialog',name='修改区服');dialog.locator('.el-form-item').filter(has_text='区服名称').locator('input').fill('浏览器区服修改')
            with page.expect_response(lambda r:r.request.method=='PUT' and '/mall/game-servers/' in r.url) as response:dialog.get_by_role('button',name='保存',exact=True).click()
            assert response.value.status==200;expect(dialog).not_to_be_visible()
            row=page.locator('.el-table__body-wrapper tr').filter(has_text='浏览器区服修改');row.get_by_role('button',name='删除',exact=True).click()
            with page.expect_response(lambda r:r.request.method=='DELETE' and '/mall/game-servers/' in r.url) as response:page.get_by_role('button',name='确定',exact=True).click()
            assert response.value.status==200
            page.screenshot(path=str(artifacts/'admin-game-servers.png'),full_page=True)
            results.append({'case':'浏览器区服新增、停用、修改和删除闭环','result':'passed'})
            page.goto('http://127.0.0.1:15174/gameshop/categories',wait_until='networkidle')
            page.get_by_role('button',name='新增游戏分类',exact=True).click()
            dialog=page.get_by_role('dialog',name='新增游戏分类')
            dialog.locator('input').first.fill('浏览器验证分类')
            with page.expect_response(lambda r:r.request.method=='POST' and r.url.endswith('/mall/categories')) as response:
                dialog.get_by_role('button',name='保存',exact=True).click()
            assert response.value.status==201
            expect(dialog).not_to_be_visible()
            row=page.locator('.el-table__body-wrapper tr').filter(has_text='浏览器验证分类')
            expect(row).to_be_visible();row.get_by_role('button',name='修改',exact=True).click()
            dialog=page.get_by_role('dialog',name='修改游戏分类');dialog.locator('input').first.fill('浏览器验证分类修改')
            with page.expect_response(lambda r:r.request.method=='PUT' and '/mall/categories/' in r.url) as response:dialog.get_by_role('button',name='保存',exact=True).click()
            assert response.value.status==200;expect(dialog).not_to_be_visible()
            row=page.locator('.el-table__body-wrapper tr').filter(has_text='浏览器验证分类修改');row.get_by_role('button',name='删除',exact=True).click()
            with page.expect_response(lambda r:r.request.method=='DELETE' and '/mall/categories/' in r.url) as response:page.get_by_role('button',name='确定',exact=True).click()
            assert response.value.status==200
            results.append({'case':'浏览器分类新增、修改及删除完整闭环','result':'passed'})
            page.goto('http://127.0.0.1:15174/gameshop/props',wait_until='networkidle');page.get_by_role('button',name='新增道具商品',exact=True).click()
            dialog=page.get_by_role('dialog',name='新增道具商品')
            dialog.locator('.el-form-item').filter(has_text='商品名称').locator('input').fill('浏览器验证道具')
            dialog.locator('.el-form-item').filter(has_text='游戏分类').locator('.el-select').click();page.get_by_role('option',name='星海远征',exact=True).click()
            dialog.locator('.el-form-item').filter(has_text='销售价格').locator('input').fill('19.90')
            dialog.locator('.el-form-item').filter(has_text='初始库存').get_by_role('spinbutton').fill('3')
            image=artifacts/'browser-product.png';Image.new('RGB',(96,96),(80,120,180)).save(image)
            with page.expect_response(lambda r:r.request.method=='POST' and r.url.endswith('/mall/media/images')) as response:dialog.locator('input[type=file]').set_input_files(str(image))
            assert response.value.status==201;expect(dialog.locator('.product-image')).to_be_visible();dialog.locator('.ql-editor').fill('浏览器验证商品详情')
            with page.expect_response(lambda r:r.request.method=='POST' and r.url.endswith('/mall/props')) as response:dialog.get_by_role('button',name='保存',exact=True).click()
            assert response.value.status==201,(response.value.status,response.value.json().get('msg'))
            expect(dialog).not_to_be_visible();row=page.locator('.el-table__body-wrapper tr').filter(has_text='浏览器验证道具');row.get_by_role('button',name='调整库存',exact=True).click()
            stock=page.get_by_role('dialog',name='调整可售库存');stock.get_by_role('spinbutton').fill('2');stock.locator('textarea').fill('浏览器验证补货')
            with page.expect_response(lambda r:r.request.method=='POST' and '/stock-adjustments' in r.url) as response:stock.get_by_role('button',name='确认调整',exact=True).click()
            assert response.value.status==200;expect(stock).not_to_be_visible();expect(row).to_contain_text('5')
            results.append({'case':'浏览器商品图片上传、创建及库存调整闭环','result':'passed'})
            page.screenshot(path=str(artifacts/'admin-props.png'),full_page=True)
            page.goto('http://127.0.0.1:15174/gameshop/orders',wait_until='networkidle')
            page.locator('.search-panel .el-form-item').filter(has_text='订单号').locator('input').fill('GC202610222000000002');page.get_by_role('button',name='搜索',exact=True).click()
            row=page.locator('.el-table__body-wrapper tr').filter(has_text='GC202610222000000002');row.get_by_role('button',name='登记交付',exact=True).click();page.locator('.el-message-box textarea').fill('浏览器验证道具已发放到角色背包')
            with page.expect_response(lambda r:r.request.method=='PUT' and r.url.endswith('/delivery')) as response:page.get_by_role('button',name='确认',exact=True).click()
            assert response.value.status==200;expect(row).to_contain_text('已完成')
            row.get_by_role('button',name='查看',exact=True).click();expect(page.get_by_role('heading',name='交付资料',exact=True)).to_be_visible()
            page.screenshot(path=str(artifacts/'admin-order.png'),full_page=True,animations='disabled')
            results.append({'case':'浏览器订单交付、状态刷新和详情查看','result':'passed'})
            assert not errors, errors
            results.append({'case':'八页及操作闭环无浏览器脚本异常','result':'passed'})
            browser.close()
    finally:
        subprocess.run(['taskkill','/PID',str(process.pid),'/T','/F'],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL,check=False)
        process.wait(timeout=15);log.close()
