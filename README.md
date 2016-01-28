# docker-owncloud

### Available Configuration Parameters

- **DB_TYPE**: The database type. Possible values: `mysql`,`pgsql`,`sqlite`. (default:`sqlite`)
- **DB_HOST**: Hostname of the database(default: `localhost`)
- **DB_NAME**: Name of the database
- **DB_USER**: User name to connect to the database(default: `owncloud`)
- **DB_PASS**: Password of the database user
- **ADMIN_USER**: User name of the admin account (default: "admin")
- **ADMIN_PASS**: Password of the admin account. Password is only set on the first run (default: "pass4owncloud")
- **OC_DEFAULT_LANGUAGE**: Default language for users.Using ISO_639-1 language codes
- **OC_DEFAULT_APP**: Default app to open on login
- **OC_TRUSTED_DOMAINS**: List of trusted domains that users can log into(default: "localhost"). Array not supported in 8.2.2 yet.
- **OC_HAS_INTERNET**: Is ownCloud connected to the Internet?(default: "true")
- **OC_SMTP_HOST**: Specify the IP address or host name of your mail server host
- **OC_SMTP_PORT**: Port of your smtp mail server(default: 25 for no encryption, 587 for ssl or tls)
- **OC_SMTP_SECURE**: Using ``ssl`` or ``tls``, or leave empty for no encryption
- **OC_SMTP_USER**: The username for authenticating to the SMTP server
- **OC_SMTP_PASS**: The user password
- **OC_SMTP_EMAIL**: Email address for the user, like this: ``demo@example.com``(default: ``OC_SMTP_USER`` is used)
- **OC_SMTP_AUTH_TYPE**: Specify the SMTP authentication method. Defaults to ``LOGIN`` if ``OC_SMTP_USER`` is set.

## Quick Start

```sh
docker pull 7kbird/owncloud
docker run -d --name=owncloud -v /srv/docker/owncloud:/owncloud_data -p 80:80 7kbird/owncloud
```