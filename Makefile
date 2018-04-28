ARGS ?= --no-cache --rm

ifneq (x${NO_PROXY},x)
ARGS += --build-arg NO_PROXY=${NO_PROXY}
endif

ifneq (x${FTP_PROXY},x)
ARGS += --build-arg FTP_PROXY=${FTP_PROXY}
endif

ifneq (x${HTTP_PROXY},x)
ARGS += --build-arg HTTP_PROXY=${HTTP_PROXY}
endif

ifneq (x${HTTPS_PROXY},x)
ARGS += --build-arg HTTPS_PROXY=${HTTPS_PROXY}
endif

ifneq (x${UBUNTU_MIRROR},x)
ARGS += --build-arg UBUNTU_MIRROR=${UBUNTU_MIRROR}
endif

ifneq (x${NVIDIA_CUDA_MIRROR},x)
ARGS += --build-arg NVIDIA_CUDA_MIRROR=${NVIDIA_CUDA_MIRROR}
endif

ifneq (x${NVIDIA_ML_MIRROR},x)
ARGS += --build-arg NVIDIA_ML_MIRROR=${NVIDIA_ML_MIRROR}
endif

ifneq (x${PIP_CACHE_HOST},x)
ARGS += --build-arg PIP_CACHE_HOST=${PIP_CACHE_HOST}
endif

ifneq (x${PIP_CACHE_PORT},x)
ARGS += --build-arg PIP_CACHE_PORT=${PIP_CACHE_PORT}
endif

.PHONY: build
build:
ifneq (x$(shell docker images takumi/nvidia-compute -aq),x)
	@docker rmi takumi/nvidia-compute
endif
	@docker build $(ARGS) -t takumi/nvidia-compute .

.PHONY: run
run:
	@docker run -i -t --name nvidia-compute takumi/nvidia-compute

.PHONY: clean
clean:
ifneq (x$(shell docker ps -aq),x)
	@docker stop $(shell docker ps -aq)
	@docker rm $(shell docker ps -aq)
endif
ifneq (x$(shell docker images -f "dangling=true" -aq),x)
	@docker rmi $(shell docker images -f "dangling=true" -aq)
endif
