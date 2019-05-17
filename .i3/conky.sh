#!/bin/sh
# 3-12 11:40 AM | MusicSymobl: 0% | 363.3 GB | W: (59%@MDC-Open) | Bat 84.68% 18:11
# { "full_text" : "RAM ${memperc}%" , "color" : ${if_match ${memperc}<90}"\#4ad0c6"${else}"\#ff0000"${endif} }

# -- ${if_mpd_playing}♫  ${mpd_artist} -  ${mpd_title} | ${endif}\

# Send the header so that i3bar knows we want to use JSON:
echo '{"version":1}'

# Begin the endless array.
echo '['

# We send an empty first array of blocks to make the loop simpler:
echo '[],'

# Now send blocks with information forever:
# exec conky -c $HOME/.i3/.conkyrc
exec conky -c $HOME/.i3/.conkyrc.lua
