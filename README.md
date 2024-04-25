# Conformance IdP deployment

To easily run the conformance IdP, you can use docker compose, but before that, a valid DNS record needs to be created in your DNS zone so that certbot could automatically generate TLS certificates for your Conformance IdP instance.
After having DNS record created, please edit the .env file and replace variables as per your need. 

* `SSPHP_ADMIN_PASSWORD` - SimplesamlPHP portal administrative password
* `SSPHP_API_TOKEN` - SimplesamlPHP administrative API token
* `DOMAIN_NAME` - A valid FQDN your instance will be available at.
* `CERTBOT_EMAIL` - an email you'll be receiving notifications from Letsencrypt to. The domain part of the email must be valid.

We strongly recommend replacing dfault credentials with new, complex ones.

After .env file variables are defined, you can build docker containers as follows:

```shell
cd docker
docker compose up -d --build
docker exec conformance_idp php /var/simplesamlphp/bin/initMDSPdo.php
docker exec conformance_idp php /var/simplesamlphp/modules/conformance/bin/install.php
```

This will start SimpleSAMLphp at `http://DOMAIN_NAME/simplesaml/module.php/admin` with the conformance module installed,
mariaDB database and nginx as a reverse proxy.

You need to mount configuration and metadata folders, see `docker-compose.yml`.

If you need your SimplesamlPHP instance to be running on HTTPS, then check the content of the "./certbot/conf/live/DOMAIN_NAME" directory, it sould contain the certificates and the key file. There should be the following files: cert.pem  chain.pem  fullchain.pem  privkey.pem, otherwise please check the certbot container logs as follows:

```shell
docker logs certbot
```

After making sure that the certificates have been generated, the script ./apply_https.sh will help to configure reverseproxy container.

Make the script executable and run it:

```shell
chmod ug+x ./apply_https.sh
./apply_https.sh
```

After this you should be able to access your SimplesamlPHP instance on HTTPS, as follows: https://DOMAIN_NAME/simplesaml/module.php/admin
