#!/bin/bash -e

# Disable console logging
pid_file=/var/run/voltdb.pid

# launch VoltDB in the background
start-stop-daemon --quiet --chuid voltdb: --startas /usr/bin/env --background --pidfile $pid_file --make-pidfile --start -- LOG4J_CONFIG_PATH=/etc/voltdb/log4j.xml /usr/bin/voltdb create -d /etc/voltdb/deployment.xml

# wait for startup completion
started=false
while true
do
  sleep 1s
  if ps -p `cat $pid_file` > /dev/null
  then
    # voltdb is running, check is the startup is complete
    last_log_line=$(tail -1 /var/log/voltdb/volt.log 2>/dev/null || true)
    if [[ $last_log_line == *"Server completed initialization." ]]
    then
      started=true
      break
    fi
  else
    # voltdb is not running
    break
  fi
done

if [ "$started" = true ]
then
  # load jar files
  for file in `find /var/lib/voltdb/jar -name *.jar | sort`
  do
    echo "exec @UpdateClasses $file '';" | /usr/bin/sqlcmd
  done
  # load sql files
  for file in `find /var/lib/voltdb/sql -name *.sql | sort`
  do
    /usr/bin/sqlcmd < $file
  done
else
 # something went wrong during startup, delete the PID file
 rm -f $pid_file
 exit 1
fi


