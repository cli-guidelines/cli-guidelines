#!/bin/sh

cmd="$@"

echo -n "$ "
echo "$cmd" | while IFS='' read -n1 char; do
  echo -n "$char"
  sleep 0.1
done
echo

exec $cmd
