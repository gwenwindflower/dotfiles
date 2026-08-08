function semtrim_test -d "Test semantic version component selection"
    set -l functions_dir (path dirname (status filename))
    source $functions_dir/semtrim.fish

    function logirl
        printf '%s: %s\n' $argv[1] $argv[2] >&2
    end

    set -l failures 0

    function assert_semtrim --no-scope-shadowing --argument-names expected
        set -e argv[1]
        set -l actual (semtrim $argv)
        set -l command_status $status

        if test $command_status -ne 0; or test "$actual" != "$expected"
            printf 'not ok - semtrim %s: expected %s, got %s (status %s)\n' \
                (string join ' ' -- $argv) $expected $actual $command_status
            set failures (math $failures + 1)
        end
    end

    assert_semtrim 1.2 1.2.3
    assert_semtrim 1.2 v1.2.3
    assert_semtrim v1.2 --use-v 1.2.3
    assert_semtrim v1.2 --use-v v1.2.3
    assert_semtrim 1 --major 1.2.3
    assert_semtrim 2 --minor 1.2.3
    assert_semtrim 3 --patch 1.2.3
    assert_semtrim 1.2 --major --minor 1.2.3
    assert_semtrim 2.3 --minor --patch 1.2.3
    assert_semtrim 1.2.3 --major --minor --patch 1.2.3
    assert_semtrim v3 --use-v --patch v1.2.3

    set -l invalid_output (semtrim --major --patch 1.2.3 2>&1)
    set -l invalid_status $status
    if test $invalid_status -ne 2; or not string match -q '*without --minor*' -- $invalid_output
        printf 'not ok - rejects noncontiguous component selections\n'
        set failures (math $failures + 1)
    end

    semtrim -v 1.2.3 >/dev/null 2>&1
    if test $status -ne 2
        printf 'not ok - reserves -v for conventional version output\n'
        set failures (math $failures + 1)
    end

    functions --erase assert_semtrim logirl

    if test $failures -gt 0
        return 1
    end

    printf 'ok - semtrim composes contiguous semantic version components\n'
end
