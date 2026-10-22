"""Verify the gc namespace upgrade against the exported snapshot and a pre-upgrade jar.

Run from system: python gc-shop/tests/namespace_upgrade.py --old-jar <backup.jar>
Uses only an owned temporary MySQL database, empty Redis DB and port 18091.
"""
import argparse
import json
import os
from pathlib import Path
import re
import socket
import subprocess
import sys
import time
import uuid
import zipfile

import pymysql
from pymysql.constants import CLIENT
import requests

SYSTEM = Path(__file__).resolve().parents[2]
ROOT = SYSTEM.parent
sys.path.insert(0, str(ROOT / 'systemUI/tests/live'))
from run import CFG, redis


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--old-jar', type=Path, required=True)
    args = parser.parse_args()
    old_jar = args.old_jar.resolve(strict=True)
    new_jar = (SYSTEM / 'gc-admin/target/gc-admin.jar').resolve(strict=True)
    owner = uuid.uuid4().hex
    database = 'gc_namespace_test_' + owner[:12]
    owner_key = '__gc_namespace_test_owner'
    artifacts = ROOT / 'systemUI/.live-test-results' / ('namespace-' + owner[:12])
    artifacts.mkdir(parents=True)
    backend, mysql, redis_db, created = None, None, None, False
    checks = []
    base = 'http://127.0.0.1:18091'

    def check(name, condition):
        assert condition, name
        checks.append(name)

    def sql(statement, params=None):
        with mysql.cursor() as cursor:
            cursor.execute(statement, params)
            return cursor.fetchall()

    def get(path, token=None):
        response = requests.get(base + path, headers={'Authorization': 'Bearer ' + token} if token else {}, timeout=10)
        check('HTTP 200 ' + path, response.status_code == 200)
        value = response.json()
        check('API success ' + path, value.get('code') == 200)
        return value

    def start(jar, label):
        nonlocal backend
        environment = {**os.environ, **CFG, 'DB_NAME': database,
            'DB_URL': f"jdbc:mysql://{CFG['DB_HOST']}:{CFG['DB_PORT']}/{database}?useUnicode=true&characterEncoding=UTF-8&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia%2FShanghai",
            'REDIS_DATABASE': str(redis_db), 'SERVER_PORT': '18091', 'SPRING_PROFILES_ACTIVE': 'dev',
            'LOG_PATH': str(artifacts / label), 'UPLOAD_PATH': str(artifacts / 'uploads')}
        java = Path(environment.get('JAVA_HOME', 'D:/java')) / 'bin/java.exe'
        with (artifacts / (label + '.log')).open('w', encoding='utf-8') as log:
            backend = subprocess.Popen([str(java), '-Duser.timezone=Asia/Shanghai', '-jar', str(jar)],
                cwd=SYSTEM, env=environment, stdout=log, stderr=subprocess.STDOUT,
                creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
        for _ in range(120):
            assert backend.poll() is None, label + ' backend exited; inspect its log'
            try:
                if requests.get(base + '/api/mall/home', timeout=1).status_code == 200:
                    check(label + ' starts with exported data', True)
                    return
            except requests.RequestException:
                pass
            time.sleep(0.5)
        raise RuntimeError(label + ' startup timed out')

    def stop():
        nonlocal backend
        if backend and backend.poll() is None:
            backend.terminate()
            try:
                backend.wait(timeout=15)
            except subprocess.TimeoutExpired:
                backend.kill()
                backend.wait(timeout=10)
        backend = None

    try:
        with socket.socket() as probe:
            probe.bind(('127.0.0.1', 18091))
        for candidate in range(15, 6, -1):
            if redis(candidate, 'DBSIZE') == 0 and redis(candidate, 'SET', owner_key, owner, 'NX') == 'OK':
                redis_db = candidate
                break
        assert redis_db is not None, 'No empty Redis DB available'
        assert re.fullmatch(r'gc_namespace_test_[0-9a-f]{12}', database) and database != CFG['DB_NAME']
        mysql = pymysql.connect(host=CFG['DB_HOST'], port=int(CFG['DB_PORT']), user=CFG['DB_USERNAME'],
            password=CFG['DB_PASSWORD'], charset='utf8mb4', autocommit=True, client_flag=CLIENT.MULTI_STATEMENTS)
        with mysql.cursor() as cursor:
            cursor.execute('CREATE DATABASE `' + database + '` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci')
            created = True
            cursor.execute('USE `' + database + '`')
            snapshot = (ROOT / 'sql/gc_system_full.sql').read_text(encoding='utf-8')
            snapshot, removed = re.subn(r'^CREATE DATABASE .*;\s*$', '', snapshot, flags=re.MULTILINE)
            snapshot, selected = re.subn(r'^USE `gc_system`;\s*$', 'USE `' + database + '`;', snapshot, flags=re.MULTILINE)
            assert removed == selected == 1 and 'USE `gc_system`' not in snapshot
            cursor.execute(snapshot)
            while cursor.nextset():
                pass
        expected = json.loads((ROOT / 'sql/校验结果.json').read_text(encoding='utf-8'))
        tables = [r[0] for r in sql('SHOW TABLES')]
        check('all snapshot tables restored', len(tables) == expected['tables'])
        for table in tables:
            assert re.fullmatch(r'[A-Za-z0-9_]+', table)
            check('snapshot row count ' + table,
                  sql('SELECT COUNT(*) FROM `' + table + '`')[0][0] == expected['rowCounts'][table])
        with zipfile.ZipFile(ROOT / 'sql/uploads.zip') as archive:
            for entry in archive.infolist():
                assert (artifacts / entry.filename).resolve().is_relative_to(artifacts.resolve())
            archive.extractall(artifacts)
        start(old_jar, 'before')
        challenge = requests.get(base + '/captchaImage', timeout=10).json()
        code = json.loads(redis(redis_db, 'GET', 'captcha_codes:' + challenge['uuid']))
        login = requests.post(base + '/login', json={'username': 'admin', 'password': 'admin123',
                              'uuid': challenge['uuid'], 'code': code}, timeout=15).json()
        check('old jar authenticates snapshot administrator', login.get('code') == 200)
        token = login['token']
        identity = get('/getInfo', token)['user']['userId']
        get('/system/dict/data/type/sys_normal_disable', token)
        check('old jar wrote old namespace session types', any(
            'com.ruoyi.common.core.domain.model.LoginUser' in redis(redis_db, 'GET', key)
            for key in redis(redis_db, 'KEYS', 'login_tokens:*')))
        stop()
        job_filter = "invoke_target='gameshopOrderExpiry.closeExpired()'"
        prior_jobs = sql('SELECT COUNT(*) FROM sys_job_log WHERE ' + job_filter)[0][0]
        start(new_jar, 'after')
        check('old login token remains valid after upgrade', get('/getInfo', token)['user']['userId'] == identity)
        for path in ('/getRouters', '/system/dict/data/type/sys_normal_disable', '/mall/props',
                     '/mall/orders', '/api/mall/me', '/api/mall/cart/items', '/api/mall/home'):
            get(path, token)
        for (url,) in sql("SELECT m.access_path FROM mall_prop p JOIN mall_media m ON p.cover_media_id=m.media_id WHERE p.del_flag='0'"):
            check('existing product image loads', requests.get(base + url, timeout=10).status_code == 200)
        deadline = time.monotonic() + 75
        while time.monotonic() < deadline:
            if sql('SELECT COUNT(*) FROM sys_job_log WHERE ' + job_filter)[0][0] > prior_jobs:
                break
            time.sleep(1)
        check('renamed Quartz job executes successfully', sql(
            'SELECT status FROM sys_job_log WHERE ' + job_filter + ' ORDER BY job_log_id DESC LIMIT 1') == (('0',),)
            and sql('SELECT COUNT(*) FROM sys_job_log WHERE ' + job_filter)[0][0] > prior_jobs)
        stop()
        after_log = (artifacts / 'after.log').read_text(encoding='utf-8', errors='replace')
        check('new backend logs contain no errors', not re.search(r'\bERROR\b|ClassNotFoundException|InvalidClassException', after_log))
        report = {'passed': len(checks), 'checks': checks, 'isolated': True,
                  'snapshotTables': len(tables), 'snapshotRows': expected['totalRows']}
        (artifacts / 'namespace-upgrade.json').write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf-8')
        print(f'PASS: {len(checks)} snapshot / old session / API / media / Quartz upgrade checks.', flush=True)
        print('Report: ' + str(artifacts / 'namespace-upgrade.json'), flush=True)
    finally:
        stop()
        if mysql:
            try:
                if created:
                    assert re.fullmatch(r'gc_namespace_test_[0-9a-f]{12}', database) and database != CFG['DB_NAME']
                    with mysql.cursor() as cursor:
                        cursor.execute('DROP DATABASE `' + database + '`')
            finally:
                mysql.close()
        if redis_db is not None and redis(redis_db, 'GET', owner_key) == owner:
            keys = redis(redis_db, 'KEYS', '*')
            if keys:
                redis(redis_db, 'DEL', *keys)
        print('Cleaned up owned test resources.', flush=True)


if __name__ == '__main__':
    main()
