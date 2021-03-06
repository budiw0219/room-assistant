FROM node:12-alpine as build
ARG ROOM_ASSISTANT_VERSION=latest

RUN apk add --no-cache python make g++ libusb-dev eudev-dev avahi-dev
RUN npm install -g --unsafe-perm room-assistant@$ROOM_ASSISTANT_VERSION

FROM node:12-alpine

WORKDIR /room-assistant

RUN apk add --no-cache bluez bluez-deprecated libusb avahi-dev bind-tools dmidecode \
    && setcap cap_net_raw+eip $(eval readlink -f `which node`) \
    && setcap cap_net_raw+eip $(eval readlink -f `which hcitool`) \
    && ln -s /usr/local/lib/node_modules/room-assistant/bin/room-assistant.js /usr/local/bin/room-assistant
COPY --from=build /usr/local/lib/node_modules/room-assistant /usr/local/lib/node_modules/room-assistant

ENTRYPOINT ["room-assistant"]
CMD ["--digResolver"]
