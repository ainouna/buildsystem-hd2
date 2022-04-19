#!/bin/sh
#start-emu by Lizard

killall ncam
killall oscam
killall mgcamd
killall wicardd-sh4
killall incubusCamd.sh4_e2

emu=`cat /usr/bin/cam/setemu`

if [ $emu == "ncam" ]; then
/usr/bin/cam/Ncam-1.1 -c /var/keys &
fi
if [ $emu == "oscam" ]; then
/usr/bin/cam/oscam -c /var/keys &
fi
if [ $emu == "mgcamd" ]; then
/usr/bin/cam/mgcamd -c /var/keys &
fi
if [ $emu == "wicardd" ]; then
/usr/bin/cam/wicardd-sh4 /var/etc/wicardd.conf & 
fi
if [ $emu == "incubuscamd" ]; then
/usr/bin/cam/incubusCamd.sh4_e2 /var/keys/incubusCamd.conf &
fi
