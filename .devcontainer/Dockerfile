# -------------------------------------------------------------------------------------------------
FROM ubuntu:latest as builder

LABEL MAINTAINER="Ralph Göstenmeier"

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
RUN    apt-get install -y tzdata                                                \
    && rm /etc/localtime                                                        \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime                           \
    && dpkg-reconfigure -f noninteractive tzdata                                \
    && apt-get clean

RUN apt-get install --yes build-essential lsb-release curl sudo git vim 

# -------------------------------------------------------------------------------------------------
# WITH-USER
# -------------------------------------------------------------------------------------------------
FROM base as with-user

RUN groupadd ${GRP_NAME}                  -g   ${GRP_ID} 
RUN adduser  ${USR_NAME} --uid ${USR_ID} --gid ${GRP_ID} --home ${USR_HOME} --disabled-password --gecos User

RUN echo '%work        ALL=(ALL)       NOPASSWD: ALL' >/etc/sudoers.d/${GRP_NAME}

# -------------------------------------------------------------------------------------------------
# WITH-APP
# -------------------------------------------------------------------------------------------------
FROM with-user as with-app

RUN apt-get install --yes python3 python3-pip python3-venv
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

EXPOSE 8000

# PYTHONDONTWRITEBYTECODE: Prevents Python from writing pyc files to disc (equivalent to python -B option)
# PYTHONUNBUFFERED:        Prevents Python from buffering stdout and stderr (equivalent to python -u option)
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# -------------------------------------------------------------------------------------------------
# USER
# -------------------------------------------------------------------------------------------------
FROM with-app as final

USER user

VOLUME [ "/workspace" ]

WORKDIR     /workspace
RUN  python -m venv .venv
RUN  echo '\n\n. /workspace/.venv/bin/activate\n' >>/home/user/.bashrc

COPY requirements.txt         requirements.txt
RUN  .venv/bin/pip install -r requirements.txt

COPY entrypoint.sh /workspace/entrypoint.sh

CMD ["bash", "-l"]
