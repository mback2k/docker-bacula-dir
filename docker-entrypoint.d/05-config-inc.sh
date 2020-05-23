#!/bin/bash -e

echo "
# Include subfiles associated with configuration of clients.
# They define the bulk of the Clients, Jobs, and FileSets.
@|\"sh -c 'for f in /etc/bacula/clientdefs/*.conf ; do echo @\${f} ; done'\"
" >> /etc/bacula/bacula-dir.conf

touch /etc/bacula/clientdefs/null.conf

exit 0
