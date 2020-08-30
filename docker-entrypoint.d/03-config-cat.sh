#!/bin/bash -e

echo "
Catalog {
  Name = Catalog
  DB Address = \"${BACULA_CATALOG_DATABASE_HOST}\"
  DB Name = \"${BACULA_CATALOG_DATABASE_NAME}\"
  User = \"${BACULA_CATALOG_DATABASE_USER}\"
  @/etc/bacula/catalog-password
}

Job {
  Name = CatalogBackup
  JobDefs = Defaults
  Level = Full
  Write Bootstrap = \"/var/lib/bacula/%n.bsr\"
  Client = bacula-dir-fd
  FileSet = CatalogFileSet
  Messages = Standard
  Pool = CatalogPool
  Schedule = WeeklyCycleAfterBackup
  RunScript {
    Command = \"/etc/init.d/bacula-fd start\"
    FailJobOnError = yes
    RunsOnClient = no
    RunsWhen = Before
  }
  RunScript {
    Command = \"/etc/init.d/bacula-fd stop\"
    FailJobOnError = no
    RunsOnSuccess = yes
    RunsOnFailure = yes
    RunsOnClient = no
    RunsWhen = After
  }
  RunScript {
    Console = \"purge volume action=all allpools\"
    FailJobOnError = no
    RunsOnSuccess = yes
    RunsOnFailure = no
    RunsOnClient = no
    RunsWhen = After
  }
  # This creates an ASCII copy of the catalog
  # Arguments to make_catalog_backup.pl are:
  #  make_catalog_backup.pl <catalog-name>
  RunScript {
    Command = \"/etc/bacula/scripts/make_catalog_backup.pl Catalog\"
    FailJobOnError = yes
    RunsOnClient = no
    RunsWhen = Before
  }
  Priority = 99 # run after other backups
}

FileSet {
  Name = CatalogFileSet
  Include {
    Options {
      noatime = yes
      signature = SHA1
      compression = LZO
      aclsupport = yes
      xattrsupport = yes
      checkfilechanges = yes
    }
    File = \"/var/lib/bacula/${BACULA_CATALOG_DATABASE_NAME}.sql\"
  }
}

Pool {
  Name = CatalogPool
  Pool Type = Backup
  Storage = bacula-sd
  Maximum Volumes = 100
  Maximum Volume Jobs = 1
  AutoPrune = yes
  Volume Retention = 3 months
  Action On Purge = Truncate
  Recycle = yes
  Recycle Oldest Volume = yes
  Recycle Current Volume = yes
  Label Format = Catalog-
}
" >> /etc/bacula/bacula-dir.conf

exit 0
