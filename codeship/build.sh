#!/usr/bin/env bash

cd /src/jano
git lfs fetch
git lfs checkout

yarn install
yarn run build