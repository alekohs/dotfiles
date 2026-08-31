function ts
    if set -q TMUX
        # Use tmux popup when inside tmux
        set session (tmux display-popup -E "tmux ls 2>/dev/null | fzf --reverse | cut -d: -f1")
        if test -n "$session"
            tmux switch-client -t $session
        end
    else
        # Use regular fzf when not in tmux
        set session (tmux ls 2>/dev/null | fzf --reverse | cut -d: -f1)
        if test -n "$session"
            tmux attach-session -t $session
        end
    end
end
