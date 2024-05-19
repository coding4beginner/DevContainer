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


# USER --------------------------------------------------------------------------------------------

log "Create User ${USR_NAME}.${GRP_NAME}"

id demouser  >/dev/null 2>&-
if [ $? == 0 ]; then
    log "- delete user $USR_NAME"
    deluser  ${USR_NAME}                                   >/dev/null
fi

if getent group ${GRP_NAME} >/dev/null; then
    log "- delete group $GRP_NAME"
    groupdel ${GRP_NAME}                                   >/dev/null
fi

rm -rf ${USR_HOME}

log "- add   group $GRP_NAME"
groupadd ${GRP_NAME}                 --gid ${GRP_ID} 

log "- add   user $USR_NAME"
adduser  ${USR_NAME} --uid ${USR_ID} --gid ${GRP_ID} --home ${USR_HOME} --disabled-password --gecos User

log "- change password to 'password'"
echo "${USR_NAME}:password" | chpasswd

log "- create user folder ${USR_HOME}"
mkdir -p ${USR_HOME}/bin
chown -R ${USR_NAME}:${GRP_NAME} ${USR_HOME}/bin

touch ${USR_HOME}/.bashrc
chmod -R 775                     ${USR_HOME}

log "- add PATH to .bashrc"
echo 'export PATH="$HOME/bin:/c4b/bin:$PATH\n"' >>${USR_HOME}/.bashrc >/dev/null

log "- set permissions"
echo '%work        ALL=(ALL)       NOPASSWD: ALL' | tee /etc/sudoers.d/${GRP_NAME}

# PYTHON ------------------------------------------------------------------------------------------
log "install python"
log "- add python repository"
add-apt-repository --yes ppa:deadsnakes/ppa            >/dev/null

log "- update"
apt-get update                                         >/dev/null

log "- install python"
apt-get install --yes python3.12 python3.12-venv       >/dev/null

update-alternatives --install /usr/bin/python python /usr/bin/python3 1

log "- check python version: $(python --version)"

# NODE --------------------------------------------------------------------------------------------
log "install node"

log "- prepare installation"
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -  >/dev/null

log "- install nodejs"
apt install --yes nodejs log "add python repository"       >/dev/null

log "- install ijavascript"
npm install -g ijavascript                                 >/dev/null


# DOTNET ------------------------------------------------------------------------------------------
log "install dotnet"

log "- update"
apt update                                                 >/dev/null

log "- install dotnet sdk 8.0"
apt install --yes dotnet-sdk-8.0                           >/dev/null

# PHP ---------------------------------------------------------------------------------------------
log "install php"

log "- update"
apt update                                                 >/dev/null

log "- install php"
apt install --yes php libapache2-mod-php                   >/dev/null

# -------------------------------------------------------------------------------------------------
# PYTHON

# DENO --------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# VSCODE
log "create .vscode folder"
mkdir -p        ${USR_HOME}/.vscode

log "- copy vscode settings"
cp -r $HERE/../etc/vscode/*  ${USR_HOME}/.vscode

# -------------------------------------------------------------------------------------------------
# CLEANUP
log "set folder permissions"
chown -R ${USR_NAME}:${GRP_NAME} ${USR_HOME}
chmod -R 775                     ${USR_HOME}

log "final clean"
apt update                                                 >/dev/null
apt upgrade --yes                                          >/dev/null

