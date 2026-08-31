function fzfc
    fzf \
        --delimiter ":" \
        --with-nth 1,2 \
        --preview "bat --color=always --style=numbers --highlight-line {2} {1} | rg --color=always --context 3 {q}" \
        --preview-window '~5' \
        --bind "change:reload:rg --column --line-number --color=always --hidden --glob '!.git/*' {q} || true" \
        --prompt "Search content> " \
        --height 60% \
        --layout=reverse
end
