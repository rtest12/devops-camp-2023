# syntax=docker/dockerfile:1.2 
FROM --platform=${BUILDPLATFORM:-linux/amd64} node:14-slim AS builder

RUN apt update
RUN apt install git -y

WORKDIR /opt/flatris
RUN git clone https://github.com/rtest12/flatris.git /opt/flatris

RUN yarn install --arch=$BUILDPLATFORM
RUN yarn test
RUN yarn build

FROM --platform=${BUILDPLATFORM:-linux/amd64} nginx:1.22.0-alpine AS runtime
RUN apk add yarn
WORKDIR /opt/flatris

COPY --from=builder /opt/flatris/ /opt/flatris/

EXPOSE 3000

CMD ["yarn", "start"]
