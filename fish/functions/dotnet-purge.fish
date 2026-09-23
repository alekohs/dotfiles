function dotnet-purge --description 'Remove bin/obj folders of .csproj projects (dry run by default)'
    argparse h/help l/live -- $argv; or return

    if set -q _flag_help
        echo "Usage: dotnet-purge [-l] [path]"
        echo ""
        echo "Lists bin/obj folders next to every .csproj under path. Nothing is deleted unless -l is given."
        echo ""
        echo "  path        Folder to search (default: .)"
        echo "  -l, --live  Actually delete the folders"
        echo "  -h, --help  Show this help"
        return
    end
    set -l root .
    set -q argv[1]; and set root $argv[1]

    for project in (find $root -type f -name '*.csproj')
        set -l dir (dirname "$project")
        for d in "$dir/bin" "$dir/obj"
            test -d "$d"; or continue
            if not set -q _flag_live
                echo "$d"
            else
                rm -rf "$d"; and echo "removed $d"
            end
        end
    end
end
