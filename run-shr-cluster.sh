#!/usr/bin/env bash
set -e
if [ -z "$1" ]
  then
    yml="docker-compose-staging.yml"
  else
    yml="$1"
fi

docker compose down
docker compose rm
docker compose -f $yml up -d cassandra-follower-server

until docker compose exec cassandra-seed-server /bin/sh -c "cqlsh -e 'desc keyspaces' | grep freeshr;"
do
   echo "Waiting"
done
docker compose -f $yml up -d
