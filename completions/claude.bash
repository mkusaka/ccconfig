# Bash completion for Claude CLI
# Generated automatically - do not edit manually

_claude() {
    local cur prev words cword
    _init_completion || return

    local commands="config mcp migrate-installer setup-token doctor update install"
    local global_opts="--help -h --version -v --continue -c --resume -r --print -p --api-key --model --permission-mode --stream"
    
    # Main command
    if [ $cword -eq 1 ]; then
        COMPREPLY=($(compgen -W "${commands} ${global_opts}" -- "${cur}"))
        return
    fi

    case "${words[1]}" in
        config)
            if [ $cword -eq 2 ]; then
                local config_subcmds="set get list remove"
                COMPREPLY=($(compgen -W "${config_subcmds}" -- "${cur}"))
            elif [ $cword -eq 3 ] && [ "${words[2]}" = "set" ]; then
                local config_keys="theme model outputdir timeout stream"
                COMPREPLY=($(compgen -W "${config_keys}" -- "${cur}"))
            fi
            ;;
        mcp)
            if [ $cword -eq 2 ]; then
                local mcp_subcmds="list add remove add-from-claude-desktop"
                COMPREPLY=($(compgen -W "${mcp_subcmds}" -- "${cur}"))
            fi
            ;;
        *)
            case "${cur}" in
                -*)
                    COMPREPLY=($(compgen -W "${global_opts}" -- "${cur}"))
                    ;;
            esac
            ;;
    esac
}

complete -F _claude claude
