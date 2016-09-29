FROM alpine:3.4
#fork from nizq <ni.zhiqiang@gmail.com>
#added elasticsearch
MAINTAINER Daniel Guerra <daniel.guerra69@gmail.com>

RUN echo "===> Adding compile runtime..." && \
    apk add --update git perl cmake curl-dev\
        make zlib-dev openssl-dev flex bison \
        python-dev libpcap-dev geoip-dev fts fts-dev \
        clang binutils g++ linux-headers

ADD source /source
VOLUME ["/final"]
CMD ["/source/build-bro.sh"]
