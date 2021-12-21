# Docker container for a simple R setup

# Copyright 2021, Wolfgang Mauerer <wolfgang.mauerer@othr.de>
# Copyright 2021, Stefanie Scherzinger <stefanie.scherzinger@uni-passau.de>
# Copyright 2021, Stefan Klessinger <stefan.klessinger@uni-passau.de>
# SPDX-License-Identifier: MIT-0

# Start off of a long-term maintained base distribution
FROM ubuntu:20.04

MAINTAINER Stefan Klessinger <stefan.klessinger@uni-passau.de>

ENV DEBIAN_FRONTEND noninteractive
ENV LANG="C.UTF-8"
ENV LC_ALL="C.UTF-8"

# Install required packages
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
		build-essential \
		ca-certificates \
		nano \
		r-base \
		r-cran-ggplot2 \
		r-cran-tidyr \
		r-cran-dplyr \
		r-cran-stringr \
		sudo \
		zlib1g-dev

# Add user
RUN useradd -m -G sudo -s /bin/bash repro && echo "repro:repro" | chpasswd
RUN usermod -a -G staff repro
USER repro
WORKDIR /home/repro

# Add res directory to container
ADD --chown=repro:repro data data/
ADD --chown=repro:repro *.r ./

RUN Rscript -e "install.packages('BiocManager')"
RUN Rscript -e "BiocManager::install('rhdf5')"
