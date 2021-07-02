#!/bin/bash

IPMIHOST=1.2.3.4
IPMIUSER=root
IPMIPW=calvin
IPMIEK=0000000000000000000000000000000000000000

LASTSPEED=0

function setfans () {
  speed=$1
  if [[ $speed == "auto" ]]; then
    # Enable automatic fan speed control
    if [[ "$speed" != "$LASTSPEED" ]]; then
      ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x01 0x01 >/dev/null 2>&1 &
      LASTSPEED=${speed}
    fi
    echo "[`date`] `hostname` FANS: AUTO (SYS TEMP: $SYSTEMP C, CPU TEMP: $CPUTEMP C)"
  else
    speedhex=$(echo "obase=16; $speed" | bc)
    # Enable manual fan speed control
    if [[ "$speed" != "$LASTSPEED" ]]; then
      if [[ "$LASTSPEED" == "auto" ]] || [[ "$LASTSPEED" == "0" ]]; then
        ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x01 0x00 >/dev/null 2>&1 &
      fi
      ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK raw 0x30 0x30 0x02 0xff 0x${speedhex} >/dev/null 2>&1 &
      LASTSPEED=${speed}
    fi
    echo "[`date`] `hostname` FANS: ${speed}% (0x${speedhex}) (SYS TEMP: $SYSTEMP C, CPU TEMP: $CPUTEMP C)"
  fi
}

while [ 1 ]; do

SYSTEMP=$(ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW -y $IPMIEK sdr type temperature |grep Ambient |grep degrees |grep -Po '\d{2}' | tail -1)


if [[ $SYSTEMP > 39 ]]; then
  setfans auto
elif [[ $SYSTEMP > 40 ]]; then
  setfans auto
elif [[ $SYSTEMP > 39 ]]; then
  setfans 70
elif [[ $SYSTEMP > 38 ]]; then
  setfans 60
elif [[ $SYSTEMP > 37 ]]; then
  setfans 50
elif [[ $SYSTEMP > 36 ]]; then
  setfans 40
elif [[ $SYSTEMP > 35 ]]; then
  setfans 40
elif [[ $SYSTEMP > 34 ]]; then
  setfans 40
elif [[ $SYSTEMP > 33 ]]; then
  setfans 40
elif [[ $SYSTEMP > 32 ]]; then
  setfans 40
elif [[ $SYSTEMP > 31 ]]; then
  setfans 40
elif [[ $SYSTEMP > 30 ]]; then
  setfans 40
elif [[ $SYSTEMP > 29 ]]; then
  setfans 40
else
  setfans 23
fi

sleep 10

done
