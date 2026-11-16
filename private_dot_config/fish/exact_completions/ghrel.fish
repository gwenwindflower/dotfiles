complete -c ghrel -f
complete -c ghrel -s h -l help -d "Show help and the release process"
complete -c ghrel -s x -l execute -d "Run the release for real (default is a dry run)"
complete -c ghrel -s n -l dry-run -d "Preview only (the default)"
complete -c ghrel -s d -l draft -d "Create the release as a draft"
complete -c ghrel -s p -l prerelease -d "Mark the release as a prerelease"
complete -c ghrel -l no-changelog -d "Skip updating, committing, and pushing CHANGELOG.md"
