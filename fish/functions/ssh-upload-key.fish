function ssh-upload-key
    if test (count $argv) -lt 1
        echo "Usage: ssh-upload-key <user@host> [comment]"
        return 1
    end

    set -l host $argv[1]
    set -l comment $argv[2]

    if test -n "$comment"
        ssh-keygen -t ed25519 -C "$comment"
    else
        ssh-keygen -t ed25519
    end

    and ssh-copy-id $host
end
