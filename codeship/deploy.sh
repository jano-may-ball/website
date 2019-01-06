#!/usr/bin/env bash

mv /src/jano/codeship/lftprc /src/jano/.lftprc

cd /src/jano
git lfs fetch
git lfs checkout

yarn install
yarn run build
lftp -u $FTP_USERNAME,$FTP_PASSWORD -e "mirror -X *.css -X *.js -X images/* -R -n /src/jano/dist /var/www/html; exit" ftp.jano.rocks
lftp -u $KEYCDN_USERNAME,$KEYCDN_PASSWORD -e "mirror -X * -I *.css -I *.js -I images/* -R -n /src/jano/dist /; exit" ftp.keycdn.com
