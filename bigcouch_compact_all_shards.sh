#!/bin/sh -e
#
# script to compact all shards
# 
# released under the terms of the `GNU GPL version 3` or later (see README.md for details)

SHARDSDIR='/opt/bigcouch/var/lib/'
NETRC='/etc/couchdb/couchdb.netrc'
SIZE='1M'

shards=`find ${SHARDSDIR}/shards/ -type f -size +${SIZE}`

echo
echo "Disk usage before: `df -h $SHARDSDIR`" 
echo 

for i in $shards
do
  shard=`echo $i | sed "s/^.*shards\///" | cut -d'/' -f 1`
  db=`basename $i .couch`
  echo -n "compacting ${i}:"
  curl -s -X POST --netrc-file $NETRC -H "Content-Type: application/json" "http://127.0.0.1:5986/shards%2F${shard}%2F${db}/_compact"
  sleep 1
done

echo
echo "Disk usage after: `df -h $SHARDSDIR`" 
echo 

echo "$0 ran successful"
