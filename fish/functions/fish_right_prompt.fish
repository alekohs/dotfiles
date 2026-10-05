function fish_right_prompt
    set -l parts
    if test "$__ak_status" -ne 0
        set -a parts (set_color $__ak_err)"$__ak_status"
    end
    if test "$CMD_DURATION" -gt 3000
        set -l s (math -s0 $CMD_DURATION / 1000)
        if test $s -ge 60
            set -a parts (set_color $__ak_meta)(math -s0 $s / 60)m(math $s % 60)s
        else
            set -a parts (set_color $__ak_meta)$s"s"
        end
    end
    set -l j (jobs -p | count)
    test $j -gt 0; and set -a parts (set_color $__ak_dim)"&$j"
    set -q IN_NIX_SHELL; and set -a parts (set_color $__ak_dim)nix
    set -a parts (set_color $__ak_dim)(command date +%H:%M)
    echo -n (string join (set_color $__ak_dim)' · ' $parts)
    set_color normal
end
