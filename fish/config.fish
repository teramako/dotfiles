
if status is-interactive
    abbr -a vi vim
    bind \cg\cf forward-bigword
    bind \cg\cb backward-bigword

    complete -f	-c dotnet -a "(dotnet complete (commandline -cp))"
end

