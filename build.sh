#!/bin/bash

set -eu
IFS=$'\n\t'

docker build -f Dockerfile.test -t mytariffs:build .
docker run -t -v "$(pwd):/tgt" --rm mytariffs:build cp -vr /app/public /tgt/app/
docker build -f Dockerfile.production -t mytariffs:latest .
docker images -a -q -f dangling=true | xargs -n 1 docker rmi || true
echo "Well done!"
