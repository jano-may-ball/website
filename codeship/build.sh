#!/usr/bin/env bash

echo -e $PRIVATE_SSH_KEY >> /root/.ssh/id_rsa
chmod 0600 /root/.ssh/id_rsa

cd /src/jano
git lfs fetch
git lfs checkout

yarn install
yarn run build