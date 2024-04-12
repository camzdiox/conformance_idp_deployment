ARG PHP_VERSION="8.3"
ARG COMPOSER_VERSION="2"
ARG SSP_VERSION="2.1.3"

FROM mlocati/php-extension-installer AS extension_installer
FROM composer/composer:${COMPOSER_VERSION} as composer

FROM php:${PHP_VERSION}${PHP_VERSION:+-}fpm AS base

ARG DEBIAN_FRONTEND=noninteractive
ARG SSPHP_API_TOKEN
ARG SSPHP_ADMIN_PASSWORD
#RUN echo "PHP API Token is: $SSPHP_API_TOKEN" \
#    && echo "ADMIN PASS: $SSPHP_ADMIN_PASSWORD"

# use production php.ini
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# install PHP extensions and their dependencies
COPY --from=extension_installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions gmp intl pdo_mysql zip

FROM base AS ssp_builder

ARG SSP_VERSION

ARG DEBIAN_FRONTEND=noninteractive
ARG COMPOSER_ALLOW_SUPERUSER=1

# add composer
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN apt update -y \
    && apt install -y --no-install-recommends git wget zip

# install SimpleSAMLphp
RUN cd /var \
    # TODO: git clone your module here etc., adapt as needed
    && wget https://github.com/simplesamlphp/simplesamlphp/releases/download/v${SSP_VERSION}/simplesamlphp-${SSP_VERSION}.tar.gz -O simplesamlphp.tar.gz \
    && tar -xzf simplesamlphp.tar.gz \
    && mv simplesamlphp-${SSP_VERSION} simplesamlphp \
    && cd simplesamlphp \
    && /usr/bin/composer install --no-interaction --no-dev --no-progress \
    && cp config/config.php.dist config/config.php \
    && cp config/authsources.php.dist config/authsources.php \
    && cp metadata/saml20-idp-hosted.php.dist metadata/saml20-idp-hosted.php \
    && cp metadata/saml20-idp-remote.php.dist metadata/saml20-idp-remote.php \
    && cp metadata/saml20-sp-remote.php.dist metadata/saml20-sp-remote.php \
    && mkdir -p /tmp/cache/simplesamlphp

# install conformance module
RUN cd /var/simplesamlphp \
    && composer config minimum-stability dev \
    && composer config repositories.0 git https://github.com/cicnavi/simplesamlphp-module-conformance.git \
    && composer require --no-progress cicnavi/simplesamlphp-module-conformance:dev-wip

# modify config
RUN sed -i "s/'session.cookie.secure' => true,/'session.cookie.secure' => false,/g" /var/simplesamlphp/config/config.php \
    && sed -i "s/'cachedir' => '\/var\/cache\/simplesamlphp',/'cachedir' => '\/tmp\/cache\/simplesamlphp',/g" /var/simplesamlphp/config/config.php \
    && sed -i "s/'auth.adminpassword' => '123',/'auth.adminpassword' => '$SSPHP_ADMIN_PASSWORD',/g" /var/simplesamlphp/config/config.php

# enable conformance IdP module
RUN sed -i "s/'saml' => true/&,/" /var/simplesamlphp/config/config.php
RUN sed -i "/'saml' => true,/a \ \ \ \ \ \ \ \ \'conformance' => true" /var/simplesamlphp/config/config.php
RUN cp /var/simplesamlphp/modules/conformance/config-templates/module_conformance.php /var/simplesamlphp/config/
RUN sed -i "s/'database.dsn' => 'mysql:host=localhost;dbname=saml',/'database.dsn' => 'mysql:host=mariadb;dbname=saml',/" /var/simplesamlphp/config/config.php \
    && sed -i "s/'database.username' => 'simplesamlphp',/'database.username' => 'root',/" /var/simplesamlphp/config/config.php \
    && sed -i "s/'database.password' => 'secret',/'database.password' => '',/" /var/simplesamlphp/config/config.php
RUN sed -i '/99 => .*core:LanguageAdaptor.*/a \        1000 => '\''conformance:Conformance'\'',' /var/simplesamlphp/config/config.php
RUN sed -i "/\['type' => 'flatfile'\],/a \        \['type' => 'pdo'\]," /var/simplesamlphp/config/config.php
RUN sed -i "s|//\('strong-random-token-string' => 'Token description',\)|'strong-random-token-string' => '$SSPHP_API_TOKEN',|g" /var/simplesamlphp/config/module_conformance.php


# finalize

FROM base

COPY --from=ssp_builder /var/simplesamlphp/ /var/simplesamlphp/

EXPOSE 9000

RUN chown -R www-data:www-data /var/www

#FROM cicnavi/dap:82

# Install GO
# GO version to download and install. Refer to https://go.dev/dl/
ENV GO_VERSION=go1.21.5.linux-amd64.tar.gz
ADD https://go.dev/dl/$GO_VERSION /usr/local/
RUN tar xf /usr/local//$GO_VERSION -C /usr/local/ && \
    rm /usr/local//$GO_VERSION
ENV GOROOT=/usr/local/go
ENV GOPATH=$HOME/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Install Chromium to enable headless support for Nuclei
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends --fix-missing \
    chromium \
    postfix

# Install Nuclei
RUN go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest
RUN go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# Create html symlink pointing to SSP public dir
RUN cd /var/www && rm -rf html && ln -s conformance-idp/public html

WORKDIR /var/simplesamlphp
