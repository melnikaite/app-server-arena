#!/bin/sh

SERVERS=(iodine passenger puma Rhebok thin unicorn)

# stop servers
pkill -f ruby &> /dev/null

# seeds
ruby ./setup.rb &> /dev/null

# clear old performance data
rm -R performance

# run servers
for i in "${!SERVERS[@]}"; do
  mkdir -p "performance/${SERVERS[$i]}"
  bundler exec rackup -s ${SERVERS[$i]} --port "300$i" -E production config.ru &> /dev/null &
done
sleep 10

# warm
for i in "${!SERVERS[@]}"; do
  curl -s -o /dev/null -I -w "%{http_code}\n" "http://localhost:300$i/"
done

# test
echo active_record
for i in "${!SERVERS[@]}"; do
  wrk -c 10 -d 10s -t 10 "http://localhost:300$i/active_record" > "performance/${SERVERS[$i]}/active_record.txt" 2>&1
done

echo pi
for i in "${!SERVERS[@]}"; do
  wrk -c 10 -d 10s -t 10 "http://localhost:300$i/pi" > "performance/${SERVERS[$i]}/pi.txt" 2>&1
done

echo random
for i in "${!SERVERS[@]}"; do
  wrk -c 10 -d 10s -t 10 "http://localhost:300$i/random" > "performance/${SERVERS[$i]}/random.txt" 2>&1
done

echo server
for i in "${!SERVERS[@]}"; do
  wrk -c 10 -d 10s -t 10 "http://localhost:300$i/server" > "performance/${SERVERS[$i]}/server.txt" 2>&1
done

echo sleep
for i in "${!SERVERS[@]}"; do
  wrk -c 10 -d 10s -t 10 "http://localhost:300$i/sleep" > "performance/${SERVERS[$i]}/sleep.txt" 2>&1
done

# stop servers
pkill -f ruby &> /dev/null
