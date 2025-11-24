#!/bin/bash

cleanup() {
  echo 'Stopping Nginx...'
	service nginx stop
	service php8.4-fpm stop
  exit 0
}

trap cleanup SIGTERM SIGINT

service php8.4-fpm start
service nginx start

tail -f /var/log/nginx/error.log &
TAIL_PID=$!

wait $TAIL_PID
