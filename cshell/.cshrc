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
