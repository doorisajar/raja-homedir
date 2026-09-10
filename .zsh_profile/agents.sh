#!/bin/bash

# Usage: nopi [--session-name NAME]
nopi() {
  local base="pi-s1"
  # Generated names replace the numeric suffix; they do not append to it.
  local session_prefix="${base%-[0-9]*}"
  local session_name
  local next

  case "$#" in
    0)
      # Preserve the original name for the first default session.
      if ! tmux has-session -t "=$base" 2>/dev/null; then
        session_name="$base"
      else
        # Count only the default name and generated numeric variants.
        # Arbitrary custom names are deliberately ignored.
        next="$(
          tmux list-sessions -F '#S' 2>/dev/null |
            awk '
              $0 ~ /^pi-s[0-9]+$/ {
                count++
              }
              END {
                print count + 1
              }
            '
        )"

        session_name="${session_prefix}-${next}"

        # Avoid a collision if numbered sessions were removed out of order.
        while tmux has-session -t "=$session_name" 2>/dev/null; do
          next=$((next + 1))
          session_name="${session_prefix}-${next}"
        done
      fi
      ;;
    2)
      if [ "$1" != "--session-name" ] || [ -z "$2" ]; then
        printf 'Usage: nopi [--session-name NAME]\n' >&2
        return 2
      fi
      session_name="$2"
      ;;
    *)
      printf 'Usage: nopi [--session-name NAME]\n' >&2
      return 2
      ;;
  esac

  tmux new-session -s "$session_name" \
    'exec nono run --profile pi -- pi'
}
