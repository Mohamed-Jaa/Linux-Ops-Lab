#!/bin/bash
#Variable declaration
TARGET="/var/www/html"
DEST="/var/backups/web"
TIME=$(date +%Y-%m-%d_%H:%M)
FILENAME="backup_$TIME.tar.gz"
#start backup script
tar -czf $DEST/$FILENAME $TARGET

#Message confirmation
echo"Backup completed seccessfully at $TIME for $TARGET "
find /var/backups/web -name "*.tar.gz" -type f -mtime +15 -delete 
