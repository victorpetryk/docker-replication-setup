# MySQL replication (master-slave) setup with Docker.

Install [Docker](https://github.com/victorpetryk/prepare-desktop-for-development/blob/master/scripts/docker.sh). 

Commands:
- `bin/start.sh` - start DB servers _(master and slave)_ and setup replication.
- `bin/stop.sh` - stop DB servers and delete related data.
- `docker-compose exec [mysql_master|mysql_slave] mysql -uroot -proot` - go to MySQL console on master|slave server

Info:
```
Master Server:
- Host: [IP]
- Port: 4306
- User: master_user
- Password: master_password
-----
Slave Server:
- Host: [IP]
- Port: 5306
- User: slave_user
- Password: slave_password
---
- User: read_only
- Password: ro_password
```