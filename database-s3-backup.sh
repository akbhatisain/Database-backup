#!/bin/bash
#I use this to create a little bash script that will backup the database at regu                                                                                        lar intervals, and I’ll even chuck in deleting backups older than 15 days and mo                                                                                        ve the dump_file in S3_bucket.
#create a few variables to contain the Database_credentials.
# Database credentials

USER="root"
PASSWORD="YOUR PASSWORD"
HOST="localhost"
DB_NAME="DATABASE NAME"

#Backup_Directory_Locations
BACKUPROOT="/var/www/backup"
TSTAMP=$(date +"%d-%b-%Y-%H-%M-%S")

#logging
LOG_ROOT="/tmp/dump.log"

#Dump of Mysql Database into S3\
echo "$(tput setaf 2)creating backup of database start at $TSTAMP" >> "$LOG_ROOT"
#mysqldump  -h <HOST>  -u <USER>  --database <DB_NAME>  -p <PASSWORD> > $BACKUPROOT/$DB_NAME-$TSTAMP.sql
mysqldump -u $USER --password=$PASSWORD $DB_NAME| zip > $BACKUPROOT/$DB_NAME-$TSTAMP.sql.zip
find  $BACKUPROOT/*   -mtime +15   -exec rm  {}  \;

#or
#mysqldump -h=$HOST -u=$USER --database=$DB_NAME -p=$PASSWORD > $BACKUPROOT/$DB_NAME-$TSTAMP.sql
echo "$(tput setaf 3)Finished backup of database and sending it in S3 Bucket at $TSTAMP" >> "$LOG_ROOT"

#Delete files older than 15 days
#find  $BACKUPROOT/*   -mtime +15   -exec rm  {}  \;
###Save it and exit (:wq)
