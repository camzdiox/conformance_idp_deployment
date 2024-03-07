# Conformance IdP deployment

To easily run the conformance IdP, you can use docker compose:

```shell
cd docker
docker compose up -d --build
```

This will start SimpleSAMLphp at `http://localhost/simplesaml/module.php/admin` with the conformance module installed,
mariaDB database and nginx as a reverse proxy.

You need to mount configuration and metadata folders, see `docker-compose.yml`, and add HTTPS (e.g. Let's encrypt).
