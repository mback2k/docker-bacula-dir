#!/bin/bash -e

echo "
Director {
  Name = bacula-dir
  @/etc/bacula/bconsole-password
  Messages = Standard
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
  File Retention = 60 days
  Job Retention = 6 months
  AutoPrune = yes
}

Messages {
  Name = Standard

  stdout = all, !skipped, !saved
  console = all, !skipped, !saved
  catalog = all
}
" > /etc/bacula/bacula-dir.conf

exit 0
