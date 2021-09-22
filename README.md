# RPi-backup #

Creator: Thiemo Schuff, thiemo@schuff.eu
Source: https://github.com/Starwhooper/RPi-status-on-OLED

## Installation ##
install all needed packages to prepare the software environtent of your Raspberry Pi:
```bash
```

and this tool itself:
```bash
cd /opt
sudo git clone https://github.com/Starwhooper/RPi-backup
```

## First configurtion ##
```bash
sudo cp /opt/RPi-backup/config.json.example /opt/RPi-backup/config.json
sudo nano /opt/RPi-backup/config.json
```

## Start ##
Its also able to add it in cron via ```sudo crontab -e```, it prevent doublicate starts
```bash
/opt/RPi-backup/backup.sh
```
one of these parameter is needed:
* --createimageandcopyfiles -cicf
* --createimage -ci
* --copyfiles -cf


## Update ##
If you already use it, feel free to update with
```bash
cd /opt/RPi-backup
sudo git pull origin main
```
