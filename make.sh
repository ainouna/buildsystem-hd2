#!/bin/bash

#
#
#
if [ "$(id -u)" = "0" ]; then
	echo ""
	echo "You are running as root. Do not do this, it is dangerous."
	echo "Aborting the build. Log in as a regular user and retry."
	echo ""
	exit 1
fi

#
#
#
if [ "$1" == -h ] || [ "$1" == --help ]; then
	echo "Parameter 1: target system (1-90)"
	echo "Parameter 2: kernel (1-2) for sh4 cpu"
	echo "Parameter 3: optimization (1-4)"
	echo "Parameter 4: Media Framework (1-2)"
	echo "Parameter 5: WLAN Support (1-2)"
	echo "Parameter 6: Neutrino Plugin Interfaces (lua/python) (1-4)"
	echo "Parameter 7: CI-Cam Interface (1-2)"
	echo "Parameter 8: Scart Interface (1-2)"
	echo "Parameter 9: VFD/LCD Interface (1-4)"
	echo "Parameter 10: Function Keys (1-2)"
	exit
fi

#
# cpu arch / boxtype
#
case $1 in
	[1-9] | 1[0-9] | 2[0-9] | 3[0-9] | 4[0-9] | 5[0-9] | 6[0-9] | 7[0-9] | 8[0-9] | 9[0-9]) REPLY=$1;;
	*)
		echo "Target receivers:"
		echo "  Kathrein"
		echo "    1)  UFS-910"
		echo "    2)  UFS-912"
		echo "    3)  UFS-913"
		echo "    4)  UFS-922"
		echo
		echo "  Topfield"
		echo "    6)  TF77X0 HDPVR"
		echo
		echo "  Fortis"
		echo "    7)  FS9000 / FS9200 (formerly Fortis HDbox)"
		echo "    8)  HS9510          (formerly Octagon SF1008P)"
		echo "    9)  HS8200          (formerly Atevio AV7500)"
		echo
		echo "  AB IPBox/cuberevo/Xsarius"
		echo "   16)  55HD"
		echo "   18)  9900HD"
		echo "   19)  9000HD / id."
		echo "   20)  900HD / mini"
		echo "   21)  910HD / mini2"
		echo "   22)  91HD / 250HD"
		echo "   24)  2000HD"
		echo "   26)  3000HD / Xsarius Alpha"
		echo
		echo "  Fulan"
		echo "   27)  Spark"
		echo "   28)  Spark7162"
		echo
		echo "  VU Plus"
		echo "   40)  Vu+ Solo4K"
		echo "   41)  VU+ Duo"
		echo "   42)  VU+ Duo2"
		echo "   43)  VU+ Duo4k"
		echo "   44)  VU+ Ultimo4k"
		echo "   45)  VU+ Uno4k"
		echo "   46)  VU+ Uno4kse"
		echo "   47)  VU+ Zero4k"
		echo
		echo "  AX Mutant"
		echo "   50)  Mut@nt HD51"
		echo "   51)  Mut@nt HD60"
		echo "   52)  Mut@nt HD61"
		echo
		echo "  Edision"
		echo "   60)  osnino"
		echo "   61)  osninoplus" 
		echo "   62)  osninopro" 
		echo "   63)  osmio4k"
		echo "   64)  osmio4kplus"
		echo "   65)  osmini4k"  
		echo
		echo "  Giga Blue"
		echo -e "\033[01;32m   70)  gb800se\033[00m"
		echo
		echo "  WWIO"
		echo "   80)  WWIO BRE2ZE 4K"
		echo
		echo "  Air Digital"
		echo "   90)  Zgemma h7"
		read -p "Select target (1-90)? ";;
esac

