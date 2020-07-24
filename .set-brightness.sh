#!/bin/sh
BrPath='/sys/class/backlight/intel_backlight'
BrCurr=`cat ${BrPath}/brightness`
BrMax=`cat ${BrPath}/max_brightness`
PCurr=$(( (100 * BrCurr / BrMax) ))
PNew=$(( (PCurr + $1) ))
if [ $PNew -gt 100 ]; then
   PNew=100
fi

if [ $PNew -lt 1 ]; then
   PNew=1
fi

BrNew=$(( (PNew * BrMax / 100) ))

echo $BrNew | sudo /usr/bin/tee ${BrPath}/brightness > /dev/null

