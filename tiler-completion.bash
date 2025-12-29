#!/bin/bash
# Bash completion for tiler - X11 Window Tiling Tool

_tiler_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # All available options
    opts="-h --help -a --for-app -r --aspect-ratio -H --horizontal -V --vertical -m --margin --circular --circular-radius --circular-margin --circular-width"

    # Handle option-specific completions
    case "${prev}" in
        -a|--for-app)
            # Complete with running application names
            local apps
            if command -v ps >/dev/null 2>&1; then
                # Get unique process names, excluding common system processes
                apps=$(ps -eo comm --no-headers | sort -u | grep -v -E '^(kthreadd|ksoftirqd|migration|rcu_|watchdog|systemd|dbus|NetworkManager|pulseaudio|gdm|gnome-|unity-|plasma|kwin|Xorg|lightdm|sddm)' | head -20)
                COMPREPLY=( $(compgen -W "${apps}" -- ${cur}) )
            fi
            return 0
            ;;
        -r|--aspect-ratio)
            # Common aspect ratios
            local ratios="16:9 4:3 16:10 21:9 32:9 1:1 3:2 5:4"
            COMPREPLY=( $(compgen -W "${ratios}" -- ${cur}) )
            return 0
            ;;
        -m|--margin)
            # Suggest common margin values
            local margins="5 10 15 20 25 30"
            COMPREPLY=( $(compgen -W "${margins}" -- ${cur}) )
            return 0
            ;;
        --circular-radius)
            # Suggest radius values (pixels and percentages)
            local radius="100 150 200 250 300 20% 25% 30% 35% 40% 45% 50%"
            COMPREPLY=( $(compgen -W "${radius}" -- ${cur}) )
            return 0
            ;;
        --circular-margin)
            # Suggest margin values for circular layout
            local margins="5 10 15 20 25 30 40 50"
            COMPREPLY=( $(compgen -W "${margins}" -- ${cur}) )
            return 0
            ;;
        --circular-width)
            # Suggest width values (pixels and percentages)
            local widths="100 120 150 180 200 250 300 15% 20% 25% 30% 35%"
            COMPREPLY=( $(compgen -W "${widths}" -- ${cur}) )
            return 0
            ;;
    esac

    # Handle multi-value options (like margins)
    if [[ ${COMP_WORDS[COMP_CWORD-2]} == "-m" || ${COMP_WORDS[COMP_CWORD-2]} == "--margin" ]]; then
        # For second, third, fourth margin values
        local margins="5 10 15 20 25 30"
        COMPREPLY=( $(compgen -W "${margins}" -- ${cur}) )
        return 0
    fi

    # Check if we're in the middle of margin specification (up to 4 values)
    local margin_count=0
    local i
    for (( i=1; i<${#COMP_WORDS[@]}; i++ )); do
        if [[ ${COMP_WORDS[i]} == "-m" || ${COMP_WORDS[i]} == "--margin" ]]; then
            # Count how many margin values follow
            local j=$((i+1))
            while [[ $j -lt ${#COMP_WORDS[@]} && ${COMP_WORDS[j]} != -* ]]; do
                margin_count=$((margin_count+1))
                j=$((j+1))
            done
            break
        fi
    done

    # If we're completing margin values and haven't reached the limit
    if [[ $margin_count -gt 0 && $margin_count -lt 4 && ${COMP_WORDS[COMP_CWORD-1]} =~ ^[0-9]+$ ]]; then
        local margins="5 10 15 20 25 30"
        COMPREPLY=( $(compgen -W "${margins}" -- ${cur}) )
        return 0
    fi

    # Default completion with all options
    if [[ ${cur} == -* ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi

    # If no specific completion, offer common options
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

# Register the completion function
complete -F _tiler_completion tiler
