function supernav-next -d "On empty cmdline go forward a directory; otherwise move forward a word, accepting autosuggestion at line end"
    if commandline -P
        commandline -f forward-word
        return
    end
    if test -z (commandline)
        nextd
        commandline -f repaint
    else
        commandline -f forward-word
    end
end
