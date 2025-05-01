#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <fichier_log>"
  exit 1
fi

fichier_log="$1"

regex='([0-9]{1,3}\.){3}[0-9]{1,3}'

grep -Eo "$regex" "$fichier_log"

exit 0
