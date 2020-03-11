FROM alpine AS builder

ARG OPAMROOT="/usr/local/opam"
ARG BUILD_ENV="alpine-sdk autoconf automake m4 opam"
ARG BUILD_LIBS="faad2-dev flac-dev lame-dev libmad-dev libogg-dev libvorbis-dev ocaml-compiler-libs ocaml-dev pcre-dev taglib-dev"
ARG PACKAGES="cry faad flac lame liquidsoap mad ogg taglib vorbis"

RUN set -e ; \
    apk add -q --no-cache curl $BUILD_ENV $BUILD_LIBS $RUNTIME_ENV $RUNTIME_LIBS ; \
    mkdir $OPAMROOT ; \
    adduser opam -D ; \
    chown opam $OPAMROOT

USER opam
RUN set -e ; \
    opam init -y --disable-sandboxing ; \
    eval $(opam env) ; \
    opam install -y $PACKAGES ; \
    strip $OPAMROOT/default/bin/liquidsoap


FROM alpine

ARG TZ
ARG OPAMSWITCH="/usr/local/opam/default"

COPY --from=builder $OPAMSWITCH/bin/liquidsoap /usr/bin/
COPY --from=builder $OPAMSWITCH/lib/liquidsoap $OPAMSWITCH/lib/liquidsoap
COPY --from=builder $OPAMSWITCH/share/camomile $OPAMSWITCH/share/camomile

RUN set -e ; \
    adduser -D liquidsoap ; \
    apk add -q curl flac faad2-libs lame libmad libogg libvorbis taglib pcre tzdata ; \
    if [ -n "$TZ" -a -f "/usr/share/zoneinfo/$TZ" ] ; then \
        ln -f "/usr/share/zoneinfo/$TZ" /etc/localtime ; \
    fi

EXPOSE 1234
USER liquidsoap
ENTRYPOINT ["/usr/bin/liquidsoap", "-t"]
