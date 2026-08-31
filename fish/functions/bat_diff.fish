function bat_diff
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
end
