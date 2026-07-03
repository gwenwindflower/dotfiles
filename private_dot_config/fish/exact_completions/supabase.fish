###-begin-supabase-completions-###
#
# Static completion script for Fish
#
# Installation:
#   supabase --completions fish > ~/.config/fish/completions/supabase.fish
#

complete -c supabase -n __fish_use_subcommand -f
complete -c supabase -n __fish_use_subcommand -f -a backups -d 'Manage Supabase physical backups'
complete -c supabase -n __fish_use_subcommand -f -a bootstrap -d 'Bootstrap a Supabase project from a starter template'
complete -c supabase -n __fish_use_subcommand -f -a branches -d 'Manage preview branches'
complete -c supabase -n __fish_use_subcommand -f -a completion -d 'Generate autocompletion scripts'
complete -c supabase -n __fish_use_subcommand -f -a config -d 'Manage project configurations'
complete -c supabase -n __fish_use_subcommand -f -a db -d 'Manage databases'
complete -c supabase -n __fish_use_subcommand -f -a domains -d 'Manage custom domain names for Supabase projects'
complete -c supabase -n __fish_use_subcommand -f -a encryption -d 'Manage encryption keys'
complete -c supabase -n __fish_use_subcommand -f -a functions -d 'Manage Supabase Edge functions'
complete -c supabase -n __fish_use_subcommand -f -a gen -d 'Run code generation tools'
complete -c supabase -n __fish_use_subcommand -f -a init -d 'Initialize a local project'
complete -c supabase -n __fish_use_subcommand -f -a inspect -d 'Inspect project tools'
complete -c supabase -n __fish_use_subcommand -f -a issue -d 'Open GitHub issue forms'
complete -c supabase -n __fish_use_subcommand -f -a link -d 'Link to a Supabase project'
complete -c supabase -n __fish_use_subcommand -f -a login -d 'Authenticate using an access token'
complete -c supabase -n __fish_use_subcommand -f -a logout -d 'Log out and delete access tokens locally'
complete -c supabase -n __fish_use_subcommand -f -a migration -d 'Manage database migration scripts'
complete -c supabase -n __fish_use_subcommand -f -a network-bans -d 'Manage network bans'
complete -c supabase -n __fish_use_subcommand -f -a network-restrictions -d 'Manage network restrictions'
complete -c supabase -n __fish_use_subcommand -f -a orgs -d 'Manage Supabase organizations'
complete -c supabase -n __fish_use_subcommand -f -a postgres-config -d 'Manage Postgres database config'
complete -c supabase -n __fish_use_subcommand -f -a projects -d 'Manage projects'
complete -c supabase -n __fish_use_subcommand -f -a secrets -d 'Manage Supabase secrets'
complete -c supabase -n __fish_use_subcommand -f -a seed -d 'Seed a Supabase project'
complete -c supabase -n __fish_use_subcommand -f -a services -d 'Show versions of all Supabase services'
complete -c supabase -n __fish_use_subcommand -f -a snippets -d 'Manage Supabase SQL snippets'
complete -c supabase -n __fish_use_subcommand -f -a ssl-enforcement -d 'Manage SSL enforcement'
complete -c supabase -n __fish_use_subcommand -f -a sso -d 'Manage Single Sign-On (SSO) authentication'
complete -c supabase -n __fish_use_subcommand -f -a start -d 'Start local Supabase stack'
complete -c supabase -n __fish_use_subcommand -f -a status -d 'Show status of local Supabase containers'
complete -c supabase -n __fish_use_subcommand -f -a stop -d 'Stop all local Supabase containers'
complete -c supabase -n __fish_use_subcommand -f -a storage -d 'Manage Supabase Storage objects'
complete -c supabase -n __fish_use_subcommand -f -a telemetry -d 'Manage telemetry'
complete -c supabase -n __fish_use_subcommand -f -a test -d 'Run tests on local Supabase containers'
complete -c supabase -n __fish_use_subcommand -f -a unlink -d 'Unlink a Supabase project'
complete -c supabase -n __fish_use_subcommand -f -a vanity-subdomains -d 'Manage vanity subdomains'
complete -c supabase -n '__fish_seen_subcommand_from backups; and not __fish_seen_subcommand_from list restore' -f
complete -c supabase -n '__fish_seen_subcommand_from backups; and not __fish_seen_subcommand_from list restore' -f -a list -d 'Lists available physical backups'
complete -c supabase -n '__fish_seen_subcommand_from backups; and not __fish_seen_subcommand_from list restore' -f -a restore -d 'Restore to a specific timestamp using PITR'
complete -c supabase -n '__fish_seen_subcommand_from list' -f
complete -c supabase -n '__fish_seen_subcommand_from list' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from list; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from restore' -f
complete -c supabase -n '__fish_seen_subcommand_from restore' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from restore' -l timestamp -s t -d 'The recovery time target in seconds since epoch.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from restore; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from restore; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s t timestamp' -f -a --timestamp -d 'The recovery time target in seconds since epoch.'
complete -c supabase -n '__fish_seen_subcommand_from bootstrap' -f
complete -c supabase -n '__fish_seen_subcommand_from bootstrap' -l password -s p -d 'Password to your remote Postgres database.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bootstrap; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s p password' -f -a --password -d 'Password to your remote Postgres database.'
complete -c supabase -n '__fish_seen_subcommand_from branches; and not __fish_seen_subcommand_from list create get update pause unpause delete' -f
complete -c supabase -n '__fish_seen_subcommand_from branches; and not __fish_seen_subcommand_from list create get update pause unpause delete' -f -a list -d 'List all preview branches'
complete -c supabase -n '__fish_seen_subcommand_from branches; and not __fish_seen_subcommand_from list create get update pause unpause delete' -f -a create -d 'Create a preview branch'
complete -c supabase -n '__fish_seen_subcommand_from branches; and not __fish_seen_subcommand_from list create get update pause unpause delete' -f -a get -d 'Retrieve details of a preview branch'
complete -c supabase -n '__fish_seen_subcommand_from branches; and not __fish_seen_subcommand_from list create get update pause unpause delete' -f -a update -d 'Update a preview branch'
complete -c supabase -n '__fish_seen_subcommand_from branches; and not __fish_seen_subcommand_from list create get update pause unpause delete' -f -a pause -d 'Pause a preview branch'
complete -c supabase -n '__fish_seen_subcommand_from branches; and not __fish_seen_subcommand_from list create get update pause unpause delete' -f -a unpause -d 'Unpause a preview branch'
complete -c supabase -n '__fish_seen_subcommand_from branches; and not __fish_seen_subcommand_from list create get update pause unpause delete' -f -a delete -d 'Delete a preview branch'
complete -c supabase -n '__fish_seen_subcommand_from list' -f
complete -c supabase -n '__fish_seen_subcommand_from list' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from list; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from create' -f
complete -c supabase -n '__fish_seen_subcommand_from create' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from create' -l region -d 'Select a region to deploy the branch database.' -r -f -a 'ap-east-1 ap-northeast-1 ap-northeast-2 ap-south-1 ap-southeast-1 ap-southeast-2 ca-central-1 eu-central-1 eu-central-2 eu-north-1 eu-west-1 eu-west-2 eu-west-3 sa-east-1 us-east-1 us-east-2 us-west-1 us-west-2'
complete -c supabase -n '__fish_seen_subcommand_from create' -l size -d 'Select a desired instance size for the branch database.' -r -f -a 'large medium micro 12xlarge 16xlarge 24xlarge 24xlarge_high_memory 24xlarge_optimized_cpu 24xlarge_optimized_memory 2xlarge 48xlarge 48xlarge_high_memory 48xlarge_optimized_cpu 48xlarge_optimized_memory 4xlarge 8xlarge nano small xlarge'
complete -c supabase -n '__fish_seen_subcommand_from create; and not __fish_contains_opt persistent no-persistent' -l persistent -d 'Whether to create a persistent branch.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not __fish_contains_opt persistent no-persistent' -l no-persistent -d 'Disable persistent'
complete -c supabase -n '__fish_seen_subcommand_from create; and not __fish_contains_opt with-data no-with-data' -l with-data -d 'Whether to clone production data to the branch database.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not __fish_contains_opt with-data no-with-data' -l no-with-data -d 'Disable with-data'
complete -c supabase -n '__fish_seen_subcommand_from create' -l notify-url -d 'URL to notify when branch is active healthy.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from create' -l git-branch -d 'Associate a git branch with the new preview branch.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt region' -f -a --region -d 'Select a region to deploy the branch database.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt size' -f -a --size -d 'Select a desired instance size for the branch database.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt persistent no-persistent' -f -a --persistent -d 'Whether to create a persistent branch.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt persistent no-persistent' -f -a --no-persistent -d 'Disable persistent'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt with-data no-with-data' -f -a --with-data -d 'Whether to clone production data to the branch database.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt with-data no-with-data' -f -a --no-with-data -d 'Disable with-data'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt notify-url' -f -a --notify-url -d 'URL to notify when branch is active healthy.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt git-branch' -f -a --git-branch -d 'Associate a git branch with the new preview branch.'
complete -c supabase -n '__fish_seen_subcommand_from get' -f
complete -c supabase -n '__fish_seen_subcommand_from get' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from get; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from update' -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l name -d 'Rename the preview branch.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l git-branch -d 'Change the associated git branch.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt persistent no-persistent' -l persistent -d 'Switch between ephemeral and persistent branch.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt persistent no-persistent' -l no-persistent -d 'Disable persistent'
complete -c supabase -n '__fish_seen_subcommand_from update' -l status -d 'Override the current branch status.' -r -f -a 'RUNNING_MIGRATIONS MIGRATIONS_PASSED MIGRATIONS_FAILED FUNCTIONS_DEPLOYED FUNCTIONS_FAILED'
complete -c supabase -n '__fish_seen_subcommand_from update' -l notify-url -d 'URL to notify when branch is active healthy.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt name' -f -a --name -d 'Rename the preview branch.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt git-branch' -f -a --git-branch -d 'Change the associated git branch.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt persistent no-persistent' -f -a --persistent -d 'Switch between ephemeral and persistent branch.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt persistent no-persistent' -f -a --no-persistent -d 'Disable persistent'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt status' -f -a --status -d 'Override the current branch status.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt notify-url' -f -a --notify-url -d 'URL to notify when branch is active healthy.'
complete -c supabase -n '__fish_seen_subcommand_from pause' -f
complete -c supabase -n '__fish_seen_subcommand_from pause' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from pause; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from unpause' -f
complete -c supabase -n '__fish_seen_subcommand_from unpause' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from unpause; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from delete' -f
complete -c supabase -n '__fish_seen_subcommand_from delete' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from delete; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from completion; and not __fish_seen_subcommand_from bash fish powershell zsh' -f
complete -c supabase -n '__fish_seen_subcommand_from completion; and not __fish_seen_subcommand_from bash fish powershell zsh' -f -a bash -d 'Generate the autocompletion script for bash'
complete -c supabase -n '__fish_seen_subcommand_from completion; and not __fish_seen_subcommand_from bash fish powershell zsh' -f -a fish -d 'Generate the autocompletion script for fish'
complete -c supabase -n '__fish_seen_subcommand_from completion; and not __fish_seen_subcommand_from bash fish powershell zsh' -f -a powershell -d 'Generate the autocompletion script for powershell'
complete -c supabase -n '__fish_seen_subcommand_from completion; and not __fish_seen_subcommand_from bash fish powershell zsh' -f -a zsh -d 'Generate the autocompletion script for zsh'
complete -c supabase -n '__fish_seen_subcommand_from bash' -f
complete -c supabase -n '__fish_seen_subcommand_from fish' -f
complete -c supabase -n '__fish_seen_subcommand_from powershell' -f
complete -c supabase -n '__fish_seen_subcommand_from zsh' -f
complete -c supabase -n '__fish_seen_subcommand_from config; and not __fish_seen_subcommand_from push' -f
complete -c supabase -n '__fish_seen_subcommand_from config; and not __fish_seen_subcommand_from push' -f -a push -d 'Push local config to linked project'
complete -c supabase -n '__fish_seen_subcommand_from push' -f
complete -c supabase -n '__fish_seen_subcommand_from push' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from diff dump push pull reset lint start query advisors schema' -f
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from diff dump push pull reset lint start query advisors schema' -f -a diff -d 'Diffs the local database for schema changes'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from diff dump push pull reset lint start query advisors schema' -f -a dump -d 'Dumps data or schemas from the remote database'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from diff dump push pull reset lint start query advisors schema' -f -a push -d 'Push new migrations to the remote database'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from diff dump push pull reset lint start query advisors schema' -f -a pull -d 'Pull schema from the remote database'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from diff dump push pull reset lint start query advisors schema' -f -a reset -d 'Resets the local database to current migrations'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from diff dump push pull reset lint start query advisors schema' -f -a lint -d 'Checks local database for typing error'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from diff dump push pull reset lint start query advisors schema' -f -a start -d 'Starts local Postgres database'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from diff dump push pull reset lint start query advisors schema' -f -a query -d 'Execute a SQL query against the database'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from diff dump push pull reset lint start query advisors schema' -f -a advisors -d 'Checks database for security and performance issues'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from diff dump push pull reset lint start query advisors schema' -f -a schema -d 'Manage database schema'
complete -c supabase -n '__fish_seen_subcommand_from diff' -f
complete -c supabase -n '__fish_seen_subcommand_from diff; and not __fish_contains_opt use-migra no-use-migra' -l use-migra -d 'Use migra to generate schema diff.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not __fish_contains_opt use-migra no-use-migra' -l no-use-migra -d 'Disable use-migra'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not __fish_contains_opt use-pgadmin no-use-pgadmin' -l use-pgadmin -d 'Use pgAdmin to generate schema diff.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not __fish_contains_opt use-pgadmin no-use-pgadmin' -l no-use-pgadmin -d 'Disable use-pgadmin'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not __fish_contains_opt use-pg-schema no-use-pg-schema' -l use-pg-schema -d 'Use pg-schema-diff to generate schema diff.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not __fish_contains_opt use-pg-schema no-use-pg-schema' -l no-use-pg-schema -d 'Disable use-pg-schema'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not __fish_contains_opt use-pg-delta no-use-pg-delta' -l use-pg-delta -d 'Use pg-delta to generate schema diff.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not __fish_contains_opt use-pg-delta no-use-pg-delta' -l no-use-pg-delta -d 'Disable use-pg-delta'
complete -c supabase -n '__fish_seen_subcommand_from diff' -l from -d 'Diff from local, linked, migrations, or a Postgres URL.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from diff' -l to -d 'Diff to local, linked, migrations, or a Postgres URL.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from diff' -l output -s o -d 'Write explicit diff output to a file path.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from diff' -l db-url -d 'Diffs against the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from diff; and not __fish_contains_opt linked no-linked' -l linked -d 'Diffs local migration files against the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not __fish_contains_opt local no-local' -l local -d 'Diffs local migration files against the local database.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from diff' -l file -s f -d 'Saves schema diff to a new migration file.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from diff' -l schema -s s -d 'Comma separated list of schema to include.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-migra no-use-migra' -f -a --use-migra -d 'Use migra to generate schema diff.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-migra no-use-migra' -f -a --no-use-migra -d 'Disable use-migra'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-pgadmin no-use-pgadmin' -f -a --use-pgadmin -d 'Use pgAdmin to generate schema diff.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-pgadmin no-use-pgadmin' -f -a --no-use-pgadmin -d 'Disable use-pgadmin'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-pg-schema no-use-pg-schema' -f -a --use-pg-schema -d 'Use pg-schema-diff to generate schema diff.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-pg-schema no-use-pg-schema' -f -a --no-use-pg-schema -d 'Disable use-pg-schema'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-pg-delta no-use-pg-delta' -f -a --use-pg-delta -d 'Use pg-delta to generate schema diff.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-pg-delta no-use-pg-delta' -f -a --no-use-pg-delta -d 'Disable use-pg-delta'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt from' -f -a --from -d 'Diff from local, linked, migrations, or a Postgres URL.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt to' -f -a --to -d 'Diff to local, linked, migrations, or a Postgres URL.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s o output' -f -a --output -d 'Write explicit diff output to a file path.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Diffs against the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Diffs local migration files against the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Diffs local migration files against the local database.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s f file' -f -a --file -d 'Saves schema diff to a new migration file.'
complete -c supabase -n '__fish_seen_subcommand_from diff; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s s schema' -f -a --schema -d 'Comma separated list of schema to include.'
complete -c supabase -n '__fish_seen_subcommand_from dump' -f
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt dry-run no-dry-run' -l dry-run -d 'Prints the pg_dump script that would be executed.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt dry-run no-dry-run' -l no-dry-run -d 'Disable dry-run'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt data-only no-data-only' -l data-only -d 'Dumps only data records.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt data-only no-data-only' -l no-data-only -d 'Disable data-only'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt use-copy no-use-copy' -l use-copy -d 'Use copy statements in place of inserts.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt use-copy no-use-copy' -l no-use-copy -d 'Disable use-copy'
complete -c supabase -n '__fish_seen_subcommand_from dump' -l exclude -s x -d 'List of schema.tables to exclude from data-only dump.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt role-only no-role-only' -l role-only -d 'Dumps only cluster roles.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt role-only no-role-only' -l no-role-only -d 'Disable role-only'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt keep-comments no-keep-comments' -l keep-comments -d 'Keeps commented lines from pg_dump output.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt keep-comments no-keep-comments' -l no-keep-comments -d 'Disable keep-comments'
complete -c supabase -n '__fish_seen_subcommand_from dump' -l file -s f -d 'File path to save the dumped contents.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from dump' -l db-url -d 'Dumps from the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt linked no-linked' -l linked -d 'Dumps from the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt local no-local' -l local -d 'Dumps from the local database.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from dump' -l password -s p -d 'Password to your remote Postgres database.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from dump' -l schema -s s -d 'Comma separated list of schema to include.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt dry-run no-dry-run' -f -a --dry-run -d 'Prints the pg_dump script that would be executed.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt dry-run no-dry-run' -f -a --no-dry-run -d 'Disable dry-run'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt data-only no-data-only' -f -a --data-only -d 'Dumps only data records.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt data-only no-data-only' -f -a --no-data-only -d 'Disable data-only'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-copy no-use-copy' -f -a --use-copy -d 'Use copy statements in place of inserts.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-copy no-use-copy' -f -a --no-use-copy -d 'Disable use-copy'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s x exclude' -f -a --exclude -d 'List of schema.tables to exclude from data-only dump.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt role-only no-role-only' -f -a --role-only -d 'Dumps only cluster roles.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt role-only no-role-only' -f -a --no-role-only -d 'Disable role-only'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt keep-comments no-keep-comments' -f -a --keep-comments -d 'Keeps commented lines from pg_dump output.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt keep-comments no-keep-comments' -f -a --no-keep-comments -d 'Disable keep-comments'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s f file' -f -a --file -d 'File path to save the dumped contents.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Dumps from the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Dumps from the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Dumps from the local database.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s p password' -f -a --password -d 'Password to your remote Postgres database.'
complete -c supabase -n '__fish_seen_subcommand_from dump; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s s schema' -f -a --schema -d 'Comma separated list of schema to include.'
complete -c supabase -n '__fish_seen_subcommand_from push' -f
complete -c supabase -n '__fish_seen_subcommand_from push; and not __fish_contains_opt include-all no-include-all' -l include-all -d 'Include all migrations not found on remote history table.'
complete -c supabase -n '__fish_seen_subcommand_from push; and not __fish_contains_opt include-all no-include-all' -l no-include-all -d 'Disable include-all'
complete -c supabase -n '__fish_seen_subcommand_from push; and not __fish_contains_opt include-roles no-include-roles' -l include-roles -d 'Include custom roles from supabase/roles.sql.'
complete -c supabase -n '__fish_seen_subcommand_from push; and not __fish_contains_opt include-roles no-include-roles' -l no-include-roles -d 'Disable include-roles'
complete -c supabase -n '__fish_seen_subcommand_from push; and not __fish_contains_opt include-seed no-include-seed' -l include-seed -d 'Include seed data from your config.'
complete -c supabase -n '__fish_seen_subcommand_from push; and not __fish_contains_opt include-seed no-include-seed' -l no-include-seed -d 'Disable include-seed'
complete -c supabase -n '__fish_seen_subcommand_from push; and not __fish_contains_opt dry-run no-dry-run' -l dry-run -d 'Print the migrations that would be applied, but don\'t actually apply them.'
complete -c supabase -n '__fish_seen_subcommand_from push; and not __fish_contains_opt dry-run no-dry-run' -l no-dry-run -d 'Disable dry-run'
complete -c supabase -n '__fish_seen_subcommand_from push' -l db-url -d 'Pushes to the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from push; and not __fish_contains_opt linked no-linked' -l linked -d 'Pushes to the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from push; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from push; and not __fish_contains_opt local no-local' -l local -d 'Pushes to the local database.'
complete -c supabase -n '__fish_seen_subcommand_from push; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from push' -l password -s p -d 'Password to your remote Postgres database.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-all no-include-all' -f -a --include-all -d 'Include all migrations not found on remote history table.'
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-all no-include-all' -f -a --no-include-all -d 'Disable include-all'
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-roles no-include-roles' -f -a --include-roles -d 'Include custom roles from supabase/roles.sql.'
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-roles no-include-roles' -f -a --no-include-roles -d 'Disable include-roles'
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-seed no-include-seed' -f -a --include-seed -d 'Include seed data from your config.'
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-seed no-include-seed' -f -a --no-include-seed -d 'Disable include-seed'
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt dry-run no-dry-run' -f -a --dry-run -d 'Print the migrations that would be applied, but don\'t actually apply them.'
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt dry-run no-dry-run' -f -a --no-dry-run -d 'Disable dry-run'
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Pushes to the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Pushes to the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Pushes to the local database.'
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from push; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s p password' -f -a --password -d 'Password to your remote Postgres database.'
complete -c supabase -n '__fish_seen_subcommand_from pull' -f
complete -c supabase -n '__fish_seen_subcommand_from pull; and not __fish_contains_opt declarative no-declarative' -l declarative -d 'Pull schema as declarative files using pg-delta instead of creating a migration.'
complete -c supabase -n '__fish_seen_subcommand_from pull; and not __fish_contains_opt declarative no-declarative' -l no-declarative -d 'Disable declarative'
complete -c supabase -n '__fish_seen_subcommand_from pull' -l diff-engine -d 'Diff engine to use for migration-style db pull.' -r -f -a 'migra pg-delta'
complete -c supabase -n '__fish_seen_subcommand_from pull' -l schema -s s -d 'Comma separated list of schema to include.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from pull' -l db-url -d 'Pulls from the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from pull; and not __fish_contains_opt linked no-linked' -l linked -d 'Pulls from the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from pull; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from pull; and not __fish_contains_opt local no-local' -l local -d 'Pulls from the local database.'
complete -c supabase -n '__fish_seen_subcommand_from pull; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from pull' -l password -s p -d 'Password to your remote Postgres database.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from pull; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt declarative no-declarative' -f -a --declarative -d 'Pull schema as declarative files using pg-delta instead of creating a migration.'
complete -c supabase -n '__fish_seen_subcommand_from pull; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt declarative no-declarative' -f -a --no-declarative -d 'Disable declarative'
complete -c supabase -n '__fish_seen_subcommand_from pull; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt diff-engine' -f -a --diff-engine -d 'Diff engine to use for migration-style db pull.'
complete -c supabase -n '__fish_seen_subcommand_from pull; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s s schema' -f -a --schema -d 'Comma separated list of schema to include.'
complete -c supabase -n '__fish_seen_subcommand_from pull; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Pulls from the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from pull; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Pulls from the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from pull; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from pull; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Pulls from the local database.'
complete -c supabase -n '__fish_seen_subcommand_from pull; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from pull; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s p password' -f -a --password -d 'Password to your remote Postgres database.'
complete -c supabase -n '__fish_seen_subcommand_from reset' -f
complete -c supabase -n '__fish_seen_subcommand_from reset' -l db-url -d 'Resets the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from reset; and not __fish_contains_opt linked no-linked' -l linked -d 'Resets the linked project with local migrations.'
complete -c supabase -n '__fish_seen_subcommand_from reset; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from reset; and not __fish_contains_opt local no-local' -l local -d 'Resets the local database with local migrations.'
complete -c supabase -n '__fish_seen_subcommand_from reset; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from reset; and not __fish_contains_opt no-seed no-no-seed' -l no-seed -d 'Skip running the seed script after reset.'
complete -c supabase -n '__fish_seen_subcommand_from reset; and not __fish_contains_opt no-seed no-no-seed' -l no-no-seed -d 'Disable no-seed'
complete -c supabase -n '__fish_seen_subcommand_from reset' -l version -d 'Reset up to the specified version.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from reset' -l last -d 'Reset up to the last n migration versions.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from reset; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Resets the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from reset; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Resets the linked project with local migrations.'
complete -c supabase -n '__fish_seen_subcommand_from reset; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from reset; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Resets the local database with local migrations.'
complete -c supabase -n '__fish_seen_subcommand_from reset; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from reset; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-seed no-no-seed' -f -a --no-seed -d 'Skip running the seed script after reset.'
complete -c supabase -n '__fish_seen_subcommand_from reset; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-seed no-no-seed' -f -a --no-no-seed -d 'Disable no-seed'
complete -c supabase -n '__fish_seen_subcommand_from reset; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt version' -f -a --version -d 'Reset up to the specified version.'
complete -c supabase -n '__fish_seen_subcommand_from reset; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt last' -f -a --last -d 'Reset up to the last n migration versions.'
complete -c supabase -n '__fish_seen_subcommand_from lint' -f
complete -c supabase -n '__fish_seen_subcommand_from lint' -l db-url -d 'Lints the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from lint; and not __fish_contains_opt linked no-linked' -l linked -d 'Lints the linked project for schema errors.'
complete -c supabase -n '__fish_seen_subcommand_from lint; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from lint; and not __fish_contains_opt local no-local' -l local -d 'Lints the local database for schema errors.'
complete -c supabase -n '__fish_seen_subcommand_from lint; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from lint' -l schema -s s -d 'Comma separated list of schema to include.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from lint' -l level -d 'Error level to emit.' -r -f -a 'warning error'
complete -c supabase -n '__fish_seen_subcommand_from lint' -l fail-on -d 'Error level to exit with non-zero status.' -r -f -a 'none warning error'
complete -c supabase -n '__fish_seen_subcommand_from lint; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Lints the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from lint; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Lints the linked project for schema errors.'
complete -c supabase -n '__fish_seen_subcommand_from lint; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from lint; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Lints the local database for schema errors.'
complete -c supabase -n '__fish_seen_subcommand_from lint; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from lint; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s s schema' -f -a --schema -d 'Comma separated list of schema to include.'
complete -c supabase -n '__fish_seen_subcommand_from lint; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt level' -f -a --level -d 'Error level to emit.'
complete -c supabase -n '__fish_seen_subcommand_from lint; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt fail-on' -f -a --fail-on -d 'Error level to exit with non-zero status.'
complete -c supabase -n '__fish_seen_subcommand_from start' -f
complete -c supabase -n '__fish_seen_subcommand_from start' -l from-backup -d 'Path to a logical backup file.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from start; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt from-backup' -f -a --from-backup -d 'Path to a logical backup file.'
complete -c supabase -n '__fish_seen_subcommand_from query' -f
complete -c supabase -n '__fish_seen_subcommand_from query' -l db-url -d 'Queries the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from query; and not __fish_contains_opt linked no-linked' -l linked -d 'Queries the linked project\'s database via Management API.'
complete -c supabase -n '__fish_seen_subcommand_from query; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from query; and not __fish_contains_opt local no-local' -l local -d 'Queries the local database.'
complete -c supabase -n '__fish_seen_subcommand_from query; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from query' -l file -s f -d 'Path to a SQL file to execute.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from query; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Queries the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from query; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Queries the linked project\'s database via Management API.'
complete -c supabase -n '__fish_seen_subcommand_from query; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from query; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Queries the local database.'
complete -c supabase -n '__fish_seen_subcommand_from query; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from query; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s f file' -f -a --file -d 'Path to a SQL file to execute.'
complete -c supabase -n '__fish_seen_subcommand_from advisors' -f
complete -c supabase -n '__fish_seen_subcommand_from advisors' -l db-url -d 'Checks the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from advisors; and not __fish_contains_opt linked no-linked' -l linked -d 'Checks the linked project for issues.'
complete -c supabase -n '__fish_seen_subcommand_from advisors; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from advisors; and not __fish_contains_opt local no-local' -l local -d 'Checks the local database for issues.'
complete -c supabase -n '__fish_seen_subcommand_from advisors; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from advisors' -l type -d 'Type of advisors to check: all, security, performance.' -r -f -a 'all security performance'
complete -c supabase -n '__fish_seen_subcommand_from advisors' -l level -d 'Minimum issue level to display: info, warn, error.' -r -f -a 'info warn error'
complete -c supabase -n '__fish_seen_subcommand_from advisors' -l fail-on -d 'Issue level to exit with non-zero status: none, info, warn, error.' -r -f -a 'none info warn error'
complete -c supabase -n '__fish_seen_subcommand_from advisors; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Checks the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from advisors; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Checks the linked project for issues.'
complete -c supabase -n '__fish_seen_subcommand_from advisors; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from advisors; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Checks the local database for issues.'
complete -c supabase -n '__fish_seen_subcommand_from advisors; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from advisors; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt type' -f -a --type -d 'Type of advisors to check: all, security, performance.'
complete -c supabase -n '__fish_seen_subcommand_from advisors; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt level' -f -a --level -d 'Minimum issue level to display: info, warn, error.'
complete -c supabase -n '__fish_seen_subcommand_from advisors; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt fail-on' -f -a --fail-on -d 'Issue level to exit with non-zero status: none, info, warn, error.'
complete -c supabase -n '__fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from declarative' -f
complete -c supabase -n '__fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from declarative' -f -a declarative -d 'Manage declarative database schemas'
complete -c supabase -n '__fish_seen_subcommand_from declarative; and not __fish_seen_subcommand_from sync generate' -f
complete -c supabase -n '__fish_seen_subcommand_from declarative; and not __fish_seen_subcommand_from sync generate' -f -a sync -d 'Generate a new migration from declarative schema'
complete -c supabase -n '__fish_seen_subcommand_from declarative; and not __fish_seen_subcommand_from sync generate' -f -a generate -d 'Generate declarative schema from a database'
complete -c supabase -n '__fish_seen_subcommand_from declarative; and not __fish_seen_subcommand_from sync generate; and not __fish_contains_opt no-cache no-no-cache' -l no-cache -d 'Disable catalog cache and force fresh shadow database setup.'
complete -c supabase -n '__fish_seen_subcommand_from declarative; and not __fish_seen_subcommand_from sync generate; and not __fish_contains_opt no-cache no-no-cache' -l no-no-cache -d 'Disable no-cache'
complete -c supabase -n '__fish_seen_subcommand_from declarative; and not __fish_seen_subcommand_from sync generate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-cache no-no-cache' -f -a --no-cache -d 'Disable catalog cache and force fresh shadow database setup.'
complete -c supabase -n '__fish_seen_subcommand_from declarative; and not __fish_seen_subcommand_from sync generate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-cache no-no-cache' -f -a --no-no-cache -d 'Disable no-cache'
complete -c supabase -n '__fish_seen_subcommand_from sync' -f
complete -c supabase -n '__fish_seen_subcommand_from sync' -l schema -s s -d 'Comma separated list of schema to include.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from sync' -l file -s f -d 'Saves schema diff to a new migration file.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from sync' -l name -d 'Name for the generated migration file.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from sync; and not __fish_contains_opt apply no-apply' -l apply -d 'Apply the generated migration to the local database without prompting.'
complete -c supabase -n '__fish_seen_subcommand_from sync; and not __fish_contains_opt apply no-apply' -l no-apply -d 'Disable apply'
complete -c supabase -n '__fish_seen_subcommand_from sync; and not __fish_contains_opt no-apply no-no-apply' -l no-apply -d 'Generate the migration file without prompting or applying it to the local database.'
complete -c supabase -n '__fish_seen_subcommand_from sync; and not __fish_contains_opt no-apply no-no-apply' -l no-no-apply -d 'Disable no-apply'
complete -c supabase -n '__fish_seen_subcommand_from sync; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s s schema' -f -a --schema -d 'Comma separated list of schema to include.'
complete -c supabase -n '__fish_seen_subcommand_from sync; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s f file' -f -a --file -d 'Saves schema diff to a new migration file.'
complete -c supabase -n '__fish_seen_subcommand_from sync; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt name' -f -a --name -d 'Name for the generated migration file.'
complete -c supabase -n '__fish_seen_subcommand_from sync; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt apply no-apply' -f -a --apply -d 'Apply the generated migration to the local database without prompting.'
complete -c supabase -n '__fish_seen_subcommand_from sync; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt apply no-apply' -f -a --no-apply -d 'Disable apply'
complete -c supabase -n '__fish_seen_subcommand_from sync; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-apply no-no-apply' -f -a --no-apply -d 'Generate the migration file without prompting or applying it to the local database.'
complete -c supabase -n '__fish_seen_subcommand_from sync; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-apply no-no-apply' -f -a --no-no-apply -d 'Disable no-apply'
complete -c supabase -n '__fish_seen_subcommand_from generate' -f
complete -c supabase -n '__fish_seen_subcommand_from generate; and not __fish_contains_opt overwrite no-overwrite' -l overwrite -d 'Overwrite declarative schema files without confirmation.'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not __fish_contains_opt overwrite no-overwrite' -l no-overwrite -d 'Disable overwrite'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not __fish_contains_opt reset no-reset' -l reset -d 'Reset local database before generating (local data will be lost).'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not __fish_contains_opt reset no-reset' -l no-reset -d 'Disable reset'
complete -c supabase -n '__fish_seen_subcommand_from generate' -l schema -s s -d 'Comma separated list of schema to include.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from generate' -l db-url -d 'Generates declarative schema from the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from generate; and not __fish_contains_opt linked no-linked' -l linked -d 'Generates declarative schema from the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not __fish_contains_opt local no-local' -l local -d 'Generates declarative schema from the local database.'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from generate' -l password -s p -d 'Password to your remote Postgres database.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from generate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt overwrite no-overwrite' -f -a --overwrite -d 'Overwrite declarative schema files without confirmation.'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt overwrite no-overwrite' -f -a --no-overwrite -d 'Disable overwrite'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt reset no-reset' -f -a --reset -d 'Reset local database before generating (local data will be lost).'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt reset no-reset' -f -a --no-reset -d 'Disable reset'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s s schema' -f -a --schema -d 'Comma separated list of schema to include.'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Generates declarative schema from the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Generates declarative schema from the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Generates declarative schema from the local database.'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from generate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s p password' -f -a --password -d 'Password to your remote Postgres database.'
complete -c supabase -n '__fish_seen_subcommand_from domains; and not __fish_seen_subcommand_from create get reverify activate delete' -f
complete -c supabase -n '__fish_seen_subcommand_from domains; and not __fish_seen_subcommand_from create get reverify activate delete' -f -a create -d 'Create a custom hostname'
complete -c supabase -n '__fish_seen_subcommand_from domains; and not __fish_seen_subcommand_from create get reverify activate delete' -f -a get -d 'Get the current custom hostname config'
complete -c supabase -n '__fish_seen_subcommand_from domains; and not __fish_seen_subcommand_from create get reverify activate delete' -f -a reverify -d 'Re-verify the custom hostname config'
complete -c supabase -n '__fish_seen_subcommand_from domains; and not __fish_seen_subcommand_from create get reverify activate delete' -f -a activate -d 'Activate the custom hostname for a project'
complete -c supabase -n '__fish_seen_subcommand_from domains; and not __fish_seen_subcommand_from create get reverify activate delete' -f -a delete -d 'Delete the custom hostname config'
complete -c supabase -n '__fish_seen_subcommand_from create' -f
complete -c supabase -n '__fish_seen_subcommand_from create' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from create' -l custom-hostname -d 'The custom hostname to use for your Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from create; and not __fish_contains_opt include-raw-output no-include-raw-output' -l include-raw-output -d '(Deprecated) use -o json instead.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not __fish_contains_opt include-raw-output no-include-raw-output' -l no-include-raw-output -d 'Disable include-raw-output'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt custom-hostname' -f -a --custom-hostname -d 'The custom hostname to use for your Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-raw-output no-include-raw-output' -f -a --include-raw-output -d '(Deprecated) use -o json instead.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-raw-output no-include-raw-output' -f -a --no-include-raw-output -d 'Disable include-raw-output'
complete -c supabase -n '__fish_seen_subcommand_from get' -f
complete -c supabase -n '__fish_seen_subcommand_from get' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from get; and not __fish_contains_opt include-raw-output no-include-raw-output' -l include-raw-output -d '(Deprecated) use -o json instead.'
complete -c supabase -n '__fish_seen_subcommand_from get; and not __fish_contains_opt include-raw-output no-include-raw-output' -l no-include-raw-output -d 'Disable include-raw-output'
complete -c supabase -n '__fish_seen_subcommand_from get; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from get; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-raw-output no-include-raw-output' -f -a --include-raw-output -d '(Deprecated) use -o json instead.'
complete -c supabase -n '__fish_seen_subcommand_from get; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-raw-output no-include-raw-output' -f -a --no-include-raw-output -d 'Disable include-raw-output'
complete -c supabase -n '__fish_seen_subcommand_from reverify' -f
complete -c supabase -n '__fish_seen_subcommand_from reverify' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from reverify; and not __fish_contains_opt include-raw-output no-include-raw-output' -l include-raw-output -d '(Deprecated) use -o json instead.'
complete -c supabase -n '__fish_seen_subcommand_from reverify; and not __fish_contains_opt include-raw-output no-include-raw-output' -l no-include-raw-output -d 'Disable include-raw-output'
complete -c supabase -n '__fish_seen_subcommand_from reverify; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from reverify; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-raw-output no-include-raw-output' -f -a --include-raw-output -d '(Deprecated) use -o json instead.'
complete -c supabase -n '__fish_seen_subcommand_from reverify; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-raw-output no-include-raw-output' -f -a --no-include-raw-output -d 'Disable include-raw-output'
complete -c supabase -n '__fish_seen_subcommand_from activate' -f
complete -c supabase -n '__fish_seen_subcommand_from activate' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from activate; and not __fish_contains_opt include-raw-output no-include-raw-output' -l include-raw-output -d '(Deprecated) use -o json instead.'
complete -c supabase -n '__fish_seen_subcommand_from activate; and not __fish_contains_opt include-raw-output no-include-raw-output' -l no-include-raw-output -d 'Disable include-raw-output'
complete -c supabase -n '__fish_seen_subcommand_from activate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from activate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-raw-output no-include-raw-output' -f -a --include-raw-output -d '(Deprecated) use -o json instead.'
complete -c supabase -n '__fish_seen_subcommand_from activate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-raw-output no-include-raw-output' -f -a --no-include-raw-output -d 'Disable include-raw-output'
complete -c supabase -n '__fish_seen_subcommand_from delete' -f
complete -c supabase -n '__fish_seen_subcommand_from delete' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from delete; and not __fish_contains_opt include-raw-output no-include-raw-output' -l include-raw-output -d '(Deprecated) use -o json instead.'
complete -c supabase -n '__fish_seen_subcommand_from delete; and not __fish_contains_opt include-raw-output no-include-raw-output' -l no-include-raw-output -d 'Disable include-raw-output'
complete -c supabase -n '__fish_seen_subcommand_from delete; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from delete; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-raw-output no-include-raw-output' -f -a --include-raw-output -d '(Deprecated) use -o json instead.'
complete -c supabase -n '__fish_seen_subcommand_from delete; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-raw-output no-include-raw-output' -f -a --no-include-raw-output -d 'Disable include-raw-output'
complete -c supabase -n '__fish_seen_subcommand_from encryption; and not __fish_seen_subcommand_from get-root-key update-root-key' -f
complete -c supabase -n '__fish_seen_subcommand_from encryption; and not __fish_seen_subcommand_from get-root-key update-root-key' -f -a get-root-key -d 'Get root encryption key'
complete -c supabase -n '__fish_seen_subcommand_from encryption; and not __fish_seen_subcommand_from get-root-key update-root-key' -f -a update-root-key -d 'Update the root encryption key'
complete -c supabase -n '__fish_seen_subcommand_from get-root-key' -f
complete -c supabase -n '__fish_seen_subcommand_from get-root-key' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from get-root-key; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from update-root-key' -f
complete -c supabase -n '__fish_seen_subcommand_from update-root-key' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update-root-key; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from functions; and not __fish_seen_subcommand_from list delete download deploy new serve' -f
complete -c supabase -n '__fish_seen_subcommand_from functions; and not __fish_seen_subcommand_from list delete download deploy new serve' -f -a list -d 'List all Functions in Supabase'
complete -c supabase -n '__fish_seen_subcommand_from functions; and not __fish_seen_subcommand_from list delete download deploy new serve' -f -a delete -d 'Delete a Function from Supabase'
complete -c supabase -n '__fish_seen_subcommand_from functions; and not __fish_seen_subcommand_from list delete download deploy new serve' -f -a download -d 'Download a Function from Supabase'
complete -c supabase -n '__fish_seen_subcommand_from functions; and not __fish_seen_subcommand_from list delete download deploy new serve' -f -a deploy -d 'Deploy a Function to Supabase'
complete -c supabase -n '__fish_seen_subcommand_from functions; and not __fish_seen_subcommand_from list delete download deploy new serve' -f -a new -d 'Create a new Function locally'
complete -c supabase -n '__fish_seen_subcommand_from functions; and not __fish_seen_subcommand_from list delete download deploy new serve' -f -a serve -d 'Serve all Functions locally'
complete -c supabase -n '__fish_seen_subcommand_from list' -f
complete -c supabase -n '__fish_seen_subcommand_from list' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from list; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from delete' -f
complete -c supabase -n '__fish_seen_subcommand_from delete' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from delete; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from download' -f
complete -c supabase -n '__fish_seen_subcommand_from download' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from download; and not __fish_contains_opt use-api no-use-api' -l use-api -d 'Unbundle functions server-side without using Docker.'
complete -c supabase -n '__fish_seen_subcommand_from download; and not __fish_contains_opt use-api no-use-api' -l no-use-api -d 'Disable use-api'
complete -c supabase -n '__fish_seen_subcommand_from download; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from download; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-api no-use-api' -f -a --use-api -d 'Unbundle functions server-side without using Docker.'
complete -c supabase -n '__fish_seen_subcommand_from download; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-api no-use-api' -f -a --no-use-api -d 'Disable use-api'
complete -c supabase -n '__fish_seen_subcommand_from deploy' -f
complete -c supabase -n '__fish_seen_subcommand_from deploy' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not __fish_contains_opt no-verify-jwt no-no-verify-jwt' -l no-verify-jwt -d 'Disable JWT verification for the Function.'
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not __fish_contains_opt no-verify-jwt no-no-verify-jwt' -l no-no-verify-jwt -d 'Disable no-verify-jwt'
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not __fish_contains_opt use-api no-use-api' -l use-api -d 'Bundle functions server-side without using Docker.'
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not __fish_contains_opt use-api no-use-api' -l no-use-api -d 'Disable use-api'
complete -c supabase -n '__fish_seen_subcommand_from deploy' -l import-map -d 'Path to import map file.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not __fish_contains_opt prune no-prune' -l prune -d 'Delete Functions that exist in Supabase project but not locally.'
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not __fish_contains_opt prune no-prune' -l no-prune -d 'Disable prune'
complete -c supabase -n '__fish_seen_subcommand_from deploy' -l jobs -s j -d 'Maximum number of parallel jobs.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-verify-jwt no-no-verify-jwt' -f -a --no-verify-jwt -d 'Disable JWT verification for the Function.'
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-verify-jwt no-no-verify-jwt' -f -a --no-no-verify-jwt -d 'Disable no-verify-jwt'
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-api no-use-api' -f -a --use-api -d 'Bundle functions server-side without using Docker.'
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-api no-use-api' -f -a --no-use-api -d 'Disable use-api'
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt import-map' -f -a --import-map -d 'Path to import map file.'
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt prune no-prune' -f -a --prune -d 'Delete Functions that exist in Supabase project but not locally.'
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt prune no-prune' -f -a --no-prune -d 'Disable prune'
complete -c supabase -n '__fish_seen_subcommand_from deploy; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s j jobs' -f -a --jobs -d 'Maximum number of parallel jobs.'
complete -c supabase -n '__fish_seen_subcommand_from new' -f
complete -c supabase -n '__fish_seen_subcommand_from new' -l auth -d 'use a specific auth mode' -r -f -a 'none apikey user'
complete -c supabase -n '__fish_seen_subcommand_from new; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt auth' -f -a --auth -d 'use a specific auth mode'
complete -c supabase -n '__fish_seen_subcommand_from serve' -f
complete -c supabase -n '__fish_seen_subcommand_from serve; and not __fish_contains_opt no-verify-jwt no-no-verify-jwt' -l no-verify-jwt -d 'Disable JWT verification for the Function.'
complete -c supabase -n '__fish_seen_subcommand_from serve; and not __fish_contains_opt no-verify-jwt no-no-verify-jwt' -l no-no-verify-jwt -d 'Disable no-verify-jwt'
complete -c supabase -n '__fish_seen_subcommand_from serve' -l env-file -d 'Path to an env file to be populated to the Function environment.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from serve' -l import-map -d 'Path to import map file.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from serve; and not __fish_contains_opt inspect no-inspect' -l inspect -d 'Alias of --inspect-mode brk.'
complete -c supabase -n '__fish_seen_subcommand_from serve; and not __fish_contains_opt inspect no-inspect' -l no-inspect -d 'Disable inspect'
complete -c supabase -n '__fish_seen_subcommand_from serve' -l inspect-mode -d 'Activate inspector capability for debugging.' -r -f -a 'run brk wait'
complete -c supabase -n '__fish_seen_subcommand_from serve; and not __fish_contains_opt inspect-main no-inspect-main' -l inspect-main -d 'Allow inspecting the main worker.'
complete -c supabase -n '__fish_seen_subcommand_from serve; and not __fish_contains_opt inspect-main no-inspect-main' -l no-inspect-main -d 'Disable inspect-main'
complete -c supabase -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-verify-jwt no-no-verify-jwt' -f -a --no-verify-jwt -d 'Disable JWT verification for the Function.'
complete -c supabase -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-verify-jwt no-no-verify-jwt' -f -a --no-no-verify-jwt -d 'Disable no-verify-jwt'
complete -c supabase -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt env-file' -f -a --env-file -d 'Path to an env file to be populated to the Function environment.'
complete -c supabase -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt import-map' -f -a --import-map -d 'Path to import map file.'
complete -c supabase -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt inspect no-inspect' -f -a --inspect -d 'Alias of --inspect-mode brk.'
complete -c supabase -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt inspect no-inspect' -f -a --no-inspect -d 'Disable inspect'
complete -c supabase -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt inspect-mode' -f -a --inspect-mode -d 'Activate inspector capability for debugging.'
complete -c supabase -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt inspect-main no-inspect-main' -f -a --inspect-main -d 'Allow inspecting the main worker.'
complete -c supabase -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt inspect-main no-inspect-main' -f -a --no-inspect-main -d 'Disable inspect-main'
complete -c supabase -n '__fish_seen_subcommand_from gen; and not __fish_seen_subcommand_from types signing-key bearer-jwt keys' -f
complete -c supabase -n '__fish_seen_subcommand_from gen; and not __fish_seen_subcommand_from types signing-key bearer-jwt keys' -f -a types -d 'Generate types from Postgres schema'
complete -c supabase -n '__fish_seen_subcommand_from gen; and not __fish_seen_subcommand_from types signing-key bearer-jwt keys' -f -a signing-key -d 'Generate a JWT signing key'
complete -c supabase -n '__fish_seen_subcommand_from gen; and not __fish_seen_subcommand_from types signing-key bearer-jwt keys' -f -a bearer-jwt -d 'Generate a Bearer Auth JWT for accessing Data API'
complete -c supabase -n '__fish_seen_subcommand_from gen; and not __fish_seen_subcommand_from types signing-key bearer-jwt keys' -f -a keys -d 'Generate keys for preview branch (experimental)'
complete -c supabase -n '__fish_seen_subcommand_from types' -f
complete -c supabase -n '__fish_seen_subcommand_from types; and not __fish_contains_opt local no-local' -l local -d 'Generate types from the local dev database.'
complete -c supabase -n '__fish_seen_subcommand_from types; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from types; and not __fish_contains_opt linked no-linked' -l linked -d 'Generate types from the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from types; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from types' -l db-url -d 'Generate types from a database url.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from types' -l project-id -d 'Generate types from a project ID.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from types' -l lang -d 'Output language of the generated types. (default typescript)' -r -f -a 'typescript go swift python'
complete -c supabase -n '__fish_seen_subcommand_from types' -l schema -s s -d 'Comma separated list of schema to include.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from types' -l swift-access-control -d 'Access control for Swift generated types. (default internal)' -r -f -a 'internal public'
complete -c supabase -n '__fish_seen_subcommand_from types; and not __fish_contains_opt postgrest-v9-compat no-postgrest-v9-compat' -l postgrest-v9-compat -d 'Generate types compatible with PostgREST v9 and below.'
complete -c supabase -n '__fish_seen_subcommand_from types; and not __fish_contains_opt postgrest-v9-compat no-postgrest-v9-compat' -l no-postgrest-v9-compat -d 'Disable postgrest-v9-compat'
complete -c supabase -n '__fish_seen_subcommand_from types' -l query-timeout -d 'Maximum timeout allowed for the database query. (default 15s)' -r -f
complete -c supabase -n '__fish_seen_subcommand_from types; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Generate types from the local dev database.'
complete -c supabase -n '__fish_seen_subcommand_from types; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from types; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Generate types from the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from types; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from types; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Generate types from a database url.'
complete -c supabase -n '__fish_seen_subcommand_from types; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-id' -f -a --project-id -d 'Generate types from a project ID.'
complete -c supabase -n '__fish_seen_subcommand_from types; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt lang' -f -a --lang -d 'Output language of the generated types. (default typescript)'
complete -c supabase -n '__fish_seen_subcommand_from types; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s s schema' -f -a --schema -d 'Comma separated list of schema to include.'
complete -c supabase -n '__fish_seen_subcommand_from types; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt swift-access-control' -f -a --swift-access-control -d 'Access control for Swift generated types. (default internal)'
complete -c supabase -n '__fish_seen_subcommand_from types; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt postgrest-v9-compat no-postgrest-v9-compat' -f -a --postgrest-v9-compat -d 'Generate types compatible with PostgREST v9 and below.'
complete -c supabase -n '__fish_seen_subcommand_from types; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt postgrest-v9-compat no-postgrest-v9-compat' -f -a --no-postgrest-v9-compat -d 'Disable postgrest-v9-compat'
complete -c supabase -n '__fish_seen_subcommand_from types; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt query-timeout' -f -a --query-timeout -d 'Maximum timeout allowed for the database query. (default 15s)'
complete -c supabase -n '__fish_seen_subcommand_from signing-key' -f
complete -c supabase -n '__fish_seen_subcommand_from signing-key' -l algorithm -d 'Algorithm for signing key generation.' -r -f -a 'ES256 RS256'
complete -c supabase -n '__fish_seen_subcommand_from signing-key; and not __fish_contains_opt append no-append' -l append -d 'Append new key to existing keys file instead of overwriting.'
complete -c supabase -n '__fish_seen_subcommand_from signing-key; and not __fish_contains_opt append no-append' -l no-append -d 'Disable append'
complete -c supabase -n '__fish_seen_subcommand_from signing-key; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt algorithm' -f -a --algorithm -d 'Algorithm for signing key generation.'
complete -c supabase -n '__fish_seen_subcommand_from signing-key; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt append no-append' -f -a --append -d 'Append new key to existing keys file instead of overwriting.'
complete -c supabase -n '__fish_seen_subcommand_from signing-key; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt append no-append' -f -a --no-append -d 'Disable append'
complete -c supabase -n '__fish_seen_subcommand_from bearer-jwt' -f
complete -c supabase -n '__fish_seen_subcommand_from bearer-jwt' -l role -d 'Postgres role to use.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bearer-jwt' -l sub -d 'User ID to impersonate.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bearer-jwt' -l exp -d 'Expiry timestamp for this token (RFC3339 format).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bearer-jwt' -l valid-for -d 'Validity duration for this token.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bearer-jwt' -l payload -d 'Custom claims in JSON format.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bearer-jwt; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt role' -f -a --role -d 'Postgres role to use.'
complete -c supabase -n '__fish_seen_subcommand_from bearer-jwt; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt sub' -f -a --sub -d 'User ID to impersonate.'
complete -c supabase -n '__fish_seen_subcommand_from bearer-jwt; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt exp' -f -a --exp -d 'Expiry timestamp for this token (RFC3339 format).'
complete -c supabase -n '__fish_seen_subcommand_from bearer-jwt; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt valid-for' -f -a --valid-for -d 'Validity duration for this token.'
complete -c supabase -n '__fish_seen_subcommand_from bearer-jwt; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt payload' -f -a --payload -d 'Custom claims in JSON format.'
complete -c supabase -n '__fish_seen_subcommand_from keys' -f
complete -c supabase -n '__fish_seen_subcommand_from keys' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from keys' -l override-name -d 'Override specific variable names.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from keys; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from keys; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt override-name' -f -a --override-name -d 'Override specific variable names.'
complete -c supabase -n '__fish_seen_subcommand_from init' -f
complete -c supabase -n '__fish_seen_subcommand_from init; and not __fish_contains_opt -s i interactive no-interactive' -l interactive -s i -d 'Enables interactive mode to configure IDE settings.'
complete -c supabase -n '__fish_seen_subcommand_from init; and not __fish_contains_opt -s i interactive no-interactive' -l no-interactive -d 'Disable interactive'
complete -c supabase -n '__fish_seen_subcommand_from init; and not __fish_contains_opt use-orioledb no-use-orioledb' -l use-orioledb -d 'Use OrioleDB storage engine for Postgres.'
complete -c supabase -n '__fish_seen_subcommand_from init; and not __fish_contains_opt use-orioledb no-use-orioledb' -l no-use-orioledb -d 'Disable use-orioledb'
complete -c supabase -n '__fish_seen_subcommand_from init; and not __fish_contains_opt force no-force' -l force -d 'Overwrite existing supabase/config.toml.'
complete -c supabase -n '__fish_seen_subcommand_from init; and not __fish_contains_opt force no-force' -l no-force -d 'Disable force'
complete -c supabase -n '__fish_seen_subcommand_from init; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s i interactive no-interactive' -f -a --interactive -d 'Enables interactive mode to configure IDE settings.'
complete -c supabase -n '__fish_seen_subcommand_from init; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s i interactive no-interactive' -f -a --no-interactive -d 'Disable interactive'
complete -c supabase -n '__fish_seen_subcommand_from init; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-orioledb no-use-orioledb' -f -a --use-orioledb -d 'Use OrioleDB storage engine for Postgres.'
complete -c supabase -n '__fish_seen_subcommand_from init; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt use-orioledb no-use-orioledb' -f -a --no-use-orioledb -d 'Disable use-orioledb'
complete -c supabase -n '__fish_seen_subcommand_from init; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt force no-force' -f -a --force -d 'Overwrite existing supabase/config.toml.'
complete -c supabase -n '__fish_seen_subcommand_from init; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt force no-force' -f -a --no-force -d 'Disable force'
complete -c supabase -n '__fish_seen_subcommand_from inspect; and not __fish_seen_subcommand_from report db' -f
complete -c supabase -n '__fish_seen_subcommand_from inspect; and not __fish_seen_subcommand_from report db' -f -a report -d 'Generate a CSV output for all inspect commands'
complete -c supabase -n '__fish_seen_subcommand_from inspect; and not __fish_seen_subcommand_from report db' -f -a db -d 'Inspect database'
complete -c supabase -n '__fish_seen_subcommand_from report' -f
complete -c supabase -n '__fish_seen_subcommand_from report' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from report; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from report; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from report; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from report; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from report' -l output-dir -d 'Path to save CSV files in.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from report; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from report; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from report; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from report; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from report; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from report; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt output-dir' -f -a --output-dir -d 'Path to save CSV files in.'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a db-stats -d 'Show database stats'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a replication-slots -d 'Show replication slots'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a locks -d 'Show exclusive locks'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a blocking -d 'Show blocking queries'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a outliers -d 'Show query outliers by time'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a calls -d 'Show queries by call count'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a index-stats -d 'Show index stats'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a long-running-queries -d 'Show long-running queries'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a bloat -d 'Show relation bloat'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a role-stats -d 'Show role stats'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a vacuum-stats -d 'Show vacuum stats'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a table-stats -d 'Show table stats'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a traffic-profile -d 'Show traffic profile'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a cache-hit -d 'Show cache hit rates (deprecated)'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a index-usage -d 'Show index efficiency (deprecated)'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a total-index-size -d 'Show total index size (deprecated)'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a index-sizes -d 'Show individual index sizes (deprecated)'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a table-sizes -d 'Show table sizes (deprecated)'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a table-index-sizes -d 'Show table index sizes (deprecated)'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a total-table-sizes -d 'Show total table sizes (deprecated)'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a unused-indexes -d 'Show unused indexes (deprecated)'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a table-record-counts -d 'Show table record counts (deprecated)'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a seq-scans -d 'Show sequential scans (deprecated)'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a role-configs -d 'Show role configs (deprecated)'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_seen_subcommand_from db-stats replication-slots locks blocking outliers calls index-stats long-running-queries bloat role-stats vacuum-stats table-stats traffic-profile cache-hit index-usage total-index-size index-sizes table-sizes table-index-sizes total-table-sizes unused-indexes table-record-counts seq-scans role-configs role-connections' -f -a role-connections -d 'Show role connections (deprecated)'
complete -c supabase -n '__fish_seen_subcommand_from db-stats' -f
complete -c supabase -n '__fish_seen_subcommand_from db-stats' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from db-stats; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from db-stats; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from db-stats; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from db-stats; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from db-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from db-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from db-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from db-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from db-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from replication-slots' -f
complete -c supabase -n '__fish_seen_subcommand_from replication-slots' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from replication-slots; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from replication-slots; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from replication-slots; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from replication-slots; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from replication-slots; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from replication-slots; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from replication-slots; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from replication-slots; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from replication-slots; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from locks' -f
complete -c supabase -n '__fish_seen_subcommand_from locks' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from locks; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from locks; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from locks; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from locks; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from locks; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from locks; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from locks; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from locks; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from locks; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from blocking' -f
complete -c supabase -n '__fish_seen_subcommand_from blocking' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from blocking; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from blocking; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from blocking; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from blocking; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from blocking; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from blocking; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from blocking; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from blocking; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from blocking; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from outliers' -f
complete -c supabase -n '__fish_seen_subcommand_from outliers' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from outliers; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from outliers; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from outliers; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from outliers; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from outliers; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from outliers; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from outliers; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from outliers; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from outliers; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from calls' -f
complete -c supabase -n '__fish_seen_subcommand_from calls' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from calls; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from calls; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from calls; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from calls; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from calls; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from calls; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from calls; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from calls; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from calls; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from index-stats' -f
complete -c supabase -n '__fish_seen_subcommand_from index-stats' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from index-stats; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from index-stats; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from index-stats; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from index-stats; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from index-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from index-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from index-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from index-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from index-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from long-running-queries' -f
complete -c supabase -n '__fish_seen_subcommand_from long-running-queries' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from long-running-queries; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from long-running-queries; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from long-running-queries; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from long-running-queries; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from long-running-queries; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from long-running-queries; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from long-running-queries; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from long-running-queries; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from long-running-queries; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from bloat' -f
complete -c supabase -n '__fish_seen_subcommand_from bloat' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bloat; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from bloat; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from bloat; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from bloat; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from bloat; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from bloat; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from bloat; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from bloat; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from bloat; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from role-stats' -f
complete -c supabase -n '__fish_seen_subcommand_from role-stats' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from role-stats; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from role-stats; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from role-stats; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from role-stats; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from role-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from role-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from role-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from role-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from role-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from vacuum-stats' -f
complete -c supabase -n '__fish_seen_subcommand_from vacuum-stats' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from vacuum-stats; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from vacuum-stats; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from vacuum-stats; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from vacuum-stats; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from vacuum-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from vacuum-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from vacuum-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from vacuum-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from vacuum-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from table-stats' -f
complete -c supabase -n '__fish_seen_subcommand_from table-stats' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from table-stats; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from table-stats; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from table-stats; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from table-stats; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from table-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from table-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from table-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from table-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from table-stats; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from traffic-profile' -f
complete -c supabase -n '__fish_seen_subcommand_from traffic-profile' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from traffic-profile; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from traffic-profile; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from traffic-profile; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from traffic-profile; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from traffic-profile; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from traffic-profile; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from traffic-profile; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from traffic-profile; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from traffic-profile; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from cache-hit' -f
complete -c supabase -n '__fish_seen_subcommand_from cache-hit' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from cache-hit; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from cache-hit; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from cache-hit; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from cache-hit; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from cache-hit; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from cache-hit; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from cache-hit; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from cache-hit; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from cache-hit; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from index-usage' -f
complete -c supabase -n '__fish_seen_subcommand_from index-usage' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from index-usage; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from index-usage; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from index-usage; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from index-usage; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from index-usage; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from index-usage; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from index-usage; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from index-usage; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from index-usage; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from total-index-size' -f
complete -c supabase -n '__fish_seen_subcommand_from total-index-size' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from total-index-size; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from total-index-size; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from total-index-size; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from total-index-size; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from total-index-size; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from total-index-size; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from total-index-size; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from total-index-size; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from total-index-size; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from index-sizes' -f
complete -c supabase -n '__fish_seen_subcommand_from index-sizes' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from index-sizes; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from index-sizes; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from index-sizes; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from index-sizes; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from index-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from index-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from index-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from index-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from index-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from table-sizes' -f
complete -c supabase -n '__fish_seen_subcommand_from table-sizes' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from table-sizes; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from table-sizes; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from table-sizes; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from table-sizes; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from table-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from table-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from table-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from table-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from table-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from table-index-sizes' -f
complete -c supabase -n '__fish_seen_subcommand_from table-index-sizes' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from table-index-sizes; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from table-index-sizes; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from table-index-sizes; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from table-index-sizes; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from table-index-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from table-index-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from table-index-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from table-index-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from table-index-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from total-table-sizes' -f
complete -c supabase -n '__fish_seen_subcommand_from total-table-sizes' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from total-table-sizes; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from total-table-sizes; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from total-table-sizes; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from total-table-sizes; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from total-table-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from total-table-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from total-table-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from total-table-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from total-table-sizes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from unused-indexes' -f
complete -c supabase -n '__fish_seen_subcommand_from unused-indexes' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from unused-indexes; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from unused-indexes; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from unused-indexes; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from unused-indexes; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from unused-indexes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from unused-indexes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from unused-indexes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from unused-indexes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from unused-indexes; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from table-record-counts' -f
complete -c supabase -n '__fish_seen_subcommand_from table-record-counts' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from table-record-counts; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from table-record-counts; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from table-record-counts; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from table-record-counts; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from table-record-counts; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from table-record-counts; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from table-record-counts; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from table-record-counts; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from table-record-counts; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from seq-scans' -f
complete -c supabase -n '__fish_seen_subcommand_from seq-scans' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from seq-scans; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from seq-scans; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from seq-scans; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from seq-scans; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from seq-scans; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from seq-scans; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from seq-scans; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from seq-scans; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from seq-scans; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from role-configs' -f
complete -c supabase -n '__fish_seen_subcommand_from role-configs' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from role-configs; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from role-configs; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from role-configs; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from role-configs; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from role-configs; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from role-configs; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from role-configs; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from role-configs; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from role-configs; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from role-connections' -f
complete -c supabase -n '__fish_seen_subcommand_from role-connections' -l db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from role-connections; and not __fish_contains_opt linked no-linked' -l linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from role-connections; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from role-connections; and not __fish_contains_opt local no-local' -l local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from role-connections; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from role-connections; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Inspect the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from role-connections; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Inspect the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from role-connections; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from role-connections; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Inspect the local database.'
complete -c supabase -n '__fish_seen_subcommand_from role-connections; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from issue; and not __fish_seen_subcommand_from bug feature docs' -f
complete -c supabase -n '__fish_seen_subcommand_from issue; and not __fish_seen_subcommand_from bug feature docs' -f -a bug -d 'Open a bug report'
complete -c supabase -n '__fish_seen_subcommand_from issue; and not __fish_seen_subcommand_from bug feature docs' -f -a feature -d 'Open a feature request'
complete -c supabase -n '__fish_seen_subcommand_from issue; and not __fish_seen_subcommand_from bug feature docs' -f -a docs -d 'Open a documentation issue'
complete -c supabase -n '__fish_seen_subcommand_from bug' -f
complete -c supabase -n '__fish_seen_subcommand_from bug' -l area -d 'Affected CLI area.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bug' -l command -d 'Command that failed.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bug' -l actual-output -d 'Actual output or error text.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bug' -l expected-behavior -d 'Expected behavior.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bug' -l reproduce -d 'Steps to reproduce.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bug' -l crash-report-id -d 'Crash report ID printed by --create-ticket.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bug' -l docker-services -d 'Relevant Docker service status or logs.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bug' -l additional-context -d 'Extra context to prefill on the issue form.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from bug; and not __fish_contains_opt no-browser no-no-browser' -l no-browser -d 'Print the issue form URL without opening a browser.'
complete -c supabase -n '__fish_seen_subcommand_from bug; and not __fish_contains_opt no-browser no-no-browser' -l no-no-browser -d 'Disable no-browser'
complete -c supabase -n '__fish_seen_subcommand_from bug; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt area' -f -a --area -d 'Affected CLI area.'
complete -c supabase -n '__fish_seen_subcommand_from bug; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt command' -f -a --command -d 'Command that failed.'
complete -c supabase -n '__fish_seen_subcommand_from bug; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt actual-output' -f -a --actual-output -d 'Actual output or error text.'
complete -c supabase -n '__fish_seen_subcommand_from bug; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt expected-behavior' -f -a --expected-behavior -d 'Expected behavior.'
complete -c supabase -n '__fish_seen_subcommand_from bug; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt reproduce' -f -a --reproduce -d 'Steps to reproduce.'
complete -c supabase -n '__fish_seen_subcommand_from bug; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt crash-report-id' -f -a --crash-report-id -d 'Crash report ID printed by --create-ticket.'
complete -c supabase -n '__fish_seen_subcommand_from bug; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt docker-services' -f -a --docker-services -d 'Relevant Docker service status or logs.'
complete -c supabase -n '__fish_seen_subcommand_from bug; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt additional-context' -f -a --additional-context -d 'Extra context to prefill on the issue form.'
complete -c supabase -n '__fish_seen_subcommand_from bug; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-browser no-no-browser' -f -a --no-browser -d 'Print the issue form URL without opening a browser.'
complete -c supabase -n '__fish_seen_subcommand_from bug; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-browser no-no-browser' -f -a --no-no-browser -d 'Disable no-browser'
complete -c supabase -n '__fish_seen_subcommand_from feature' -f
complete -c supabase -n '__fish_seen_subcommand_from feature; and not __fish_contains_opt existing-issues no-existing-issues' -l existing-issues -d 'Prefill the existing issues checklist.'
complete -c supabase -n '__fish_seen_subcommand_from feature; and not __fish_contains_opt existing-issues no-existing-issues' -l no-existing-issues -d 'Disable existing-issues'
complete -c supabase -n '__fish_seen_subcommand_from feature' -l area -d 'Affected CLI area.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from feature' -l problem -d 'Problem the feature should solve.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from feature' -l proposed-solution -d 'Proposed solution.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from feature' -l alternatives -d 'Alternatives considered.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from feature' -l additional-context -d 'Extra context to prefill on the issue form.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from feature; and not __fish_contains_opt no-browser no-no-browser' -l no-browser -d 'Print the issue form URL without opening a browser.'
complete -c supabase -n '__fish_seen_subcommand_from feature; and not __fish_contains_opt no-browser no-no-browser' -l no-no-browser -d 'Disable no-browser'
complete -c supabase -n '__fish_seen_subcommand_from feature; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt existing-issues no-existing-issues' -f -a --existing-issues -d 'Prefill the existing issues checklist.'
complete -c supabase -n '__fish_seen_subcommand_from feature; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt existing-issues no-existing-issues' -f -a --no-existing-issues -d 'Disable existing-issues'
complete -c supabase -n '__fish_seen_subcommand_from feature; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt area' -f -a --area -d 'Affected CLI area.'
complete -c supabase -n '__fish_seen_subcommand_from feature; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt problem' -f -a --problem -d 'Problem the feature should solve.'
complete -c supabase -n '__fish_seen_subcommand_from feature; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt proposed-solution' -f -a --proposed-solution -d 'Proposed solution.'
complete -c supabase -n '__fish_seen_subcommand_from feature; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt alternatives' -f -a --alternatives -d 'Alternatives considered.'
complete -c supabase -n '__fish_seen_subcommand_from feature; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt additional-context' -f -a --additional-context -d 'Extra context to prefill on the issue form.'
complete -c supabase -n '__fish_seen_subcommand_from feature; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-browser no-no-browser' -f -a --no-browser -d 'Print the issue form URL without opening a browser.'
complete -c supabase -n '__fish_seen_subcommand_from feature; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-browser no-no-browser' -f -a --no-no-browser -d 'Disable no-browser'
complete -c supabase -n '__fish_seen_subcommand_from docs' -f
complete -c supabase -n '__fish_seen_subcommand_from docs' -l link -d 'Relevant documentation link.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from docs' -l issue-type -d 'Documentation issue type.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from docs' -l problem -d 'What is confusing, missing, or incorrect.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from docs' -l improvement -d 'Suggested documentation improvement.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from docs' -l additional-context -d 'Extra context to prefill on the issue form.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from docs; and not __fish_contains_opt no-browser no-no-browser' -l no-browser -d 'Print the issue form URL without opening a browser.'
complete -c supabase -n '__fish_seen_subcommand_from docs; and not __fish_contains_opt no-browser no-no-browser' -l no-no-browser -d 'Disable no-browser'
complete -c supabase -n '__fish_seen_subcommand_from docs; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt link' -f -a --link -d 'Relevant documentation link.'
complete -c supabase -n '__fish_seen_subcommand_from docs; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt issue-type' -f -a --issue-type -d 'Documentation issue type.'
complete -c supabase -n '__fish_seen_subcommand_from docs; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt problem' -f -a --problem -d 'What is confusing, missing, or incorrect.'
complete -c supabase -n '__fish_seen_subcommand_from docs; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt improvement' -f -a --improvement -d 'Suggested documentation improvement.'
complete -c supabase -n '__fish_seen_subcommand_from docs; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt additional-context' -f -a --additional-context -d 'Extra context to prefill on the issue form.'
complete -c supabase -n '__fish_seen_subcommand_from docs; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-browser no-no-browser' -f -a --no-browser -d 'Print the issue form URL without opening a browser.'
complete -c supabase -n '__fish_seen_subcommand_from docs; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-browser no-no-browser' -f -a --no-no-browser -d 'Disable no-browser'
complete -c supabase -n '__fish_seen_subcommand_from link' -f
complete -c supabase -n '__fish_seen_subcommand_from link' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from link' -l password -s p -d 'Password to your remote Postgres database.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from link; and not __fish_contains_opt skip-pooler no-skip-pooler' -l skip-pooler -d 'Use direct connection instead of pooler.'
complete -c supabase -n '__fish_seen_subcommand_from link; and not __fish_contains_opt skip-pooler no-skip-pooler' -l no-skip-pooler -d 'Disable skip-pooler'
complete -c supabase -n '__fish_seen_subcommand_from link; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from link; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s p password' -f -a --password -d 'Password to your remote Postgres database.'
complete -c supabase -n '__fish_seen_subcommand_from link; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt skip-pooler no-skip-pooler' -f -a --skip-pooler -d 'Use direct connection instead of pooler.'
complete -c supabase -n '__fish_seen_subcommand_from link; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt skip-pooler no-skip-pooler' -f -a --no-skip-pooler -d 'Disable skip-pooler'
complete -c supabase -n '__fish_seen_subcommand_from login' -f
complete -c supabase -n '__fish_seen_subcommand_from login' -l token -d 'Use provided token instead of automatic login flow.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from login' -l name -d 'Name that will be used to store token in your settings.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from login; and not __fish_contains_opt no-browser no-no-browser' -l no-browser -d 'Do not open browser automatically.'
complete -c supabase -n '__fish_seen_subcommand_from login; and not __fish_contains_opt no-browser no-no-browser' -l no-no-browser -d 'Disable no-browser'
complete -c supabase -n '__fish_seen_subcommand_from login; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt token' -f -a --token -d 'Use provided token instead of automatic login flow.'
complete -c supabase -n '__fish_seen_subcommand_from login; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt name' -f -a --name -d 'Name that will be used to store token in your settings.'
complete -c supabase -n '__fish_seen_subcommand_from login; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-browser no-no-browser' -f -a --no-browser -d 'Do not open browser automatically.'
complete -c supabase -n '__fish_seen_subcommand_from login; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-browser no-no-browser' -f -a --no-no-browser -d 'Disable no-browser'
complete -c supabase -n '__fish_seen_subcommand_from logout' -f
complete -c supabase -n '__fish_seen_subcommand_from migration; and not __fish_seen_subcommand_from list new repair squash up down fetch' -f
complete -c supabase -n '__fish_seen_subcommand_from migration; and not __fish_seen_subcommand_from list new repair squash up down fetch' -f -a list -d 'List local and remote migrations'
complete -c supabase -n '__fish_seen_subcommand_from migration; and not __fish_seen_subcommand_from list new repair squash up down fetch' -f -a new -d 'Create an empty migration script'
complete -c supabase -n '__fish_seen_subcommand_from migration; and not __fish_seen_subcommand_from list new repair squash up down fetch' -f -a repair -d 'Repair the migration history table'
complete -c supabase -n '__fish_seen_subcommand_from migration; and not __fish_seen_subcommand_from list new repair squash up down fetch' -f -a squash -d 'Squash migrations to a single file'
complete -c supabase -n '__fish_seen_subcommand_from migration; and not __fish_seen_subcommand_from list new repair squash up down fetch' -f -a up -d 'Apply pending migrations to local database'
complete -c supabase -n '__fish_seen_subcommand_from migration; and not __fish_seen_subcommand_from list new repair squash up down fetch' -f -a down -d 'Resets applied migrations up to the last n versions'
complete -c supabase -n '__fish_seen_subcommand_from migration; and not __fish_seen_subcommand_from list new repair squash up down fetch' -f -a fetch -d 'Fetch migration files from history table'
complete -c supabase -n '__fish_seen_subcommand_from list' -f
complete -c supabase -n '__fish_seen_subcommand_from list' -l db-url -d 'Lists migrations of the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from list; and not __fish_contains_opt linked no-linked' -l linked -d 'Lists migrations applied to the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from list; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from list; and not __fish_contains_opt local no-local' -l local -d 'Lists migrations applied to the local database.'
complete -c supabase -n '__fish_seen_subcommand_from list; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from list' -l password -s p -d 'Password to your remote Postgres database.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from list; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Lists migrations of the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from list; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Lists migrations applied to the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from list; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from list; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Lists migrations applied to the local database.'
complete -c supabase -n '__fish_seen_subcommand_from list; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from list; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s p password' -f -a --password -d 'Password to your remote Postgres database.'
complete -c supabase -n '__fish_seen_subcommand_from new' -f
complete -c supabase -n '__fish_seen_subcommand_from repair' -f
complete -c supabase -n '__fish_seen_subcommand_from repair' -l status -d 'Version status to update.' -r -f -a 'applied reverted'
complete -c supabase -n '__fish_seen_subcommand_from repair' -l db-url -d 'Repairs migrations of the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from repair; and not __fish_contains_opt linked no-linked' -l linked -d 'Repairs the migration history of the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from repair; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from repair; and not __fish_contains_opt local no-local' -l local -d 'Repairs the migration history of the local database.'
complete -c supabase -n '__fish_seen_subcommand_from repair; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from repair' -l password -s p -d 'Password to your remote Postgres database.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from repair; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt status' -f -a --status -d 'Version status to update.'
complete -c supabase -n '__fish_seen_subcommand_from repair; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Repairs migrations of the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from repair; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Repairs the migration history of the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from repair; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from repair; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Repairs the migration history of the local database.'
complete -c supabase -n '__fish_seen_subcommand_from repair; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from repair; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s p password' -f -a --password -d 'Password to your remote Postgres database.'
complete -c supabase -n '__fish_seen_subcommand_from squash' -f
complete -c supabase -n '__fish_seen_subcommand_from squash' -l version -d 'Squash up to the specified version.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from squash' -l db-url -d 'Squashes migrations of the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from squash; and not __fish_contains_opt linked no-linked' -l linked -d 'Squashes the migration history of the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from squash; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from squash; and not __fish_contains_opt local no-local' -l local -d 'Squashes the migration history of the local database.'
complete -c supabase -n '__fish_seen_subcommand_from squash; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from squash' -l password -s p -d 'Password to your remote Postgres database.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from squash; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt version' -f -a --version -d 'Squash up to the specified version.'
complete -c supabase -n '__fish_seen_subcommand_from squash; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Squashes migrations of the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from squash; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Squashes the migration history of the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from squash; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from squash; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Squashes the migration history of the local database.'
complete -c supabase -n '__fish_seen_subcommand_from squash; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from squash; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s p password' -f -a --password -d 'Password to your remote Postgres database.'
complete -c supabase -n '__fish_seen_subcommand_from up' -f
complete -c supabase -n '__fish_seen_subcommand_from up; and not __fish_contains_opt include-all no-include-all' -l include-all -d 'Include all migrations not found on remote history table.'
complete -c supabase -n '__fish_seen_subcommand_from up; and not __fish_contains_opt include-all no-include-all' -l no-include-all -d 'Disable include-all'
complete -c supabase -n '__fish_seen_subcommand_from up' -l db-url -d 'Applies migrations to the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from up; and not __fish_contains_opt linked no-linked' -l linked -d 'Applies pending migrations to the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from up; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from up; and not __fish_contains_opt local no-local' -l local -d 'Applies pending migrations to the local database.'
complete -c supabase -n '__fish_seen_subcommand_from up; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from up; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-all no-include-all' -f -a --include-all -d 'Include all migrations not found on remote history table.'
complete -c supabase -n '__fish_seen_subcommand_from up; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt include-all no-include-all' -f -a --no-include-all -d 'Disable include-all'
complete -c supabase -n '__fish_seen_subcommand_from up; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Applies migrations to the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from up; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Applies pending migrations to the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from up; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from up; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Applies pending migrations to the local database.'
complete -c supabase -n '__fish_seen_subcommand_from up; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from down' -f
complete -c supabase -n '__fish_seen_subcommand_from down' -l last -d 'Reset up to the last n migration versions.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from down' -l db-url -d 'Resets applied migrations on the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from down; and not __fish_contains_opt linked no-linked' -l linked -d 'Resets applied migrations on the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from down; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from down; and not __fish_contains_opt local no-local' -l local -d 'Resets applied migrations on the local database.'
complete -c supabase -n '__fish_seen_subcommand_from down; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from down; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt last' -f -a --last -d 'Reset up to the last n migration versions.'
complete -c supabase -n '__fish_seen_subcommand_from down; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Resets applied migrations on the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from down; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Resets applied migrations on the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from down; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from down; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Resets applied migrations on the local database.'
complete -c supabase -n '__fish_seen_subcommand_from down; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from fetch' -f
complete -c supabase -n '__fish_seen_subcommand_from fetch' -l db-url -d 'Fetches migrations from the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from fetch; and not __fish_contains_opt linked no-linked' -l linked -d 'Fetches migration history from the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from fetch; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from fetch; and not __fish_contains_opt local no-local' -l local -d 'Fetches migration history from the local database.'
complete -c supabase -n '__fish_seen_subcommand_from fetch; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from fetch; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Fetches migrations from the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from fetch; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Fetches migration history from the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from fetch; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from fetch; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Fetches migration history from the local database.'
complete -c supabase -n '__fish_seen_subcommand_from fetch; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from network-bans; and not __fish_seen_subcommand_from get remove' -f
complete -c supabase -n '__fish_seen_subcommand_from network-bans; and not __fish_seen_subcommand_from get remove' -f -a get -d 'Get the current network bans'
complete -c supabase -n '__fish_seen_subcommand_from network-bans; and not __fish_seen_subcommand_from get remove' -f -a remove -d 'Remove a network ban'
complete -c supabase -n '__fish_seen_subcommand_from get' -f
complete -c supabase -n '__fish_seen_subcommand_from get' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from get; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from remove' -f
complete -c supabase -n '__fish_seen_subcommand_from remove' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from remove' -l db-unban-ip -d 'IP to allow DB connections from.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from remove; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from remove; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-unban-ip' -f -a --db-unban-ip -d 'IP to allow DB connections from.'
complete -c supabase -n '__fish_seen_subcommand_from network-restrictions; and not __fish_seen_subcommand_from get update' -f
complete -c supabase -n '__fish_seen_subcommand_from network-restrictions; and not __fish_seen_subcommand_from get update' -f -a get -d 'Get the current network restrictions'
complete -c supabase -n '__fish_seen_subcommand_from network-restrictions; and not __fish_seen_subcommand_from get update' -f -a update -d 'Update network restrictions'
complete -c supabase -n '__fish_seen_subcommand_from get' -f
complete -c supabase -n '__fish_seen_subcommand_from get' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from get; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from update' -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l db-allow-cidr -d 'CIDR to allow DB connections from.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt bypass-cidr-checks no-bypass-cidr-checks' -l bypass-cidr-checks -d 'Bypass some of the CIDR validation checks.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt bypass-cidr-checks no-bypass-cidr-checks' -l no-bypass-cidr-checks -d 'Disable bypass-cidr-checks'
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt append no-append' -l append -d 'Append to existing restrictions instead of replacing them.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt append no-append' -l no-append -d 'Disable append'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-allow-cidr' -f -a --db-allow-cidr -d 'CIDR to allow DB connections from.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt bypass-cidr-checks no-bypass-cidr-checks' -f -a --bypass-cidr-checks -d 'Bypass some of the CIDR validation checks.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt bypass-cidr-checks no-bypass-cidr-checks' -f -a --no-bypass-cidr-checks -d 'Disable bypass-cidr-checks'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt append no-append' -f -a --append -d 'Append to existing restrictions instead of replacing them.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt append no-append' -f -a --no-append -d 'Disable append'
complete -c supabase -n '__fish_seen_subcommand_from orgs; and not __fish_seen_subcommand_from list create' -f
complete -c supabase -n '__fish_seen_subcommand_from orgs; and not __fish_seen_subcommand_from list create' -f -a list -d 'List all organizations'
complete -c supabase -n '__fish_seen_subcommand_from orgs; and not __fish_seen_subcommand_from list create' -f -a create -d 'Create an organization'
complete -c supabase -n '__fish_seen_subcommand_from list' -f
complete -c supabase -n '__fish_seen_subcommand_from create' -f
complete -c supabase -n '__fish_seen_subcommand_from postgres-config; and not __fish_seen_subcommand_from get update delete' -f
complete -c supabase -n '__fish_seen_subcommand_from postgres-config; and not __fish_seen_subcommand_from get update delete' -f -a get -d 'Get Postgres database config'
complete -c supabase -n '__fish_seen_subcommand_from postgres-config; and not __fish_seen_subcommand_from get update delete' -f -a update -d 'Update Postgres database config'
complete -c supabase -n '__fish_seen_subcommand_from postgres-config; and not __fish_seen_subcommand_from get update delete' -f -a delete -d 'Delete Postgres database config overrides'
complete -c supabase -n '__fish_seen_subcommand_from get' -f
complete -c supabase -n '__fish_seen_subcommand_from get' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from get; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from update' -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l config -d 'Config overrides specified as a \'key=value\' pair' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt replace-existing-overrides no-replace-existing-overrides' -l replace-existing-overrides -d 'If true, replaces all existing overrides with the ones provided. If false (default), merges existing overrides with the ones provided.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt replace-existing-overrides no-replace-existing-overrides' -l no-replace-existing-overrides -d 'Disable replace-existing-overrides'
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt no-restart no-no-restart' -l no-restart -d 'Do not restart the database after updating config.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt no-restart no-no-restart' -l no-no-restart -d 'Disable no-restart'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt config' -f -a --config -d 'Config overrides specified as a \'key=value\' pair'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt replace-existing-overrides no-replace-existing-overrides' -f -a --replace-existing-overrides -d 'If true, replaces all existing overrides with the ones provided. If false (default), merges existing overrides with the ones provided.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt replace-existing-overrides no-replace-existing-overrides' -f -a --no-replace-existing-overrides -d 'Disable replace-existing-overrides'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-restart no-no-restart' -f -a --no-restart -d 'Do not restart the database after updating config.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-restart no-no-restart' -f -a --no-no-restart -d 'Disable no-restart'
complete -c supabase -n '__fish_seen_subcommand_from delete' -f
complete -c supabase -n '__fish_seen_subcommand_from delete' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from delete' -l config -d 'Config keys to delete (comma-separated)' -r -f
complete -c supabase -n '__fish_seen_subcommand_from delete; and not __fish_contains_opt no-restart no-no-restart' -l no-restart -d 'Do not restart the database after deleting config.'
complete -c supabase -n '__fish_seen_subcommand_from delete; and not __fish_contains_opt no-restart no-no-restart' -l no-no-restart -d 'Disable no-restart'
complete -c supabase -n '__fish_seen_subcommand_from delete; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from delete; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt config' -f -a --config -d 'Config keys to delete (comma-separated)'
complete -c supabase -n '__fish_seen_subcommand_from delete; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-restart no-no-restart' -f -a --no-restart -d 'Do not restart the database after deleting config.'
complete -c supabase -n '__fish_seen_subcommand_from delete; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-restart no-no-restart' -f -a --no-no-restart -d 'Disable no-restart'
complete -c supabase -n '__fish_seen_subcommand_from projects; and not __fish_seen_subcommand_from list create api-keys delete' -f
complete -c supabase -n '__fish_seen_subcommand_from projects; and not __fish_seen_subcommand_from list create api-keys delete' -f -a list -d 'List all projects'
complete -c supabase -n '__fish_seen_subcommand_from projects; and not __fish_seen_subcommand_from list create api-keys delete' -f -a create -d 'Create a project'
complete -c supabase -n '__fish_seen_subcommand_from projects; and not __fish_seen_subcommand_from list create api-keys delete' -f -a api-keys -d 'List API keys'
complete -c supabase -n '__fish_seen_subcommand_from projects; and not __fish_seen_subcommand_from list create api-keys delete' -f -a delete -d 'Delete a project'
complete -c supabase -n '__fish_seen_subcommand_from list' -f
complete -c supabase -n '__fish_seen_subcommand_from create' -f
complete -c supabase -n '__fish_seen_subcommand_from create' -l org-id -d 'Organization ID to create the project in.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from create' -l db-password -d 'Database password of the project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from create' -l region -d 'Select a region close to you for the best performance.' -r -f -a 'ap-east-1 ap-northeast-1 ap-northeast-2 ap-south-1 ap-southeast-1 ap-southeast-2 ca-central-1 eu-central-1 eu-central-2 eu-north-1 eu-west-1 eu-west-2 eu-west-3 sa-east-1 us-east-1 us-east-2 us-west-1 us-west-2'
complete -c supabase -n '__fish_seen_subcommand_from create' -l size -d 'Select a desired instance size for your project.' -r -f -a 'nano micro small medium large xlarge 2xlarge 4xlarge 8xlarge 12xlarge 16xlarge 24xlarge 24xlarge_high_memory 24xlarge_optimized_cpu 24xlarge_optimized_memory 48xlarge 48xlarge_high_memory 48xlarge_optimized_cpu 48xlarge_optimized_memory'
complete -c supabase -n '__fish_seen_subcommand_from create; and not __fish_contains_opt high-availability no-high-availability' -l high-availability -d 'Enable high availability for the project.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not __fish_contains_opt high-availability no-high-availability' -l no-high-availability -d 'Disable high-availability'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt org-id' -f -a --org-id -d 'Organization ID to create the project in.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-password' -f -a --db-password -d 'Database password of the project.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt region' -f -a --region -d 'Select a region close to you for the best performance.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt size' -f -a --size -d 'Select a desired instance size for your project.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt high-availability no-high-availability' -f -a --high-availability -d 'Enable high availability for the project.'
complete -c supabase -n '__fish_seen_subcommand_from create; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt high-availability no-high-availability' -f -a --no-high-availability -d 'Disable high-availability'
complete -c supabase -n '__fish_seen_subcommand_from api-keys' -f
complete -c supabase -n '__fish_seen_subcommand_from api-keys' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from api-keys; and not __fish_contains_opt reveal no-reveal' -l reveal -d 'Reveal the secret API keys in full (e.g. sb_secret_...).'
complete -c supabase -n '__fish_seen_subcommand_from api-keys; and not __fish_contains_opt reveal no-reveal' -l no-reveal -d 'Disable reveal'
complete -c supabase -n '__fish_seen_subcommand_from api-keys; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from api-keys; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt reveal no-reveal' -f -a --reveal -d 'Reveal the secret API keys in full (e.g. sb_secret_...).'
complete -c supabase -n '__fish_seen_subcommand_from api-keys; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt reveal no-reveal' -f -a --no-reveal -d 'Disable reveal'
complete -c supabase -n '__fish_seen_subcommand_from delete' -f
complete -c supabase -n '__fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from list set unset' -f
complete -c supabase -n '__fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from list set unset' -f -a list -d 'List all secrets on Supabase'
complete -c supabase -n '__fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from list set unset' -f -a set -d 'Set a secret(s) on Supabase'
complete -c supabase -n '__fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from list set unset' -f -a unset -d 'Unset a secret(s) on Supabase'
complete -c supabase -n '__fish_seen_subcommand_from list' -f
complete -c supabase -n '__fish_seen_subcommand_from list' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from list; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from set' -f
complete -c supabase -n '__fish_seen_subcommand_from set' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from set' -l env-file -d 'Read secrets from a .env file.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from set; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from set; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt env-file' -f -a --env-file -d 'Read secrets from a .env file.'
complete -c supabase -n '__fish_seen_subcommand_from unset' -f
complete -c supabase -n '__fish_seen_subcommand_from unset' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from unset; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from seed; and not __fish_seen_subcommand_from buckets' -f
complete -c supabase -n '__fish_seen_subcommand_from seed; and not __fish_seen_subcommand_from buckets' -f -a buckets -d 'Seed buckets declared in [storage.buckets]'
complete -c supabase -n '__fish_seen_subcommand_from buckets' -f
complete -c supabase -n '__fish_seen_subcommand_from services' -f
complete -c supabase -n '__fish_seen_subcommand_from snippets; and not __fish_seen_subcommand_from list download' -f
complete -c supabase -n '__fish_seen_subcommand_from snippets; and not __fish_seen_subcommand_from list download' -f -a list -d 'List all SQL snippets'
complete -c supabase -n '__fish_seen_subcommand_from snippets; and not __fish_seen_subcommand_from list download' -f -a download -d 'Download contents of a SQL snippet'
complete -c supabase -n '__fish_seen_subcommand_from list' -f
complete -c supabase -n '__fish_seen_subcommand_from list' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from list; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from download' -f
complete -c supabase -n '__fish_seen_subcommand_from download' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from download; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from ssl-enforcement; and not __fish_seen_subcommand_from get update' -f
complete -c supabase -n '__fish_seen_subcommand_from ssl-enforcement; and not __fish_seen_subcommand_from get update' -f -a get -d 'Get SSL enforcement configuration'
complete -c supabase -n '__fish_seen_subcommand_from ssl-enforcement; and not __fish_seen_subcommand_from get update' -f -a update -d 'Update SSL enforcement configuration'
complete -c supabase -n '__fish_seen_subcommand_from get' -f
complete -c supabase -n '__fish_seen_subcommand_from get' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from get; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from update' -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt enable-db-ssl-enforcement no-enable-db-ssl-enforcement' -l enable-db-ssl-enforcement -d 'Whether the DB should enable SSL enforcement for all external connections.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt enable-db-ssl-enforcement no-enable-db-ssl-enforcement' -l no-enable-db-ssl-enforcement -d 'Disable enable-db-ssl-enforcement'
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt disable-db-ssl-enforcement no-disable-db-ssl-enforcement' -l disable-db-ssl-enforcement -d 'Whether the DB should disable SSL enforcement for all external connections.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt disable-db-ssl-enforcement no-disable-db-ssl-enforcement' -l no-disable-db-ssl-enforcement -d 'Disable disable-db-ssl-enforcement'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt enable-db-ssl-enforcement no-enable-db-ssl-enforcement' -f -a --enable-db-ssl-enforcement -d 'Whether the DB should enable SSL enforcement for all external connections.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt enable-db-ssl-enforcement no-enable-db-ssl-enforcement' -f -a --no-enable-db-ssl-enforcement -d 'Disable enable-db-ssl-enforcement'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt disable-db-ssl-enforcement no-disable-db-ssl-enforcement' -f -a --disable-db-ssl-enforcement -d 'Whether the DB should disable SSL enforcement for all external connections.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt disable-db-ssl-enforcement no-disable-db-ssl-enforcement' -f -a --no-disable-db-ssl-enforcement -d 'Disable disable-db-ssl-enforcement'
complete -c supabase -n '__fish_seen_subcommand_from sso; and not __fish_seen_subcommand_from list add remove update show info' -f
complete -c supabase -n '__fish_seen_subcommand_from sso; and not __fish_seen_subcommand_from list add remove update show info' -f -a list -d 'List all SSO identity providers'
complete -c supabase -n '__fish_seen_subcommand_from sso; and not __fish_seen_subcommand_from list add remove update show info' -f -a add -d 'Add a new SSO identity provider'
complete -c supabase -n '__fish_seen_subcommand_from sso; and not __fish_seen_subcommand_from list add remove update show info' -f -a remove -d 'Remove an existing SSO identity provider'
complete -c supabase -n '__fish_seen_subcommand_from sso; and not __fish_seen_subcommand_from list add remove update show info' -f -a update -d 'Update information about an SSO identity provider'
complete -c supabase -n '__fish_seen_subcommand_from sso; and not __fish_seen_subcommand_from list add remove update show info' -f -a show -d 'Show information about an SSO identity provider'
complete -c supabase -n '__fish_seen_subcommand_from sso; and not __fish_seen_subcommand_from list add remove update show info' -f -a info -d 'Returns the SAML SSO settings required for the identity provider'
complete -c supabase -n '__fish_seen_subcommand_from list' -f
complete -c supabase -n '__fish_seen_subcommand_from list' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from list; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from add' -f
complete -c supabase -n '__fish_seen_subcommand_from add' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from add' -l type -s t -d 'Type of identity provider (according to supported protocol).' -r -f -a saml
complete -c supabase -n '__fish_seen_subcommand_from add' -l domains -d 'Comma separated list of email domains to associate with the added identity provider.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from add' -l metadata-file -d 'File containing a SAML 2.0 Metadata XML document describing the identity provider.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from add' -l metadata-url -d 'URL pointing to a SAML 2.0 Metadata XML document describing the identity provider.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from add; and not __fish_contains_opt skip-url-validation no-skip-url-validation' -l skip-url-validation -d 'Skip local validation of the SAML 2.0 Metadata URL (HTTPS requirement, live GET probe, and UTF-8 body decode). Use in air-gapped CI where the IDP is not reachable from the build agent.'
complete -c supabase -n '__fish_seen_subcommand_from add; and not __fish_contains_opt skip-url-validation no-skip-url-validation' -l no-skip-url-validation -d 'Disable skip-url-validation'
complete -c supabase -n '__fish_seen_subcommand_from add' -l attribute-mapping-file -d 'File containing a JSON mapping between SAML attributes to custom JWT claims.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from add' -l name-id-format -d 'URI reference representing the classification of string-based identifier information.' -r -f -a 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified urn:oasis:names:tc:SAML:2.0:nameid-format:persistent urn:oasis:names:tc:SAML:2.0:nameid-format:transient'
complete -c supabase -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s t type' -f -a --type -d 'Type of identity provider (according to supported protocol).'
complete -c supabase -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt domains' -f -a --domains -d 'Comma separated list of email domains to associate with the added identity provider.'
complete -c supabase -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt metadata-file' -f -a --metadata-file -d 'File containing a SAML 2.0 Metadata XML document describing the identity provider.'
complete -c supabase -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt metadata-url' -f -a --metadata-url -d 'URL pointing to a SAML 2.0 Metadata XML document describing the identity provider.'
complete -c supabase -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt skip-url-validation no-skip-url-validation' -f -a --skip-url-validation -d 'Skip local validation of the SAML 2.0 Metadata URL (HTTPS requirement, live GET probe, and UTF-8 body decode). Use in air-gapped CI where the IDP is not reachable from the build agent.'
complete -c supabase -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt skip-url-validation no-skip-url-validation' -f -a --no-skip-url-validation -d 'Disable skip-url-validation'
complete -c supabase -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt attribute-mapping-file' -f -a --attribute-mapping-file -d 'File containing a JSON mapping between SAML attributes to custom JWT claims.'
complete -c supabase -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt name-id-format' -f -a --name-id-format -d 'URI reference representing the classification of string-based identifier information.'
complete -c supabase -n '__fish_seen_subcommand_from remove' -f
complete -c supabase -n '__fish_seen_subcommand_from remove' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from remove; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from update' -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l domains -d 'Replace domains with this comma separated list of email domains.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l add-domains -d 'Add this comma separated list of email domains to the identity provider.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l remove-domains -d 'Remove this comma separated list of email domains from the identity provider.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l metadata-file -d 'File containing a SAML 2.0 Metadata XML document describing the identity provider.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l metadata-url -d 'URL pointing to a SAML 2.0 Metadata XML document describing the identity provider.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt skip-url-validation no-skip-url-validation' -l skip-url-validation -d 'Skip local validation of the SAML 2.0 Metadata URL (HTTPS requirement, live GET probe, and UTF-8 body decode). Use in air-gapped CI where the IDP is not reachable from the build agent.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not __fish_contains_opt skip-url-validation no-skip-url-validation' -l no-skip-url-validation -d 'Disable skip-url-validation'
complete -c supabase -n '__fish_seen_subcommand_from update' -l attribute-mapping-file -d 'File containing a JSON mapping between SAML attributes to custom JWT claims.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from update' -l name-id-format -d 'URI reference representing the classification of string-based identifier information.' -r -f -a 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified urn:oasis:names:tc:SAML:2.0:nameid-format:persistent urn:oasis:names:tc:SAML:2.0:nameid-format:transient'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt domains' -f -a --domains -d 'Replace domains with this comma separated list of email domains.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt add-domains' -f -a --add-domains -d 'Add this comma separated list of email domains to the identity provider.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt remove-domains' -f -a --remove-domains -d 'Remove this comma separated list of email domains from the identity provider.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt metadata-file' -f -a --metadata-file -d 'File containing a SAML 2.0 Metadata XML document describing the identity provider.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt metadata-url' -f -a --metadata-url -d 'URL pointing to a SAML 2.0 Metadata XML document describing the identity provider.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt skip-url-validation no-skip-url-validation' -f -a --skip-url-validation -d 'Skip local validation of the SAML 2.0 Metadata URL (HTTPS requirement, live GET probe, and UTF-8 body decode). Use in air-gapped CI where the IDP is not reachable from the build agent.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt skip-url-validation no-skip-url-validation' -f -a --no-skip-url-validation -d 'Disable skip-url-validation'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt attribute-mapping-file' -f -a --attribute-mapping-file -d 'File containing a JSON mapping between SAML attributes to custom JWT claims.'
complete -c supabase -n '__fish_seen_subcommand_from update; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt name-id-format' -f -a --name-id-format -d 'URI reference representing the classification of string-based identifier information.'
complete -c supabase -n '__fish_seen_subcommand_from show' -f
complete -c supabase -n '__fish_seen_subcommand_from show' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from show; and not __fish_contains_opt metadata no-metadata' -l metadata -d 'Show SAML 2.0 XML Metadata only'
complete -c supabase -n '__fish_seen_subcommand_from show; and not __fish_contains_opt metadata no-metadata' -l no-metadata -d 'Disable metadata'
complete -c supabase -n '__fish_seen_subcommand_from show; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from show; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt metadata no-metadata' -f -a --metadata -d 'Show SAML 2.0 XML Metadata only'
complete -c supabase -n '__fish_seen_subcommand_from show; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt metadata no-metadata' -f -a --no-metadata -d 'Disable metadata'
complete -c supabase -n '__fish_seen_subcommand_from info' -f
complete -c supabase -n '__fish_seen_subcommand_from info' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from info; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from start' -f
complete -c supabase -n '__fish_seen_subcommand_from start' -l exclude -s x -d 'Names of containers to not start. [analytics,db,edge-runtime,functions,imgproxy,inbucket,kong,meta,realtime,rest,storage,studio,vector]' -r -f
complete -c supabase -n '__fish_seen_subcommand_from start; and not __fish_contains_opt ignore-health-check no-ignore-health-check' -l ignore-health-check -d 'Ignore unhealthy services and exit 0'
complete -c supabase -n '__fish_seen_subcommand_from start; and not __fish_contains_opt ignore-health-check no-ignore-health-check' -l no-ignore-health-check -d 'Disable ignore-health-check'
complete -c supabase -n '__fish_seen_subcommand_from start; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s x exclude' -f -a --exclude -d 'Names of containers to not start. [analytics,db,edge-runtime,functions,imgproxy,inbucket,kong,meta,realtime,rest,storage,studio,vector]'
complete -c supabase -n '__fish_seen_subcommand_from start; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt ignore-health-check no-ignore-health-check' -f -a --ignore-health-check -d 'Ignore unhealthy services and exit 0'
complete -c supabase -n '__fish_seen_subcommand_from start; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt ignore-health-check no-ignore-health-check' -f -a --no-ignore-health-check -d 'Disable ignore-health-check'
complete -c supabase -n '__fish_seen_subcommand_from status' -f
complete -c supabase -n '__fish_seen_subcommand_from status' -l override-name -d 'Override specific variable names.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from status; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt override-name' -f -a --override-name -d 'Override specific variable names.'
complete -c supabase -n '__fish_seen_subcommand_from stop' -f
complete -c supabase -n '__fish_seen_subcommand_from stop' -l project-id -d 'Local project ID to stop.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from stop; and not __fish_contains_opt no-backup no-no-backup' -l no-backup -d 'Deletes all data volumes after stopping.'
complete -c supabase -n '__fish_seen_subcommand_from stop; and not __fish_contains_opt no-backup no-no-backup' -l no-no-backup -d 'Disable no-backup'
complete -c supabase -n '__fish_seen_subcommand_from stop; and not __fish_contains_opt all no-all' -l all -d 'Stop all local Supabase instances from all projects across the machine.'
complete -c supabase -n '__fish_seen_subcommand_from stop; and not __fish_contains_opt all no-all' -l no-all -d 'Disable all'
complete -c supabase -n '__fish_seen_subcommand_from stop; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-id' -f -a --project-id -d 'Local project ID to stop.'
complete -c supabase -n '__fish_seen_subcommand_from stop; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-backup no-no-backup' -f -a --no-backup -d 'Deletes all data volumes after stopping.'
complete -c supabase -n '__fish_seen_subcommand_from stop; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt no-backup no-no-backup' -f -a --no-no-backup -d 'Disable no-backup'
complete -c supabase -n '__fish_seen_subcommand_from stop; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt all no-all' -f -a --all -d 'Stop all local Supabase instances from all projects across the machine.'
complete -c supabase -n '__fish_seen_subcommand_from stop; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt all no-all' -f -a --no-all -d 'Disable all'
complete -c supabase -n '__fish_seen_subcommand_from storage; and not __fish_seen_subcommand_from ls cp mv rm' -f
complete -c supabase -n '__fish_seen_subcommand_from storage; and not __fish_seen_subcommand_from ls cp mv rm' -f -a ls -d 'List objects by path prefix'
complete -c supabase -n '__fish_seen_subcommand_from storage; and not __fish_seen_subcommand_from ls cp mv rm' -f -a cp -d 'Copy objects from src to dst path'
complete -c supabase -n '__fish_seen_subcommand_from storage; and not __fish_seen_subcommand_from ls cp mv rm' -f -a mv -d 'Move objects from src to dst path'
complete -c supabase -n '__fish_seen_subcommand_from storage; and not __fish_seen_subcommand_from ls cp mv rm' -f -a rm -d 'Remove objects by file path'
complete -c supabase -n '__fish_seen_subcommand_from ls' -f
complete -c supabase -n '__fish_seen_subcommand_from ls; and not __fish_contains_opt -s r recursive no-recursive' -l recursive -s r -d 'Recursively list a directory.'
complete -c supabase -n '__fish_seen_subcommand_from ls; and not __fish_contains_opt -s r recursive no-recursive' -l no-recursive -d 'Disable recursive'
complete -c supabase -n '__fish_seen_subcommand_from ls; and not __fish_contains_opt linked no-linked' -l linked -d 'Connects to Storage API of the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from ls; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from ls; and not __fish_contains_opt local no-local' -l local -d 'Connects to Storage API of the local database.'
complete -c supabase -n '__fish_seen_subcommand_from ls; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from ls; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s r recursive no-recursive' -f -a --recursive -d 'Recursively list a directory.'
complete -c supabase -n '__fish_seen_subcommand_from ls; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s r recursive no-recursive' -f -a --no-recursive -d 'Disable recursive'
complete -c supabase -n '__fish_seen_subcommand_from ls; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Connects to Storage API of the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from ls; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from ls; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Connects to Storage API of the local database.'
complete -c supabase -n '__fish_seen_subcommand_from ls; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from cp' -f
complete -c supabase -n '__fish_seen_subcommand_from cp; and not __fish_contains_opt -s r recursive no-recursive' -l recursive -s r -d 'Recursively copy a directory.'
complete -c supabase -n '__fish_seen_subcommand_from cp; and not __fish_contains_opt -s r recursive no-recursive' -l no-recursive -d 'Disable recursive'
complete -c supabase -n '__fish_seen_subcommand_from cp' -l cache-control -d 'Custom Cache-Control header for HTTP upload. (default "max-age=3600")' -r -f
complete -c supabase -n '__fish_seen_subcommand_from cp' -l content-type -d 'Custom Content-Type header for HTTP upload. (default "auto-detect")' -r -f
complete -c supabase -n '__fish_seen_subcommand_from cp' -l jobs -s j -d 'Maximum number of parallel jobs. (default 1)' -r -f
complete -c supabase -n '__fish_seen_subcommand_from cp; and not __fish_contains_opt linked no-linked' -l linked -d 'Connects to Storage API of the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from cp; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from cp; and not __fish_contains_opt local no-local' -l local -d 'Connects to Storage API of the local database.'
complete -c supabase -n '__fish_seen_subcommand_from cp; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from cp; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s r recursive no-recursive' -f -a --recursive -d 'Recursively copy a directory.'
complete -c supabase -n '__fish_seen_subcommand_from cp; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s r recursive no-recursive' -f -a --no-recursive -d 'Disable recursive'
complete -c supabase -n '__fish_seen_subcommand_from cp; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt cache-control' -f -a --cache-control -d 'Custom Cache-Control header for HTTP upload. (default "max-age=3600")'
complete -c supabase -n '__fish_seen_subcommand_from cp; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt content-type' -f -a --content-type -d 'Custom Content-Type header for HTTP upload. (default "auto-detect")'
complete -c supabase -n '__fish_seen_subcommand_from cp; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s j jobs' -f -a --jobs -d 'Maximum number of parallel jobs. (default 1)'
complete -c supabase -n '__fish_seen_subcommand_from cp; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Connects to Storage API of the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from cp; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from cp; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Connects to Storage API of the local database.'
complete -c supabase -n '__fish_seen_subcommand_from cp; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from mv' -f
complete -c supabase -n '__fish_seen_subcommand_from mv; and not __fish_contains_opt -s r recursive no-recursive' -l recursive -s r -d 'Recursively move a directory.'
complete -c supabase -n '__fish_seen_subcommand_from mv; and not __fish_contains_opt -s r recursive no-recursive' -l no-recursive -d 'Disable recursive'
complete -c supabase -n '__fish_seen_subcommand_from mv; and not __fish_contains_opt linked no-linked' -l linked -d 'Connects to Storage API of the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from mv; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from mv; and not __fish_contains_opt local no-local' -l local -d 'Connects to Storage API of the local database.'
complete -c supabase -n '__fish_seen_subcommand_from mv; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from mv; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s r recursive no-recursive' -f -a --recursive -d 'Recursively move a directory.'
complete -c supabase -n '__fish_seen_subcommand_from mv; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s r recursive no-recursive' -f -a --no-recursive -d 'Disable recursive'
complete -c supabase -n '__fish_seen_subcommand_from mv; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Connects to Storage API of the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from mv; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from mv; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Connects to Storage API of the local database.'
complete -c supabase -n '__fish_seen_subcommand_from mv; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from rm' -f
complete -c supabase -n '__fish_seen_subcommand_from rm; and not __fish_contains_opt -s r recursive no-recursive' -l recursive -s r -d 'Recursively remove a directory.'
complete -c supabase -n '__fish_seen_subcommand_from rm; and not __fish_contains_opt -s r recursive no-recursive' -l no-recursive -d 'Disable recursive'
complete -c supabase -n '__fish_seen_subcommand_from rm; and not __fish_contains_opt linked no-linked' -l linked -d 'Connects to Storage API of the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from rm; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from rm; and not __fish_contains_opt local no-local' -l local -d 'Connects to Storage API of the local database.'
complete -c supabase -n '__fish_seen_subcommand_from rm; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from rm; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s r recursive no-recursive' -f -a --recursive -d 'Recursively remove a directory.'
complete -c supabase -n '__fish_seen_subcommand_from rm; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s r recursive no-recursive' -f -a --no-recursive -d 'Disable recursive'
complete -c supabase -n '__fish_seen_subcommand_from rm; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Connects to Storage API of the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from rm; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from rm; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Connects to Storage API of the local database.'
complete -c supabase -n '__fish_seen_subcommand_from rm; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from telemetry; and not __fish_seen_subcommand_from enable disable status' -f
complete -c supabase -n '__fish_seen_subcommand_from telemetry; and not __fish_seen_subcommand_from enable disable status' -f -a enable -d 'Enable telemetry'
complete -c supabase -n '__fish_seen_subcommand_from telemetry; and not __fish_seen_subcommand_from enable disable status' -f -a disable -d 'Disable telemetry'
complete -c supabase -n '__fish_seen_subcommand_from telemetry; and not __fish_seen_subcommand_from enable disable status' -f -a status -d 'Show telemetry status'
complete -c supabase -n '__fish_seen_subcommand_from enable' -f
complete -c supabase -n '__fish_seen_subcommand_from disable' -f
complete -c supabase -n '__fish_seen_subcommand_from status' -f
complete -c supabase -n '__fish_seen_subcommand_from test; and not __fish_seen_subcommand_from db new' -f
complete -c supabase -n '__fish_seen_subcommand_from test; and not __fish_seen_subcommand_from db new' -f -a db -d 'Run pgTAP tests'
complete -c supabase -n '__fish_seen_subcommand_from test; and not __fish_seen_subcommand_from db new' -f -a new -d 'Create a new test file'
complete -c supabase -n '__fish_seen_subcommand_from db' -f
complete -c supabase -n '__fish_seen_subcommand_from db' -l db-url -d 'Tests the database specified by the connection string (must be percent-encoded).' -r -f
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_contains_opt linked no-linked' -l linked -d 'Runs pgTAP tests on the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_contains_opt linked no-linked' -l no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_contains_opt local no-local' -l local -d 'Runs pgTAP tests on the local database.'
complete -c supabase -n '__fish_seen_subcommand_from db; and not __fish_contains_opt local no-local' -l no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from db; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt db-url' -f -a --db-url -d 'Tests the database specified by the connection string (must be percent-encoded).'
complete -c supabase -n '__fish_seen_subcommand_from db; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --linked -d 'Runs pgTAP tests on the linked project.'
complete -c supabase -n '__fish_seen_subcommand_from db; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt linked no-linked' -f -a --no-linked -d 'Disable linked'
complete -c supabase -n '__fish_seen_subcommand_from db; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --local -d 'Runs pgTAP tests on the local database.'
complete -c supabase -n '__fish_seen_subcommand_from db; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt local no-local' -f -a --no-local -d 'Disable local'
complete -c supabase -n '__fish_seen_subcommand_from new' -f
complete -c supabase -n '__fish_seen_subcommand_from new' -l template -s t -d 'Template framework to generate.' -r -f -a pgtap
complete -c supabase -n '__fish_seen_subcommand_from new; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s t template' -f -a --template -d 'Template framework to generate.'
complete -c supabase -n '__fish_seen_subcommand_from unlink' -f
complete -c supabase -n '__fish_seen_subcommand_from vanity-subdomains; and not __fish_seen_subcommand_from get check-availability activate delete' -f
complete -c supabase -n '__fish_seen_subcommand_from vanity-subdomains; and not __fish_seen_subcommand_from get check-availability activate delete' -f -a get -d 'Get the current vanity subdomain'
complete -c supabase -n '__fish_seen_subcommand_from vanity-subdomains; and not __fish_seen_subcommand_from get check-availability activate delete' -f -a check-availability -d 'Check subdomain availability'
complete -c supabase -n '__fish_seen_subcommand_from vanity-subdomains; and not __fish_seen_subcommand_from get check-availability activate delete' -f -a activate -d 'Activate a vanity subdomain'
complete -c supabase -n '__fish_seen_subcommand_from vanity-subdomains; and not __fish_seen_subcommand_from get check-availability activate delete' -f -a delete -d 'Delete the vanity subdomain'
complete -c supabase -n '__fish_seen_subcommand_from get' -f
complete -c supabase -n '__fish_seen_subcommand_from get' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from get; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from check-availability' -f
complete -c supabase -n '__fish_seen_subcommand_from check-availability' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from check-availability' -l desired-subdomain -d 'The desired vanity subdomain to use for your Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from check-availability; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from check-availability; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt desired-subdomain' -f -a --desired-subdomain -d 'The desired vanity subdomain to use for your Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from activate' -f
complete -c supabase -n '__fish_seen_subcommand_from activate' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from activate' -l desired-subdomain -d 'The desired vanity subdomain to use for your Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from activate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from activate; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt desired-subdomain' -f -a --desired-subdomain -d 'The desired vanity subdomain to use for your Supabase project.'
complete -c supabase -n '__fish_seen_subcommand_from delete' -f
complete -c supabase -n '__fish_seen_subcommand_from delete' -l project-ref -d 'Project ref of the Supabase project.' -r -f
complete -c supabase -n '__fish_seen_subcommand_from delete; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt project-ref' -f -a --project-ref -d 'Project ref of the Supabase project.'

###-end-supabase-completions-###
