#!/bin/bash
verbose=1

if [ ${hostname} ]; then HOSTNAME=$(hostname); fi
HOSTNAME=${HOSTNAME,,}

scriptfolder=$(dirname $0)

. $scriptfolder/config.cfg

do_copyfiles=0
do_createimage=0
do_clean=0
do_createtext=0

for i in $*
do
 if [ "$i" = "-cf" ] 
  then 
   do_copyfiles=1
 elif [ "$i" = "-ci" ] 
  then 
   do_createimage=1
 elif [ "$i" = "-cl" ] 
  then 
   do_clean=1
 elif [ "$i" = "-ct" ] 
  then 
   do_createtext=1
 elif [ "$i" = "-ds" ] 
  then 
   do_shrink=1
 fi
done

if [ $(($do_copyfiles + $do_createimage + $do_clean + $do_createtext + do_shrink)) -lt 1 ]; then
	echo "keine passenden parameter"
	echo "-cf: copy files"
	echo "-ci: create image"
	echo "-cl: clean"
	echo "-ct: create infotext"
	echo "-ds: shrink image (required -ci)"
	exit 0
fi

##################################################
# Bereinigen
if [ $do_clean = 1 ]; then
	if [[ $verbose == 1 ]]; then echo clean apt-get; fi
	if which apt-get 2>/dev/null|grep -q apt-get; then
		apt-get clean
	fi
fi

##################################################
# Image erstellen
if [ $do_createimage = 1 ]; then
	mkdir -p $IMAGEPATH
	if [[ $verbose == 1 ]]; then
		echo create image
		dd if=/dev/mmcblk0 of=$IMAGEPATHFILE bs=1MB count=10MB status=progress
	else
		dd if=/dev/mmcblk0 of=$IMAGEPATHFILE bs=1MB
	fi
fi

##################################################
# Image verkleinern
if [ $do_createimage = 1 ] && [ $do_shrink = 1 ]; then
	if [[ $verbose == 1 ]]; then echo start to shrink image; fi
	if [[ $verbose == 1 ]]; then echo $PISHRINK $PISHRINKPARAMETER $IMAGEPATHFILE $IMAGEPISHRINKPATHFILE; fi
	$PISHRINK $PISHRINKPARAMETER $IMAGEPATHFILE $IMAGEPISHRINKPATHFILE
	if [ -f $IMAGEPISHRINKPATHFILE ]; then
		rm $IMAGEPATHFILE
	fi
fi

##################################################
# Dateien kopieren
if [ $do_copyfiles = 1 ]; then
	mkdir -p ${BACKUP_FILES_PFAD}
	for i in "${BACKUP[@]}"; do
		cp --parents $i ${BACKUP_FILES_PFAD}
	done

	cd ${BACKUP_FILES_PFAD}
	zip -qq -${ZIP_LEVEL} -rm ${BACKUP_FILES_PFAD}.zip *
	rmdir ${BACKUP_FILES_PFAD}
fi

##################################################
# Info text
if [ $do_createtext = 1 ]; then
 . $scriptfolder/infofile.sh ;
fi
