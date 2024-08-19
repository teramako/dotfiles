function rm --description "use trash command!!"
    set_color yellow
    figlet "use 'trash' command."
    set_color normal

    set -l rm_command (command -v rm)
    $rm_command $argv
end
