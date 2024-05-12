# -------------------------------------------------------------------------------------------------
FROM ubuntu:latest as builder

LABEL MAINTAINER="Ralph Göstenmeier"

ARG DEBIAN_FRONTEND=noninteractive

ARG USR_NAME=user
ARG USR_HOME=/home/${USR_NAME}
ARG USR_ID=10000

ARG GRP_NAME=work
ARG GRP_ID=10000

# set environment variables
ENV TZ 'Europe/Berlin'
RUN echo $TZ > /etc/timezone 

# -------------------------------------------------------------------------------------------------
# BASE
# -------------------------------------------------------------------------------------------------
FROM builder as base

RUN    apt-get update
RUN    apt     install --yes tzdata \
    && rm /etc/localtime \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean

RUN apt install --yes build-essential lsb-release curl sudo git vim unzip
RUN apt install --yes software-properties-common

# -------------------------------------------------------------------------------------------------
# WITH-USER
# -------------------------------------------------------------------------------------------------
FROM base as with-user

RUN groupadd ${GRP_NAME}                 --gid ${GRP_ID} 
RUN adduser  ${USR_NAME} --uid ${USR_ID} --gid ${GRP_ID} --home ${USR_HOME} --disabled-password --gecos User

RUN mkdir -p ${USR_HOME}/bin
RUN chown -R ${USR_NAME}:${GRP_NAME} ${USR_HOME}/bin

RUN echo '%work        ALL=(ALL)       NOPASSWD: ALL' >/etc/sudoers.d/${GRP_NAME}

# -------------------------------------------------------------------------------------------------
# PYTHON
# -------------------------------------------------------------------------------------------------
FROM with-user as with-python

RUN apt install --yes python3 python3-pip python3-venv
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# -------------------------------------------------------------------------------------------------
# NODEJS
# -------------------------------------------------------------------------------------------------
FROM with-python as with-nodejs

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
RUN apt install -y nodejs
RUN npm install -g ijavascript

RUN echo 'export PATH="$HOME/bin:$PATH:/coding4beginner/bin\n"' >>${USR_HOME}/.bashrc

# -------------------------------------------------------------------------------------------------
# DOTNET
# -------------------------------------------------------------------------------------------------
FROM with-nodejs as with-dotnet

RUN    apt-get update \
    && apt     install --yes dotnet-sdk-8.0


# -------------------------------------------------------------------------------------------------
# PHP
# -------------------------------------------------------------------------------------------------
FROM with-dotnet as with-php

RUN    apt-get update \
    && apt     install --yes php libapache2-mod-php

# -------------------------------------------------------------------------------------------------
# DJANGO
EXPOSE 8000

# -------------------------------------------------------------------------------------------------
FROM with-php as with-apps

# =================================================================================================
# USER
# =================================================================================================
FROM with-apps as final

USER user

VOLUME [ "/coding4beginner" ]
WORKDIR /coding4beginner

# -------------------------------------------------------------------------------------------------
# PYTHON
RUN  python -m venv ${USR_HOME}/.venv
RUN  echo '\n\n. /home/user/.venv/bin/activate\n'               >>${USR_HOME}/.bashrc
COPY requirements.txt requirements.txt
RUN  ${USR_HOME}/.venv/bin/pip install -r requirements.txt

# -------------------------------------------------------------------------------------------------
# DENO
RUN curl -fsSL https://deno.land/install.sh | sh
RUN echo '\n\n# Deno\nexport DENO_INSTALL="/home/user/.deno"\n' >>${USR_HOME}/.bashrc
RUN echo 'export PATH="$DENO_INSTALL/bin:$PATH"\n'              >>${USR_HOME}/.bashrc

# -------------------------------------------------------------------------------------------------
# JUPYTER
RUN sudo npm install ijavascript
RUN PATH=${USR_HOME}/.venv/bin:$PATH:                       ijsinstall --install=local
RUN PATH=${USR_HOME}/.venv/bin:${USR_HOME}/.deno/bin:$PATH: deno jupyter --install

# -------------------------------------------------------------------------------------------------
# VSCODE
RUN  mkdir -p  /coding4beginner/.vscode
COPY vscode/*  /coding4beginner/.vscode
COPY bin/*     /coding4beginner/bin

RUN sudo chown -R ${USR_NAME}:${GRP_NAME} ${USR_HOME}/bin    /coding4beginner
RUN sudo chmod +x                         ${USR_HOME}/bin/*

# -------------------------------------------------------------------------------------------------
# CLEANUP
# -------------------------------------------------------------------------------------------------
RUN    sudo apt update \
    && sudo apt upgrade --yes


CMD ["bash", "-l"]
