FROM alpine as intermediate
LABEL stage=intermediate

RUN apk update && \
    apk add --update git

RUN git clone https://github.com/problematiq/SausageRoll-Server.git

FROM openjdk:17-alpine
LABEL Creator=Problematiq
SHELL ["/bin/sh", "-c"]
RUN apk add --no-cache bash
ARG user=sausage
ARG home=/home/$user
RUN addgroup -S docker
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home $home \
    --ingroup docker \
    $user

USER $user
WORKDIR $home
RUN mkdir $home/server
COPY --chown=$user:docker --from=intermediate /SausageRoll-Server/* $home/server/
RUN chmod +x /home/sausage/server/*

EXPOSE 25565
WORKDIR /home/sausage/server
ENTRYPOINT [ "/home/sausage/server/startserver.sh" ]