ARG FROM_TAG
ARG LIBRDKAFKA_VERSION

FROM wodby/php:${FROM_TAG}

USER root

ENV LIBRDKAFKA_VERSION v${LIBRDKAFKA_VERSION}
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
