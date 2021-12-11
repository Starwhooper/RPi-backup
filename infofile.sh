#. config.cfg

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

echo ===BIGGEST FOLDER=== >> ${INFOFILE}
echo $(du -hsx /* | sort -rh | head -10) >> ${INFOFILE}
