DOCKER_PUSH?=false
IMAGE_NAMESPACE?=jwiii
IMAGE_TAG?=latest

ifeq (${DOCKER_PUSH},true)
ifndef IMAGE_NAMESPACE
$(error IMAGE_NAMESPACE must be set to push images (e.g. IMAGE_NAMESPACE=jwiii))
endif
endif

ifdef IMAGE_NAMESPACE
IMAGE_PREFIX=${IMAGE_NAMESPACE}/
endif

all: darknet python lfs

darknet:
	docker build --build-arg http_proxy --build-arg https_proxy -t $(IMAGE_PREFIX)darknet:$(IMAGE_TAG) -f Dockerfile .
	@if [ "$(DOCKER_PUSH)" = "true" ] ; then  docker push $(IMAGE_PREFIX)object_detection:$(IMAGE_TAG) ; fi

python: darknet
	docker build --build-arg http_proxy --build-arg https_proxy -t $(IMAGE_PREFIX)darknet:python36 -f Dockerfile.python36 .
	@if [ "$(DOCKER_PUSH)" = "true" ] ; then  docker push $(IMAGE_PREFIX)darknet:python36: ; fi

lfs: python
	docker build --build-arg http_proxy --build-arg https_proxy -t $(IMAGE_PREFIX)darknet:lfs -f Dockerfile.lfs .
	@if [ "$(DOCKER_PUSH)" = "true" ] ; then  docker push $(IMAGE_PREFIX)darknet:lfs: ; fi
