FROM mback2k/ubuntu:rolling

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        debconf-utils mailutils openssl && \
    echo "bacula-director-mysql bacula-director-mysql/dbconfig-install boolean false" | \
        debconf-set-selections && \
    echo "bacula-director-mysql bacula-director-mysql/dbconfig-reinstall boolean false" | \
        debconf-set-selections && \
    echo "bacula-director-mysql bacula-director-mysql/dbconfig-upgrade boolean false" | \
        debconf-set-selections && \
    echo "bacula-director-mysql bacula-director-mysql/dbconfig-remove boolean false" | \
        debconf-set-selections && \
    apt-get install -y --no-install-recommends \
        bacula-director bacula-director-mysql bacula-console bacula-fd && \
    apt-get clean

RUN sed -i 's/`/\\`/g' /usr/share/bacula-director/make_mysql_tables && \
    sed -i 's/db_name=XXX_DBNAME_XXX/db_name=\${db_name:-XXX_DBNAME_XXX}/g' \
        /usr/share/bacula-director/update_mysql_tables && \
    echo "column-statistics=0" >> /etc/mysql/conf.d/mysqldump.cnf

EXPOSE 9101

VOLUME /run/bacula
VOLUME /var/lib/bacula

ADD docker-entrypoint.d/ /run/docker-entrypoint.d/
ENV DOCKER_ENV_HIDEVARS BACULA_CATALOG_DATABASE_PASS BACULA_CONSOLE_PASS BACULA_STORAGE_PASS

CMD ["/usr/sbin/bacula-dir", "-f"]
