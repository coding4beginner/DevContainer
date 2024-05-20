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

MODE=${1:-as-root}
PACKAGE=${2:-all}

# -------------------------------------------------------------------------------------------------
log() {
    echo "# $*"
}

check_args() {
    if [[ "$1" != "$MODE" ]]; then
        RESULT=1
    elif [[ "$2" == "$PACKAGE" || "$2" == "all" ]]; then
        RESULT=0
    else
        RESULT=1
    fi

    return $RESULT
}

# USER --------------------------------------------------------------------------------------------
if check_args "as-root" "user"; then
    log "Create User ${USR_NAME}.${GRP_NAME}"

    id demouser  >/dev/null 2>&-
    if [ $? == 0 ]; then
        log "- delete user $USR_NAME"
        sudo deluser  ${USR_NAME} >/dev/null
    fi

    if getent group ${GRP_NAME} >/dev/null; then
        log "- delete group $GRP_NAME"
        sudo groupdel ${GRP_NAME} >/dev/null
    fi

    sudo rm -rf ${USR_HOME}

    log "- add   group $GRP_NAME"
    sudo groupadd ${GRP_NAME}                 --gid ${GRP_ID} 

    log "- add   user $USR_NAME"
    sudo adduser  ${USR_NAME} --uid ${USR_ID} --gid ${GRP_ID} --home ${USR_HOME} --disabled-password --gecos User
    
    log "- change password to 'password'"
    echo "${USR_NAME}:password" | sudo chpasswd

    log "- create user folder ${USR_HOME}"
    sudo mkdir -p ${USR_HOME}/bin
    sudo chown -R ${USR_NAME}:${GRP_NAME} ${USR_HOME}/bin

    sudo touch ${USR_HOME}/.bashrc
    sudo chmod -R 775                     ${USR_HOME}

    log "- add PATH to .bashrc"
    echo 'export PATH="$HOME/bin:/c4b/bin:$PATH\n"' | sudo tee >>${USR_HOME}/.bashrc >/dev/null

    log "- set sudo permissions"
    echo '%work        ALL=(ALL)       NOPASSWD: ALL' | sudo tee /etc/sudoers.d/${GRP_NAME}
fi

# PYTHON ------------------------------------------------------------------------------------------
if check_args "as-root" "python"; then
    log "install python"
    log "- add python repository"
    sudo add-apt-repository --yes ppa:deadsnakes/ppa            >/dev/null

    log "- update"
    sudo apt update                                             >/dev/null

    log "- install python"
    sudo apt install --yes python3.12 python3.12-venv           >/dev/null

    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1

    log "- check python version: $(python --version)"
fi

# NODE --------------------------------------------------------------------------------------------
if check_args "as-root" "node"; then
    log "install node"

    log "prepare isntallation"
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash -  >/dev/null 2>&1
    
    log "- install nodejs"
    sudo apt install --yes nodejs log "add python repository"       >/dev/null 2>&1

    log "- install ijavascript"
    sudo npm install -g ijavascript                                 >/dev/null 2>&1
fi

# DOTNET ------------------------------------------------------------------------------------------
if check_args "as-root" "dotnet"; then
    log "install dotnet"

    log "- update"
    sudo apt update 

    log "- install dotnet sdk 8.0"
    sudo apt install --yes dotnet-sdk-8.0
fi

# PHP ---------------------------------------------------------------------------------------------
if check_args "as-root" "php"; then
    log "instal php"

    log "- update"
    sudo apt update 

    log "- install php"
    sudo apt install --yes php libapache2-mod-php
fi

# -------------------------------------------------------------------------------------------------
# PYTHON
if check_args "as-user" "python"; then
    python -m venv ${USR_HOME}/.venv
    echo '\n\n. /home/user/.venv/bin/activate\n'               >>${USR_HOME}/.bashrc
    cp $HERE/../etc/requirements.txt requirements.txt
    ${USR_HOME}/.venv/bin/pip install -r requirements.txt
fi

# DENO --------------------------------------------------------------------------------------------
if check_args "as-user" "deno"; then
    curl -fsSL https://deno.land/install.sh | sudo -u ${USR_NAME} sh
    
    #echo '\n\n# Deno\nexport DENO_INSTALL="/home/user/.deno"\n' >>${USR_HOME}/.bashrc
    #echo 'export PATH="$DENO_INSTALL/bin:$PATH"\n'              >>${USR_HOME}/.bashrc

    #sudo npm install ijavascript
    #PATH=${USR_HOME}/.venv/bin:$PATH:                       sudo -u ${USR_NAME} ijsinstall   --install=local
    #PATH=${USR_HOME}/.venv/bin:${USR_HOME}/.deno/bin:$PATH: sudo -u ${USR_NAME} deno jupyter --install
fi


# -------------------------------------------------------------------------------------------------
# VSCODE
if check_args "as-root" "all"; then
    log "create .vscode folder"
    sudo mkdir -p        ${USR_HOME}/.vscode

    log "- copy vscode settings"
    sudo cp -r $HERE/../etc/vscode/*  ${USR_HOME}/.vscode
fi


# -------------------------------------------------------------------------------------------------
# CLEANUP
if check_args "as-root" "all"; then
    log "set folder permissions"
    sudo chown -R ${USR_NAME}:${GRP_NAME} ${USR_HOME}
    sudo chmod -R 775                     ${USR_HOME}
fi

if check_args "as-user" "all"; then
    log "final clean"
    sudo apt update
    sudo apt upgrade --yes
fi
