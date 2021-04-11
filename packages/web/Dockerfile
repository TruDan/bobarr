FROM node:14-alpine as build

ENV PORT 3000
EXPOSE 3000

WORKDIR /usr/src/app
COPY package*.json yarn.lock ./

RUN yarn --network-timeout 1000000
COPY . .

RUN yarn start