#! /usr/bin/bash

help()
{
    echo "Usage: Iperf3 client [ -c | --ipserver ]
               [ -p | --port ]
               [ -h | --help  ]
               [ -P | --parallel ]
               [ -t | --time ]
               [ -u | --udp ]
               [ --logfile ]
               [ --sleep ]
               [ --json ]"
    exit 2
}



#Setting default parameters
ipserver="127.0.0.1"
time=10
port=5201
parallel=1
protocol_flag="TCP"
protocol=""
path="$PWD/Client_output/"
logfile="Client_log.txt"
sleep=5   #sleep time in second
output_flag="TXT"
output_type=""

SHORT=c:,p:,P:,t:,u,J,h
LONG=ipserver:,port:,parallel:,time:,udp,logfile:,sleep:,json,help
OPTS=$(getopt -a -n iperf --options $SHORT --longoptions $LONG -- "$@")

VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options

if [ "$VALID_ARGUMENTS" -eq 0 ]; then
  help
fi

eval set -- "$OPTS"

while :
do
  case "$1" in
    -c | --ipserver )
      ipserver="$2"
      shift 2
      ;;
    -p | --port )
      port="$2"
      shift 2
      ;;
    -P | --parallel )
      parallel="$2"
      shift 2
      ;;
    -t | --time )
      time="$2"
      shift 2
      ;;
    -u | --udp )
      protocol_flag="UDP"
      protocol="u"
      shift 1
      ;;
    -J | --json )
      output_flag="JSON"
      output_type="J"
      shift 1
      ;;
    --logfile )
      logfile="$2"
      shift 2
      ;;
    --sleep )
      sleep="$2"
      shift 2
      ;;
    -h | --help)
      help
      ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      help
      ;;
  esac
done

log_path=$path$logfile

# echo $path
# echo $log_path

# iperf3 -c $ipserver -p $port -P $parallel -t $time --logfile $log_path -$protocol

while true
do 
  echo "Testing with server $ipserver, port $port"
  echo "Testing in $protocol_flag mode, output type $output_flag"
  now=$(date)
  echo "Current time: $now"
  
  iperf3 -c $ipserver -p $port -P $parallel -t $time --logfile $log_path -$protocol -$output_type
  
  echo "---------------------------------------------"
  sleep $sleep
done

# while true
# do
# 	if [[ $protocol == "tcp" ]] 
# 	then
# 		echo "Testing in TCP mode"
# 		now=$(date)
# 		echo "Current time: $now"
# 		iperf3 -c $ipserver -p $port -P $parallel -t $time --logfile $log_path
# 		echo "---------------------------------------------"
# 	elif [[ $protocol == "udp" ]]
# 	then
# 		echo "Testing in UDP mode"
# 		now=$(date)
# 		echo "Current time: $now"
# 		iperf3 -c $ipserver -p $port -P $parallel -t $time --logfile $log_path -u
# 		echo "---------------------------------------------"
# 	fi
# sleep $sleep
# done 

# while true
# do
# 	iperf3 -c $ipserver -p $port -P $parallel -t $time
# 	sleep 600
# done