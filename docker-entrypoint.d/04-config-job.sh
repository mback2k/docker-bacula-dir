#!/bin/bash -e

echo "
JobDefs {
  Name = Defaults
  Type = Backup
  Level = Full
  Accurate = yes
  Write Bootstrap = \"/var/lib/bacula/%c.bsr\"
  Messages = Standard
  Pool = FilePool
  Schedule = WeeklyCycle
  Spool Attributes = yes
  Priority = 10
}

Job {
  Name = FileRestore
  Type = Restore
  Client = bacula-dir-fd
# The FileSet and Pool directives are not used by Restore Jobs
# but must not be removed
  FileSet = CatalogFileSet
  Pool = CatalogPool
  Storage = bacula-sd
  Messages = Standard
  Where = /tmp/bacula-restores
}

Pool {
  Name = FilePool
  Pool Type = Backup
  Storage = bacula-sd
  Maximum Volumes = 110
  Maximum Volume Bytes = 10 GB
  AutoPrune = yes
  Volume Retention = 3 months
  Action On Purge = Truncate
  Recycle = yes
  Recycle Oldest Volume = yes
  Recycle Current Volume = yes
  Label Format = File-
}

# When to do the backups, full backup on first sunday of the month,
#  differential (i.e. incremental since full) every other sunday,
#  and incremental backups other days.
Schedule {
  Name = WeeklyCycle
  Run = Full 1st sun at 23:05
  Run = Differential 2nd-5th sun at 23:05
  Run = Incremental mon-sat at 23:05
}

# This schedule does the catalog. It starts after the WeeklyCycle.
Schedule {
  Name = WeeklyCycleAfterBackup
  Run = Full sun-sat at 23:10
}
" >> /etc/bacula/bacula-dir.conf

exit 0
