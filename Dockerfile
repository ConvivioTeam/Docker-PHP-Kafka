FROM wodby/php:7.1-dev-4.7.4

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
        curl-dev
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
RUN pecl install -f raphf \
    && docker-php-ext-enable raphf \
    &&  pecl install -f propro \
    && docker-php-ext-enable propro \
    && pecl install -f pecl_http \
    && docker-php-ext-enable http
RUN apk del .build-deps
