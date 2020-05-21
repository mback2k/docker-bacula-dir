#!/bin/bash -e

echo "
Director {
  Name = bacula-dir
  @/etc/bacula/bacula-dir-password
}

FileDaemon {
  Name = bacula-dir-fd
  WorkingDirectory = \"/var/lib/bacula\"
  PidDirectory = \"/run/bacula\"
  PluginDirectory = \"/usr/lib/bacula\"
  Maximum Concurrent Jobs = 20
  FD Address = 127.0.0.1
  FD Port = 9102
}

Messages {
  Name = Standard

  director = bacula-dir = all, !skipped, !restored
}
" > /etc/bacula/bacula-fd.conf

exit 0
