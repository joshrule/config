# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# BASH-SPECIFIC ENVIRONMENT VARIABLES

# prompts
if [ -n "$SSH_CLIENT" ]; then
    # SSH goes yellow
    export PS1='\[\e[0;33m\]SSH \u@\h:\W $\[\e[m\] '
elif [ `/usr/bin/whoami` = "root" ] ; then
    # root goes red
    export PS1="\[\033[1;31m\]\W\$ \[\033[0m\]"
else
    # else plain
    export PS1='\[\e[1;32m\]\w >>\[\e[0m\] '
fi
# I mostly use emacs, but that's not always available
export EDITOR="vim"

# ALIASES

alias ls="ls -G"
alias la="ls -aG"
alias ll="ls -lhG"
alias lla="ls -lahG"
alias go="cd $1 && ls -aG $1"
alias rm="rm -i"
alias mv="mv -i"
alias grep="grep --color=auto"
alias maxtun="ssh -fN -L 2222:141.161.206.55:22 maxlab"
alias maxtun2="ssh -fN -L 2222:10.162.0.106:22 maxlab"
alias maxtun3="ssh -fN -XL 2223:10.162.0.106:22 maxlab"
alias sep="echo && \
           echo --------------------------------------------------------------------------------  && \
           echo"
alias gl="git log --oneline -n $1"
alias gg="git log --branches --remotes --tags --graph --oneline --decorate"
alias ml="/Applications/MATLAB_R2013b.app/bin/matlab -nodisplay -nodesktop -nosplash -logfile ~/.matlab/log"
alias e="emacs"

# FUNCTIONS

# Removes all installed GHC/cabal packages, but not binaries, docs, etc.
# Use this to get out of dependency hell and start over, at the cost of some rebuilding time.
function ghc-pkg-reset() {
    read -p 'erasing all your user ghc and cabal packages - are you sure (y/n) ? ' ans
    test x$ans == xy && ( \
        echo 'erasing directories under ~/.ghc'; rm -rf `find ~/.ghc -maxdepth 1 -type d`; \
        echo 'erasing ~/.cabal/lib'; rm -rf ~/.cabal/lib; \
        # echo 'erasing ~/.cabal/packages'; rm -rf ~/.cabal/packages; \
        # echo 'erasing ~/.cabal/share'; rm -rf ~/.cabal/share; \
    )
}

# updates via homebrew, TexLiveManaGeR (tlmgr), pip, and rustup
function update_eo(){
    # homebrew
    brew update;
    OUTDATED="$(brew outdated)"
    if [[ -n $OUTDATED ]]; then
        echo && echo ---- && echo
        echo $OUTDATED
        read -p "Do you want to update the above brew packages [y/n] : " ans
        if [[ $ans == "y" ]]; then
            brew upgrade
            echo && echo ---- && echo
            brew cleanup
        fi
    fi

    # brew cask
    OUTDATED="$(brew cask outdated)"
    if [[ -n $OUTDATED ]]; then
        echo && echo ---- && echo
        echo $OUTDATED
        read -p "Do you want to update the above brew cask packages [y/n] : " ans
        if [[ $ans == "y" ]]; then
            brew cask reinstall $OUTDATED
        fi
    fi

    # LaTeX
    echo && echo ---- && echo
    sudo tlmgr update --self --all;

    # Python 2
    OUTDATED="$(pip2 list --outdated --format=columns | tail -n +3 | cut -d \  -f 1 | sed '/Django/d')"
    if [[ -n $OUTDATED ]]; then
        echo && echo ---- && echo
        echo $OUTDATED
        read -p "Do you want to update the above python packages [y/n] : " ans
        if [[ $ans == "y" ]]; then
            pip2 install -U $OUTDATED
        fi
    fi

    # rust
    echo && echo ---- && echo
    rustup self update && rustup update && rustup default stable;
}

# write the output of some script to a log file
function d(){
    $@ &> debug.log ;
    less debug.log
}

# rip a dvd
function rip_dvd(){
    diskutil list
    read -p 'Which disk would you like to rip? ' mount_point
    read -p 'What would you like to name the file? ' file_name
    diskutil unmount $mount_point
    disk_info=`isoinfo -d -i $mount_point`
    block_size=`echo "$disk_info"  | grep -i -E 'block size' | sed "s/[^0-9]//g"`
    volume_size=`echo "$disk_info" | grep -i -E 'volume size' | sed "s/[^0-9]//g"`
    sudo dd if=$mount_point of=~/sync/$file_name.iso bs=$block_size count=$volume_size
    diskutil eject $mount_point
}

# install to global pip
gpip() {
    PIP_REQUIRE_VIRTUALENV="" pip "$@"
}
