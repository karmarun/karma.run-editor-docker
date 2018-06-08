FROM node:9.11.1-alpine as builder
ARG HOME_DIR=/home/node/karma.run-editor/

# Install build tools
RUN apk add gcc g++ make --update-cache

# Install libvips
RUN apk add vips-dev fftw-dev --update-cache --repository https://dl-3.alpinelinux.org/alpine/edge/testing/

COPY ./LICENSE $HOME_DIR
COPY ./package.json $HOME_DIR
COPY ./yarn.lock $HOME_DIR
COPY ./.yarnclean $HOME_DIR

WORKDIR $HOME_DIR
RUN yarn install

# Copy to final image
FROM node:9.11.1-alpine
ARG HOME_DIR=/home/node/karma.run-editor/
COPY --from=builder $HOME_DIR $HOME_DIR

RUN chown -R node:node $HOME_DIR
WORKDIR $HOME_DIR
USER node

EXPOSE 3000
CMD yarn start
