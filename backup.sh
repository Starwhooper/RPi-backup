#!/bin/bash

parametererror=0
#if [ -s $1 ]
if  [ $# -gt 1 ] || [ $# -lt 1 ]
	then parametererror=1
else
	if [ $1 == '--createimageandcopyfiles' ] || [ $1 == '--createimage' ] || [ $1 == '--copyfiles' ] || [ $1 == '-cicf' ] || [ $1 == '-ci' ] || [ $1 == '-cf' ]
		then true #echo "parameter gesetzt"
	else
		parametererror=1
	fi
fi

if [ $parametererror == 1 ]; then
	echo "falsche Parameter"
	echo "--createimageandcopyfiles, -cicf"
	echo "--createimage, -ci"
	echo "--copyfiles, -cf"
	exit
fi

if [ ${hostname} ]; then HOSTNAME=$(hostname); fi
HOSTNAME=${HOSTNAME,,}

. config.cfg

if [ $1 ]; then
	if [ $1 == '--createimage' ] || [ $1 == '--createimageandcopyfiles' ] || [ $1 == '-ci' ] || [ $1 == '-cicf' ]; then

		#Bereinigen des apt-get
		if which apt-get 2>/dev/null|grep -q apt-get; then
			apt-get clean
		fi

		# Backup mit Hilfe von dd erstellen und im angegebenen Pfad speichern
		mkdir -p $IMAGEPATH
		dd if=/dev/mmcblk0 of=$IMAGEPATHFILE bs=1MB

		# Shrinken
		$PISHRINK -vpd $IMAGEPATHFILE $IMAGEPISHRINKPATHFILE
		if [ -f $IMAGEPISHRINKPATHFILE ]; then
			rm $IMAGEPATHFILE
		fi

	fi

	if [ $1 == '--copyfiles' ] || [ $1 == '--createimageandcopyfiles' ] || [ $1 == '-cf' ] || [ $1 == '-cicf' ]; then

		mkdir -p ${BACKUP_FILES_PFAD}
		for i in "${BACKUP[@]}"
		do
		 cp --parents $i ${BACKUP_FILES_PFAD}
		done

		cd ${BACKUP_FILES_PFAD}
		zip -qq -${ZIP_LEVEL} -rm ${BACKUP_FILES_PFAD}.zip *
		rmdir ${BACKUP_FILES_PFAD}
	fi
fi


INFOFILE=${BACKUP_PFAD}/$(date +%Y%m)_info.txt
echo Datum: $(date +%Y%m%d) > ${INFOFILE}

echo ===UNAME========= >> ${INFOFILE}
echo Kernel Name: $(uname -s) >> ${INFOFILE}
echo Network Hostname : $(uname -n) >> ${INFOFILE}
echo Kernel Release: $(uname -r) >> ${INFOFILE}
echo Kernel Version: $(uname -v | cut -d' ' -f 1) >> ${INFOFILE}
echo Betriebssystem: $(uname -o) >> ${INFOFILE}

echo ===Raspberry Pi== >> ${INFOFILE}
echo Hardware Name: $(cat /proc/cpuinfo | grep model | grep name | cut -d' ' -f 3-10 | sed -n 1p) >> ${INFOFILE}
echo Prozessor Typ: $(cat /proc/cpuinfo | grep Hardware | cut -d' ' -f 2) >> ${INFOFILE}
echo Hardware Platform: $(cat /proc/cpuinfo | grep Model | cut -d' ' -f 2-10) >> ${INFOFILE}

echo Memory: $(free -h -w | grep Mem: | cut -c 14-20) >> ${INFOFILE}

echo ===SD============ >> ${INFOFILE}
echo Size: $( df / -h | sed -n 2p | tr -s " " " " | cut -d' ' -f2) >> ${INFOFILE}
echo Used: $( df / -h | sed -n 2p | tr -s " " " " | cut -d' ' -f3) >> ${INFOFILE}
echo Use%: $( df / -h | sed -n 2p | tr -s " " " " | cut -d' ' -f5) >> ${INFOFILE}

echo ===Temperatur==== >> ${INFOFILE}
cputemp=$(</sys/class/thermal/thermal_zone0/temp)
echo CPU: $((cputemp/1000)) °C >> ${INFOFILE}
echo GPU: $(vcgencmd measure_temp | cut -d'=' -f2) >> ${INFOFILE}

echo ===CAT=========== >> ${INFOFILE}
echo Debian Version: $(cat /etc/debian_version) >> ${INFOFILE}

echo ===LSB_RELEASE=== >> ${INFOFILE}
echo $(lsb_release --id) >> ${INFOFILE}
echo $(lsb_release --description) >> ${INFOFILE}
echo $(lsb_release --release) >> ${INFOFILE}
echo $(lsb_release --codename) >> ${INFOFILE}
