# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_himalaya_global_optspecs
	string join \n c/config= o/output= debug trace h/help V/version
end

function __fish_himalaya_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_himalaya_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_himalaya_using_subcommand
	set -l cmd (__fish_himalaya_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c himalaya -n "__fish_himalaya_needs_command" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_needs_command" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_needs_command" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_needs_command" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_needs_command" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_needs_command" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_needs_command" -f -a "account" -d 'Configure, list and diagnose your accounts'
complete -c himalaya -n "__fish_himalaya_needs_command" -f -a "folder" -d 'Create, list and purge your folders (as known as mailboxes)'
complete -c himalaya -n "__fish_himalaya_needs_command" -f -a "mailbox" -d 'Create, list and purge your folders (as known as mailboxes)'
complete -c himalaya -n "__fish_himalaya_needs_command" -f -a "envelope" -d 'List, search and sort your envelopes'
complete -c himalaya -n "__fish_himalaya_needs_command" -f -a "flag" -d 'Add, change and remove your envelopes flags'
complete -c himalaya -n "__fish_himalaya_needs_command" -f -a "message" -d 'Read, write, send, copy, move and delete your messages'
complete -c himalaya -n "__fish_himalaya_needs_command" -f -a "attachment" -d 'Download your message attachments'
complete -c himalaya -n "__fish_himalaya_needs_command" -f -a "template" -d 'Generate, save and send message templates'
complete -c himalaya -n "__fish_himalaya_needs_command" -f -a "manual" -d 'Generate manual pages to the given directory'
complete -c himalaya -n "__fish_himalaya_needs_command" -f -a "completion" -d 'Print completion script for the given shell to stdout'
complete -c himalaya -n "__fish_himalaya_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and not __fish_seen_subcommand_from configure doctor list help" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and not __fish_seen_subcommand_from configure doctor list help" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and not __fish_seen_subcommand_from configure doctor list help" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and not __fish_seen_subcommand_from configure doctor list help" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and not __fish_seen_subcommand_from configure doctor list help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and not __fish_seen_subcommand_from configure doctor list help" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and not __fish_seen_subcommand_from configure doctor list help" -f -a "configure" -d 'Configure the given account'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and not __fish_seen_subcommand_from configure doctor list help" -f -a "doctor" -d 'Diagnose and fix the given account'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and not __fish_seen_subcommand_from configure doctor list help" -f -a "list" -d 'List all existing accounts'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and not __fish_seen_subcommand_from configure doctor list help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from configure" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from configure" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from configure" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from configure" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from configure" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from configure" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from doctor" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from doctor" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from doctor" -s f -l fix -d 'Try to fix the given account'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from doctor" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from doctor" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from doctor" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from doctor" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from list" -s w -l max-width -d 'The maximum width the table should not exceed' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from list" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from list" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from list" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from list" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from help" -f -a "configure" -d 'Configure the given account'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from help" -f -a "doctor" -d 'Diagnose and fix the given account'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from help" -f -a "list" -d 'List all existing accounts'
complete -c himalaya -n "__fish_himalaya_using_subcommand account; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and not __fish_seen_subcommand_from add create list expunge purge delete help" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and not __fish_seen_subcommand_from add create list expunge purge delete help" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and not __fish_seen_subcommand_from add create list expunge purge delete help" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and not __fish_seen_subcommand_from add create list expunge purge delete help" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and not __fish_seen_subcommand_from add create list expunge purge delete help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and not __fish_seen_subcommand_from add create list expunge purge delete help" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "add" -d 'Create the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "create" -d 'Create the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "list" -d 'List all folders'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "expunge" -d 'Expunge the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "purge" -d 'Purge the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "delete" -d 'Delete the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from add" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from add" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from add" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from add" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from add" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from add" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from add" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from create" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from create" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from create" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from create" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from create" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from create" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from list" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from list" -s w -l max-width -d 'The maximum width the table should not exceed' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from list" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from list" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from list" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from list" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from expunge" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from expunge" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from expunge" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from expunge" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from expunge" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from expunge" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from expunge" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from purge" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from purge" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from purge" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from purge" -s y -l yes
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from purge" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from purge" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from purge" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from purge" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from delete" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from delete" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from delete" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from delete" -s y -l yes
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from delete" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from delete" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from delete" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from help" -f -a "add" -d 'Create the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from help" -f -a "list" -d 'List all folders'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from help" -f -a "expunge" -d 'Expunge the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from help" -f -a "purge" -d 'Purge the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from help" -f -a "delete" -d 'Delete the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand folder; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and not __fish_seen_subcommand_from add create list expunge purge delete help" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and not __fish_seen_subcommand_from add create list expunge purge delete help" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and not __fish_seen_subcommand_from add create list expunge purge delete help" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and not __fish_seen_subcommand_from add create list expunge purge delete help" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and not __fish_seen_subcommand_from add create list expunge purge delete help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and not __fish_seen_subcommand_from add create list expunge purge delete help" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "add" -d 'Create the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "create" -d 'Create the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "list" -d 'List all folders'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "expunge" -d 'Expunge the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "purge" -d 'Purge the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "delete" -d 'Delete the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and not __fish_seen_subcommand_from add create list expunge purge delete help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from add" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from add" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from add" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from add" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from add" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from add" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from add" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from create" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from create" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from create" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from create" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from create" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from create" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from list" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from list" -s w -l max-width -d 'The maximum width the table should not exceed' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from list" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from list" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from list" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from list" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from expunge" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from expunge" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from expunge" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from expunge" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from expunge" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from expunge" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from expunge" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from purge" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from purge" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from purge" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from purge" -s y -l yes
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from purge" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from purge" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from purge" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from purge" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from delete" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from delete" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from delete" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from delete" -s y -l yes
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from delete" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from delete" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from delete" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from help" -f -a "add" -d 'Create the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from help" -f -a "list" -d 'List all folders'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from help" -f -a "expunge" -d 'Expunge the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from help" -f -a "purge" -d 'Purge the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from help" -f -a "delete" -d 'Delete the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand mailbox; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and not __fish_seen_subcommand_from list thread help" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and not __fish_seen_subcommand_from list thread help" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and not __fish_seen_subcommand_from list thread help" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and not __fish_seen_subcommand_from list thread help" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and not __fish_seen_subcommand_from list thread help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and not __fish_seen_subcommand_from list thread help" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and not __fish_seen_subcommand_from list thread help" -f -a "list" -d 'Search and sort envelopes as a list'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and not __fish_seen_subcommand_from list thread help" -f -a "thread" -d 'Search and sort envelopes as a thread'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and not __fish_seen_subcommand_from list thread help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from list" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from list" -s p -l page -d 'The page number' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from list" -s s -l page-size -d 'The page size' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from list" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from list" -s w -l max-width -d 'The maximum width the table should not exceed' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from list" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from list" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from list" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from list" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from thread" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from thread" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from thread" -s i -l id -d 'Show only threads that contain the given envelope identifier' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from thread" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from thread" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from thread" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from thread" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from thread" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from thread" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from help" -f -a "list" -d 'Search and sort envelopes as a list'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from help" -f -a "thread" -d 'Search and sort envelopes as a thread'
complete -c himalaya -n "__fish_himalaya_using_subcommand envelope; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and not __fish_seen_subcommand_from add set remove help" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and not __fish_seen_subcommand_from add set remove help" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and not __fish_seen_subcommand_from add set remove help" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and not __fish_seen_subcommand_from add set remove help" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and not __fish_seen_subcommand_from add set remove help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and not __fish_seen_subcommand_from add set remove help" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and not __fish_seen_subcommand_from add set remove help" -f -a "add" -d 'Add flag(s) to the given envelope'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and not __fish_seen_subcommand_from add set remove help" -f -a "set" -d 'Replace flag(s) of a given envelope'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and not __fish_seen_subcommand_from add set remove help" -f -a "remove" -d 'Remove flag(s) from a given envelope'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and not __fish_seen_subcommand_from add set remove help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from add" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from add" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from add" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from add" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from add" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from add" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from add" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from add" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from set" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from set" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from set" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from set" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from set" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from set" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from set" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from set" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from remove" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from remove" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from remove" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from remove" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from remove" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from remove" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from remove" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from help" -f -a "add" -d 'Add flag(s) to the given envelope'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from help" -f -a "set" -d 'Replace flag(s) of a given envelope'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Remove flag(s) from a given envelope'
complete -c himalaya -n "__fish_himalaya_using_subcommand flag; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "read" -d 'Read a human-friendly version of the message associated to the given envelope id(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "export" -d 'Export the message associated to the given envelope id'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "thread" -d 'Read human-friendly version of messages associated to the given envelope id\'s thread'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "write" -d 'Compose a new message, from scratch'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "reply" -d 'Reply to the message associated to the given envelope id'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "forward" -d 'Forward the message associated to the given envelope id'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "edit" -d 'Edit the message associated to the given envelope id'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "mailto" -d 'Parse and edit a message from the given mailto URL string'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "save" -d 'Save the given raw message to the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "send" -d 'Send the given raw message'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "copy" -d 'Copy the message associated to the given envelope id(s) to the given target folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "move" -d 'Move the message associated to the given envelope id(s) to the given target folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "delete" -d 'Mark as deleted the message associated to the given envelope id(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and not __fish_seen_subcommand_from read export thread write reply forward edit mailto save send copy move delete help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from read" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from read" -s H -l header -d 'List of headers that should be visible at the top of the message' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from read" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from read" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from read" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from read" -s p -l preview -d 'Read the message without applying the "seen" flag to its corresponding envelope'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from read" -l no-headers -d 'Read only the body of the message'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from read" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from read" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from read" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from read" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from export" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from export" -s d -l destination -d 'Where the message should be exported to' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from export" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from export" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from export" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from export" -s F -l full -d 'Export the full raw message as one unique .eml file'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from export" -s O -l open -d 'Try to open the exported message, when applicable'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from export" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from export" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from export" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from export" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from thread" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from thread" -s H -l header -d 'List of headers that should be visible at the top of the message' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from thread" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from thread" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from thread" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from thread" -s p -l preview -d 'Thread the message without applying the "seen" flag to its corresponding envelope'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from thread" -l no-headers -d 'Thread only the body of the message'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from thread" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from thread" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from thread" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from thread" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from write" -s H -l header -d 'Prefill the template with custom headers' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from write" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from write" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from write" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from write" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from write" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from write" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from write" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from reply" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from reply" -s H -l header -d 'Prefill the template with custom headers' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from reply" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from reply" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from reply" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from reply" -s A -l all -d 'Reply to all recipients'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from reply" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from reply" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from reply" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from reply" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from forward" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from forward" -s H -l header -d 'Prefill the template with custom headers' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from forward" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from forward" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from forward" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from forward" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from forward" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from forward" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from forward" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from edit" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from edit" -s H -l header -d 'List of headers that should be visible at the top of the message' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from edit" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from edit" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from edit" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from edit" -s p -l on-place -d 'Edit the message on place'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from edit" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from edit" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from edit" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from edit" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from mailto" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from mailto" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from mailto" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from mailto" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from mailto" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from mailto" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from mailto" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from save" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from save" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from save" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from save" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from save" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from save" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from save" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from save" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from send" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from send" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from send" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from send" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from send" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from send" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from send" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from copy" -s f -l folder -d 'The name of the source folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from copy" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from copy" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from copy" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from copy" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from copy" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from copy" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from copy" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from move" -s f -l folder -d 'The name of the source folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from move" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from move" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from move" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from move" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from move" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from move" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from move" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from delete" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from delete" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from delete" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from delete" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from delete" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from delete" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from delete" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "read" -d 'Read a human-friendly version of the message associated to the given envelope id(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "export" -d 'Export the message associated to the given envelope id'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "thread" -d 'Read human-friendly version of messages associated to the given envelope id\'s thread'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "write" -d 'Compose a new message, from scratch'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "reply" -d 'Reply to the message associated to the given envelope id'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "forward" -d 'Forward the message associated to the given envelope id'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "edit" -d 'Edit the message associated to the given envelope id'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "mailto" -d 'Parse and edit a message from the given mailto URL string'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "save" -d 'Save the given raw message to the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "send" -d 'Send the given raw message'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "copy" -d 'Copy the message associated to the given envelope id(s) to the given target folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "move" -d 'Move the message associated to the given envelope id(s) to the given target folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "delete" -d 'Mark as deleted the message associated to the given envelope id(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand message; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and not __fish_seen_subcommand_from download help" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and not __fish_seen_subcommand_from download help" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and not __fish_seen_subcommand_from download help" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and not __fish_seen_subcommand_from download help" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and not __fish_seen_subcommand_from download help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and not __fish_seen_subcommand_from download help" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and not __fish_seen_subcommand_from download help" -f -a "download" -d 'Download all attachments found in the given message'
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and not __fish_seen_subcommand_from download help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and __fish_seen_subcommand_from download" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and __fish_seen_subcommand_from download" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and __fish_seen_subcommand_from download" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and __fish_seen_subcommand_from download" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and __fish_seen_subcommand_from download" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and __fish_seen_subcommand_from download" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and __fish_seen_subcommand_from download" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and __fish_seen_subcommand_from download" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and __fish_seen_subcommand_from help" -f -a "download" -d 'Download all attachments found in the given message'
complete -c himalaya -n "__fish_himalaya_using_subcommand attachment; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and not __fish_seen_subcommand_from write reply forward save send help" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and not __fish_seen_subcommand_from write reply forward save send help" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and not __fish_seen_subcommand_from write reply forward save send help" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and not __fish_seen_subcommand_from write reply forward save send help" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and not __fish_seen_subcommand_from write reply forward save send help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and not __fish_seen_subcommand_from write reply forward save send help" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and not __fish_seen_subcommand_from write reply forward save send help" -f -a "write" -d 'Generate a template for writing a new message from scratch'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and not __fish_seen_subcommand_from write reply forward save send help" -f -a "reply" -d 'Generate a template for replying to a message'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and not __fish_seen_subcommand_from write reply forward save send help" -f -a "forward" -d 'Generate a template for forwarding a message'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and not __fish_seen_subcommand_from write reply forward save send help" -f -a "save" -d 'Save a template to a folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and not __fish_seen_subcommand_from write reply forward save send help" -f -a "send" -d 'Send a template'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and not __fish_seen_subcommand_from write reply forward save send help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from write" -s H -l header -d 'Prefill the template with custom headers' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from write" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from write" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from write" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from write" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from write" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from write" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from write" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from reply" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from reply" -s H -l header -d 'Prefill the template with custom headers' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from reply" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from reply" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from reply" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from reply" -s A -l all -d 'Reply to all recipients'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from reply" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from reply" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from reply" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from reply" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from forward" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from forward" -s H -l header -d 'Prefill the template with custom headers' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from forward" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from forward" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from forward" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from forward" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from forward" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from forward" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from forward" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from save" -s f -l folder -d 'The name of the folder' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from save" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from save" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from save" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from save" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from save" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from save" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from save" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from send" -s a -l account -d 'Override the default account' -r
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from send" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from send" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from send" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from send" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from send" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from send" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from help" -f -a "write" -d 'Generate a template for writing a new message from scratch'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from help" -f -a "reply" -d 'Generate a template for replying to a message'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from help" -f -a "forward" -d 'Generate a template for forwarding a message'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from help" -f -a "save" -d 'Save a template to a folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from help" -f -a "send" -d 'Send a template'
complete -c himalaya -n "__fish_himalaya_using_subcommand template; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand manual" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand manual" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand manual" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand manual" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand manual" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand manual" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand completion" -s c -l config -d 'Override the default configuration file path' -r -F
complete -c himalaya -n "__fish_himalaya_using_subcommand completion" -s o -l output -d 'Customize the output format' -r -f -a "plain\t''
json\t''"
complete -c himalaya -n "__fish_himalaya_using_subcommand completion" -l debug -d 'Enable logs with spantrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand completion" -l trace -d 'Enable verbose logs with backtrace'
complete -c himalaya -n "__fish_himalaya_using_subcommand completion" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c himalaya -n "__fish_himalaya_using_subcommand completion" -s V -l version -d 'Print version'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and not __fish_seen_subcommand_from account folder envelope flag message attachment template manual completion help" -f -a "account" -d 'Configure, list and diagnose your accounts'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and not __fish_seen_subcommand_from account folder envelope flag message attachment template manual completion help" -f -a "folder" -d 'Create, list and purge your folders (as known as mailboxes)'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and not __fish_seen_subcommand_from account folder envelope flag message attachment template manual completion help" -f -a "envelope" -d 'List, search and sort your envelopes'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and not __fish_seen_subcommand_from account folder envelope flag message attachment template manual completion help" -f -a "flag" -d 'Add, change and remove your envelopes flags'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and not __fish_seen_subcommand_from account folder envelope flag message attachment template manual completion help" -f -a "message" -d 'Read, write, send, copy, move and delete your messages'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and not __fish_seen_subcommand_from account folder envelope flag message attachment template manual completion help" -f -a "attachment" -d 'Download your message attachments'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and not __fish_seen_subcommand_from account folder envelope flag message attachment template manual completion help" -f -a "template" -d 'Generate, save and send message templates'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and not __fish_seen_subcommand_from account folder envelope flag message attachment template manual completion help" -f -a "manual" -d 'Generate manual pages to the given directory'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and not __fish_seen_subcommand_from account folder envelope flag message attachment template manual completion help" -f -a "completion" -d 'Print completion script for the given shell to stdout'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and not __fish_seen_subcommand_from account folder envelope flag message attachment template manual completion help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from account" -f -a "configure" -d 'Configure the given account'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from account" -f -a "doctor" -d 'Diagnose and fix the given account'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from account" -f -a "list" -d 'List all existing accounts'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from folder" -f -a "add" -d 'Create the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from folder" -f -a "list" -d 'List all folders'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from folder" -f -a "expunge" -d 'Expunge the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from folder" -f -a "purge" -d 'Purge the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from folder" -f -a "delete" -d 'Delete the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from envelope" -f -a "list" -d 'Search and sort envelopes as a list'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from envelope" -f -a "thread" -d 'Search and sort envelopes as a thread'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from flag" -f -a "add" -d 'Add flag(s) to the given envelope'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from flag" -f -a "set" -d 'Replace flag(s) of a given envelope'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from flag" -f -a "remove" -d 'Remove flag(s) from a given envelope'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from message" -f -a "read" -d 'Read a human-friendly version of the message associated to the given envelope id(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from message" -f -a "export" -d 'Export the message associated to the given envelope id'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from message" -f -a "thread" -d 'Read human-friendly version of messages associated to the given envelope id\'s thread'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from message" -f -a "write" -d 'Compose a new message, from scratch'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from message" -f -a "reply" -d 'Reply to the message associated to the given envelope id'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from message" -f -a "forward" -d 'Forward the message associated to the given envelope id'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from message" -f -a "edit" -d 'Edit the message associated to the given envelope id'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from message" -f -a "mailto" -d 'Parse and edit a message from the given mailto URL string'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from message" -f -a "save" -d 'Save the given raw message to the given folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from message" -f -a "send" -d 'Send the given raw message'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from message" -f -a "copy" -d 'Copy the message associated to the given envelope id(s) to the given target folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from message" -f -a "move" -d 'Move the message associated to the given envelope id(s) to the given target folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from message" -f -a "delete" -d 'Mark as deleted the message associated to the given envelope id(s)'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from attachment" -f -a "download" -d 'Download all attachments found in the given message'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from template" -f -a "write" -d 'Generate a template for writing a new message from scratch'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from template" -f -a "reply" -d 'Generate a template for replying to a message'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from template" -f -a "forward" -d 'Generate a template for forwarding a message'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from template" -f -a "save" -d 'Save a template to a folder'
complete -c himalaya -n "__fish_himalaya_using_subcommand help; and __fish_seen_subcommand_from template" -f -a "send" -d 'Send a template'
