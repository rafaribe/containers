#!/bin/sh

set -e

export DB_PORT=5432
export AKKOMA_CONFIG_PATH=$AKKOMADIR/config/config.exs
export AKKOMA_DB_PATH=$AKKOMADIR/config/setup_db.psql

function dbwait() {
	echo "-- Waiting for database..."
	while ! pg_isready -U ${DB_USER} -h ${DB_HOST} -p ${DB_PORT} -t 1; do
		sleep 1s
	done
}

if [ ! -f $AKKOMA_CONFIG_PATH ]; then
	echo "-- Generating instance configuration --"
	mkdir -p $(dirname $AKKOMA_CONFIG_PATH)
	$AKKOMADIR/bin/pleroma_ctl instance gen \
		--output $AKKOMA_CONFIG_PATH \
		--output-psql $AKKOMA_DB_PATH \
		--domain "$INSTANCE_DOMAIN" \
		--instance-name "$INSTANCE_NAME" \
		--media-url "$MEDIA_URL" \
		--admin-email "$INSTANCE_ADMIN_EMAIL" \
		--notify-email "$INSTANCE_NOTIFY_EMAIL" \
		--dbhost "$DB_HOST" \
		--dbname "$DB_NAME" \
		--dbuser "$DB_USER" \
		--dbpass "$DB_PASS" \
		--rum N \
		--indexable "$INSTANCE_INDEX" \
		--db-configurable "$INSTANCE_ADMINFE" \
		--uploads-dir "$AKKOMADIR/uploads" \
		--static-dir "$AKKOMADIR/static" \
		--listen-ip "0.0.0.0" \
		--listen-port "4000" \
		--strip-uploads-metadata "$STRIP_UPLOADS" \
		--anonymize-uploads "$ANONYMIZE_UPLOADS" \
		--read-uploads-description "$READ_UPLOAD_DATA"
	echo "-- Generated instance config --"
fi

if [ -f $AKKOMA_DB_PATH ]; then
	echo "-- Initializing database --"
	dbwait
	echo "$DB_PASS" | \
		psql \
		-h "$DB_HOST" \
		-p "$DB_PORT" \
		-U "$DB_USER" \
		-f $AKKOMA_DB_PATH \
		"$DB_NAME"
	rm $AKKOMA_DB_PATH

	echo "-- Initialized database --"
fi

dbwait()

echo "-- Running migrations..."
$AKKOMADIR/bin/pleroma_ctl migrate

echo "-- Starting!"
$AKKOMADIR/bin/pleroma start
