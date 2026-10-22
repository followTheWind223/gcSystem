"""Run the storefront against a real, isolated Spring Boot / MySQL / Redis stack.

Only gc_ui_test_<random> databases and a previously empty Redis DB are used.
The captcha/mail helper is test-only and is never imported by the application.
"""
import hashlib
import hmac
import os
from pathlib import Path
import re
import shutil
import socket
import subprocess
import sys
import time
import uuid

import pymysql
from pymysql.constants import CLIENT
import requests
from PIL import Image

UI = Path(__file__).resolve().parents[2]
SYSTEM = UI.parent / 'system'
CFG = dict(line.split('=', 1) for line in (SYSTEM / '.env').read_text(encoding='utf-8-sig').splitlines()
           if line and not line.startswith('#') and '=' in line)
CFG = {k.strip(): v.strip() for k, v in CFG.items()}
OWNER_KEY = '__storefront_live_test_owner'


def redis(database, *args):
    with socket.create_connection((CFG.get('REDIS_HOST', '127.0.0.1'), int(CFG.get('REDIS_PORT', '6379'))), timeout=5) as sock:
        stream = sock.makefile('rb')

        def read():
            kind, raw = stream.read(1), stream.readline().rstrip(b'\r\n')
            if kind == b'+': return raw.decode()
            if kind == b':': return int(raw)
            if kind == b'-': raise RuntimeError('Redis rejected the test command')
            if kind == b'*': return [read() for _ in range(int(raw))]
            if kind == b'$':
                count = int(raw)
                if count < 0: return None
                result = stream.read(count); stream.read(2)
                return result.decode()
            raise RuntimeError('Invalid Redis response')

        def send(command):
            data = [str(value).encode() for value in command]
            sock.sendall(b'*' + str(len(data)).encode() + b'\r\n' + b''.join(
                b'$' + str(len(value)).encode() + b'\r\n' + value + b'\r\n' for value in data))
            return read()

        if CFG.get('REDIS_PASSWORD'): send(['AUTH', CFG['REDIS_PASSWORD']])
        send(['SELECT', database])
        return send(args)


def helper():
    database = int(os.environ['MALL_TEST_REDIS_DATABASE'])
    assert 7 <= database <= 15 and redis(database, 'GET', OWNER_KEY) == os.environ['MALL_TEST_OWNER']
    if sys.argv[1] == 'ruoyi-captcha':
        import json
        value = redis(database, 'GET', 'captcha_codes:' + sys.argv[2])
        assert value is not None, 'Captcha missing'
        print(json.loads(value))
    elif sys.argv[1] == 'captcha':
        captcha_id = sys.argv[2]
        digest = redis(database, 'GET', 'mall:captcha:' + captcha_id)
        answer = next(str(n) for n in range(19) if hmac.new(CFG['GAMESHOP_CODE_SECRET'].encode(),
            (captcha_id + ':' + str(n)).encode(), hashlib.sha256).hexdigest() == digest)
        print(answer)
    elif sys.argv[1] == 'mail':
        scene, email = sys.argv[2:4]
        assert scene in ('REGISTER', 'RESET_PASSWORD')
        filename = hashlib.sha256((email + ':' + scene).encode()).hexdigest() + '.txt'
        content = (Path(os.environ['MALL_TEST_MAILBOX']) / filename).read_text(encoding='utf-8')
        print(re.search(r'Code: (\d{6})', content).group(1))
    else:
        raise RuntimeError('Unknown test helper')


