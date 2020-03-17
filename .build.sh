docker images localhost:5000/$1 -q | xargs --no-run-if-empty docker rmi
docker build -t localhost:5000/$1:$2 . 
docker tag localhost:5000/$1:$2 localhost:5000/$1:latest
docker push localhost:5000/$1:latest