case "$REPLY" in
	 1) BOXARCH="sh4";BOXTYPE="ufs910";;
	 2) BOXARCH="sh4";BOXTYPE="ufs912";;
	 3) BOXARCH="sh4";BOXTYPE="ufs913";;
	 4) BOXARCH="sh4";BOXTYPE="ufs922";;
	 6) BOXARCH="sh4";BOXTYPE="tf7700";;
	 7) BOXARCH="sh4";BOXTYPE="fortis_hdbox";;
	 8) BOXARCH="sh4";BOXTYPE="octagon1008";;
	 9) BOXARCH="sh4";BOXTYPE="atevio7500";;
	16) BOXARCH="sh4";BOXTYPE="ipbox55";;
	18) BOXARCH="sh4";BOXTYPE="ipbox9900";;
	19) BOXARCH="sh4";BOXTYPE="cuberevo";;
	20) BOXARCH="sh4";BOXTYPE="cuberevo_mini";;
	21) BOXARCH="sh4";BOXTYPE="cuberevo_mini2";;
	22) BOXARCH="sh4";BOXTYPE="cuberevo_250hd";;
	24) BOXARCH="sh4";BOXTYPE="cuberevo_2000hd";;
	26) BOXARCH="sh4";BOXTYPE="cuberevo_3000hd";;
	27) BOXARCH="sh4";BOXTYPE="spark";;
	28) BOXARCH="sh4";BOXTYPE="spark7162";;
	40) BOXARCH="arm";BOXTYPE="vusolo4k";;
	41) BOXARCH="mips";BOXTYPE="vuduo";;
	42) BOXARCH="mips";BOXTYPE="vuduo2";;
	43) BOXARCH="arm";BOXTYPE="vuduo4k";;
	44) BOXARCH="arm";BOXTYPE="vuultimo4k";;
	45) BOXARCH="arm";BOXTYPE="vuuno4k";;
	46) BOXARCH="arm";BOXTYPE="vuuno4kse";;
	47) BOXARCH="arm";BOXTYPE="vuzero4k";;
	50) BOXARCH="arm";BOXTYPE="hd51";;
	51) BOXARCH="arm";BOXTYPE="hd60";;
	52) BOXARCH="arm";BOXTYPE="hd61";;
	60) BOXARCH="mips";BOXTYPE="osnino";;
	61) BOXARCH="mips";BOXTYPE="osninoplus";;
	62) BOXARCH="mips";BOXTYPE="osninopro";;
	63) BOXARCH="arm";BOXTYPE="osmio4k";;
	64) BOXARCH="arm";BOXTYPE="osmio4kplus";;
	65) BOXARCH="arm";BOXTYPE="osmini4k";;
	70) BOXARCH="mips";BOXTYPE="gb800se";;
	80) BOXARCH="arm";BOXTYPE="bre2ze4k";;
	90) BOXARCH="arm";BOXTYPE="h7";;
	 *) BOXARCH="mips";BOXTYPE="gb800se";;
esac
#echo "BOXARCH=$BOXARCH" > config
echo "BOXTYPE=$BOXTYPE" > config

if [ $BOXARCH == "sh4" ]; then
#
# check for elf files
#
CURDIR=`pwd`
echo -ne "\n    Checking the .elf files in $CURDIR/root/boot..."
set='audio_7100 audio_7105 audio_7109 audio_7111 video_7100 video_7105 video_7109 video_7111'
for i in $set;
do
	if [ ! -e $CURDIR/root/boot/$i.elf ]; then
		echo -e "\n    ERROR: One or more .elf files are missing in ./root/boot!"
		echo "           ($i.elf is one of them)"
		echo
		echo "    Correct this and retry."
		echo
		exit
	fi
done
echo " [OK]"
echo

#
# STM Kernel
#
case $2 in
	[1-2]) REPLY=$2;;
	*)	echo -e "\nKernel:"
		echo "   1)  STM 24 P0209 [2.6.32.46]"
		echo -e "   \033[01;32m2)  STM 24 P0217 [2.6.32.71]\033[00m"
		read -p "Select kernel (1-2)? ";;
esac

case "$REPLY" in
	1)  KERNEL_STM="p0209";;
	2)  KERNEL_STM="p0217";;
	*)  KERNEL_STM="p0217";;
esac
echo "KERNEL_STM=$KERNEL_STM" >> config

fi

#
# Kernel Optimization
#
case $3 in
	[1-4]) REPLY=$3;;
	*)	echo -e "\nOptimization:"
		echo -e "   \033[01;32m1)  optimization for size\033[00m"
		echo "   2)  optimization normal"
		echo "   3)  Kernel debug"
		echo "   4)  debug (includes Kernel debug)"
		read -p "Select optimization (1-4)? ";;
esac

case "$REPLY" in
	1)  OPTIMIZATIONS="size";;
	2)  OPTIMIZATIONS="normal";;
	3)  OPTIMIZATIONS="kerneldebug";;
	4)  OPTIMIZATIONS="debug";;
	*)  OPTIMIZATIONS="size";;
esac
echo "OPTIMIZATIONS=$OPTIMIZATIONS" >> config

#
# WLAN Support
#
case $4 in
	[1-2]) REPLY=$4;;
	*)	echo -e "\nDo you want to build WLAN drivers and tools"
		echo -e "   \033[01;32m1) no\033[00m"
		echo "   2) yes (includes WLAN drivers and tools)"
		read -p "Select to build (1-2)? ";;
