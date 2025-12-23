#!/bin/bash
set -e

# Ensure mydata directory exists
mkdir -p /mydata

## Download books.csv if not already present
#if [ ! -f /mydata/books.csv ]; then
#  wget -O /mydata/books.csv https://raw.githubusercontent.com/apache/solr/main/solr/example/exampledocs/books.csv
#fi

# Download films.json if not already present
if [ ! -f /mydata/films.json ]; then
  wget -O /mydata/films.json https://raw.githubusercontent.com/apache/solr/refs/heads/main/solr/example/films/films.json
fi

# Start Solr in background (standalone mode)
/opt/solr/bin/solr start

# Wait for Solr to be up
until curl -s http://localhost:8983/solr/ > /dev/null; do
  echo "Waiting for Solr to start..."
  sleep 2
done

# Create cores in standalone mode (if missing)
if ! curl -s "http://localhost:8983/solr/admin/cores?action=STATUS&core=books&wt=json" | grep -q '"name":"books"'; then
  echo "Creating books core..."
  /opt/solr/bin/solr create_core -c books -n _default || {
    echo "Core creation failed, but continuing..."
  }
else
  echo "Books core already exists, skipping creation."
fi

if ! curl -s "http://localhost:8983/solr/admin/cores?action=STATUS&core=films&wt=json" | grep -q '"name":"films"'; then
  echo "Creating films core..."
  /opt/solr/bin/solr create_core -c films -n _default || {
    echo "Core creation failed, but continuing..."
  }
else
  echo "Films core already exists, skipping creation."
fi

curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-field": {
    "name":"name",
    "type":"text_general",
    "multiValued":false,
    "stored":true
  },
  "add-field": {
    "name":"initial_release_date",
    "type":"pdate",
    "stored":true
  }
}' http://localhost:8983/solr/films/schema

## Post the books.csv data
/opt/solr/bin/solr post -c books /mydata/books.csv

# Post the films.json data
/opt/solr/bin/solr post -c films /mydata/films.json

# Stop background Solr and run in foreground (standalone)
/opt/solr/bin/solr stop
exec /opt/solr/bin/solr start -f