#!/bin/sh

EINSTALLERROR=1
EINTERNALERROR=2
EUSERABORT=3
EINVALIDRESPONSE=4

export PERSONAL="$HOME/personal"

mv_and_edit() {
    if [ $# -ne 2 ]
    then
        echo >&2 "Internal error in function $0: expected 2 arguments"
        exit $EINTERNALERROR
    fi
    mkdir -p "`dirname \"$2\"`"
    mv "$1" "$2"
    echo "Moved $1 to $2, now launching an editor to do any necessary changes."
    "${EDITOR:-vi}" "$2"
}

echo "Installing config files."
echo "    Installing .profile"
if [ -e "$HOME/.profile" ]
then
    echo '~/.profile already exists: (o)verwrite, use as "config/shell/local/(a)lways", use as "config/shell/local/(l)ogin", or (q)uit installing?'
    read response
    case $response in
        [oO])
            rm "$HOME/.profile"
            ;;
        [aA])
            mv_and_edit "$HOME/.profile" "$PERSONAL/config/shell/local/always"
            ;;
        [lL])
            mv_and_edit "$HOME/.profile" "$PERSONAL/config/shell/local/login"
            ;;
        [qQ])
            exit $EUSERABORT
            ;;
        *)
            echo "Unrecognized response" >&2
            exit $EINVALIDRESPONSE
            ;;
    esac
            
fi
ln -s "$PERSONAL/config/shell/login" "$HOME/.profile"

echo "    Installing .bashrc"
if [ -e "$HOME/.bashrc" ]
then
    echo '~/.bashrc already exists: (o)verwrite, use as "config/shell/local/(a)lways", use as "config/shell/local/(n)onlogin", or (q)uit installing?'
    read response
    case $response in
        [oO])
            rm "$HOME/.bashrc"
            ;;
        [aA])
            mv_and_edit "$HOME/.bashrc" "$PERSONAL/config/shell/local/always"
            ;;
        [lL])
            mv_and_edit "$HOME/.bashrc" "$PERSONAL/config/shell/local/nonlogin"
            ;;
        [qQ])
            exit $EUSERABORT
            ;;
        *)
            echo "Unrecognized response" >&2
            exit $EINVALIDRESPONSE
            ;;
    esac
            
fi

ln -s "$PERSONAL/config/shell/login" "$HOME/.bashrc"


source "$PERSONAL/config/shell/always-paths"
echo "Installing software."
if cd "$PERSONAL/applications/installation" && sh -c make
then
    echo "Software installed."
else
    exit $EINSTALLERROR
fi
