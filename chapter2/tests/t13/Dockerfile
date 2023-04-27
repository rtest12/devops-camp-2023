ARG NODE_VERSION=14-slim
ARG NGINX_VERSION=1.22.0-alpine

# syntax=docker/dockerfile:1.2 
FROM --platform=${BUILDPLATFORM:-linux/amd64} node:"${NODE_VERSION}" AS builder

RUN apt update
RUN apt install git -y

WORKDIR /opt/flatris
RUN git clone https://github.com/rtest12/flatris.git /opt/flatris

RUN yarn install --arch=$BUILDPLATFORM \
  && yarn test \
  && yarn build

FROM --platform=${BUILDPLATFORM:-linux/amd64} nginx:"${NGINX_VERSION}" AS runtime
RUN apk add yarn
WORKDIR /opt/flatris

COPY --from=builder /opt/flatris/ /opt/flatris/

EXPOSE 3000

CMD ["yarn", "start"]