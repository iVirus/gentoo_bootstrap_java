USE `mysql`;

DELETE
FROM `user`
WHERE `User` LIKE 'root';

DELETE
FROM `db`
WHERE `User` LIKE '';

GRANT
ALL PRIVILEGES
ON *.*
TO 'bmoorman'@'%' IDENTIFIED BY PASSWORD '%BMOORMAN_HASH%'
WITH GRANT OPTION;

GRANT
ALL PRIVILEGES
ON *.*
TO 'ecall'@'10.%' IDENTIFIED BY PASSWORD '%ECALL_HASH%'
WITH GRANT OPTION;

GRANT
SELECT, INSERT, UPDATE, DELETE
ON *.*
TO 'tpurdy'@'%' IDENTIFIED BY PASSWORD '%TPURDY_HASH%';

GRANT
SELECT
ON *.*
TO 'npeterson'@'%' IDENTIFIED BY PASSWORD '%NPETERSON_HASH%';

GRANT
REPLICATION SLAVE
ON *.*
TO 'replication'@'10.%' IDENTIFIED BY '%REPLICATION_AUTH%';

GRANT
PROCESS, SUPER, REPLICATION CLIENT
ON *.*
TO 'monitoring'@'localhost' IDENTIFIED BY '%MONITORING_AUTH%';

GRANT
PROCESS
ON *.*
TO 'mytop'@'localhost' IDENTIFIED BY '%MYTOP_AUTH%';

FLUSH PRIVILEGES;

RESET MASTER;

CHANGE MASTER TO
master_host = '%MASTER_HOST%',
master_user = 'replication',
master_password = '%MASTER_AUTH%';

START SLAVE;
