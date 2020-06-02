#!/bin/bash

# append to history file. Allows history to be available across multiple sessions
export HISTCONTROL=ignorespace:ignoredups:erasedups
shopt -s histappend
export HISTSIZE=1000
export HISTFILESIZE=2000
export PROMPT_COMMAND="history -a;history -r"
