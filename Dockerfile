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

RUN conda config --set anaconda_upload yes --set always_yes yes --set changeps1 no --set auto_update_conda no
RUN conda update -q conda
RUN conda install -y anaconda-client conda-build conda-verify
RUN conda init bash

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]