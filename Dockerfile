FROM alpine:latest
LABEL org.label-schema.name="Image for building the Jano Ticketing website" \
    maintainer="Andrew Ying <hi@andrewying.com>" \
    org.label-schema.schema-version="1.0"

ENV HUGO_VERSION=0.53 HUGO_BINARY=hugo_0.53_Linux-64bit
ENV NODEJS_VERSION=v10.15.0 DISTRO=linux-x64 NPM_VERSION=6 YARN_VERSION=latest

RUN apk add --no-cache bash ca-certificates curl py-pygments binutils-gold gnupg

RUN curl -sfSL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sfSLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk \
    && apk add glibc-2.28-r0.apk \
    && rm -f glibc-2.28-r0.apk

RUN for server in ipv4.pool.sks-keyservers.net keyserver.pgp.com ha.pool.sks-keyservers.net; do \
        gpg --keyserver $server --recv-keys \
            94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
            B9AE9905FFD7803F25714661B63B535A4C206CA9 \
            77984A986EBC2AA786BC0F66B01FBB92821C587A \
            71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
            FD3A5288F042B6850C66B31F09FE44734EB7990E \
            8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
            C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
            DD8F2338BAE7501E3DD5AC78C273792F7D83545D && break; \
    done \
    \
    && curl -sfSLO https://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}-${DISTRO}.tar.xz \
    && curl -sfSL https://nodejs.org/dist/${NODEJS_VERSION}/SHASUMS256.txt.asc | gpg --batch --decrypt | \
        grep " node-${NODEJS_VERSION}-${DISTRO}.tar.xz\$" | sha256sum -c | grep ': OK$' \
    \
    && mkdir -p /usr/local/lib/nodejs \
    && tar -xf node-${NODEJS_VERSION}-${DISTRO}.tar.xz -C /usr/local/lib/nodejs \
    && mv -f /usr/local/lib/nodejs/node-${NODEJS_VERSION}-${DISTRO} /usr/local/lib/nodejs/node-${NODEJS_VERSION} \
    && ln -s /usr/local/lib/nodejs/node-${NODEJS_VERSION}/bin/node /usr/local/bin/node \
    && ln -s /usr/local/lib/nodejs/node-${NODEJS_VERSION}/bin/npm /usr/local/bin/npm \
    && ln -s /usr/local/lib/nodejs/node-${NODEJS_VERSION}/bin/npx /usr/local/bin/npx \
    \
    && cd / \
    && if [ -n "$NPM_VERSION" ]; then \
        npm install -g npm@${NPM_VERSION}; \
    fi; \
    find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf \
    \
    && if [ -n "$YARN_VERSION" ]; then \
        for server in ipv4.pool.sks-keyservers.net keyserver.pgp.com ha.pool.sks-keyservers.net; do \
            gpg --keyserver $server --recv-keys \
                6A010C5166006599AA17F08146C2130DFD2497F5 && break; \
        done \
        && curl -sfSL -O https://yarnpkg.com/${YARN_VERSION}.tar.gz -O https://yarnpkg.com/${YARN_VERSION}.tar.gz.asc \
        && gpg --batch --verify ${YARN_VERSION}.tar.gz.asc ${YARN_VERSION}.tar.gz \
        && mkdir /usr/local/share/yarn \
        && tar -xf ${YARN_VERSION}.tar.gz -C /usr/local/share/yarn --strip 1 \
        && ln -s /usr/local/share/yarn/bin/yarn /usr/local/bin/yarn \
        && ln -s /usr/local/share/yarn/bin/yarnpkg /usr/local/bin/yarnpkg \
        && rm ${YARN_VERSION}.tar.gz*; \
    fi \
    \
    && rm -rf node-${NODEJS_VERSION}-${DISTRO}.tar.xz  /root/.npm /root/.node-gyp /root/.gnupg /usr/lib/node_modules/npm/man \
        /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts \

RUN mkdir /usr/local/hugo
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz /usr/local/hugo/
RUN tar xzf /usr/local/hugo/${HUGO_BINARY}.tar.gz -C /usr/local/hugo/ \
	&& ln -s /usr/local/hugo/hugo /usr/local/bin/hugo
RUN apk del curl ca-certificates gnupg \
    && rm -rf /usr/share/man /tmp/* /var/cache/apk/* /usr/local/hugo/${HUGO_BINARY}.tar.gz

RUN mkdir -p /src/jano
WORKDIR /src/jano

COPY . /src/jano

EXPOSE 1313
CMD hugo version