FROM node:lts-alpine
LABEL org.label-schema.name="Image for building the Jano Ticketing website" \
    maintainer="Andrew Ying <hi@andrewying.com>" \
    org.label-schema.schema-version="1.0"

ENV HUGO_VERSION=0.53 HUGO_BINARY=hugo_0.53_Linux-64bit

RUN apk add --no-cache bash curl py-pygments
RUN mkdir /usr/local/hugo
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz /usr/local/hugo/
RUN tar xzf /usr/local/hugo/${HUGO_BINARY}.tar.gz -C /usr/local/hugo/ \
	&& ln -s /usr/local/hugo/hugo /usr/local/bin/hugo
RUN apk del curl \
    && rm -rf /usr/share/man /tmp/* /var/cache/apk/* /usr/local/hugo/${HUGO_BINARY}.tar.gz

RUN mkdir -p /src/jano
WORKDIR /src/jano

COPY . /src/jano
RUN yarn install

EXPOSE 1313
CMD hugo version