
if status is-interactive
    abbr -a vi vim
    bind --preset \cg\cf forward-bigword
    bind --preset \cg\cb backward-bigword

    complete -f	-c dotnet -a "(dotnet complete (commandline -cp))"
end

