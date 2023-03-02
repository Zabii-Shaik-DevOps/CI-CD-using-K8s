FROM ubuntu:latest
RUN apt update
RUN apt install -y nginx
RUN apt-get install -y systemctl
EXPOSE 80 22
