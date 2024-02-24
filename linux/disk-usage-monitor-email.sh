#!/bin/bash



# INTRO
# Scrirt purpose
# Script created and managed by
# chatgpt add other details
# script logfile at $LOGFILE
# send email also if crosses threshold
# Scrit end


# variables
THRESHOLD=70             # in percent
CRITICAL_THRESHOLD=90    # in percent
FILESYSTEM="/dev/root"
TIMESTAMP=$(date +"%Y-%m-%d %I:%m:%S %p %Z")
LOGFILE="/var/log/$(basename $0 | tr -d '.sh').log"


# Script and logfile details
function script-start(){
    echo "======================================================================="
    echo "Script started on $TIMESTAMP and running as user $USER"
    echo "Script located at $(pwd)/$(basename $0)"
    echo "Script Logfile located at $LOGFILE"
}

#  Grabbing Disk Details
DISK_INFO=$(df -h --output=pcent,avail,size,used "$FILESYSTEM" | tail -n 1 | tr -s ' ')
DISK_USED_PERCENT=$(echo "$DISK_INFO" | awk '{print $1}' | tr -d '%' )
DISK_AVAILABLE=$(echo "$DISK_INFO" | awk '{print $2}')
DISK_SIZE=$(echo "$DISK_INFO" | awk '{print $3}')
DISK_USED=$(echo "$DISK_INFO" | awk '{print $4}')

# Max uasge by directory
function dir-usage(){
    DIR_USAGE=$(sudo du -m --max-depth=1 / 2>/dev/null | tail -n 10 | sort -nr)
    printf "Top 10 directories consuming more memory (in Megabyte )is :\n%s\n" "$DIR_USAGE"
}

# Logging Disk details
function disk-details(){
    echo "Disk Size        : $DISK_SIZE"
    echo "Memory Available : $DISK_AVAILABLE"
    echo "Memory Used      : $DISK_USED"
    echo "Memory Used in % : $DISK_USED_PERCENT %"

}
# Script main logic.
function threshold-checker() {
    if [ "$DISK_USED_PERCENT" -ge "$CRITICAL_THRESHOLD" ]; then
        echo "CRITICAL!!! DISK USAGE ON $HOSTNAME GREATER THAN $CRITICAL_THRESHOLD %, CURRENT USAGE IS $DISK_USED_PERCENT %"
        critical-email
    elif [ "$DISK_USED_PERCENT" -ge "$THRESHOLD" ]; then
        echo "ALERT! DISK USAGE ON HOSTNAME: $HOSTNAME GREATER THAN  $THRESHOLD % , CURRENT USAGE IS $DISK_USED_PERCENT % "
        alert-email
    fi
}


# Sending Email if disk usage is greater than threshold using postfix.
function alert-email(){

    ALERT_MESSAGE="<html><body><p style=\"color: red; font-weight: bold;\">ALERT - Disk Usage Threshold Exceeded</p><p>Disk Usage on $HOSTNAME is greater than $THRESHOLD%, Current usage is $DISK_USED_PERCENT%</p></body> <body><pre> $(disk-details)</pre></body> <body><pre>$(dir-usage)</pre></body></html>"

    curl -s --user 'api:5b2d5b8ef84258e173fd2a1b1858a616-408f32f3-a6282175' \
        https://api.mailgun.net/v3/sandboxab189fa2822a4c4da400e209a8ef3593.mailgun.org/messages \
        -F from='MEMORY THRESHOLD <mailgun@sandboxab189fa2822a4c4da400e209a8ef3593.mailgun.org>' \
        -F to=eduboneofficial@gmail.com \
        -F subject='ALERT - Disk Usage Threshold ' \
        --form-string html="$ALERT_MESSAGE"
}

function critical-email(){

    CRITICAL_MESSAGE="<html><body><p style=\"color: red; font-weight: bold;\"> !!! CRITICAL !!! - Disk Usage Threshold Exceeded</p><p>Disk Usage on $HOSTNAME is greater than $CRITICAL_THRESHOLD %, Current usage is $DISK_USED_PERCENT%</p></body> <body><pre> $(disk-details) </pre></body><body><pre>$(dir-usage)</pre></body></html>"

    curl -s --user 'api:5b2d5b8ef84258e173fd2a1b1858a616-408f32f3-a6282175' \
        https://api.mailgun.net/v3/sandboxab189fa2822a4c4da400e209a8ef3593.mailgun.org/messages \
        -F from='MEMORY THRESHOLD <mailgun@sandboxab189fa2822a4c4da400e209a8ef3593.mailgun.org>' \
        -F to=eduboneofficial@gmail.com \
        -F subject='CRITICAL - Disk Usage Threshold ' \
        --form-string html="$CRITICAL_MESSAGE"
}


function main(){

        script-start
        disk-details
        dir-usage
        threshold-checker

} >> "$LOGFILE"

main

echo "======================================================================="  >> "$LOGFILE"
