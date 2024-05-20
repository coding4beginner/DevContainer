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

PACKAGE=${1:-all}
MODE=${2:-as-root}

# -------------------------------------------------------------------------------------------------
log() {
    echo "# $*"
}

# USER --------------------------------------------------------------------------------------------

# PYTHON ------------------------------------------------------------------------------------------

# NODE --------------------------------------------------------------------------------------------

# DOTNET ------------------------------------------------------------------------------------------

# PHP ---------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# PYTHON
log "setup python"

log "- setup venv"
python -m venv ${USR_HOME}/.venv
echo '\n\n. /home/user/.venv/bin/activate\n'               >>${USR_HOME}/.bashrc

if [ -f $HERE/../etc/requirements.txt ]; then
    cp $HERE/../etc/requirements.txt requirements.txt
    ${USR_HOME}/.venv/bin/pip install -r requirements.txt  >/dev/null
fi

# DENO --------------------------------------------------------------------------------------------
curl -fsSL https://deno.land/install.sh | sudo -u ${USR_NAME} sh

echo '\n\n# Deno\nexport DENO_INSTALL="/home/user/.deno"\n' >>${USR_HOME}/.bashrc
echo 'export PATH="$DENO_INSTALL/bin:$PATH"\n'              >>${USR_HOME}/.bashrc

PATH=${USR_HOME}/.venv/bin:$PATH:                       sudo -u ${USR_NAME} ijsinstall   --install=local
PATH=${USR_HOME}/.venv/bin:${USR_HOME}/.deno/bin:$PATH: sudo -u ${USR_NAME} deno jupyter --install


# -------------------------------------------------------------------------------------------------
# VSCODE

# -------------------------------------------------------------------------------------------------
# CLEANUP
log "set folder permissions"
sudo chown -R ${USR_NAME}:${GRP_NAME} ${USR_HOME}
sudo chmod -R 775                     ${USR_HOME}

log "final clean"
apt update                                                 >/dev/null
apt upgrade --yes                                          >/dev/null
