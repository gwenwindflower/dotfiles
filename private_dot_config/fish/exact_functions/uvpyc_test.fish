function uvpyc_test -d "Test Python patch upgrades and cleanup"
    set -l functions_dir (path dirname (status filename))
    if not test -f $functions_dir/uvpyc.fish
        printf 'not ok - uvpyc is not implemented\n'
        return 1
    end
    source $functions_dir/uvpyc.fish

    function logirl
        printf '%s: %s\n' $argv[1] $argv[2]
    end

    function uv
        switch $argv[2]
            case list
                if test "$uvpyc_test_failure" = list
                    return 1
                end
                echo $uvpyc_test_catalog
            case install
                set -ga uvpyc_test_actions "install $argv[-1]"
                if test "$uvpyc_test_failure" = install
                    return 1
                end
                set -g uvpyc_test_catalog (printf '%s' "$uvpyc_test_catalog" | jq --arg key $argv[-1] \
                    'map(if .key == $key then .path = "/managed/bin/python" else . end)')
            case uninstall
                set -ga uvpyc_test_actions "uninstall $argv[-1]"
                if test "$uvpyc_test_failure" = uninstall
                    return 1
                end
                set -g uvpyc_test_catalog (printf '%s' "$uvpyc_test_catalog" | jq --arg key $argv[-1] \
                    'map(select(.key != $key))')
            case '*'
                return 1
        end
    end

    function uvpyc_fixture
        set -g uvpyc_test_actions
        set -g uvpyc_test_failure
        set -g uvpyc_test_catalog (printf '%s\n' $argv | jq -Rn '
            [inputs | select(length > 0) | split(":") | . as $input
            | ($input[0] | split(".") | map(tonumber? // 0)) as $parts
            | {key: ("cpython-" + $input[0] + "-linux-x86_64-gnu"),
               implementation: "cpython", variant: "default", os: "linux",
               arch: "x86_64", libc: "gnu", version: $input[0],
               version_parts: {major: $parts[0], minor: $parts[1], patch: $parts[2]},
               path: (if $input[1] == "installed" then "/managed/bin/python" else null end)}]')
    end

    set -l failures 0
    function uvpyc_assert --no-scope-shadowing --argument-names expected actual message
        if test "$expected" != "$actual"
            printf 'not ok - %s: expected <%s>, got <%s>\n' "$message" "$expected" "$actual"
            set failures (math $failures + 1)
        end
    end

    uvpyc_fixture 3.14.5:installed 3.14.7:available 3.14.8rc1:available 3.11.9:available
    set -l output (uvpyc)
    uvpyc_assert 0 $status 'report succeeds'
    uvpyc_assert 1 (count $output) 'only the installed minor needs upgrading'
    uvpyc_assert 1 (count (string match -r 'Upgrade.*3[.]14[.]7' -- $output)) 'selects the latest GA patch'
    uvpyc_assert 0 (count $uvpyc_test_actions) 'report does not mutate installs'

    uvpyc --only-clean >/dev/null
    uvpyc_assert 0 (count $uvpyc_test_actions) 'clean preserves patches until latest is installed'

    uvpyc --fix >/dev/null
    uvpyc_assert 0 $status 'combined fix succeeds'
    uvpyc_assert 'install cpython-3.14.7-linux-x86_64-gnu,uninstall cpython-3.14.5-linux-x86_64-gnu' \
        (string join , -- $uvpyc_test_actions) 'upgrade precedes cleanup after refreshing installed state'

    uvpyc_fixture 3.14.5:installed 3.14.7:installed 3.14.6:installed 3.14.7:installed 3.14.8b1:installed
    uvpyc --only-clean --fix >/dev/null
    uvpyc_assert 'uninstall cpython-3.14.5-linux-x86_64-gnu,uninstall cpython-3.14.6-linux-x86_64-gnu' \
        (string join , -- $uvpyc_test_actions) 'cleanup deduplicates executables and preserves prereleases'

    uvpyc_fixture 3.14.9:available 3.14.7:installed 3.13.9:installed 3.13.10:available
    uvpyc --only-upgrade --fix >/dev/null
    uvpyc_assert 'install cpython-3.13.10-linux-x86_64-gnu,install cpython-3.14.9-linux-x86_64-gnu' \
        (string join , -- $uvpyc_test_actions) 'each installed minor upgrades numerically without cleanup'

    uvpyc_fixture 3.14.5:installed 3.14.7:available
    set -g uvpyc_test_catalog (printf '%s' "$uvpyc_test_catalog" | jq '
        . + [.[1] | .variant = "freethreaded" | .path = "/managed/threaded/python"
            | .key = "cpython-3.14.7+freethreaded-linux-x86_64-gnu"]
          + [.[1] | .arch = "aarch64" | .path = "/managed/arm/python"
            | .key = "cpython-3.14.7-linux-aarch64-gnu"]')
    uvpyc --only-clean --fix >/dev/null
    uvpyc_assert 0 (count $uvpyc_test_actions) 'other variants and architectures do not enable cleanup'
    uvpyc --only-upgrade --fix >/dev/null
    uvpyc_assert 'install cpython-3.14.7-linux-x86_64-gnu' \
        (string join , -- $uvpyc_test_actions) 'other variants and architectures do not satisfy upgrades'

    uvpyc_fixture 3.16.0a1:installed 3.16.0b1:available
    uvpyc --fix >/dev/null
    uvpyc_assert 0 $status 'lanes without a GA release are skipped'
    uvpyc_assert 0 (count $uvpyc_test_actions) 'prerelease-only lanes are untouched'

    uvpyc_fixture 3.14.5:installed 3.14.7:available
    set -g uvpyc_test_catalog (printf '%s' "$uvpyc_test_catalog" | jq 'map(.implementation = "pypy")')
    uvpyc --fix >/dev/null
    uvpyc_assert 0 (count $uvpyc_test_actions) 'other implementations are untouched'

    for failure in list install
        uvpyc_fixture 3.14.5:installed 3.14.7:available
        set -g uvpyc_test_failure $failure
        uvpyc --fix >/dev/null 2>&1
        uvpyc_assert 1 $status "$failure failure is reported"
        uvpyc_assert 0 (count (string match 'uninstall *' -- $uvpyc_test_actions)) 'failure prevents removal'
    end

    uvpyc_fixture 3.14.5:installed 3.14.7:installed
    set -g uvpyc_test_failure uninstall
    uvpyc --fix >/dev/null 2>&1
    uvpyc_assert 1 $status 'uninstall failure is reported'

    set -g uvpyc_test_failure
    set -g uvpyc_test_catalog invalid-json
    uvpyc --fix >/dev/null 2>&1
    uvpyc_assert 1 $status 'invalid catalog data is rejected'

    uvpyc --only-clean --only-upgrade >/dev/null 2>&1
    uvpyc_assert 2 $status 'conflicting check selectors are rejected'
    uvpyc unexpected >/dev/null 2>&1
    uvpyc_assert 2 $status 'positional arguments are rejected'

    uvpyc_fixture
    uvpyc --fix >/dev/null
    uvpyc_assert 0 $status 'empty installations succeed'
    uvpyc_assert 0 (count $uvpyc_test_actions) 'empty installations stay empty'

    functions --erase uv logirl uvpyc_fixture uvpyc_assert
    set -e uvpyc_test_catalog uvpyc_test_actions uvpyc_test_failure
    if test $failures -gt 0
        return 1
    end
    printf 'ok - uvpyc upgrades installed minor lanes and cleans superseded patches\n'
end
