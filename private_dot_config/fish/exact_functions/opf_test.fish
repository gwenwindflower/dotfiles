function opf_test --description "Test global 1Password environment selection actions"
    set -l functions_dir (path dirname (status filename))
    source $functions_dir/opf.fish

    set -l test_env_dir (mktemp -d)
    set -lx OP_ENV_DIR $test_env_dir
    printf '%s\n' \
        '# global credentials' \
        'FIRST_TOKEN=op://dev/first/credential' \
        'SECOND_TOKEN=$FIRST_TOKEN' \
        'invalid-name=op://dev/invalid/credential' \
        'INVALID_VALUE=plaintext' >$test_env_dir/global.env

    function op
        if test "$argv[1]" != read
            set -g opf_test_unexpected_op_call (string join ' ' -- $argv)
            return 1
        end
        set -ga opf_test_read_uris $argv[-1]
        printf decrypted-first
    end

    function _fzf_wrapper
        set -g opf_test_fzf_args $argv
        set -l selections
        while read -l selection
            set -a selections $selection
        end
        set -g opf_test_fzf_input (string join \n -- $selections)
        printf '%s\n' $opf_test_action $selections
    end

    function fish_clipboard_copy
        set -e opf_test_clipboard
        while read -l line
            set -ga opf_test_clipboard $line
        end
    end

    function logirl
    end

    set -l failures 0

    function assert_equal --no-scope-shadowing --argument-names expected actual message
        if test "$actual" != "$expected"
            printf 'not ok - %s: expected %s, got %s\n' "$message" "$expected" "$actual"
            set failures (math $failures + 1)
        end
    end

    set -g opf_test_action load
    opf
    assert_equal decrypted-first "$FIRST_TOKEN" "enter decrypts an op URI"
    assert_equal decrypted-first "$SECOND_TOKEN" "enter resolves an environment reference"
    assert_equal op://dev/first/credential "$opf_test_read_uris[1]" "enter reads the secret with op"
    assert_equal 1 (count $opf_test_read_uris) "shared references are decrypted once"

    set -g opf_test_action copy-name
    opf
    assert_equal FIRST_TOKEN "$opf_test_clipboard[1]" "ctrl-y copies the first selected name"
    assert_equal SECOND_TOKEN "$opf_test_clipboard[2]" "ctrl-y copies the second selected name"

    set -g opf_test_action copy-value
    opf
    assert_equal op://dev/first/credential "$opf_test_clipboard[1]" "alt-y copies the first selected value"
    assert_equal '$FIRST_TOKEN' "$opf_test_clipboard[2]" "alt-y copies the second selected value"

    set -l fzf_args (string join ' ' -- $opf_test_fzf_args)
    for option in \
        --multi \
        'enter:print(load)+accept' \
        'ctrl-y:print(copy-name)+accept' \
        'alt-y:print(copy-value)+accept'
        if not string match -q "*$option*" -- $fzf_args
            printf 'not ok - configures %s\n' "$option"
            set failures (math $failures + 1)
        end
    end

    if string match -q '*invalid-name*' -- $opf_test_fzf_input
        printf 'not ok - excludes invalid variable names\n'
        set failures (math $failures + 1)
    end
    if string match -q '*INVALID_VALUE*' -- $opf_test_fzf_input
        printf 'not ok - excludes unsupported values\n'
        set failures (math $failures + 1)
    end
    assert_equal '' "$opf_test_unexpected_op_call" "only uses op read"

    command rm -r -- $test_env_dir
    set -e FIRST_TOKEN SECOND_TOKEN opf_test_action opf_test_clipboard opf_test_fzf_args opf_test_fzf_input opf_test_read_uris opf_test_unexpected_op_call
    functions --erase fish_clipboard_copy logirl op _fzf_wrapper assert_equal

    if test $failures -gt 0
        return 1
    end

    printf 'ok - opf decrypts and copies global environment mappings\n'
end
