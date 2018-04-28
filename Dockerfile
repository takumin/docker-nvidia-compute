FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04

MAINTAINER Takumi Takahashi <takumiiinn@gmail.com>

ARG NO_PROXY
ARG FTP_PROXY
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG UBUNTU_MIRROR="http://jp.archive.ubuntu.com/ubuntu"
ARG NVIDIA_CUDA_MIRROR="http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64"
ARG NVIDIA_ML_MIRROR="http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64"
ARG PIP_CACHE_HOST
ARG PIP_CACHE_PORT="3141"

RUN echo Start! \
 && set -ex \
 && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
 && APT_PACKAGES="autoconf automake libtool wget ca-certificates python python3 python-dev python3-dev python-pip python3-pip" \
 && if [ "x${NO_PROXY}" != "x" ]; then export no_proxy="${NO_PROXY}"; fi \
 && if [ "x${FTP_PROXY}" != "x" ]; then export ftp_proxy="${FTP_PROXY}"; fi \
 && if [ "x${HTTP_PROXY}" != "x" ]; then export http_proxy="${HTTP_PROXY}"; fi \
 && if [ "x${HTTPS_PROXY}" != "x" ]; then export https_proxy="${HTTPS_PROXY}"; fi \
 && if [ "x${PIP_CACHE_HOST}" != "x" ]; then export PIP_TRUSTED_HOST="${PIP_CACHE_HOST}"; export PIP_INDEX_URL="http://${PIP_CACHE_HOST}:${PIP_CACHE_PORT}/root/pypi/"; fi \
 && echo "deb ${UBUNTU_MIRROR} xenial          main restricted universe multiverse" >  /etc/apt/sources.list \
 && echo "deb ${UBUNTU_MIRROR} xenial-updates  main restricted universe multiverse" >> /etc/apt/sources.list \
 && echo "deb ${UBUNTU_MIRROR} xenial-security main restricted universe multiverse" >> /etc/apt/sources.list \
 && echo "deb ${NVIDIA_CUDA_MIRROR} /" > /etc/apt/sources.list.d/cuda.list \
 && echo "deb ${NVIDIA_ML_MIRROR} /" > /etc/apt/sources.list.d/nvidia-ml.list \
 && export DEBIAN_FRONTEND="noninteractive" \
 && export DEBIAN_PRIORITY="critical" \
 && export DEBCONF_NONINTERACTIVE_SEEN="true" \
 && apt-get -y update \
 && apt-get -y dist-upgrade \
 && apt-get -y --no-install-recommends install $APT_PACKAGES \
 && apt-get clean autoclean \
 && apt-get autoremove --purge -y \
 && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* \
 && wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.2.tar.gz \
 && tar -xvf mvapich2-2.2.tar.gz \
 && cd mvapich2-2.2 \
 && ./configure --prefix=/usr --enable-cuda && make -j $NPROC && make install && ldconfig \
 && cd / \
 && rm -fr mvapich2-2.2 \
 && rm mvapich2-2.2.tar.gz \
 && python2 -m pip --no-cache-dir install --upgrade pip setuptools wheel \
 && python3 -m pip --no-cache-dir install --upgrade pip setuptools wheel \
 && python2 -m pip --no-cache-dir install numpy \
 && python3 -m pip --no-cache-dir install numpy \
 && python2 -m pip --no-cache-dir install cupy-cuda91 \
 && python3 -m pip --no-cache-dir install cupy-cuda91 \
 && python2 -m pip --no-cache-dir install chainer \
 && python3 -m pip --no-cache-dir install chainer \
 && echo Complete!
