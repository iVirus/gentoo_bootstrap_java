## Parameters

- [ ] ~~setup_backup.sh~~
  - -b backup_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_bin.sh
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_db.sh
  - -m master_name:master_ip
  - -i server_id
  - -o offset
  - -b backup_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_deploy.sh
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_eh.sh
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [ ] ~~setup_fs.sh~~
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_inbound.sh
  - -m master_name:master_ip
  - -i server_id
  - -o offset
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_jp.sh
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [ ] ~~setup_log.sh~~
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_mdb.sh
  - -p peer_name:peer_ip[,peer_name:peer_ip,...]
  - -b backup_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_monitor.sh
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_mq.sh
  - -p peer_name:peer_ip
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_ns.sh
  - -p peer_name:peer_ip
- [x] setup_pub.sh
  - -p peer_name:peer_ip
  - -i server_id
  - -o offset
  - -b backup_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [ ] ~~setup_rfs.sh~~
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [ ] setup_router.sh
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_sip.sh
  - -p peer_name:peer_ip[,peer_name:peer_ip,...]
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_socket.sh
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_stats.sh
  - -i server_id
  - -o offset
  - -b backup_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_systems.sh
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_web.sh
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]
- [x] setup_worker.sh
  - -i server_id
  - -o offset
  - -b files_bucket_name
  - -h hostname_prefix [optional]
  - -e environment_suffix [optional]

## Databases

setup_db.sh

| host  | master (-m) | server_id (-i) | offset (-o) |
| ----- | ----------- | -------------- | ----------- |
| dbx_0 | dbx_1       | 1              | 1           |
| dbx_1 | dbx_0       | 2              | 2           |
| dbx_2 | dbx_1       | 3              | 1           |

setup_inbound.sh

| host     | master (-m) | server_id (-i) | offset (-o) |
| -------- | ----------- | -------------- | ----------- |
| inbound1 | inbound2    | 1              | 1           |
| inbound2 | inbound1    | 2              | 2           |

setup_pub.sh

| host | peer (-p) | server_id (-i) | offset (-o) |
| ---- | --------- | -------------- | ----------- |
| pub1 | pub2      | 1              | 1           |
| pub2 | pub1      | 2              | 2           |

setup_stats.sh

| host  | server_id (-i) | offset (-o) |
| ----- | -------------- | ----------- |
| stats | 1              | 1           |

setup_worker.sh

| host   | server_id (-i) | offset (-o) |
| ------ | -------------- | ----------- |
| worker | 1              | 1           |

## User Data

```bash
#!/bin/bash
scripts="https://raw.githubusercontent.com/iVirus/gentoo_bootstrap_java/master/templates/hvm/scripts"

filename="setup_%TYPE%.sh"
setup_file="$(mktemp)"
curl -sf -o "${setup_file}" "${scripts}/${filename}" || exit 1
bash "${setup_file}" %PARAMETERS%
cfn-signal --region=%REGION% --stack=%STACK% --resource=%RESOURCE% --exit-code=$?
```
