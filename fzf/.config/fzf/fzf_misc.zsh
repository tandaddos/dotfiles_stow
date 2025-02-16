# #
# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
# 
f_rg() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# 
# repeat history
# 
f_history() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) \
    | fzf +s --tac \
    | sed -E 's/ *[0-9]*\*? *//' \
    | sed -E 's/\\/\\\\/g')
}

# 
# fkill - kill processes - list only the ones you can kill.
# 
f_kill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -efa | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}


