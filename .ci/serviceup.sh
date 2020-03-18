#!/bin/bash

source $(dirname $0)/.service.env

STACK=manager
NETWORK=traefiknet

REG_SERVER=localhost:5000
JOB=$1
IMAGE_NAME=$REG_SERVER/$JOB:latest

HOST=testservice.ddns.net
#HOST=empresa.com

APP_NAME="$(cut -d'-' -f2 <<<"$JOB")"
APP_TYPE="$(cut -d'-' -f1 <<<"$JOB")"
APP_ENVR="$(cut -d'-' -f3 <<<"$JOB")"

#URL=$APP_TYPE.$APP_NAME.$APP_ENVR.$HOST

URL=$HOST

NTW=$STACK"_"$NETWORK

ROUTERS=traefik.http.routers

LABEL0=com.docker.stack.namespace=$STACK
LABEL1=traefik.enable=true
LABEL2=traefik.port=$PORT
LABEL3=$ROUTERS.$JOB.rule=Host\(\`$URL\`\)
LABEL4=$ROUTERS.$JOB.entrypoints=web
LABEL5=$ROUTERS.$JOB.middlewares=https_redirect
LABEL6=$ROUTERS.$JOB"-ssl".rule=Host\(\`$URL\`\)
LABEL7=$ROUTERS.$JOB"-ssl".entrypoints=websecure
LABEL8=$ROUTERS.$JOB"-ssl".tls.certresolver=dnsresolver

SVCLBL[0]=$LABEL0
SVCLBL[1]=com.docker.stack.image=$IMAGE_NAME

CONLBL[0]=$LABEL0
CONLBL[1]=$LABEL1
CONLBL[2]=$LABEL2
CONLBL[3]=$LABEL3
CONLBL[4]=$LABEL4
CONLBL[5]=$LABEL5
CONLBL[6]=$LABEL6
CONLBL[7]=$LABEL7
CONLBL[8]=$LABEL8

CMD="service create -d --name $JOB --network $NTW --with-registry-auth"

for i in "${SVCLBL[@]}"
do
   CMD="$CMD -l $i"
done

for i in "${CONLBL[@]}"
do
   CMD="$CMD --container-label $i"
done

CMD="$CMD $IMAGE_NAME"

docker $CMD
