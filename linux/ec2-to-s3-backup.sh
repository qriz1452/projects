#!/bin/bash 

# The purpose of this script to take backup of user provided  directory  and compress then  upload to s3 bucket.
# Once it is successfully uploaded to S3 bucket it will removet the bacup archive created.
# This script is created and managed by @backupadmin .
# Script is scheduled to run everyday at 5 PM IST via cron job. 
# This script generates log file and can be accessed at /var/log/script-file-name.logs
# For example if your script name is takebackup.sh then log filr will be /var/log/takebackup.logs
# End of intro section. 


# Immediate Exiting if any command exited with non zero status code.
set -e


# AWS S3 bucket name and region 
S3_BUCKET=nnnnnaaaaaaaaaaaaa  # Comment it  if you want to use parameter.
AWS_REGION=us-east-1 
#S3_BUCKET=$2   # comment it if you want to use flobal variable name
  

# Folder name to take backup 
BACKUP_DIR_NAME="$1"  # User needs to provide dir to take backup
TIMESTAMP=$(date +"%Y-%m-%d--%I-%M-%S--%-p-%Z") 
BACKUP_FILE="backup_$(basename "$BACKUP_DIR_NAME")_${TIMESTAMP}.tar.gz" 


# Logfile name 
LOGFILE="/$(dirname "$(realpath "$BACKUP_DIR_NAME")")/$(basename "$(realpath "$0")").logs"
echo "Script name is $0" >> "$LOGFILE"
echo "Logfile name is $LOGFILE" >> "$LOGFILE"


# checking parameter is provided or not and its a folder or file. 
if [ -z "$1" ]; then 
        echo "Backup script start  date and time $TIMESTAMP"  >> "$LOGFILE" 
        echo "$USER  Did not provided any argument , Please provide directory path  to take backup." >> "$LOGFILE" 
        echo "Exiting with status code 1" >> "$LOGFILE" 
        exit 1 
elif [ -d "$1" ]; then 
        echo "Backup script start  date and time $TIMESTAMP"  >> "$LOGFILE"
        echo "$USER prvided -->  $1 <--  parameter to take backup and  is a directory" >> "$LOGFILE" 
        echo "Proceeding to next steps to take backup and upload to s3 bucket." >> "$LOGFILE"
elif [ -f "$1" ]; then 
        echo "Backup script start  date and time $TIMESTAMP"  >> "$LOGFILE"
        echo "$USER provided -->  $1 <--  parameter and  it is a FILE  not a DIRECTORY, please provide Directory path." >> "$LOGFILE" 
        echo " Exiting with status code 1" >> "$LOGFILE" 
        exit 1 
else 
        echo "Backup script start  date and time $TIMESTAMP"  >> "$LOGFILE"
        echo "$USER provided -->  $1 <--  parameter and the Directory is not found." >> "$LOGFILE" 
        exit 1
fi 


# Now Creating archive of user provided directory. 
echo "Creating archive with name $BACKUP_FILE in dir  $(dirname "$(realpath "$BACKUP_DIR_NAME")") " >> "$LOGFILE" 
tar -czvf $BACKUP_FILE $BACKUP_DIR_NAME >> "$LOGFILE" 2>&1 
echo "Archive successfully  created at $(date +"%Y-%m-%d--%I-%M-%S--%-p-%Z") with name $BACKUP_FILE and located at $(dirname "$(realpath "$BACKUP_DIR_NAME")") " >> "$LOGFILE" 


# Uploading to S3 
echo " Uploading backup $BACKUP_FILE to S3 bucket $S3_BUCKET ." >> "$LOGFILE" 
aws s3 cp "$(dirname "$(realpath "$BACKUP_DIR_NAME")")/$BACKUP_FILE"   "s3://$S3_BUCKET/$BACKUP_FILE"  >> "$LOGFILE"  2>&1 
echo " Congrats! Archive  Upload Successfully to S3 bucket on $(date +"%Y-%m-%d--%I-%M-%S--%-p-%Z") " >> "$LOGFILE" 


# Cleaning local backup file 
echo "Now cleaning local backup file $BACKUP_FILE ." >> "$LOGFILE" 
rm $BACKUP_FILE -vvv >> "$LOGFILE"  2>&1 
echo "Backup and upload Completed on $(date +"%Y-%m-%d--%I-%M-%S--%-p-%Z")" >> "$LOGFILE" 
#!/bin/bash

echo "====================="
echo "=                   =" 
echo "= BACKUP SUCCESSFUL ="
echo "=                   ="
echo "====================="

exit 0 
