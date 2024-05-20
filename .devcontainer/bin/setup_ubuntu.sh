#!/usr/bin/bash

# =================================================================================================
#
# =================================================================================================
HERE="$(dirname "$0")"
HERE="${HERE#.}"

if [ -z "$HERE" ]; then
    HERE="$PWD"
else 
    HERE="$PWD/$HERE"
fi

# -------------------------------------------------------------------------------------------------
USR_NAME=demouser
USR_HOME=/home/${USR_NAME}
USR_ID=10000

GRP_NAME=work
GRP_ID=10000

# -------------------------------------------------------------------------------------------------
log() {
    echo "# $*"
}

# PREPARE -----------------------------------------------------------------------------------------

export DEBIAN_FRONTEND=noninteractive

log "Prepare Ubuntu"
apt-get update                                                                           >/dev/null

log "Prepare Ubuntu: install apt-utils vim curl sudo make"
apt-get install --yes apt-utils vim curl sudo make                                       >/dev/null

log "Prepare Ubuntu: install debconf-utils"
apt-get install --yes debconf-utils                                                      >/dev/null


echo "tzdata tzdata/Areas select Europe"        | debconf-set-selections                 >/dev/null
echo "tzdata tzdata/Zones/Europe select Berlin" | debconf-set-selections                 >/dev/null

log "Prepare Ubuntu: install software-properties-common"
apt-get install --yes software-properties-common                                         >/dev/null

# USER --------------------------------------------------------------------------------------------

log "Create User ${USR_NAME}.${GRP_NAME}"

id demouser  >/dev/null 2>&-
if [ $? == 0 ]; then
    log "- delete user $USR_NAME"
    deluser  ${USR_NAME}                                                                 >/dev/null
fi

if getent group ${GRP_NAME} >/dev/null; then
    log "- delete group $GRP_NAME"
    groupdel ${GRP_NAME}                                   >/dev/null
fi

rm -rf ${USR_HOME}

log "- add   group $GRP_NAME"
groupadd ${GRP_NAME}                 --gid ${GRP_ID} 

log "- add   user $USR_NAME"
adduser  ${USR_NAME} --uid ${USR_ID} --gid ${GRP_ID} --home ${USR_HOME} --disabled-password --gecos User >/dev/null

log "- change password to 'password'"
echo "${USR_NAME}:password" | chpasswd

log "- create user folder ${USR_HOME}"
mkdir -p ${USR_HOME}/bin
chown -R ${USR_NAME}:${GRP_NAME} ${USR_HOME}/bin

touch ${USR_HOME}/.bashrc
chmod -R 775                     ${USR_HOME}

log "- add PATH to .bashrc"
echo 'export PATH="$HOME/bin:/c4b/bin:$PATH\n"' >>${USR_HOME}/.bashrc                    >/dev/null

log "- set permissions"
echo '%work        ALL=(ALL)       NOPASSWD: ALL'  >/etc/sudoers.d/${GRP_NAME}           >/dev/null



# C++ ---------------------------------------------------------------------------------------------
log "install g++"
apt-get install --yes build-essential                                                    >/dev/null
apt-get install --yey g++-14                                                             >/dev/null

# PYTHON ------------------------------------------------------------------------------------------
log "install python"
log "- add python repository"
add-apt-repository --yes ppa:deadsnakes/ppa                                              >/dev/null

log "- update"
apt-get update                                                                           >/dev/null

log "- install python"
apt-get install --yes python3.12 python3.12-venv                                         >/dev/null

update-alternatives --install /usr/bin/python python /usr/bin/python3 1                  >/dev/null


log "- check python version: $(python --version)"

# NODE --------------------------------------------------------------------------------------------
log "install node"

log "- prepare installation"
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -  >/dev/null

log "- install nodejs"
apt-get install --yes nodejs                                                             >/dev/null

log "- update npm"
npm install -g npm@10.8.0                                                                >/dev/null

# log "- install ijavascript"
# npm install -g ijavascript                                                             >/dev/null


# DOTNET ------------------------------------------------------------------------------------------
log "install dotnet"

# log "- update"
# apt-get update                                                                         >/dev/null

log "- install dotnet sdk 8.0"
apt-get install --yes dotnet-sdk-8.0                                                     >/dev/null

# PHP ---------------------------------------------------------------------------------------------
log "install php"

# log "- update"
# apt-get update                                                                         >/dev/null

log "- install php"
apt-get install --yes php libapache2-mod-php                                             >/dev/null

# -------------------------------------------------------------------------------------------------
# PYTHON

# DENO --------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# VSCODE
log "create .vscode folder"
mkdir -p        ${USR_HOME}/.vscode

# log "- copy vscode settings"
# cp -r $HERE/../etc/vscode/*  ${USR_HOME}/.vscode

# -------------------------------------------------------------------------------------------------
# CLEANUP
log "set folder permissions"
chown -R ${USR_NAME}:${GRP_NAME} ${USR_HOME}
chmod -R 775                     ${USR_HOME}

log "final clean"
apt-get update                                                 >/dev/null
apt-get upgrade --yes                                          >/dev/null

