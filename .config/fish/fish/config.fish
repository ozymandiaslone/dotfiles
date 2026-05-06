if status is-interactive
    # Commands to run in interactive sessions can go here
end

function smart_tab
    if test (commandline -t) != ""
        commandline -f accept-autosuggestion
    else
        commandline -f complete
    end
end

bind \t smart_tab



function l
    ls -la $argv
end

function v 
  nvim $argv
end
set -x TERM xterm-256color
alias fm="~/scripts/fleet-mount"
