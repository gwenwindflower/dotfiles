complete -c taplo -n "__fish_use_subcommand" -l colors -r -f -a "{auto	'Determine whether to colorize output automatically',always	'Always colorize output',never	'Never colorize output'}"
complete -c taplo -n "__fish_use_subcommand" -l verbose -d 'Enable a verbose logging format'
complete -c taplo -n "__fish_use_subcommand" -l log-spans -d 'Enable logging spans'
complete -c taplo -n "__fish_use_subcommand" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c taplo -n "__fish_use_subcommand" -s V -l version -d 'Print version'
complete -c taplo -n "__fish_use_subcommand" -f -a "lint" -d 'Lint TOML documents'
complete -c taplo -n "__fish_use_subcommand" -f -a "format" -d 'Format TOML documents'
complete -c taplo -n "__fish_use_subcommand" -f -a "lsp" -d 'Language server operations'
complete -c taplo -n "__fish_use_subcommand" -f -a "config" -d 'Operations with the Taplo config file'
complete -c taplo -n "__fish_use_subcommand" -f -a "get" -d 'Extract a value from the given TOML document'
complete -c taplo -n "__fish_use_subcommand" -f -a "toml-test" -d 'Start a decoder for `toml-test` (https://github.com/BurntSushi/toml-test)'
complete -c taplo -n "__fish_use_subcommand" -f -a "completions" -d 'Generate completions for Taplo CLI'
complete -c taplo -n "__fish_use_subcommand" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c taplo -n "__fish_seen_subcommand_from lint" -s c -l config -d 'Path to the Taplo configuration file' -r -F
complete -c taplo -n "__fish_seen_subcommand_from lint" -l cache-path -d 'Set a cache path' -r -F
complete -c taplo -n "__fish_seen_subcommand_from lint" -l schema -d 'URL to the schema to be used for validation' -r
complete -c taplo -n "__fish_seen_subcommand_from lint" -l schema-catalog -d 'URL to a schema catalog (index) that is compatible with Schema Store or Taplo catalogs' -r
complete -c taplo -n "__fish_seen_subcommand_from lint" -l colors -r -f -a "{auto	'Determine whether to colorize output automatically',always	'Always colorize output',never	'Never colorize output'}"
complete -c taplo -n "__fish_seen_subcommand_from lint" -l no-auto-config -d 'Do not search for a configuration file'
complete -c taplo -n "__fish_seen_subcommand_from lint" -l default-schema-catalogs -d 'Use the default online catalogs for schemas'
complete -c taplo -n "__fish_seen_subcommand_from lint" -l no-schema -d 'Disable all schema validations'
complete -c taplo -n "__fish_seen_subcommand_from lint" -l verbose -d 'Enable a verbose logging format'
complete -c taplo -n "__fish_seen_subcommand_from lint" -l log-spans -d 'Enable logging spans'
complete -c taplo -n "__fish_seen_subcommand_from lint" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c taplo -n "__fish_seen_subcommand_from format" -s c -l config -d 'Path to the Taplo configuration file' -r -F
complete -c taplo -n "__fish_seen_subcommand_from format" -l cache-path -d 'Set a cache path' -r -F
complete -c taplo -n "__fish_seen_subcommand_from format" -s o -l option -d 'A formatter option given as a "key=value", can be set multiple times' -r
complete -c taplo -n "__fish_seen_subcommand_from format" -l stdin-filepath -d 'A path to the file that the Taplo CLI will treat like stdin' -r
complete -c taplo -n "__fish_seen_subcommand_from format" -l colors -r -f -a "{auto	'Determine whether to colorize output automatically',always	'Always colorize output',never	'Never colorize output'}"
complete -c taplo -n "__fish_seen_subcommand_from format" -l no-auto-config -d 'Do not search for a configuration file'
complete -c taplo -n "__fish_seen_subcommand_from format" -s f -l force -d 'Ignore syntax errors and force formatting'
complete -c taplo -n "__fish_seen_subcommand_from format" -l check -d 'Dry-run and report any files that are not correctly formatted'
complete -c taplo -n "__fish_seen_subcommand_from format" -l diff -d 'Print the differences in patch formatting to `stdout`'
complete -c taplo -n "__fish_seen_subcommand_from format" -l verbose -d 'Enable a verbose logging format'
complete -c taplo -n "__fish_seen_subcommand_from format" -l log-spans -d 'Enable logging spans'
complete -c taplo -n "__fish_seen_subcommand_from format" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio; and not __fish_seen_subcommand_from help" -s c -l config -d 'Path to the Taplo configuration file' -r -F
complete -c taplo -n "__fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio; and not __fish_seen_subcommand_from help" -l cache-path -d 'Set a cache path' -r -F
complete -c taplo -n "__fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio; and not __fish_seen_subcommand_from help" -l colors -r -f -a "{auto	'Determine whether to colorize output automatically',always	'Always colorize output',never	'Never colorize output'}"
complete -c taplo -n "__fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio; and not __fish_seen_subcommand_from help" -l no-auto-config -d 'Do not search for a configuration file'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio; and not __fish_seen_subcommand_from help" -l verbose -d 'Enable a verbose logging format'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio; and not __fish_seen_subcommand_from help" -l log-spans -d 'Enable logging spans'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio; and not __fish_seen_subcommand_from help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio; and not __fish_seen_subcommand_from help" -f -a "tcp" -d 'Run the language server and listen on a TCP address'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio; and not __fish_seen_subcommand_from help" -f -a "stdio" -d 'Run the language server over the standard input and output'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and __fish_seen_subcommand_from tcp" -l address -d 'The address to listen on' -r
complete -c taplo -n "__fish_seen_subcommand_from lsp; and __fish_seen_subcommand_from tcp" -l colors -r -f -a "{auto	'Determine whether to colorize output automatically',always	'Always colorize output',never	'Never colorize output'}"
complete -c taplo -n "__fish_seen_subcommand_from lsp; and __fish_seen_subcommand_from tcp" -l verbose -d 'Enable a verbose logging format'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and __fish_seen_subcommand_from tcp" -l log-spans -d 'Enable logging spans'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and __fish_seen_subcommand_from tcp" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and __fish_seen_subcommand_from stdio" -l colors -r -f -a "{auto	'Determine whether to colorize output automatically',always	'Always colorize output',never	'Never colorize output'}"
complete -c taplo -n "__fish_seen_subcommand_from lsp; and __fish_seen_subcommand_from stdio" -l verbose -d 'Enable a verbose logging format'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and __fish_seen_subcommand_from stdio" -l log-spans -d 'Enable logging spans'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and __fish_seen_subcommand_from stdio" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio; and not __fish_seen_subcommand_from help" -f -a "tcp" -d 'Run the language server and listen on a TCP address'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio; and not __fish_seen_subcommand_from help" -f -a "stdio" -d 'Run the language server over the standard input and output'
complete -c taplo -n "__fish_seen_subcommand_from lsp; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c taplo -n "__fish_seen_subcommand_from config; and not __fish_seen_subcommand_from default; and not __fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from help" -l colors -r -f -a "{auto	'Determine whether to colorize output automatically',always	'Always colorize output',never	'Never colorize output'}"
complete -c taplo -n "__fish_seen_subcommand_from config; and not __fish_seen_subcommand_from default; and not __fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from help" -l verbose -d 'Enable a verbose logging format'
complete -c taplo -n "__fish_seen_subcommand_from config; and not __fish_seen_subcommand_from default; and not __fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from help" -l log-spans -d 'Enable logging spans'
complete -c taplo -n "__fish_seen_subcommand_from config; and not __fish_seen_subcommand_from default; and not __fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c taplo -n "__fish_seen_subcommand_from config; and not __fish_seen_subcommand_from default; and not __fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from help" -f -a "default" -d 'Print the default `.taplo.toml` configuration file'
complete -c taplo -n "__fish_seen_subcommand_from config; and not __fish_seen_subcommand_from default; and not __fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from help" -f -a "schema" -d 'Print the JSON schema of the `.taplo.toml` configuration file'
complete -c taplo -n "__fish_seen_subcommand_from config; and not __fish_seen_subcommand_from default; and not __fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c taplo -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from default" -l colors -r -f -a "{auto	'Determine whether to colorize output automatically',always	'Always colorize output',never	'Never colorize output'}"
complete -c taplo -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from default" -l verbose -d 'Enable a verbose logging format'
complete -c taplo -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from default" -l log-spans -d 'Enable logging spans'
complete -c taplo -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from default" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c taplo -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from schema" -l colors -r -f -a "{auto	'Determine whether to colorize output automatically',always	'Always colorize output',never	'Never colorize output'}"
complete -c taplo -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from schema" -l verbose -d 'Enable a verbose logging format'
complete -c taplo -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from schema" -l log-spans -d 'Enable logging spans'
complete -c taplo -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from schema" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c taplo -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from default; and not __fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from help" -f -a "default" -d 'Print the default `.taplo.toml` configuration file'
complete -c taplo -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from default; and not __fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from help" -f -a "schema" -d 'Print the JSON schema of the `.taplo.toml` configuration file'
complete -c taplo -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from default; and not __fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c taplo -n "__fish_seen_subcommand_from get" -s o -l output-format -d 'The format specifying how the output is printed' -r -f -a "{value	'Extract the value outputting it in a text format',json	'Output format in JSON',toml	'Output format in TOML'}"
complete -c taplo -n "__fish_seen_subcommand_from get" -s f -l file-path -d 'Path to the TOML document, if omitted the standard input will be used' -r -F
complete -c taplo -n "__fish_seen_subcommand_from get" -l separator -d 'A string that separates array values when printing to stdout' -r
complete -c taplo -n "__fish_seen_subcommand_from get" -l colors -r -f -a "{auto	'Determine whether to colorize output automatically',always	'Always colorize output',never	'Never colorize output'}"
complete -c taplo -n "__fish_seen_subcommand_from get" -s s -l strip-newline -d 'Strip the trailing newline from the output'
complete -c taplo -n "__fish_seen_subcommand_from get" -l verbose -d 'Enable a verbose logging format'
complete -c taplo -n "__fish_seen_subcommand_from get" -l log-spans -d 'Enable logging spans'
complete -c taplo -n "__fish_seen_subcommand_from get" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c taplo -n "__fish_seen_subcommand_from toml-test" -l colors -r -f -a "{auto	'Determine whether to colorize output automatically',always	'Always colorize output',never	'Never colorize output'}"
complete -c taplo -n "__fish_seen_subcommand_from toml-test" -l verbose -d 'Enable a verbose logging format'
complete -c taplo -n "__fish_seen_subcommand_from toml-test" -l log-spans -d 'Enable logging spans'
complete -c taplo -n "__fish_seen_subcommand_from toml-test" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c taplo -n "__fish_seen_subcommand_from completions" -l colors -r -f -a "{auto	'Determine whether to colorize output automatically',always	'Always colorize output',never	'Never colorize output'}"
complete -c taplo -n "__fish_seen_subcommand_from completions" -l verbose -d 'Enable a verbose logging format'
complete -c taplo -n "__fish_seen_subcommand_from completions" -l log-spans -d 'Enable logging spans'
complete -c taplo -n "__fish_seen_subcommand_from completions" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c taplo -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from lint; and not __fish_seen_subcommand_from format; and not __fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from get; and not __fish_seen_subcommand_from toml-test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "lint" -d 'Lint TOML documents'
complete -c taplo -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from lint; and not __fish_seen_subcommand_from format; and not __fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from get; and not __fish_seen_subcommand_from toml-test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "format" -d 'Format TOML documents'
complete -c taplo -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from lint; and not __fish_seen_subcommand_from format; and not __fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from get; and not __fish_seen_subcommand_from toml-test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "lsp" -d 'Language server operations'
complete -c taplo -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from lint; and not __fish_seen_subcommand_from format; and not __fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from get; and not __fish_seen_subcommand_from toml-test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "config" -d 'Operations with the Taplo config file'
complete -c taplo -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from lint; and not __fish_seen_subcommand_from format; and not __fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from get; and not __fish_seen_subcommand_from toml-test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "get" -d 'Extract a value from the given TOML document'
complete -c taplo -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from lint; and not __fish_seen_subcommand_from format; and not __fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from get; and not __fish_seen_subcommand_from toml-test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "toml-test" -d 'Start a decoder for `toml-test` (https://github.com/BurntSushi/toml-test)'
complete -c taplo -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from lint; and not __fish_seen_subcommand_from format; and not __fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from get; and not __fish_seen_subcommand_from toml-test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "completions" -d 'Generate completions for Taplo CLI'
complete -c taplo -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from lint; and not __fish_seen_subcommand_from format; and not __fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from get; and not __fish_seen_subcommand_from toml-test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c taplo -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio" -f -a "tcp" -d 'Run the language server and listen on a TCP address'
complete -c taplo -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from lsp; and not __fish_seen_subcommand_from tcp; and not __fish_seen_subcommand_from stdio" -f -a "stdio" -d 'Run the language server over the standard input and output'
complete -c taplo -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from default; and not __fish_seen_subcommand_from schema" -f -a "default" -d 'Print the default `.taplo.toml` configuration file'
complete -c taplo -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from default; and not __fish_seen_subcommand_from schema" -f -a "schema" -d 'Print the JSON schema of the `.taplo.toml` configuration file'
