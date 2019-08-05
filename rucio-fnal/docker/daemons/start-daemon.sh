#!/bin/sh

if [ -f /opt/rucio/etc/rucio.cfg ]; then
    echo "rucio.cfg already mounted."
else
    echo "rucio.cfg not found. will generate one."
    j2 /tmp/rucio.cfg.j2 | sed '/^\s*$/d' > /opt/rucio/etc/rucio.cfg
fi

echo "=================== /opt/rucio/etc/rucio.cfg ============================"
cat /opt/rucio/etc/rucio.cfg
echo ""

if [ "$DELEGATE_FTS_PROXY" = "true" ]; then
	echo "Creating fts proxy"
	/delegate_fts_proxy.sh

	echo "Spawning proxy delegation script"
	(
		while true; do
			sleep 3600
			/delegate_fts_proxy.sh
		done
	) >/dev/null 2>/dev/null </dev/null &
fi

echo "starting daemon with: $RUCIO_DAEMON $RUCIO_DAEMON_ARGS"
echo ""

if [ -z "$RUCIO_ENABLE_LOGS" ]; then
    /usr/sbin/fetch-crl &
    /usr/sbin/crond
    eval "/usr/bin/rucio-$RUCIO_DAEMON $RUCIO_DAEMON_ARGS"
else
    /usr/sbin/fetch-crl &
    /usr/sbin/crond
    eval "/usr/bin/rucio-$RUCIO_DAEMON $RUCIO_DAEMON_ARGS >> /var/log/rucio/daemon.log 2>> /var/log/rucio/error.log"
fi
