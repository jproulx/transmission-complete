#!/bin/bash
SSH_OPTS="Files@192.168.1.15 -i /mnt/Downloads/id_rsa_files"
TR_OPTS="-n transmission:transmission"

sq() { # single quote for Bourne shell evaluation
    # Change ' to '\'' and wrap in single quotes.
    # If original starts/ends with a single quote, creates useless
    # (but harmless) '' at beginning/end of result.
    printf '%s\n' "$*" | sed -e "s/'/'\\\\''/g" -e 1s/^/\'/ -e \$s/\$/\'/
}

# Local information
TR_TORRENT_INFO=`transmission-remote ${TR_OPTS} -t "$TR_TORRENT_ID" -it`

# Remote resources
REMOTE_SOURCE="/mnt/md0/Downloads/transmission/complete/$TR_TORRENT_NAME"
REMOTE_DESTINATION="/mnt/md0/Downloads/"

case "$TR_TORRENT_INFO" in
    *broadcasthe.net*)
    REMOTE_DESTINATION=${REMOTE_DESTINATION}/tv/
    ;;
    *passthepopcorn.me*)
    REMOTE_DESTINATION=${REMOTE_DESTINATION}/movies/
    ;;
    *what.cd*)
    REMOTE_DESTINATION=${REMOTE_DESTINATION}/music/
    ;;
    *)
    REMOTE_DESTINATION=${REMOTE_DESTINATION}/other/
    ;;
esac

# Ensure decent permissions for various AV programs that use these files
REMOTE_PERMS="chmod 755 $(sq $REMOTE_SOURCE)"
# Since we still want to seed data, link the data to the new destination instead of copying or moving
REMOTE_COPY="cp -val $(sq $REMOTE_SOURCE) $REMOTE_DESTINATION"

# These SSH commands are run under transmission-daemon user, which has no home directory
# disable known hosts and strict key checks since this is entirely done through the local network
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $SSH_OPTS "$REMOTE_PERMS" >> /var/log/transmission.log 2>&1
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $SSH_OPTS "$REMOTE_COPY" >> /var/log/transmission.log 2>&1
