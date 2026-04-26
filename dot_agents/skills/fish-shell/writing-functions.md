# Writing Fish Functions

Functions live one-per-file in `~/.config/fish/functions/<name>.fish` (chezmoi source: `private_dot_config/fish/functions/`). Filename must match function name; fish autoloads on first use.

## Structure

Scale to complexity, but the canonical shape:

```fish
function funcname -d "Brief description of what this function does"
    argparse h/help 'o/option=' -- $argv
    or return

    if set -q _flag_help
        # help text via logirl (see below)
        return 0
    end

    if not type -q required_cmd
        logirl error "required_cmd not found in PATH"
        return 127
    end

    if test (count $argv) -lt 1
        logirl error "Missing required argument"
        printf "Try: funcname --help\n"
        return 1
    end

    # main logic — guard early, return early
    return 0
end
```

## Argument parsing

Use built-in `argparse`:

```fish
argparse h/help v/verbose -- $argv
or return

argparse 'w/width=' 'o/output=' -- $argv   # flags with values

if set -q _flag_verbose
    echo "Verbose mode enabled"
end
set width $_flag_width
```

Simple positional args without flags:

```fish
function greet -d "Greet someone" --argument-names name
    echo "Hello, $name!"
end
```

## Help text

Required for any function with flags or non-obvious usage. Structure: description → usage → commands (if any) → options → examples (optional). Use `logirl` for consistent formatting:

```fish
if set -q _flag_help
    echo "Brief description of what this function does."
    logirl help_usage "funcname [OPTIONS] <required_arg>"
    logirl help_header "Options"
    logirl help_flag "h/help" "Show this help message"
    logirl help_flag "v/verbose" "Enable verbose output"
    logirl help_flag "o/output" "FILE" "Specify output file path"
    logirl help_header "Examples"
    printf "  funcname file.txt\n"
    printf "  funcname -v -o out.txt in\n"
    return 0
end
```

Patterns:

- `echo` for the one-sentence description
- `help_usage` for the Usage line (avoids double spacing from consecutive `help_header`)
- `help_header` takes 1 arg (Options, Examples, Commands, …)
- `help_flag "h/help" "desc"` for booleans; `help_flag "o/output" "FILE" "desc"` for valued flags

For more, see [logirl reference](logirl-custom-logging-framework.md).

## Error handling and exit codes

Use `logirl` for all structured messages:

```fish
logirl error "File not found: $filepath"
logirl warning "Deprecated flag used"
logirl info "Processing 42 files"
logirl success "Build completed successfully"
logirl special "Step 1: Installing dependencies"
```

Always pair errors with a return code:

```fish
if not test -f "$file"
    logirl error "File not found: $file"
    return 1
end
```

Conventions:

- `0` success
- `1` general error (bad input, file not found)
- `2` usage error (wrong arguments)
- `127` missing dependency

For pipeable functions not using `logirl`, write to stderr: `echo "msg" >&2`. Deeper patterns: [error handling best practices](error-handling-best-practices.md).

## Dependency checks

```fish
if not type -q ffmpeg
    logirl error "ffmpeg not found in PATH"
    logirl info "Install with: brew install ffmpeg"
    return 127
end
```

## Variable scopes

```fish
set -l local_var "value"      # local to function (default)
set -g global_var "value"     # session-global
set -gx EXPORTED_VAR "value"  # exported to children
set -U universal_var "value"  # persists across sessions (sparingly)
```

## Conditionals and tests

```fish
if set -q MY_VAR;        end       # variable set?
if test -z "$MY_VAR";    end       # empty/unset?
if test -f "$filepath";  end       # file/dir/readable/writable/executable: -f -d -r -w -x
if test "$var" = "value"; end      # equality (single =)
if test $count -gt 0;    end       # numeric: -gt -eq -lt -ge -le -ne

# compound
if test -f "$file"; and test -r "$file"; end
if test -z "$var"; or test "$var" = "default"; end
```

## Command success

```fish
some_command
if test $status -ne 0
    return 1
end

some_command; and echo "ok"; or echo "fail"

set -l output (some_command 2>&1)
test $status -eq 0; and echo "got: $output"
```

## Colors

Prefer `logirl` for structured messages. Drop to `set_color` only for custom output:

```fish
set_color red
set_color --bold red
set_color brred              # bright red
set_color brblack            # gray (good for "disabled")
echo "Status: "(set_color green)"OK"(set_color normal)
set_color normal             # always reset
```

### Color conventions (handled by logirl)

- Help body normal, headings green, commands bold, flags blue italics
- Error tags red bold, error messages red
- Warning tags bright yellow bold, messages bright yellow
- Info tags cyan bold, messages normal
- Success tags bright green bold, messages bright green
- Special (progress) tags bright magenta bold, messages bright magenta

## Interactive prompts

Prefer `gum` for polished components, fall back to `read`:

```fish
if gum confirm "Delete files?"
    rm *.tmp
    logirl success "Files deleted"
end

set name (gum input --placeholder "Enter name")
set option (gum choose "Option 1" "Option 2" "Option 3")

read -P "Continue? (y/N) " -n 1 response
test "$response" = y; or test "$response" = Y; and echo "continuing"
read -P "Password: " -s password
```

For more: [gum reference](charm-gum-shell-script-helper-cli.md).

## String manipulation

Use the `string` builtin:

