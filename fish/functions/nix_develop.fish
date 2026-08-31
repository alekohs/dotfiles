function nix_develop
    if test (count $argv) -gt 0
        nix develop ~/Developer/Github/devshells/$argv[1] -c fish
    else
        nix develop
    end
end
