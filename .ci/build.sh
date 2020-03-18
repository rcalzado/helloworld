
REGISTRY=localhost:5000

docker images $REGISTRY/$1 -q | xargs --no-run-if-empty docker rmi -f
docker build -t $REGISTRY/$1:$2 -f ../Dockerfile
docker tag $REGISTRY/$1:$2 $REGISTRY/$1:latest
docker push $REGISTRY/$1:latest
docker rmi $REGISTRY/$1:$2
