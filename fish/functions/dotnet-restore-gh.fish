function dotnet-restore-gh
    set -lx GITHUB_NUGET_TOKEN (gh auth token)
    dotnet restore $argv
end
