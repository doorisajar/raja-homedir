#!/bin/bash

# Usage: nopi [--session-name NAME]
nopi() {
  local launch_dir="${PWD##*/}"
  local launch_slug
  # Use the launch directory as a safe, recognizable part of the session name.
  [ -n "$launch_dir" ] || launch_dir="root"
  launch_slug="$(printf '%s' "$launch_dir" | tr -cs '[:alnum:]_-' '-' | sed 's/^-*//; s/-*$//')"
  [ -n "$launch_slug" ] || launch_slug="root"

  local base="pi1-${launch_slug}"
  # Generated names replace the numeric suffix; they do not append to it.
  local session_prefix="pi"
  local session_name
  local next

  case "$#" in
    0)
      # Use the base name for the first default session in this directory.
      if ! tmux has-session -t "=$base" 2>/dev/null; then
        session_name="$base"
      else
        # Count only this directory's default name and numeric variants.
        # Arbitrary custom names and other directories are ignored.
        next="$(
          tmux list-sessions -F '#S' 2>/dev/null |
            awk -v slug="$launch_slug" '
              $0 ~ "^pi[0-9]+-" slug "$" {
                count++
              }
              END {
                print count + 1
              }
            '
        )"

        session_name="${session_prefix}${next}-${launch_slug}"

        # Avoid a collision if numbered sessions were removed out of order.
        while tmux has-session -t "=$session_name" 2>/dev/null; do
          next=$((next + 1))
          session_name="${session_prefix}${next}-${launch_slug}"
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
    'exec nono run --allow-cwd --profile pi -- pi'
}
