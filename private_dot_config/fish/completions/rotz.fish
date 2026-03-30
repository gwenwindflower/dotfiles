# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_rotz_global_optspecs
	string join \n d/dotfiles= c/config= r/dry-run h/help V/version
end

function __fish_rotz_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_rotz_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_rotz_using_subcommand
	set -l cmd (__fish_rotz_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c rotz -n "__fish_rotz_needs_command" -s d -l dotfiles -d 'Overwrites the dotfiles path set in the config file' -r
complete -c rotz -n "__fish_rotz_needs_command" -s c -l config -d 'Path to the config file' -r
complete -c rotz -n "__fish_rotz_needs_command" -s r -l dry-run -d 'When this switch is set no changes will be made'
complete -c rotz -n "__fish_rotz_needs_command" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c rotz -n "__fish_rotz_needs_command" -s V -l version -d 'Print version'
complete -c rotz -n "__fish_rotz_needs_command" -f -a "clone" -d 'Clones a dotfiles git repository'
complete -c rotz -n "__fish_rotz_needs_command" -f -a "init" -d 'Creates a dotfiles git repository and config'
complete -c rotz -n "__fish_rotz_needs_command" -f -a "link" -d 'Links dotfiles to the filesystem'
complete -c rotz -n "__fish_rotz_needs_command" -f -a "install" -d 'Installs applications using the provided commands'
complete -c rotz -n "__fish_rotz_needs_command" -f -a "completions" -d 'Adds completions to shell'
complete -c rotz -n "__fish_rotz_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c rotz -n "__fish_rotz_using_subcommand clone" -s h -l help -d 'Print help'
complete -c rotz -n "__fish_rotz_using_subcommand init" -s h -l help -d 'Print help'
complete -c rotz -n "__fish_rotz_using_subcommand link" -s l -l link-type -d 'Which link type to use for linking dotfiles' -r -f -a "symbolic\t'Uses symbolic links for linking'
hard\t'Uses hard links for linking'"
complete -c rotz -n "__fish_rotz_using_subcommand link" -s f -l force -d 'Force link creation if file already exists and was not created by rotz'
complete -c rotz -n "__fish_rotz_using_subcommand link" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c rotz -n "__fish_rotz_using_subcommand install" -s c -l continue-on-error -d 'Continues installation when an error occurs during installation'
complete -c rotz -n "__fish_rotz_using_subcommand install" -s d -l skip-dependencies -d 'Do not install dependencies'
complete -c rotz -n "__fish_rotz_using_subcommand install" -s i -l skip-installation-dependencies -d 'Do not install installation dependencies'
complete -c rotz -n "__fish_rotz_using_subcommand install" -s a -l skip-all-dependencies -d 'Do not install any dependencies'
complete -c rotz -n "__fish_rotz_using_subcommand install" -s h -l help -d 'Print help'
complete -c rotz -n "__fish_rotz_using_subcommand completions" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "clone" -d 'Clones a dotfiles git repository'
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "init" -d 'Creates a dotfiles git repository and config'
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "link" -d 'Links dotfiles to the filesystem'
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "install" -d 'Installs applications using the provided commands'
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "completions" -d 'Adds completions to shell'
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
