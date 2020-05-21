#!/bin/bash -e

echo "
Director {
  Name = bacula-dir
  DirPort = 9101
  Address = localhost
  @/etc/bacula/bconsole-password
}
" > /etc/bacula/bconsole.conf

exit 0
