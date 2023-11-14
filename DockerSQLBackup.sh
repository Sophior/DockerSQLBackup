#!/bin/bash
devices=( "SQLPROD" "SQLDEV" )
backupPath="/share/DOCKERMEDIA/DBbackup"

# perform backup
for i in "${devices[@]}";do
	STR=$(docker ps -aqf name="$i")
	echo "Processing $STR"
	SAPWD=$(docker exec "$STR" /bin/bash -c "echo \$SA_PASSWORD")
	for test in $(docker exec -it $STR /bin/bash -c "/opt/mssql-tools/bin/sqlcmd -U SA -S localhost -P $SAPWD -h -1 -Q 'set nocount on;select name from sys.databases'")
	do
		if [ ${#test} -ge 2 ]; then # skip blank lines
			filename="$(date +%Y%m%d_%H%M%S)_${i}_${test}.bak"
			#echo "$filename"		
			$(docker exec "$STR" /opt/mssql-tools/bin/sqlcmd -U SA -S localhost -P "$SAPWD" -h -1 -Q "set nocount on;BACKUP DATABASE [$test] TO DISK='/var/opt/mssql/data/$filename' WITH INIT")
			cd $backupPath
			$(docker cp "$STR":/var/opt/mssql/data/$filename $filename)
			 $(echo "$filename" > lastbackup.txt)
			 $(docker cp  lastbackup.txt "$STR":/var/opt/mssql/data/lastbackup.txt)
		fi
	done
done

# perform remove of remnant backcups
echo "Cleaning .bak files in the containers"
for i in "${devices[@]}";do
	STR=$(docker ps -aqf name="$i")
	echo "Processing $STR"
		 $(docker exec "$STR" /bin/bash -c "rm /var/opt/mssql/data/*.bak")
	done
done

