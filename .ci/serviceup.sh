#!/bin/bash

source $(dirname $0)/.service.env

STACK=manager
NETWORK=traefiknet

REG_SERVER=localhost:5000
SERVICE=$1
IMAGE_NAME=$REG_SERVER/$SERVICE:latest

NTW=$STACK"_"$NETWORK

LABEL0=com.docker.stack.namespace=$STACK
LABEL1=traefik.enable=true
LABEL2=traefik.port=$PORT
LABEL3=traefik.http.routers.$SERVICE.rule=Host\(\`$HOST\`\)
LABEL4=traefik.http.routers.$SERVICE.entrypoints=web
LABEL5=traefik.http.routers.$SERVICE.middlewares=https_redirect
LABEL6=traefik.http.routers.$SERVICE"-ssl".rule=Host\(\`$HOST\`\)
LABEL7=traefik.http.routers.$SERVICE"-ssl".entrypoints=websecure
LABEL8=traefik.http.routers.$SERVICE"-ssl".tls.certresolver=dnsresolver

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

CMD="service create -d --name $SERVICE --network $NTW --with-registry-auth"

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
