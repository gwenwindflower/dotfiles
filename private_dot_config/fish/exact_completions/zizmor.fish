complete -c zizmor -l collect -d 'Control which kinds of inputs are collected for auditing' -r -f -a "all\t'Collect all possible inputs, ignoring `.gitignore` files'
default\t'Collect all possible inputs, respecting `.gitignore` files'
workflows\t'Collect workflows'
actions\t'Collect action definitions (i.e. `action.yml`)'
dependabot\t'Collect Dependabot configuration files (i.e. `dependabot.yml`)'"
complete -c zizmor -l fix -d 'Fix findings automatically, when available (EXPERIMENTAL)' -r -f -a "safe\t'Apply only safe fixes (the default)'
unsafe-only\t'Apply only unsafe fixes'
all\t'Apply all fixes, both safe and unsafe'"
complete -c zizmor -l persona -d 'The persona to use while auditing' -r -f -a "auditor\t'The "auditor" persona (false positives OK)'
pedantic\t'The "pedantic" persona (code smells OK)'
regular\t'The "regular" persona (minimal false positives)'"
complete -c zizmor -l min-severity -d 'Filter all results below this severity' -r -f -a "informational\t''
low\t''
medium\t''
high\t''"
complete -c zizmor -l min-confidence -d 'Filter all results below this confidence' -r -f -a "low\t''
medium\t''
high\t''"
complete -c zizmor -l format -d 'The output format to emit. By default, cargo-style diagnostics will be emitted' -r -f -a "plain\t'cargo-style output'
json\t'JSON-formatted output (currently v1)'
json-v1\t'"v1" JSON format'
sarif\t'SARIF-formatted output'
github\t'GitHub Actions workflow command-formatted output'"
complete -c zizmor -l color -d 'Control the use of color in output' -r -f -a "auto\t'Use color output if the output supports it'
always\t'Force color output, even if the output isn\'t a terminal'
never\t'Disable color output, even if the output is a compatible terminal'"
complete -c zizmor -l render-links -d 'Whether to render OSC 8 links in the output' -r -f -a "auto\t'Render OSC 8 links in output if support is detected'
always\t'Always render OSC 8 links in output'
never\t'Never render OSC 8 links in output'"
complete -c zizmor -l show-audit-urls -d 'Whether to render audit URLs in the output, separately from any URLs embedded in OSC 8 links' -r -f -a "auto\t'Render audit URLs in output automatically based on output format and runtime context'
always\t'Always render audit URLs in output'
never\t'Never render audit URLs in output'"
complete -c zizmor -l gh-token -d 'The GitHub API token to use [env: GH_TOKEN or GITHUB_TOKEN or ZIZMOR_GITHUB_TOKEN]' -r
complete -c zizmor -l github-token -d 'This is an alias for `--gh-token` / `GH_TOKEN`' -r
complete -c zizmor -l zizmor-github-token -d 'This is an alias for `--gh-token` / `GH_TOKEN` / `--github-token` / `GITHUB_TOKEN`' -r
complete -c zizmor -l gh-hostname -d 'The GitHub Server Hostname. Defaults to github.com' -r
complete -c zizmor -l cache-dir -d 'The directory to use for HTTP caching. By default, a host-appropriate user-caching directory will be used' -r -f -a "(__fish_complete_directories)"
complete -c zizmor -s c -l config -d 'The configuration file to load. This loads a single configuration file across all input groups, which may not be what you intend' -r -F
complete -c zizmor -l completions -d 'Generate tab completion scripts for the specified shell' -r -f -a "bash\t'Bourne Again `SHell` (bash)'
elvish\t'Elvish shell'
fish\t'Friendly Interactive `SHell` (fish)'
nushell\t'Nushell'
powershell\t'`PowerShell`'
zsh\t'Z `SHell` (zsh)'"
complete -c zizmor -l strict-collection -d 'Fail instead of warning on syntax and schema errors in collected inputs'
complete -c zizmor -s p -l pedantic -d 'Emit \'pedantic\' findings'
complete -c zizmor -s v -l verbose -d 'Increase logging verbosity'
complete -c zizmor -s q -l quiet -d 'Decrease logging verbosity'
complete -c zizmor -l no-progress -d 'Don\'t show progress bars, even if the terminal supports them'
complete -c zizmor -l no-exit-codes -d 'Disable all error codes besides success and tool failure'
complete -c zizmor -l naches -d 'Enable naches mode'
complete -c zizmor -s o -l offline -d 'Perform only offline operations'
complete -c zizmor -l no-online-audits -d 'Perform only offline audits'
complete -c zizmor -l lsp -d 'Run in language server mode (EXPERIMENTAL)'
complete -c zizmor -l stdio
complete -c zizmor -l no-config -d 'Disable all configuration loading'
complete -c zizmor -l thanks -d 'Emit thank-you messages for zizmor\'s sponsors'
complete -c zizmor -s h -l help -d 'Print help (see more with \'--help\')'
complete -c zizmor -s V -l version -d 'Print version'
