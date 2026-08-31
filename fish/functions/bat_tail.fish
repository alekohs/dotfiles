function bat_tail
    tail -f $argv[1] | bat --paging=never -l log
end
