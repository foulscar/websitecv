#!/bin/bash

cd "$1"

files_to_fetch=(
  "blog"
  "content/contact"
  "content/home"
  "content/metrics"
  "projects"
  "content/resume"
)

total_files=${#files_to_fetch[@]}

json_string='{ "dates": ['

for ((i=0; i<total_files; i++)); do
  json_string+=' "'
  json_string+=$(ls -lsd "${files_to_fetch[i]}" | awk '{print "| " $7, ($8<10 ? $8 " " : $8), "|"}')
  if [ ! $i -eq $((total_files - 1)) ]; then
    json_string+='",'
  else
    json_string+='" ]}'
  fi
done

echo "$json_string" > content/dates.json
