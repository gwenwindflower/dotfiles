function af_test
    abbr --add native_abbr "echo native"
    abbr --add am_active "echo duplicate"
    alias native_alias "echo aliased"

    function native_function -d "Run the native function"
        echo function
    end

    function am
        printf '%s\n' \
            '🌐 global' \
            '│  ╰─ am_active → echo active' \
            '│' \
            '╰─● work (active: 1)' \
            '    ╰─ work_alias → echo work' \
            '    ╰─ project (/tmp/example/.aliases)' \
            '        ╰─ project_alias → echo project' \
            '' \
            '○ dormant' \
            '  ╰─ dormant_alias → echo dormant'
    end

    function fzf
        set -l amoxide_record
        set -l function_record

        while read -l line
            printf '%s\n' $line
            string match -rq '^amoxide\twork_alias\t' -- $line; and set amoxide_record $line
            string match -rq '^function\tnative_function\t' -- $line; and set function_record $line
        end

        set -l preview
        for option in $argv
            if string match -q -- '--preview=*' $option
                set preview (string replace -- '--preview=' '' $option)
                break
            end
        end

        printf '\n__amoxide_preview__\n'
        string replace -- '{}' (string escape -- $amoxide_record) $preview | source
        printf '\n__function_preview__\n'
        string replace -- '{}' (string escape -- $function_record) $preview | source
        printf '\n__fzf_args__\t%s\n' (string join \t -- $argv)
    end

    set -g output (af seed)
    set -g failures 0

    function assert_match --argument-names pattern message
        if not string match -rq -- $pattern $output
            printf 'not ok - %s\n' $message
            set -g failures (math $failures + 1)
        end
    end

    function assert_no_match --argument-names pattern message
        if string match -rq -- $pattern $output
            printf 'not ok - %s\n' $message
            set -g failures (math $failures + 1)
        end
    end

    assert_match '^abbr\tnative_abbr\tfish\t\t' "lists Fish abbreviations"
    assert_match '^alias\tnative_alias\tfish\t\t' "lists Fish aliases"
    assert_match '^function\tnative_function\t[^\t]+\t\t' "lists Fish functions"
    assert_no_match '^function\tnative_alias\t' "does not duplicate aliases as functions"
    assert_match '^amoxide\tam_active\tglobal\tactive\techo active$' "lists active global amoxide aliases"
    assert_match '^amoxide\twork_alias\tprofile:work\tactive\techo work$' "shows an active amoxide profile"
    assert_match '^amoxide\tproject_alias\tproject:/tmp/example/.aliases\tactive\techo project$' "shows an active amoxide project"
    assert_match '^amoxide\tdormant_alias\tprofile:dormant\tinactive\techo dormant$' "shows an inactive amoxide profile"
    assert_no_match '^abbr\tam_active\t' "does not duplicate active amoxide abbreviations"
    assert_match '__fzf_args__\t.*--query=seed' "passes the initial query to fzf"
    assert_match '__fzf_args__\t.*--preview=' "configures a preview"
    assert_match '^AMOXIDE: work_alias$' "previews amoxide aliases"
    assert_match '^scope: profile:work$' "previews amoxide scope"
    assert_match '^state: active$' "previews amoxide state"
    assert_match '^echo work$' "previews amoxide expansion"
    assert_match '^FUNCTION: native_function$' "previews Fish functions"
    assert_match '^function native_function' "previews Fish function definitions"

    if test $failures -gt 0
        return 1
    end

    printf 'ok - af searches Fish and amoxide command shortcuts\n'
end
