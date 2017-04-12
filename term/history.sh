#!/bin/bash

# append to history file. Allows history to be available across multiple sessions
export HISTCONTROL=ignorespace:ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND='history -a;history -n;history -w;history -c;history -r'
