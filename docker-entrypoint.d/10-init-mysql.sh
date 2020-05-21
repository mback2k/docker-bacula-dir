#!/bin/bash -e

if [ -f "${BACULA_CATALOG_DATABASE_PASS_FILE}" ]; then
    BACULA_CATALOG_DATABASE_PASS="$(< "${BACULA_CATALOG_DATABASE_PASS_FILE}")"
fi

echo "
[client]
host=\"${BACULA_CATALOG_DATABASE_HOST}\"
database=\"${BACULA_CATALOG_DATABASE_NAME}\"
user=\"${BACULA_CATALOG_DATABASE_USER}\"
password=\"${BACULA_CATALOG_DATABASE_PASS}\"
" > ~/.my.cnf

export db_name="${BACULA_CATALOG_DATABASE_NAME}"

/usr/share/bacula-director/update_mysql_tables || \
/usr/share/bacula-director/make_mysql_tables

unset db_name

shred ~/.my.cnf
rm ~/.my.cnf

unset BACULA_CATALOG_DATABASE_PASS

exit 0
