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
RUN apt-get update && apt-get install -y --no-install-recommends \
		nano \
		python3 \
		python3-pip \
		r-base \
		r-cran-ggplot2 \
		r-cran-reshape2 \
		r-cran-knitr \
		r-cran-tinytex \ 
		sudo \
		texlive-base \
		texlive-bibtex-extra \
		texlive-fonts-recommended \
		texlive-latex-extra \
		texlive-publishers 

# Add user
RUN useradd -m -G sudo -s /bin/bash repro && echo "repro:repro" | chpasswd
RUN usermod -a -G staff repro
USER repro
WORKDIR /home/repro

ADD --chown=repro:repro sin.Rnw sin.Rnw
