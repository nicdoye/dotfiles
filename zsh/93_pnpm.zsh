#!/bin/zsh

# pnpm
export PNPM_HOME="${HOME}/Library/pnpm"

if [ -d "$PNPM_HOME" ]; then
    case ":$PATH:" in
        *":$PNPM_HOME/bin:"*) ;;
        *) export PATH="$PNPM_HOME/bin:$PATH" ;;
    esac
fi
# pnpm end
