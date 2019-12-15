#!/bin/bash

# Create and assign user permissions to a replica on Master server.
docker-compose exec mysql_master mysql -uroot -proot -e "GRANT REPLICATION SLAVE ON *.* TO 'slave_user'@'%' IDENTIFIED BY 'slave_password';
FLUSH PRIVILEGES;"

# Show Master status and grab needed data.
MASTER_STATUS=$(docker-compose exec mysql_master mysql -uroot -proot -e "SHOW MASTER STATUS")
MASTER_HOST=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql_master)
SLAVE_HOST=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql_slave)
CURRENT_LOG=$(echo "$MASTER_STATUS" | awk '{print $2}' | grep mysql)
CURRENT_POS=$(echo "$MASTER_STATUS" | awk '{print $4}' | grep -o '[0-9]*')

# Enable replication.
SLAVE_STMT="CHANGE MASTER TO MASTER_HOST='$MASTER_HOST',MASTER_USER='slave_user',MASTER_PASSWORD='slave_password',MASTER_LOG_FILE='$CURRENT_LOG',MASTER_LOG_POS=$CURRENT_POS;"
docker-compose exec mysql_slave mysql -uroot -proot -e "$SLAVE_STMT; START SLAVE;"

# Show Slave status.
docker-compose exec mysql_slave mysql -uroot -proot -e "SHOW SLAVE STATUS\G"

# Create "read-only" user on Slave server.
docker-compose exec mysql_slave mysql -uroot -proot -e "CREATE USER 'read_only'@'%' IDENTIFIED BY 'ro_password'; GRANT SELECT ON *.* TO 'read_only'@'%'; FLUSH PRIVILEGES;"

# Show Info.
echo "
$(tput setaf 2)
Master Server:
- Host: $MASTER_HOST
- Port: 4306
- User: master_user
- Password: master_password
-----
Slave Server:
- Host: $SLAVE_HOST
- Port: 5306
- User: slave_user
- Password: slave_password
---
- User: read_only
- Password: ro_password
"