esac

case "$REPLY" in
	1) WLAN=" ";;
	2) WLAN="wlandriver";;
	*) WLAN=" ";;
esac
echo "WLAN=$WLAN" >> config

#
# Media Framework
#
case $5 in
	[1-2]) REPLY=$5;;
	*)	echo -e "\nMedia Framework:"
		echo "   1) libeplayer3"
		echo -e "   \033[01;32m2) gstreamer (recommended for mips and arm boxes)\033[00m"
		read -p "Select media framework (1-2)? ";;
esac

case "$REPLY" in
	1) MEDIAFW="buildinplayer";;
	2) MEDIAFW="gstreamer";;
	*) MEDIAFW="gstreamer";;
esac
echo "MEDIAFW=$MEDIAFW" >> config

#
# Plugins Interface (lua/python)
#
case $6 in
	[1-4]) REPLY=$6;;
	*)	echo -e "\nWhich neutrino interface do you want to build?:"
		echo -e "   \033[01;32m1) lua\033[00m"
		echo "   2)  python (experimental)"
		echo "   3)  lua and python (experimental)"
		echo "   4)  none"
		read -p "Select Interface to build (1-4)? ";;
esac

case "$REPLY" in
	1) INTERFACE="lua";;
	2) INTERFACE="python";;
	3) INTERFACE="lua-python";;
	4) INTERFACE=" ";;
	*) INTERFACE="lua";;
esac
echo "INTERFACE=$INTERFACE" >> config

#
# CI-Cam Interface
#
#case $7 in
#	[1-2]) REPLY=$7;;
#	*)	echo -e "\nci-cam interface?:"
#		echo -e "   \033[01;32m1) ci-cam\033[00m"
#		echo "   2)  none"
#		read -p "Select with ci-cam Interface or not (1-2)? ";;
#esac

#case "$REPLY" in
#	1) CICAM="ci-cam";;
#	2) CICAM=" ";;
#	*) CICAM="ci-cam";;
#esac
#echo "CICAM=$CICAM" >> config

#
# Scart Interface
#
#case $8 in
#	[1-2]) REPLY=$8;;
#	*)	echo -e "\nScart interface?:"
#		echo -e "   \033[01;32m1) scart\033[00m"
#		echo "   2)  none"
#		read -p "Select with Scart Interface or not (1-2)? ";;
#esac

#case "$REPLY" in
#	1) SCART="scart";;
#	2) SCART=" ";;
#	*) SCART="scart";;
#esac
#echo "SCART=$SCART" >> config

#
# VFD/LCD Interface
#
#case $9 in
#	[1-4]) REPLY=$9;;
#	*)	echo -e "\nLCD Support?:"
#		echo "   1)  lcd"
#		echo "   2)  vfd"
#		echo -e "   \033[01;32m3) 4 digits\033[00m"
#		echo "   4)  none"
#		read -p "Select with LCD Support or not (1-4)? ";;
#esac

#case "$REPLY" in
#	1) LCD="lcd";;
#	2) LCD="vfd";;
#	3) LCD="4-digits";;
#	4) LCD=" ";;
#	*) LCD="4-digits";;
#esac
#echo "LCD=$LCD" >> config

#
# Function Keys
#
#case $10 in
#	[1-2]) REPLY=$10;;
#	*)	echo -e "\nFunctions Keys Support?:"
#		echo "   1)  fkeys"
#		echo -e "   \033[01;32m2) none\033[00m"
#		read -p "Select with Functions Keys or not (1-2)? ";;
#esac

#case "$REPLY" in
#	1) FKEYS="fkeys";;
#	2) FKEYS=" ";;
#	*) FKEYS=" ";;
#esac
#echo "FKEYS=$FKEYS" >> config

#
# testing
#
#case $11 in
#	[1-2]) REPLY=$11;;
#	*)	echo -e "\nTesting Support?:"
#		echo "   1)  testing"
#		echo -e "   \033[01;32m2) none\033[00m"
#		read -p "Select with Tesing or not (1-2)? ";;
#esac
#
#case "$REPLY" in
#	1) TESTING="testing";;
#	2) TESTING=" ";;
#	*) TESTING=" ";;
#esac
#echo "TESTING=$TESTING" >> config

#
#
#
echo " "
make printenv

#
#
#
echo "Your next step could be:"
echo "  make flashimage"
echo "for more details:"
echo "  make help"
echo "to check your build enviroment:"
echo "  make printenv"
echo " "


