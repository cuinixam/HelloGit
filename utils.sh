#!/bin/bash

reset=`tput sgr0`
red=`tput setaf 1`
green=`tput setaf 2`
cyan=`tput setaf 6`
yellow=`tput setaf 3`

log_error() {
  echo "${red}[ERROR]${reset} $*" >&2
}

log_ok() {
  echo "${green}[OK]${reset} $*" >&2
}

log_nok() {
  echo "${red}[NOK]${reset} $*" >&2
}

log_debug() {
  echo "${yellow}[DEBUG]${reset} $*" >&2
}

log_info() {
  echo "${cyan}[INFO] $* ${reset}" >&2
}

log_attention() {
  echo "${yellow}[ATTENTION] $* ${reset}" >&2
}


START_TIME=0

tic() {
   START_TIME=$SECONDS
}

toc() {
   ELAPSED_TIME=$(($SECONDS - $START_TIME))
   echo "$(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"
}

pause(){

   while true; do
      printf "\r:"
      # In the following line -t for timeout, -N for just 1 character
      read -t 1 -n 1 input
      if [ ! "$?" -gt 128 ]
      then
         if [[ $input = "q" ]] || [[ $input = "Q" ]]; then
            log_debug "Execution stopped ..."
            exit 0
         else
            # log_debug "Continue execution ..."
            echo  ""
            break
         fi
      fi
   done

}
