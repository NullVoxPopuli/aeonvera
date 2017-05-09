#!/bin/bash
set -x

# place backup in <gitdir>/backups
# $1 will be the file name -- not the path
#
# backups from heroku postgres will work with this script without modification
file=${1:-$(ls backups)}

cmd="pg_restore --verbose --clean --no-acl --no-owner --host \$DATABASE_HOST --username \$DATABASE_USERNAME --dbname \$DATABASE_NAME $file"

  # --username \$POSTGRES_USER
  # --dbname \$POSTGRES_DB

docker-compose -f docker-compose.dev.yml \
  run -T --rm web bash -c "cd /backups && {
    echo \"\$(ls)\"
    export PGPASSWORD=\$DATABASE_PASSWORD
    echo \"\$($cmd)\"
  }"
