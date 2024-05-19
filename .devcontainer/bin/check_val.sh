#!/bin/bash

MODE="$1"
PACKAGE="$2"

# -------------------------------------------------------------------------------------------------
check() {
    if [[ "$1" != "$MODE" ]]; then
        RESULT=1
    elif [[ "$2" == "$PACKAGE" || "$2" == "all" ]]; then
        RESULT=0
    else
        RESULT=1
    fi

    return $RESULT
}

if check "as-root" "user"; then
    echo "MATCH   : as-root/user = $MODE/$PACKAGE"
else
    echo "NO MATCH: as-root/user = $MODE/$PACKAGE"
fi
