"""Apply V007 once, after stopping the application; full backup precedes every mutation."""
import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess
import pymysql
from pymysql.constants import CLIENT

SYSTEM = Path(__file__).resolve().parents[1]

def main():
    cfg = dict(line.split('=', 1) for line in (SYSTEM / '.env').read_text(encoding='utf-8-sig').splitlines()
               if line and not line.startswith('#') and '=' in line)
    cfg = {key.strip(): value.strip() for key, value in cfg.items()}
    connection = pymysql.connect(host=cfg['DB_HOST'], port=int(cfg['DB_PORT']), user=cfg['DB_USERNAME'],
        password=cfg['DB_PASSWORD'], database=cfg['DB_NAME'], charset='utf8mb4', autocommit=True, client_flag=CLIENT.MULTI_STATEMENTS)
    def query(sql, args=None):
        with connection.cursor() as cursor:
            cursor.execute(sql, args)
            return cursor.fetchall() if cursor.description else cursor.rowcount
    try:
        if query("SELECT version FROM mall_schema_history WHERE version='V007'"):
            print('V007 already installed; no changes made.')
            return
        assert query("SELECT version FROM mall_schema_history WHERE version='V006'"), 'V006 required'
        assert query("SELECT COUNT(*) FROM mall_member m JOIN sys_user u ON CONVERT(m.username USING utf8mb4) COLLATE utf8mb4_unicode_ci=u.user_name COLLATE utf8mb4_unicode_ci")[0][0] == 0, 'Username conflict; migration aborted without merging identities'
        assert query("SELECT COUNT(*) FROM sys_role WHERE role_key='common' AND del_flag='0'")[0][0] == 1, 'Expected one ordinary role'
        stamp = datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
        backup = SYSTEM / 'data/backups' / ('pre-V007-' + stamp + '.sql')
        backup.parent.mkdir(parents=True, exist_ok=True)
        dump = shutil.which('mysqldump')
        assert dump, 'mysqldump required; no database changes made'
        with backup.open('wb') as stream:
            subprocess.run([dump, '--host=' + cfg['DB_HOST'], '--port=' + cfg['DB_PORT'], '--user=' + cfg['DB_USERNAME'],
                '--single-transaction', '--routines', '--triggers', '--events', '--set-gtid-purged=OFF', '--no-tablespaces', cfg['DB_NAME']],
                env={**os.environ, 'MYSQL_PWD': cfg['DB_PASSWORD']}, stdout=stream, stderr=subprocess.PIPE, check=True)
        assert backup.stat().st_size > 1000, 'Backup incomplete'
        legacy = query('SELECT member_id,username,password_hash FROM mall_member ORDER BY member_id')
        before = dict(query("SELECT 'orders',COUNT(*) FROM mall_order UNION ALL SELECT 'cart',COUNT(*) FROM mall_cart_item UNION ALL SELECT 'reviews',COUNT(*) FROM mall_review UNION ALL SELECT 'products',COUNT(*) FROM mall_prop"))
        with connection.cursor() as cursor:
            cursor.execute((SYSTEM / 'sql/migrations/V007__ruoyi_storefront_identity.sql').read_text(encoding='utf-8'))
            while cursor.nextset(): pass
        for mid, username, password_hash in legacy:
            row = query('SELECT m.member_id,u.user_name,u.password,m.password_hash FROM mall_member m JOIN sys_user u ON u.user_id=m.sys_user_id WHERE m.member_id=%s', (mid,))[0]
            assert row == (mid, username, password_hash, None), 'Legacy identity verification failed'
        after = dict(query("SELECT 'orders',COUNT(*) FROM mall_order UNION ALL SELECT 'cart',COUNT(*) FROM mall_cart_item UNION ALL SELECT 'reviews',COUNT(*) FROM mall_review UNION ALL SELECT 'products',COUNT(*) FROM mall_prop"))
        assert before == after, 'Business row counts changed'
        assert query("SELECT COUNT(*) FROM sys_role_menu m JOIN sys_role r ON r.role_id=m.role_id WHERE r.role_key='common'")[0][0] == 0
        report = {'version': 'V007', 'backup': str(backup), 'migratedMembers': len(legacy), 'businessRows': after,
                  'defaultRole': 'common', 'ordinaryRoleMenuCount': 0, 'legacyPasswordsPreserved': True}
        (SYSTEM / 'data/backups' / ('V007-' + stamp + '.json')).write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf-8')
        print(json.dumps({key: value for key, value in report.items() if key != 'backup'}, ensure_ascii=True))
    finally:
        connection.close()

if __name__ == '__main__':
    main()
