# DockerSQLBackup

A script to run on a host and backup your databases by container name.

It assumes you have docker containers running with MSSQL on a linux system and you know how to SSH into your system to set it up. 

The purpose is to automate this process and define the container name. Which elevates the need to reconfigure scripts after an image has been recreated and they have new ids.

It will read the SA-environment variable out of the docker container and use it to access the database.
The databases are then iterated and backed up one by one, and copied over to your configured backupPath.

After the script has finished, it will iterate the containers again and remove the .bak files in order to keep the container uncluttered.


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

3) Make crontab see the changes
 crontab /etc/config/crontab
4) restart crontab

crontab /etc/config/crontab && /etc/init.d/crond.sh restart

5) Validate

crontab -l
