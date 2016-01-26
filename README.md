# docker-owncloud

### Available Configuration Parameters

- **DB_TYPE**: The database type. Possible values: `mysql`,`pgsql`,`sqlite`. (default:`sqlite`)
- **DB_HOST**: Hostname of the database(default: `localhost`)
- **DB_NAME**: Name of the database
- **DB_USER**: User name to connect to the database(default: `owncloud`)
- **DB_PASS**: Password of the database user
- **ADMIN_USER**: User name of the admin account (default: "admin")
- **ADMIN_PASS**: Password of the admin account. Password is only set on the first run (default: "pass4owncloud")

## Quick Start

```sh
docker pull 7kbird/owncloud
docker run -d --name=owncloud -v /srv/docker/owncloud:/owncloud_data -p 80:80 7kbird/owncloud
```