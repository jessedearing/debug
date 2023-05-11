#!/bin/bash

while true; do
  if [[ "$(date +%S)" != "00" ]]; then
    sleep 0.25
  else
    date
    sleep 1
  fi
done
