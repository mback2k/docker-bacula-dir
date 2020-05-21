#!/bin/bash -e

if [ -f "${BACULA_CATALOG_DATABASE_PASS_FILE}" ]; then
    BACULA_CATALOG_DATABASE_PASS="$(< "${BACULA_CATALOG_DATABASE_PASS_FILE}")"
fi

if [ -f "${BACULA_CONSOLE_PASS_FILE}" ]; then
    BACULA_CONSOLE_PASS="$(< "${BACULA_CONSOLE_PASS_FILE}")"
fi

if [ -f "${BACULA_STORAGE_PASS_FILE}" ]; then
    BACULA_STORAGE_PASS="$(< "${BACULA_STORAGE_PASS_FILE}")"
fi

echo "
Password = \"${BACULA_CATALOG_DATABASE_PASS}\"
" > /etc/bacula/catalog-password

chmod 600 /etc/bacula/catalog-password

echo "
Password = \"${BACULA_CONSOLE_PASS}\"
" > /etc/bacula/bconsole-password

chmod 600 /etc/bacula/bconsole-password

echo "
Password = \"${BACULA_STORAGE_PASS}\"
" > /etc/bacula/bacula-sd-password

chmod 600 /etc/bacula/bacula-sd-password

echo "
Password = \"$(openssl rand -hex 42)\"
" > /etc/bacula/bacula-dir-password

chmod 600 /etc/bacula/bacula-dir-password

exit 0
