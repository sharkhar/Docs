######################################################################################################
######################################################################################################
##################################### Created by: Shardul shekhar ####################################
#####################################   Date : 25 April 2025     #####################################
######################################################################################################
######################################################################################################

#!/bin/bash

####################### Variables & Paths ######################

KEYSPACE="prod"
SNAPSHOT_NAME="prod_nodeserver_$(date +%s_%Y_%m_%d)"
CASSANDRA_DIR="/var/lib/cassandra/data"
BACKUP_DIR="/home/shardul/cassandra_backup/fullbackups/nodeserver/$SNAPSHOT_NAME"
START_TIME=$(date)

###################### Starting time of the script ######################

echo "Script started at: $START_TIME"
echo ""

####################### Create snapshot ######################

echo "Taking snapshot of keyspace: $KEYSPACE..."
echo ""

nodetool snapshot -t $SNAPSHOT_NAME $KEYSPACE

####################### Move snapshots to isebackups ######################

for TABLE in $(ls $CASSANDRA_DIR/$KEYSPACE | grep -oP '^[^\\-]+'); do
    echo "Processing table: $TABLE"

    SRC_TABLE_DIR=$(ls -d $CASSANDRA_DIR/$KEYSPACE/${TABLE}-*/snapshots/$SNAPSHOT_NAME 2>/dev/null | head -n1)

    if [[ -z "$SRC_TABLE_DIR" ]]; then
        echo "No snapshot found for table: $TABLE, skipping..."
        continue
    fi

    mkdir -p "$BACKUP_DIR/$TABLE"
    cp -r "$SRC_TABLE_DIR"/* "$BACKUP_DIR/$TABLE/"
done

###################### Delete Snapshot ######################

echo "Clearing snapshot."
echo ""

nodetool clearsnapshot -t $SNAPSHOT_NAME

echo "Backup completed. Snapshot saved in: $BACKUP_DIR"
echo ""
###################### End Time of the Script ######################

END_TIME=$(date)

echo "Script ended at: $END_TIME"
