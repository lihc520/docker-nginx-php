#!/bin/sh

set -e

if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
	# ./docker/scripts/init.sh
	setfacl -dR -m u:www:rwx -m u:`whoami`:rwx /app/web
	set -- supervisord -n "$@"
fi

/usr/sbin/crond -i

exec "$@"