```fish
string replace "old" "new" -- $var
string replace -r 'pattern' 'replacement' -- $var
string split "/" -- $path
string join "," -- $list
string match -q "*.fish" -- $filename
string trim -- $var
string length $var
```

## Loops

```fish
for file in *.fish
    echo "Processing $file"
end

for i in (seq 1 10); echo $i; end

while read -l line
    echo "$line"
end < file.txt

set -l items a b c
for i in (seq (count $items))
    echo "$i: $items[$i]"
end
```

## Private helpers

Prefix with underscore:

```fish
function _myhelper -d "Internal helper"
end

function myfunc -d "Public function"
    _myhelper arg1 arg2
end
```

## Common patterns

### Wrapper with defaults

```fish
function mygrep -d "Ripgrep with my preferred defaults"
    rg --smart-case --hidden --glob '!.git' $argv
end
```

### Directory navigation

```fish
function proj -d "Jump to project directory"
    z ~/Projects/$argv[1]
end
```

### fzf integration

```fish
function ffile -d "Find and open file with fzf"
    set -l file (fd --type f | fzf --preview 'bat --color=always {}')
    test -n "$file"; and $EDITOR $file
end
```

### Confirm before destructive action

```fish
function cleanup -d "Remove temp files with confirmation"
    if not type -q gum
        logirl error "gum not found in PATH"
        logirl info "Install with: brew install gum"
        return 127
    end

    set -l files (fd -t f -e tmp -e temp)
    if test (count $files) -eq 0
        logirl info "No temp files found"
        return 0
    end

    logirl warning "Found "(count $files)" temp files"
    printf "  %s\n" $files

    if not gum confirm "Delete these files?"
        logirl info "Cancelled"
        return 0
    end

    rm $files
    logirl success "Deleted "(count $files)" files"
end
```

## Worked examples

### Simple, no flags

```fish
function wthr -d "Get weather for a location (default: Chicago)"
    set -l location (string join "+" $argv)
    test -z "$location"; and set location chicago
    curl -s "wttr.in/$location"
end
```

### Flags + validation

```fish
function imgopt -d "Optimize images with optional resize"
    argparse h/help 'w/width=' q/quality= -- $argv
    or return

    if set -q _flag_help
        echo "Optimize and optionally resize images."
        logirl help_usage "imgopt [OPTIONS] <image>"
        logirl help_header "Options"
        logirl help_flag "h/help" "Show this help"
        logirl help_flag "w/width" "PX" "Resize to width (preserves aspect)"
        logirl help_flag "q/quality" "N" "Quality 1-100 (default: 80)"
        return 0
    end

    if not type -q magick
        logirl error "ImageMagick not found"
        logirl info "Install: brew install imagemagick"
        return 127
    end

    if test (count $argv) -lt 1
        logirl error "No image specified"
        printf "Try: imgopt --help\n"
        return 1
    end

    set -l input $argv[1]
    if not test -f "$input"
        logirl error "File not found: $input"
        return 1
    end

    set -l quality 80
    set -q _flag_quality; and set quality $_flag_quality

    set -l resize_arg ""
    set -q _flag_width; and set resize_arg "-resize $_flag_width"

    set -l output (string replace -r '\.[^.]+$' '_optimized.jpg' -- $input)

    logirl info "Optimizing $input..."
    magick $input $resize_arg -quality $quality $output
    if test $status -eq 0
        logirl success "Created: $output"
    else
        logirl error "Optimization failed"
        return 1
    end
end
```

### Multi-step with progress

```fish
function deploy -d "Deploy the current project"
    argparse h/help d/dry-run -- $argv
    or return

    if set -q _flag_help
        echo "Deploy the current project."
        logirl help_usage "deploy [OPTIONS]"
        logirl help_header "Options"
        logirl help_flag "h/help" "Show help"
        logirl help_flag "d/dry-run" "Show what would happen"
        return 0
    end

    set -q _flag_dry_run; and logirl warning "DRY-RUN mode enabled"

    logirl special "Step 1: Running tests"
    if not set -q _flag_dry_run
        npm test; or begin
            logirl error "Tests failed, aborting deploy"
            return 1
        end
    end

    logirl special "Step 2: Building project"
    set -q _flag_dry_run; or npm run build

    logirl special "Step 3: Deploying to server"
    set -q _flag_dry_run; or rsync -avz ./dist/ server:/var/www/

    logirl success "Deploy complete!"
end
```

## Do / Don't

**Do:**

- Always include `-d "description"`
- Add `--help` for any function with flags or non-obvious usage
- Use `logirl` for all structured messages
- Always pair `logirl error` with a `return` code
- Validate inputs and dependencies before processing
- Use `set -l` for locals
- Prefer `test`, `type -q`, `string` (fish idioms)

**Don't:**

- Use bash/zsh syntax (`[[ ]]`, `VAR=value`, bare `$(...)`)
- Forget `or return` after `argparse`
- Hard-code paths with usernames
- Mix logging styles (`set_color`+`echo` for things `logirl` covers)
- Forget `(set_color normal)` after a custom color
- Use `echo -e` (use `printf`)

## Testing

After creating or modifying a function:

1. Reload fish: `source ~/.config/fish/config.fish` or `fresh -r` in a fish subshell
2. Test with various inputs and `--help`
3. Test error cases (missing args, bad input, missing deps)
4. Verify colors render correctly

From bash (this environment): `fish -c "<commands>"`. New `.fish` files are picked up automatically by each new subshell after `chezmoi apply`. Prefer asking the user to test interactive features.
