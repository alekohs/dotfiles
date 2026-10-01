function _jj_pick_revision
    set -l selection (command jj log --color always -r '::@ | mutable()' -T 'change_id.shortest(8) ++ " " ++ description.first_line() ++ " " ++ bookmarks' 2>/dev/null \
        | fzf --ansi +m --height 60% --layout=reverse --prompt 'Revision> ' \
            --preview 'jj show --color always (string match -rg "([k-z]{1,8}) " {})' --preview-window 'right,60%')

    if test -n "$selection"
        commandline -i (string match -rg '([k-z]{1,8}) ' (string replace -ra '\e\[[0-9;]*m' '' $selection))
    end
    commandline -f repaint
end
