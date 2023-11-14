# DockerSQLBackup
A script to run on a host and backup your databases by container name.
It assumes you have docker containers running with MSSQL on a linux system and you know how to SSH into your system to set it up. 


# Configure your script

1) In the start of the script, define the docker names you wish to backup

devices=( "SQLPROD" "SQLDEV" )

2) Set the path of where the .bak files have to end up

backupPath="/share/DOCKERMEDIA/DBbackup"


# Install your script
1) Set permission

chmod +X DockerSQLBackup.sh

2) Set repetition of the task (every sunday)
 
echo "0 0 * * 0 /share/DOCKERMEDIA/DockerScripts/DockerSQLBackup.sh" >> /etc/config/crontab

3) restart crontab

crontab /etc/config/crontab && /etc/init.d/crond.sh restart

4) Validate

crontab -l