def run(email_policy=None, ruoyi_auth=False):
    owner = uuid.uuid4().hex
    database = 'gc_ui_test_' + owner[:12]
    assert re.fullmatch(r'gc_ui_test_[0-9a-f]{12}', database) and database != CFG['DB_NAME']
    artifacts = UI / '.live-test-results' / owner[:12]
    artifacts.mkdir(parents=True)
    redis_db, mysql, created = None, None, False
    children = []
    try:
        # Fail before creating anything if another process owns either test port.
        for port in (18090, 15173):
            with socket.socket() as probe:
                probe.bind(('127.0.0.1', port))
        for candidate in range(15, 6, -1):
            if redis(candidate, 'DBSIZE') == 0 and redis(candidate, 'SET', OWNER_KEY, owner, 'NX') == 'OK':
                redis_db = candidate
                break
        assert redis_db is not None, 'No empty Redis database 7-15; existing data was not touched'
        mysql = pymysql.connect(host=CFG['DB_HOST'], port=int(CFG['DB_PORT']), user=CFG['DB_USERNAME'],
            password=CFG['DB_PASSWORD'], charset='utf8mb4', autocommit=True, client_flag=CLIENT.MULTI_STATEMENTS)
        with mysql.cursor() as cursor:
            cursor.execute('CREATE DATABASE `' + database + '` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci')
            created = True
            cursor.execute('USE `' + database + '`')
            for filename in ('upstream/ry_20260417.sql', 'upstream/quartz.sql',
                'migrations/V001__create_mall_tables.sql', 'demo/D001__mall_demo.sql',
                'migrations/V002__register_order_expiry_job.sql', 'migrations/V003__register_admin_menus.sql', 'migrations/V004__customize_admin_brand.sql', 'migrations/V005__prune_admin_menus.sql', 'migrations/V006__game_servers.sql'):
                cursor.execute((SYSTEM / 'sql' / filename).read_text(encoding='utf-8'))
                while cursor.nextset(): pass
            if ruoyi_auth:
                cursor.execute((SYSTEM / 'sql/migrations/V007__ruoyi_storefront_identity.sql').read_text(encoding='utf-8'))
                while cursor.nextset(): pass
            else:
                cursor.execute("UPDATE sys_config SET config_value='false' WHERE config_key='sys.account.captchaEnabled'")
            cursor.execute("UPDATE sys_job SET status='1' WHERE invoke_target='gameshopOrderExpiry.closeExpired()'")
        image_path = artifacts / 'uploads/mall/2026/10/22/0123456789abcdef0123456789abcdef.png'
        image_path.parent.mkdir(parents=True)
        shutil.copyfile(UI / 'public/images/hero-sword.png', image_path)
        Image.new('RGB', (64, 64), '#38d9ae').save(artifacts / 'avatar.png')
        backend_env = {**os.environ, **CFG, 'DB_NAME': database,
            'DB_URL': f"jdbc:mysql://{CFG['DB_HOST']}:{CFG['DB_PORT']}/{database}?useUnicode=true&characterEncoding=UTF-8&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia%2FShanghai",
            'REDIS_DATABASE': str(redis_db), 'SERVER_PORT': '18090', 'GAMESHOP_MAILBOX_PATH': str(artifacts / 'mailbox'),
            'LOG_PATH': str(artifacts / 'logs'), 'UPLOAD_PATH': str(artifacts / 'uploads'),
            'SPRING_PROFILES_ACTIVE': 'dev', 'GAMESHOP_MAIL_MODE': 'file', 'GAMESHOP_CAPTCHA_ENABLED': 'true',
            'GAMESHOP_EMAIL_VERIFICATION_ENABLED': 'false' if email_policy == 'off' else 'true'}
        java = Path(backend_env.get('JAVA_HOME', 'D:/java')) / 'bin/java.exe'
        with (artifacts / 'backend.log').open('w', encoding='utf-8') as log:
            backend = subprocess.Popen([str(java), '-Duser.timezone=Asia/Shanghai', '-jar',
                os.environ.get('MALL_TEST_JAR', str(SYSTEM / 'ruoyi-admin/target/ruoyi-admin.jar'))], cwd=SYSTEM, env=backend_env,
                stdout=log, stderr=subprocess.STDOUT, creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
            children.append(backend)
        for attempt in range(120):
            if backend.poll() is not None: raise RuntimeError('Isolated backend exited; see backend.log')
            try:
                if requests.get('http://127.0.0.1:18090/api/mall/home', timeout=1).status_code == 200: break
            except requests.RequestException: pass
            time.sleep(0.5)
        else: raise RuntimeError('Isolated backend startup timed out')
        frontend_env = {**os.environ, 'DEV_PROXY_TARGET': 'http://127.0.0.1:18090', 'VITE_USE_MOCK': 'false'}
        with (artifacts / 'vite.log').open('w', encoding='utf-8') as log:
            frontend = subprocess.Popen(['node', 'node_modules/vite/bin/vite.js', '--mode', 'api', '--port', '15173'],
                cwd=UI, env=frontend_env, stdout=log, stderr=subprocess.STDOUT,
                creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
            children.append(frontend)
        for attempt in range(40):
            if frontend.poll() is not None: raise RuntimeError('Isolated Vite exited; see vite.log')
            try:
                if requests.get('http://127.0.0.1:15173/api/mall/home', timeout=1).status_code == 200: break
            except requests.RequestException: pass
            time.sleep(0.25)
        else: raise RuntimeError('Isolated Vite startup timed out')
        test_env = {**os.environ, 'MALL_TEST_REDIS_DATABASE': str(redis_db), 'MALL_TEST_OWNER': owner,
            'MALL_TEST_MAILBOX': str(artifacts / 'mailbox'), 'MALL_TEST_ARTIFACTS': str(artifacts),
            'MALL_TEST_PYTHON': sys.executable, 'MALL_TEST_EMAIL_POLICY': email_policy or 'on'}
        if ruoyi_auth:
            from ruoyi_auth import verify
            verify(mysql, redis_db, artifacts)
            subprocess.run(['node', 'tests/live/ruoyi-auth.mjs'], cwd=UI, env=test_env, check=True, timeout=180)
            print('PASS: unified RuoYi authentication and storefront browser checks.', flush=True)
            return
        print('Real backend and proxy ready; running Chrome storefront checks.', flush=True)
        script = 'tests/live/email-policy.mjs' if email_policy else 'tests/live/browser.mjs'
        subprocess.run(['node', script], cwd=UI, env=test_env, check=True, timeout=180)
        if email_policy:
            with mysql.cursor() as cursor:
                cursor.execute("SELECT email_verified FROM mall_member WHERE username='email_policy_user'")
                assert cursor.fetchone() == (0 if email_policy == 'off' else 1,)
            if email_policy == 'off':
                assert not list((artifacts / 'mailbox').glob('*.txt'))
            print('PASS: persisted email verification status and mailbox policy.', flush=True)
            return
        with mysql.cursor() as cursor:
            cursor.execute("SELECT status, total_amount FROM mall_order WHERE member_id=(SELECT member_id FROM mall_member WHERE username='ui_live_player') ORDER BY order_id")
            orders = cursor.fetchall()
            assert [(s, str(a)) for s, a in orders] == [('4', '99.80'), ('3', '49.90')], orders
            cursor.execute("SELECT COUNT(*) FROM mall_review WHERE member_id=(SELECT member_id FROM mall_member WHERE username='ui_live_player')")
            assert cursor.fetchone()[0] == 1
            cursor.execute('SELECT stock,sales FROM mall_prop WHERE prop_id=1001')
            assert cursor.fetchone() == (6, 7)
        print('PASS: MySQL persisted completed/cancelled orders, one review, stock and sales.', flush=True)
    finally:
        for child in reversed(children):
            if child.poll() is None:
                if os.name == 'nt':
                    subprocess.run(['taskkill', '/PID', str(child.pid), '/T', '/F'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                else: child.terminate()
                child.wait(timeout=15)
        if mysql:
            try:
                if created:
                    assert re.fullmatch(r'gc_ui_test_[0-9a-f]{12}', database) and database != CFG['DB_NAME']
                    with mysql.cursor() as cursor: cursor.execute('DROP DATABASE `' + database + '`')
            finally: mysql.close()
        if redis_db is not None and redis(redis_db, 'GET', OWNER_KEY) == owner:
            keys = redis(redis_db, 'KEYS', '*')
            if keys: redis(redis_db, 'DEL', *keys)
        print('Isolated test processes, database and Redis keys cleaned up.', flush=True)


if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] == '--ruoyi-auth':
        run(ruoyi_auth=True)
    elif len(sys.argv) == 2 and sys.argv[1] in ('--email-policy=off', '--email-policy=on'):
        raise SystemExit('Legacy email-auth tests were retired in V007. Run --ruoyi-auth instead.')
    elif len(sys.argv) > 1: helper()
    else: run(ruoyi_auth=True)
