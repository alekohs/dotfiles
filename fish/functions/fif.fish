function fif
    if test (count $argv) -eq 0
        echo "No search parameter"
        return 1
    end
    rg --files-with-matches --no-messages --ignore-case "$argv[1]" | fzf --preview "rg --ignore-case --pretty --context 10 '$argv[1]' {} || echo 'No matches in file'" --preview-window=right:70%
end
