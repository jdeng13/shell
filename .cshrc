#!/bin/csh
### Alias for commands
set prompt="`hostname`: $cwd/"
alias cd 'chdir \!*; set prompt="`hostname`: $cwd/"; ls -ltrh'
alias . "cd ../"
alias .. "cd ../../"
alias ... "cd ../../../"
alias l "ls -lhtr" 
alias ll 'ls -lthra'
alias his 'history'
alias . "cd ../"
alias .. "cd ../../"
alias ... "cd ../../../"
alias v 'vim'
alias g 'gvim'
alias p 'python3.7'
alias vr "gvim ~/.vimrc"
alias cr "gvim ~/.cshrc"
alias o "source ~/open_gnomeTerminal.tcl"
alias gr "grep -r"
alias sc "source ~/.cshrc"
alias cp "cp -rf"

#### Alias for directories ####
alias dt "cd /data"
alias pj "cd /data/projects/"
alias vd "cd ~/.vim"
alias pd "cd /data/python/"

# create command arguments
set _exit = 1
if ( $#argv >= 1 ) then
  if ( $argv[1] =~ sd[0-9]* || $argv[1] =~ hi[0-9]* ) then
    setenv ver $argv[1];
    set _exit = 0
  endif
endif

if ( $#argv > 1 ) then
  setenv _SC_MODE_ $argv[2];
else
  setenv _SC_MODE_ "NONE"
endif

# get the current working directory
set cur_dir = $cwd;
alias lc "ls $cwd/\!*"
