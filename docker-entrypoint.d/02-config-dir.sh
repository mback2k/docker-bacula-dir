#!/bin/bash -e

echo "
Director {
  Name = bacula-dir
  @/etc/bacula/bconsole-password
  Messages = Daemon
  WorkingDirectory = \"/var/lib/bacula\"
  PidDirectory = \"/run/bacula\"
  QueryFile = \"/etc/bacula/scripts/query.sql\"
  Maximum Concurrent Jobs = 20
  DirAddress = 0.0.0.0
  DirPort = 9101
}

Autochanger {
  Name = bacula-sd
  Address = bacula-sd
  SD Port = 9103
  @/etc/bacula/bacula-sd-password
  Device = VirtualDiskDrive
  Media Type = VirtualDisk
  Maximum Concurrent Jobs = 10
}

Client {
  Name = bacula-dir-fd
  Address = localhost
  FD Port = 9102
  Catalog = Catalog
  @/etc/bacula/bacula-dir-password
  File Retention = 3 months
  Job Retention = 3 months
  AutoPrune = yes
}

Messages {
  Name = Standard

  mailcommand = \"/usr/sbin/bsmtp -8 -h ${BACULA_MESSAGES_HOST:-bsmtp} -f '(Bacula) <%r>' -s 'Bacula: %t %e of %c %l' %r\"
  operatorcommand = \"/usr/sbin/bsmtp -8 -h ${BACULA_MESSAGES_HOST:-bsmtp} -f '(Bacula) <%r>' -s 'Bacula: Intervention needed for %j' %r\"
  mail on error = ${BACULA_MESSAGES_USER:-root@localhost} = all, !skipped, !info
  operator = ${BACULA_MESSAGES_USER:-root@localhost} = mount

  console = all, !skipped, !saved
  stdout = all, !skipped

  catalog = all
}

Messages {
  Name = Daemon

  mailcommand = \"/usr/sbin/bsmtp -8 -h ${BACULA_MESSAGES_HOST:-bsmtp} -f '(Bacula) <%r>' -s 'Bacula daemon message' %r\"
  mail = ${BACULA_MESSAGES_USER:-root@localhost} = all, !skipped, !info

  console = all, !skipped, !saved
  stdout = all, !skipped
}
" > /etc/bacula/bacula-dir.conf

exit 0
