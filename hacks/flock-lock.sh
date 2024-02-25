#!/bin/bash

lockfile=/tmp/mylockfile
exec 200>$lockfile

# Wait for lock on fd 200 (associated with $lockfile) for the rest of the script
flock -n 200 || { echo "Script is already running. Waiting..."; flock 200; }

echo "Running script..."
sleep 2
echo "Script completed."

# lock will be automatically released when the script finishes or the file descriptor is closed

