
if status is-interactive
    abbr -a vi vim
    abbr -a dc docker compose
    abbr -a tp tmux-popup

    abbr -a '-' prevd
    abbr -a '+' nextd

    bind \cg\cf forward-bigword
    bind \cg\cb backward-bigword

    complete -f	-c dotnet -a "(dotnet complete (commandline -cp))"

    # Prompt color
    set ___fish_git_prompt_color_prefix (set_color yellow)

    if set -q TMUX_POPUP
        figlet TMUX POPUP
    end
end

