# Replication package example for the lecure series
# "Reproducibility Engineering"
# at  Technical University of Applied Sciences Regensburg
# and Passau University

# Copyright 2021, Wolfgang Mauerer <wolfgang.mauerer@othr.de>
# SPDX-License-Identifier: GPL-2.0-only

# Build on a long-term maintained base distribution
FROM ubuntu:20.04

LABEL maintainer="Wolfgang Mauerer <wolfgang.mauerer@othr.de>"

ENV DEBIAN_FRONTEND noninteractive
ENV LANG="C.UTF-8"
ENV LC_ALL="C.UTF-8"

RUN apt update -qq

# NOTE: Recommended practice: Sort list alphabetically
RUN apt update && apt install -y --no-install-recommends \
	build-essential \
	ca-certificates \
	curl \
	emacs \
	ess \
	file \
	gawk \
	git \
	joe \
	r-base \
	r-cran-dplyr \
	r-cran-purrr \
	r-cran-tidyr \
	ssh
	
RUN useradd -m -G sudo -s /bin/bash repro && echo "repro:repro" | chpasswd
USER repro
WORKDIR /home/repro

## We want to be able to use git within the container, so set default values
RUN git config --global user.name "Wolfgang Mauerer"
RUN git config --global user.email "wolfgang.mauerer@othr.de"
