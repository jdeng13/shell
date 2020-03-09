########### customize prompt
export PS1="\u: \w/"

########### alias for typical commands
alias l='ls -ltrha'
alias ll='ls -alF'
alias la='ls -A'
alias .='cd ../'
alias ..='cd ../../'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias his='history'
alias v='vim'
alias g='mvim'
alias p='python3'
function cd {
          builtin cd "$@" && ls -ltrha
}
############ update bashrc every time
if [ -n "$BASH_VERSION" ] && [ -f $HOME/.bashrc ];then
    source $HOME/.bashrc
fi
