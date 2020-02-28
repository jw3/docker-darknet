FROM buildpack-deps:bionic as weights

WORKDIR /tmp/darknet

RUN curl -sL -O https://pjreddie.com/media/files/darknet53.conv.74

#------------------------------------

FROM nvidia/cuda:10.1-devel-ubuntu18.04 as build

RUN apt update \
 && apt install -y build-essential git

WORKDIR /tmp/darknet

RUN git clone https://github.com/AlexeyAB/darknet.git .

RUN make GPU=1

#------------------------------------

FROM nvidia/cuda:10.1-runtime-ubuntu18.04

RUN mkdir /opt/workspace \
 && useradd -u 10001 -G 0 -d /opt/workspace default \
 && chown default:0 /opt/workspace

WORKDIR /opt/darknet

COPY --from=weights /tmp/darknet/        .
COPY --from=build   /tmp/darknet/cfg     cfg
COPY --from=build   /tmp/darknet/darknet /usr/local/bin

USER 10001

ENTRYPOINT ["darknet"]
