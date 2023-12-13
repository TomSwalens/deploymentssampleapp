#!/bin/bashS
### remove dir
rm -rf sample_deployment
mkdir sample_deployment

cd sample_deployment
### git clone sampleapp
echo "Downloading app for deployment"
#git clone https://github.com/yroosel/sample_app.git
git fetch --tags --force --progress -- https://github.com/TomSwalens/deploymentssampleapp +refs/heads/*:refs/remotes/origin/* # timeout=10
cd sample_app
### make docker file
echo "Building docker File..."

touch Dockerfile
echo "FROM python:3.9.10-slim-buster" >> Dockerfile
echo "RUN python3 -m pip install flask" >> Dockerfile
echo "WORKDIR  /home/microweb_app" >> Dockerfile
echo "COPY ./static static/" >> Dockerfile
echo "COPY ./templates templates/" >> Dockerfile
echo "COPY ./sample_app.py /home/microweb_app/" >> Dockerfile
echo "EXPOSE 5555" >> Dockerfile
echo "CMD python sample_app.py" >> Dockerfile
###
echo "Dockerfile made."
### build and run image 
docker image rm sample_deployment_image
docker build -t sample_deployment_image:latest .
docker container stop sample_deployment_container
docker run -t --rm -d -p 5555:5555 --name sample_deployment_container sample_deployment_image

sleep 5

### make log
echo Date and time >> sample_deploy_log
date  >> sample_deploy_log
docker image ls -a >> sample_deploy_log
docker container ls -a >> sample_deploy_log
docker inspect sample_deployment_image >> sample_deploy_log
docker inspect sample_deployment_container >> sample_deploy_log
cat sample_deploy_log

curl http://localhost:5555
curl 172.17.0.3:5555
