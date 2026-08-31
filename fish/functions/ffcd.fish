function ffcd
    set -l fd_args --type directory --hidden --exclude .git --exclude node_modules
    if test (count $argv) -gt 1
        set fd_args $argv[1] $argv[2] $fd_args
    else if test (count $argv) -gt 0
        set fd_args . $argv[1] $fd_args
    end

    set selection (fd $fd_args | fzf +m --height 60% --layout=reverse)

    if test -n "$selection"
        cd $selection
    end
end
