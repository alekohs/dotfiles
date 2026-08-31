function fcd
    set -l fzf_args +m --height 60% --layout=reverse
    if test (count $argv) -gt 0
        set fzf_args $fzf_args --query "$argv[1]"
    end

    set selection (fd . . --type directory --hidden --exclude .git --exclude node_modules | fzf $fzf_args)

    if test -n "$selection"
        cd $selection
    end
end
