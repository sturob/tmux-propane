#!/bin/bash

pidfile=/tmp/myscript.pid

# If the pidfile exists, check if the process is running
if [ -e ${pidfile} ]; then
    pid=$(cat ${pidfile})

    # If the process is running, wait for it to finish
    while kill -0 ${pid} 2>/dev/null; do
		sleep 0.01
        continue
    done

    # If no process with the PID is running, remove the pidfile
    rm ${pidfile}
fi

# Write the PID of this script instance to the pidfile
echo $$ > ${pidfile}

# Trap any exit signal and remove the pidfile before exiting
trap "rm -f ${pidfile}" EXIT

# Your actual script commands here

echo cool
sleep 10
echo done
