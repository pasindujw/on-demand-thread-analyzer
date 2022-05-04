#!/bin/bash
########### Configurations ###############
health_check_API=http://www.google.com:81/
health_check_periodic_time=10
max_waiting_time=10
identification_term_for_jps=Bootstrap
#configurations related to taking thread-dumps
number_of_threads=10
timegap=1s
#######################################
# Get thread-dumps using thread-analyze.sh file.
# Step 1: Find related process id.
# Step 2: Start thread-analyze sh using configured params.
# Arguments: None
#######################################
function get_thread_dumps() {
  echo starting to get thread-dumps.
  jps_output=$(jps |grep $identification_term_for_jps)
  pid=$(echo $jps_output | awk '{print $1;}')
  echo process-id: $pid
  count=$2
  for i in `seq 1 $number_of_threads`;
    do
        jstack -l $pid > thread_dump_`date "+%F-%T"`.txt &
        ps --pid $pid -Lo pid,tid,%cpu,time,nlwp,c > thread_usage_`date "+%F-%T"`.txt &
        if [ $i -ne $number_of_threads ]; then
          echo "sleeping for $timegap [$i]"
          sleep $timegap
        fi
    done
}

#######################################
# Get thread-dumps using thread-analyze.sh file.
# Step 1: Find related process id.
# Step 2: Start JFR record
# Arguments: None
#######################################
function get_JFR_record() {
  jps_output=$(jps |grep $identification_term_for_jps)
  pid=$(echo $jps_output | awk '{print $1;}')
  echo process-id: $pid
  jcmd $pid JFR.start settings=default duration=5m name=Default filename=jfr_`date "+%F-%T"`.jfr
}

echo Invoking $health_check_API with $health_check_periodic_time seconds intervals
while true;
do
  curl --max-time $max_waiting_time $health_check_API
  if [ $? -eq 28 ]
  then
    echo Alert
    get_thread_dumps
    #get_JFR_record
  fi
  sleep $health_check_periodic_time;
done
