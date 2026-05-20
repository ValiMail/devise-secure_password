# syntax=docker/dockerfile:1

FROM ruby:3.4-slim-bookworm

LABEL maintainer="Valimail Engineering <engineering@valimail.com>"

ARG BUNDLER_VERSION=4.0.10
ARG APP_UID=1000
ARG APP_GID=1000

ENV BUILD_HOME=/secure-password-gem \
    BUNDLE_GEMFILE=gemfiles/rails_8_0.gemfile \
    BUNDLE_JOBS=4 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_RETRY=5 \
    DISPLAY=:99 \
    RAILS_ENV=test

RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      build-essential \
      chromium \
      chromium-driver \
      git \
      libsqlite3-dev \
      libyaml-dev \
      pkg-config \
      sqlite3 \
      xvfb && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd --gid "${APP_GID}" app && \
    useradd --uid "${APP_UID}" --gid app --create-home --shell /bin/bash app

RUN gem install bundler -v "${BUNDLER_VERSION}" && \
    mkdir -p "${BUILD_HOME}" "${BUNDLE_PATH}" && \
    chown -R app:app "${BUILD_HOME}" "${BUNDLE_PATH}"

WORKDIR ${BUILD_HOME}

COPY --chown=app:app . ./

RUN chmod 755 docker-entrypoint.sh

USER app

RUN bundle install

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["/bin/bash"]
