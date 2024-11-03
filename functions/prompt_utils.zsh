#
# functions/prompt_utils.zsh - provide prompt definitions
#
# This work is free.  You can redistribute it and/or modify it under the terms of
# the Do What The Fuck You Want To Public License, Version 2, as published by Sam
# Hocevar.  See  the COPYING file  or  http://www.wtfpl.net/  for  more  details.
#

# Context: user@Git branch hash or user@hostname (who am I and where am I)
prompt_context () {
  local username="%(!.$OHMYVIA_CONTEXT_ROOT_COLOR.$OHMYVIA_CONTEXT_USER_COLOR)%n%b%f"

  # Check if we are inside a Git repository
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # Get the current commit short hash
    local branch_hash="$(git rev-parse --short HEAD 2>/dev/null)"
    if [[ -n "$branch_hash" ]]; then
      # Replace the hostname with the commit hash
      print -P "${username}${OHMYVIA_CONTEXT_SEPARATOR_COLOR}@${OHMYVIA_CONTEXT_HOSTNAME_COLOR}${branch_hash}%b%f"
      return
    fi
  fi

  # Display only the username if $OHMYVIA_CONTEXT_HOSTNAME is empty
  if [[ $OHMYVIA_CONTEXT_HOSTNAME == "empty" ]]; then
    print -P "${username}"
    return
  fi

  local separator="$OHMYVIA_CONTEXT_SEPARATOR_COLOR@%b%f"
  local colorless_hostname="$OHMYVIA_CONTEXT_HOSTNAME"

  # Handle full or partial hostname display
  if [[ $OHMYVIA_CONTEXT_HOSTNAME == 'full' ]]; then
    colorless_hostname="%M"
  elif [[ $OHMYVIA_CONTEXT_HOSTNAME == 'partial' ]]; then
    colorless_hostname="%m"
  fi

  # Set the color depending on whether we detect an SSH session
  if [[ -n $SSH_TTY ]]; then
    hostname="$OHMYVIA_CONTEXT_HOSTNAME_COLOR_SSH${colorless_hostname}%b%f"
  else
    hostname="$OHMYVIA_CONTEXT_HOSTNAME_COLOR${colorless_hostname}%b%f"
  fi

  print -P "${username}${separator}${hostname}"
}

# Print current directory with ~ instead of $HOME
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Shell-state
prompt_dir () {
  local colorless_current_dir="%${OHMYVIA_DIR_SIZE}~"
  local current_dir="$OHMYVIA_DIR_COLOR${colorless_current_dir}%b%f"

  echo "$current_dir"
}

# Print current time
prompt_time () {
  local clock="$OHMYVIA_TIME_COLOR$OHMYVIA_TIME_FORMAT%b%f"

  echo "$clock"
}

# vim: ft=zsh noet
