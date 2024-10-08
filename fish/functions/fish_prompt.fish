# Original is defined in /usr/share/fish/functions/fish_prompt.fish @ line 4
function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -l normal (set_color normal)

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l prefix
    set -l suffix '>'
    if contains -- $USER root toor
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # If we're running via SSH, change the host color.
    set -l color_host $fish_color_host
    if set -q SSH_TTY
        set color_host $fish_color_host_remote
    end

    # Write pipestatus
    set -l prompt_status (__fish_print_pipestatus " [" "]" "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus)


    # VIRTUAL_ENV
    set -l virtualenv ""
    if set -q VIRTUAL_ENV_PROMPT
        set virtualenv " " (set_color magenta) (string trim $VIRTUAL_ENV_PROMPT)
    end

    echo -n -s (set_color $fish_color_user) "$USER" $normal \
        @ (set_color $color_host) (prompt_hostname) $normal \
        ' ' (set_color $color_cwd) (prompt_pwd) $normal \
        $virtualenv $normal \
        (fish_vcs_prompt " %s") $normal \
        $prompt_status \
        $suffix " "
end
