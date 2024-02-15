FROM ubuntu:22.04
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt update

RUN apt install -y wget && rm -rf /var/lib/apt/lists/*

# install miniconda
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
RUN conda --version

LABEL "repository"="https://github.com/hellmrf/conda-publish-action"
LABEL "maintainer"="Heliton Martins"

RUN apt update
# to fix: import cv2 > ImportError: libGL.so.1: cannot open shared object file: No such file or directory
RUN apt install -y libgl1-mesa-dev

# to fix: import cv2 > ImportError: libjasper.so.1: cannot open shared object file: No such file or directory
RUN apt install -y libjasper1

RUN conda install -y anaconda-client conda-build conda-verify

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]