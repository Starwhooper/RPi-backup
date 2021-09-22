#!/bin/bash

if [ ${hostname} ]; then HOSTNAME=$(hostname); fi
HOSTNAME=${HOSTNAME,,}

. config.cfg

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
else



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
			$PISHRINK $PISHRINKPARAMETER $IMAGEPATHFILE $IMAGEPISHRINKPATHFILE
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
fi

if [ $CREATEINFOFILE = "1" ]; then
	. infofile.sh ;
fi
