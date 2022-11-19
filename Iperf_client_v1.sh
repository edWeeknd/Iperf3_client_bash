#! /usr/bin/bash

help()
{
    echo "Usage: Iperf3 client [ -c | --ipserver ]
               [ -p | --port ]
               [ -h | --help  ]
               [ -P | --parallel ]
               [ -t | --time ]
               [ -u | --udp ]
               [ --logfile ]"
    exit 2
}



#The set of default value
ipserver="127.0.0.1"
time=10
port=5201
parallel=1
protocol="tcp"
path="$PWD/Client_output/"
logfile="Client_log.txt"


SHORT=c:,p:,P:,t:,u,h
LONG=ipserver:,port:,parallel:,time:,udp,logfile:,help
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
      protocol="udp"
      shift 1
      ;;
    --logfile )
      logfile="$2"
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
while true
do
	if [[ $protocol == "tcp" ]] 
	then
		echo "Testing in TCP mode"
		now=$(date)
		echo "Current time: $now"
		iperf3 -c $ipserver -p $port -P $parallel -t $time --logfile $log_path
		echo "---------------------------------------------"
	elif [[ $protocol == "udp" ]]
	then
		echo "Testing in UDP mode"
		now=$(date)
		echo "Current time: $now"
		iperf3 -c $ipserver -p $port -P $parallel -t $time --logfile $log_path -u
		echo "---------------------------------------------"
	fi
sleep 600
done 
# while true
# do
# 	iperf3 -c $ipserver -p $port -P $parallel -t $time
# 	sleep 600
# done