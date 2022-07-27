
# Base environment directory. Change values here!

deactivate () {
    # with reference from python's venv activate

    # This should detect bash and zsh, which have a hash command that must
    # be called to get it to forget past commands.  Without forgetting
    # past commands the $PATH changes we made may not be respected
    if [ -n "${BASH:-}" -o -n "${ZSH_VERSION:-}" ] ; then
        hash -r
    fi

    if [ -n "${_OLD_PS1:-}" ] ; then
        PS1="${_OLD_PS1:-}"
        export PS1
        unset _OLD_PS1
    fi


    if [ ! "$1" = "nondestructive" ] ; then
    # Self destruct!
        unset -f deactivate
    fi

}

set_ps1 () {
    # Display current version in bash shell
    _OLD_PS1="${PS1:-}"
    PS1="[rucio-$EXPERIMENT $RUCIO_AMS_VERSION_TAG] ${PS1:-}"
    export PS1

    # This should detect bash and zsh, which have a hash command that must
    # be called to get it to forget past commands.  Without forgetting
    # past commands the $PATH changes we made may not be respected
    if [ -n "${BASH:-}" -o -n "${ZSH_VERSION:-}" ] ; then
        hash -r
    fi
}

deactivate nondestructive

# Checks if EXPERIMENT is defined, defaults to "int"
if [[ -z "${EXPERIMENT}" ]]; then
    EXPERIMENT=int
else
    EXPERIMENT="${EXPERIMENT}"
fi
echo Experiment: $EXPERIMENT
export EXPERIMENT=$EXPERIMENT

# get variables from the experiment
source $EXPERIMENT/setup_rucio_env.sh

export RUCIO_AMS_DIR=$PWD

# set user
export RUCIO_BUILD_USER=$(whoami)
echo Author: $RUCIO_BUILD_USER

# add bin to the PATH
export PATH=$RUCIO_AMS_DIR/bin:$PATH

set_ps1
