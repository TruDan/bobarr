#!/bin/bash
set -e # exit when error

cat << "EOF"

    /$$                 /$$
    | $$                | $$
    | $$$$$$$   /$$$$$$ | $$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$
    | $$__  $$ /$$__  $$| $$__  $$ |____  $$ /$$__  $$ /$$__  $$
    | $$  \ $$| $$  \ $$| $$  \ $$  /$$$$$$$| $$  \__/| $$  \__/
    | $$  | $$| $$  | $$| $$  | $$ /$$__  $$| $$      | $$
    | $$$$$$$/|  $$$$$$/| $$$$$$$/|  $$$$$$$| $$      | $$
    |_______/  \______/ |_______/  \_______/|__/      |__/

        https://github.com/iam4x/bobarr

EOF

args=$1
dc='docker-compose -f docker-compose.yml -f docker-compose.prod.yml'

stop_bobarr() {
  $dc down --remove-orphans || true
}

after_start() {
  echo ""
  echo "bobarr started correctly, printing bobarr api logs"
  echo "you can close this and bobarr will continue to run in backgound"
  echo ""
  $dc logs -f --tail 20 api
}

if [[ $args == 'start' ]]; then
  stop_bobarr
  $dc up --force-recreate -d
  after_start
elif [[ $args == 'start:vpn' ]]; then
  stop_bobarr
  $dc -f docker-compose.vpn.yml up --force-recreate -d
  after_start
elif [[ $args == 'start:wireguard' ]]; then
  stop_bobarr
  $dc -f docker-compose.wireguard.yml up --force-recreate -d
  after_start
elif [[ $args == 'stop' ]]; then
  stop_bobarr
  echo ""
  echo "bobarr correctly stopped"
elif [[ $args == 'update' ]]; then
  stop_bobarr
  $dc pull
  echo ""
  echo "bobarr correctly updated, you can now re-start bobarr"
else
  echo "unknow command: $args"
  echo "use [start | start:vpn | start:wireguard | stop | update]"
fi
