#!/usr/bin/env zsh

# Message to display
MESSAGE="> Welcome back, $USER. Hyprland system initialized."
DELAY=0.04 # Delay between characters (seconds)

# Open the eww window
eww open welcome

# Reset text variable to empty
eww update welcome_text=""

# Typewriter effect loop
ACCUMULATED=""
for ((i = 0; i < ${#MESSAGE}; i++)); do
  ACCUMULATED="${ACCUMULATED}${MESSAGE:$i:1}"
  eww update welcome_text="$ACCUMULATED"
  sleep "$DELAY"
done

# Keep text visible on screen for 4 seconds, then close window
sleep 4
eww close welcome
