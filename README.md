transmission-complete
=====================
Sample bash script to process finished files in Transmission

You can use torrent files with Sickbeard and Couchpotato, but the post processing leaves a bit to be desired. Essentially, this script assumes:
* SSH access to network storage
* Local mount points for processing completed sickbeard/couchpotato files
* Transmission is used for torrent management
* Transmission is set up with complete/incomplete directories
* Per-media folders are set up for SB/CP processing

Transmission should be configured with the following options in settings.json:

script-torrent-done-enabled: true
script-torrent-done-filename: "path/to/this/script"

The script will then execute on torrent completion:
* Pull the full transmission torrent details from the transmission-remote daemon
* Determine the interim download folder based on the torrent source (p2p.me -> movies, btn -> tv, etc)
* Changes the file permissions over SSh
* Copies the media to the interim download folder using hardlinks over SSH, ensuring a fast copy operation and the ability for transmission to continue seeding.

SB or CP can then be set up to scan and process their respective download directories for new media files.
