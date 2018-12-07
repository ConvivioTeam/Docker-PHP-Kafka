FROM wodby/php:7.2-dev-4.7.4

USER root

ENV LIBRDKAFKA_VERSION v0.9.5
ENV BUILD_DEPS \
  autoconf \
        bash \
        build-base \
        git \
        pcre-dev \
        python \
        zlib-dev \
        curl-dev \
        icu-dev
RUN apk --no-cache --virtual .build-deps add ${BUILD_DEPS} \
    && cd /tmp \
    && git clone \
        --branch ${LIBRDKAFKA_VERSION} \
        --depth 1 \
        https://github.com/edenhill/librdkafka.git \
    && cd librdkafka \
    && ./configure \
    && make \
    && make install \
    && pecl install -f rdkafka \
    && docker-php-ext-enable rdkafka \
    && rm -rf /tmp/librdkafka
RUN docker-php-ext-install intl; \
    pecl install raphf-2.0.0 \
    && docker-php-ext-enable raphf \
    && pecl install propro-2.1.0 \
    && docker-php-ext-enable propro \
    && pecl install pecl_http-3.2.0 \
    && docker-php-ext-enable http; \
    chown -R wodby:wodby \
        "${PHP_INI_DIR}/conf.d"; \
    # Ensure http extension loads after raphf and propro dependencies
    mv "${PHP_INI_DIR}/conf.d/docker-php-ext-raphf.ini" "${PHP_INI_DIR}/conf.d/docker-php-ext-1-raphf.ini"; \
    mv "${PHP_INI_DIR}/conf.d/docker-php-ext-propro.ini" "${PHP_INI_DIR}/conf.d/docker-php-ext-2-propro.ini";
RUN apk del .build-deps
