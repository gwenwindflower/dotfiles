# Fish shell completions for Simon Willison's `llm`
# https://llm.datasette.io/

complete -c llm -f

#
# Global options
#
complete -c llm -l help -s h -d "Show help and exit"
complete -c llm -l version -d "Show version and exit"

#
# Top-level commands
#
complete -c llm -n __fish_use_subcommand -a prompt -d "Execute a prompt"
complete -c llm -n __fish_use_subcommand -a chat -d "Hold an ongoing chat with a model"
complete -c llm -n __fish_use_subcommand -a keys -d "Manage stored API keys"
complete -c llm -n __fish_use_subcommand -a logs -d "Explore logged prompts and responses"
complete -c llm -n __fish_use_subcommand -a models -d "Manage available models"
complete -c llm -n __fish_use_subcommand -a templates -d "Manage prompt templates"
complete -c llm -n __fish_use_subcommand -a schemas -d "Manage stored schemas"
complete -c llm -n __fish_use_subcommand -a tools -d "Manage tools"
complete -c llm -n __fish_use_subcommand -a aliases -d "Manage model aliases"
complete -c llm -n __fish_use_subcommand -a fragments -d "Manage stored fragments"
complete -c llm -n __fish_use_subcommand -a plugins -d "List installed plugins"
complete -c llm -n __fish_use_subcommand -a install -d "Install Python packages"
complete -c llm -n __fish_use_subcommand -a uninstall -d "Uninstall Python packages"
complete -c llm -n __fish_use_subcommand -a embed -d "Embed text"
complete -c llm -n __fish_use_subcommand -a embed-multi -d "Embed multiple strings"
complete -c llm -n __fish_use_subcommand -a embed-models -d "Manage embedding models"
complete -c llm -n __fish_use_subcommand -a collections -d "Manage embedding collections"
complete -c llm -n __fish_use_subcommand -a similar -d "Find similar embeddings"
complete -c llm -n __fish_use_subcommand -a openai -d "OpenAI-specific commands"

#
# prompt
#
complete -c llm -n "__fish_seen_subcommand_from prompt" -l model -s m -d "Model to use"
complete -c llm -n "__fish_seen_subcommand_from prompt" -l system -d "System prompt"
complete -c llm -n "__fish_seen_subcommand_from prompt" -l temperature -d "Sampling temperature"
complete -c llm -n "__fish_seen_subcommand_from prompt" -l json -d "Output JSON"
complete -c llm -n "__fish_seen_subcommand_from prompt" -l schema -d "JSON schema to validate against"

#
# chat
#
complete -c llm -n "__fish_seen_subcommand_from chat" -l model -s m -d "Model to use"
complete -c llm -n "__fish_seen_subcommand_from chat" -l system -d "System prompt"
complete -c llm -n "__fish_seen_subcommand_from chat" -l temperature -d "Sampling temperature"

#
# keys
#
complete -c llm -n "__fish_seen_subcommand_from keys" -a list -d "List stored keys"
complete -c llm -n "__fish_seen_subcommand_from keys" -a get -d "Get a stored key"
complete -c llm -n "__fish_seen_subcommand_from keys" -a set -d "Set a key"
complete -c llm -n "__fish_seen_subcommand_from keys" -a path -d "Show keys file path"

#
# logs
#
complete -c llm -n "__fish_seen_subcommand_from logs" -a list -d "List logs"
complete -c llm -n "__fish_seen_subcommand_from logs" -a status -d "Show logging status"
complete -c llm -n "__fish_seen_subcommand_from logs" -a on -d "Enable logging"
complete -c llm -n "__fish_seen_subcommand_from logs" -a off -d "Disable logging"
complete -c llm -n "__fish_seen_subcommand_from logs" -a path -d "Show log database path"
complete -c llm -n "__fish_seen_subcommand_from logs" -a backup -d "Backup logs database"

#
# models
#
complete -c llm -n "__fish_seen_subcommand_from models" -a list -d "List models"
complete -c llm -n "__fish_seen_subcommand_from models" -a default -d "Get or set default model"
complete -c llm -n "__fish_seen_subcommand_from models" -a options -d "Manage model options"

complete -c llm -n "__fish_seen_subcommand_from models; and __fish_seen_subcommand_from options" \
    -a list -d "List model options"
complete -c llm -n "__fish_seen_subcommand_from models; and __fish_seen_subcommand_from options" \
    -a show -d "Show model options"
complete -c llm -n "__fish_seen_subcommand_from models; and __fish_seen_subcommand_from options" \
    -a set -d "Set a model option"
complete -c llm -n "__fish_seen_subcommand_from models; and __fish_seen_subcommand_from options" \
    -a clear -d "Clear model options"

#
# templates
#
complete -c llm -n "__fish_seen_subcommand_from templates" -a list -d "List templates"
complete -c llm -n "__fish_seen_subcommand_from templates" -a show -d "Show a template"
complete -c llm -n "__fish_seen_subcommand_from templates" -a edit -d "Edit a template"
complete -c llm -n "__fish_seen_subcommand_from templates" -a path -d "Show templates path"
complete -c llm -n "__fish_seen_subcommand_from templates" -a loaders -d "List template loaders"

#
# schemas
#
complete -c llm -n "__fish_seen_subcommand_from schemas" -a list -d "List schemas"
complete -c llm -n "__fish_seen_subcommand_from schemas" -a show -d "Show a schema"
complete -c llm -n "__fish_seen_subcommand_from schemas" -a dsl -d "Schema DSL help"

#
# aliases
#
complete -c llm -n "__fish_seen_subcommand_from aliases" -a list -d "List aliases"
complete -c llm -n "__fish_seen_subcommand_from aliases" -a set -d "Set an alias"
complete -c llm -n "__fish_seen_subcommand_from aliases" -a remove -d "Remove an alias"
complete -c llm -n "__fish_seen_subcommand_from aliases" -a path -d "Show aliases file path"

#
# fragments
#
complete -c llm -n "__fish_seen_subcommand_from fragments" -a list -d "List fragments"
complete -c llm -n "__fish_seen_subcommand_from fragments" -a set -d "Set a fragment"
complete -c llm -n "__fish_seen_subcommand_from fragments" -a show -d "Show a fragment"
complete -c llm -n "__fish_seen_subcommand_from fragments" -a remove -d "Remove a fragment"
complete -c llm -n "__fish_seen_subcommand_from fragments" -a loaders -d "List fragment loaders"

#
# embed-models
#
complete -c llm -n "__fish_seen_subcommand_from embed-models" -a list -d "List embedding models"
complete -c llm -n "__fish_seen_subcommand_from embed-models" -a default -d "Get or set default embedding model"

#
# collections
#
complete -c llm -n "__fish_seen_subcommand_from collections" -a list -d "List collections"
complete -c llm -n "__fish_seen_subcommand_from collections" -a delete -d "Delete a collection"
complete -c llm -n "__fish_seen_subcommand_from collections" -a path -d "Show collections path"

#
# openai
#
complete -c llm -n "__fish_seen_subcommand_from openai" -a models -d "List OpenAI models"

function __fish_llm_models
    llm models list 2>/dev/null \
        | awk -F':' '{print $2}' \
        | awk '{print $1}'
end

complete -c llm -n "__fish_seen_subcommand_from prompt" \
    -s m -l model -ra "(__fish_llm_models)" -d "Model to use"
