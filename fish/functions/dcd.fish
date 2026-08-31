function dcd
    if test (count $argv) -gt 0
        ffcd $argv[1] ~/Developer
    else
        ffcd . ~/Developer
    end
end
