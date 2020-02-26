FROM nvidia/cuda:10.1-devel-ubuntu18.04 as build

RUN apt update \
 && apt install -y build-essential git

WORKDIR /tmp/darknet

RUN git clone https://github.com/AlexeyAB/darknet.git .

RUN make GPU=1

#------------------------------------

FROM nvidia/cuda:10.1-runtime-ubuntu18.04

COPY --from=build /tmp/darknet/darknet /usr/local/bin

ENTRYPOINT ["darknet"]
