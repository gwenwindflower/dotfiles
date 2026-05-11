function supernav-prev -d "On empty cmdline go back a directory; otherwise kill word backward"
    if commandline -P
        commandline -f backward-kill-word
        return
    end
    if test -z (commandline)
        prevd
        commandline -f repaint
    else
        commandline -f backward-kill-word
    end
end
