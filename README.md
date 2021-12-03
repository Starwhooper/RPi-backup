RPi-backup
==========

* Creator: Thiemo Schuff, thiemo@schuff.eu
* Source: https://github.com/Starwhooper/RPi-status-on-OLED
* License: CC-BY-SA-4.0

Installation
------------
install PiShrink on your system: 
```bash
cd /opt
sudo git clone https://github.com/Drewsif/PiShrink
```
and this tool itself:
```bash
cd /opt
sudo git clone https://github.com/Starwhooper/RPi-backup
sudo chmod +x /opt/RPi-backup/backup.sh
```

First configurtion
------------------
```bash
sudo cp /opt/RPi-backup/config.cfg.example /opt/RPi-backup/config.cfg
sudo nano /opt/RPi-backup/config.cfg
```

Start
-----
Its also able to add it in cron via ```sudo crontab -e```, it prevent doublicate starts
```bash
/opt/RPi-backup/backup.sh
```

one of these parameter are needed:
* -cf: copy files
* -ci: create image
  * -ds: shrink image
* -cl: clean
* -ct: create infotext

Update
------
If you already use it, feel free to update with
```bash
cd /opt/RPi-backup
sudo git pull origin main
```
