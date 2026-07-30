function et_test -d "Test exe.dev VM profile selection and bootstrap"
    set -l functions_dir (path dirname (status filename))
    source $functions_dir/et.fish

    function logirl
    end

    function ssh
        set -g et_test_ssh_args $argv
    end

    set -l default_profile (_et_resolve_machine_profile)
    if test "$default_profile" != work
        printf "not ok - work is the default machine profile\n"
        return 1
    end

    set -l selected_profile (_et_resolve_machine_profile personal)
    if test "$selected_profile" != personal
        printf "not ok - machine profile can be overridden\n"
        return 1
    end

    _et_resolve_machine_profile unknown >/dev/null
    if test $status -ne 2
        printf "not ok - unknown machine profiles are rejected\n"
        return 1
    end

    _et_bootstrap_chezmoi phosphor-test-1.exe.xyz $selected_profile

    set -l expected_command 'export CHEZMOI_ONESHOT=1; sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot --promptChoice "Machine profile=personal" gwenwindflower'
    if test "$et_test_ssh_args[1]" != phosphor-test-1.exe.xyz
        printf "not ok - bootstrap targets the VM\n"
        return 1
    end
    if test "$et_test_ssh_args[2]" != "$expected_command"
        printf "not ok - bootstrap supplies the selected machine profile\n"
        return 1
    end

    printf "ok - et selects and supplies the exe.dev machine profile\n"
end
