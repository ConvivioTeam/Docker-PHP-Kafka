FROM wodby/php:7.2-dev-4.7.4

USER root

ENV LIBRDKAFKA_VERSION v0.9.5
ENV BUILD_DEPS \
  autoconf \
        bash \
        build-base \
        git \
        pcre-dev \
        python
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
    && rm -rf /tmp/librdkafka \
    && apk del .build-deps
