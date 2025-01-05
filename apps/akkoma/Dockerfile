FROM hexpm/elixir:1.18.1-erlang-27.2-alpine-3.21.0 as otp
ARG MIX_ENV="prod"
ARG TMPDIR="/tmp/akkoma"
ARG BUILD_TAG="v3.13.2"
ARG PLEROMA_BUILD_BRANCH=${BUILD_TAG}
# install dependencies
RUN apk add git gcc g++ musl-dev make cmake file-dev rclone wget zip imagemagick
# get source
RUN wget \
    -O /tmp/akkoma.tar.gz \
    https://akkoma.dev/AkkomaGang/akkoma/archive/${BUILD_TAG}.tar.gz
RUN mkdir -p ${TMPDIR}
RUN tar -C ${TMPDIR} --strip-components=1 -xvf /tmp/akkoma.tar.gz
WORKDIR ${TMPDIR}
# clean
RUN (rm -rf release || true) && (rm -rf _build || true) && (rm -rf /root/.mix)
# setup-hex
RUN mix local.hex --force && mix local.rebar --force
# mix-clean
RUN mix deps.clean --all && mix clean
RUN mix deps.get --only prod
RUN mix release --path $TMPDIR/release

FROM alpine:3.21 AS akkoma-basic-alpine
ARG AKKOMADIR="/opt/akkoma"
ARG TMPDIR="/tmp/akkoma"
COPY --from=otp ${TMPDIR}/release ${AKKOMADIR}
# dependencies
RUN apk add postgresql-client
# optional dependencies
RUN apk add imagemagick ffmpeg exiftool libsoup libmagic catatonit

WORKDIR ${AKKOMADIR}
EXPOSE 4000
ENV AKKOMADIR=${AKKOMADIR}

COPY apps/akkoma/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://akkoma.dev/AkkomaGang/akkoma"