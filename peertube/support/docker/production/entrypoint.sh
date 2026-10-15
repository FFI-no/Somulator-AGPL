#!/bin/sh
set -e

# Customzied entrypoint based on 3.4.1 release (production-buster docker tag):
# https://github.com/Chocobozzz/PeerTube/blob/v3.4.1/support/docker/production/entrypoint.sh

# Populate config directory
if [ -z "$(ls -A /config)" ]; then
    cp /app/support/docker/production/config/* /config
fi

# Always copy default and custom env configuration file, in cases where new keys were added
cp /app/config/default.yaml /config
cp /app/support/docker/production/config/custom-environment-variables.yaml /config

# Copy customizations (config, images, a.s.o.)
cp -rf /custom/data/* /data/

find /config ! -user peertube -exec chown peertube:peertube {} \; || true

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
    set -- npm "$@"
fi

# allow the container to be started with `--user`
# PeerTube 8.3 ships a migration script that must run once, by hand, after the database migration
# has finished and while the server is running (release notes: "node dist/scripts/migrations/peertube-8.3.js").
# Nobody should have to remember that in a cluster, so a background one-shot waits for the API and runs it;
# the marker file keeps restarts from repeating it (upstream records the run as well, a repeat is harmless).
run_manual_migrations() {
    local marker=/data/.somu-migration-8.3-done
    [ -f "$marker" ] && return 0
    for _ in $(seq 1 180); do
        if curl -sf -o /dev/null http://127.0.0.1:9000/api/v1/config; then
            (cd /app && NODE_CONFIG_DIR=/config NODE_ENV=production node dist/scripts/migrations/peertube-8.3.js) \
                && date > "$marker" \
                && echo "PeerTube 8.3 manual migration done" \
                || echo "PeerTube 8.3 manual migration failed; it will run again at the next start"
            return 0
        fi
        sleep 10
    done
    echo "PeerTube 8.3 manual migration skipped: the server did not come up within 30 minutes"
}

if [ "$1" = 'npm' -a "$(id -u)" = '0' ]; then
    find /data ! -user peertube -exec  chown peertube:peertube {} \;
    exec gosu peertube "$0" "$@"
fi

if [ "$1" = 'npm' ]; then
    run_manual_migrations &
fi

exec "$@"