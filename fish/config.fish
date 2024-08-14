
if status is-interactive
    abbr -a vi vim
    abbr -a dc docker compose
    abbr -a tp tmux-popup

    bind \cg\cf forward-bigword
    bind \cg\cb backward-bigword

    complete -f	-c dotnet -a "(dotnet complete (commandline -cp))"

    # Prompt color
    set ___fish_git_prompt_color_prefix (set_color yellow)
end

