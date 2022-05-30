# -------------------------------------------------------------------
# Minimal dockerfile from alpine base
#
# Instructions:
# =============
# 1. Create an empty directory and copy this file into it.
#
# 2. Create image with:
#	docker build --tag timeoff:latest .
#
# 3. Run with:
#	docker run -d -p 3000:3000 --name alpine_timeoff timeoff
#
# 4. Login to running container (to update config (vi config/app.json):
#	docker exec -ti --user root alpine_timeoff /bin/sh
# --------------------------------------------------------------------
FROM public.ecr.aws/ubuntu/ubuntu:18.04

RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_14.x  | bash -
RUN apt-get -y install nodejs
RUN apt-get install nodejs -y
RUN apt-get install make -y
RUN apt-get install g++ -y
RUN apt-get install gcc -y
RUN apt-get install libc-dev -y
RUN apt-get install clang -y

COPY package.json  .
RUN npm install

RUN adduser --system app --home /app
USER app
WORKDIR /app
COPY . /app

CMD npm start

EXPOSE 3000
