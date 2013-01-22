#!/bin/bash

# 매니페스트 파일의 스크립트 부분을 압축 코드로 변경한다.

input="$1/manifest.json" # original manifest file
output="$2/manifest.json" # destination manifest file

# Reset output file
rm "$output" 2> /dev/null
touch "$output"

r_array_closed='],?'
is_array_open=false

cscript_output='"js": [ "js/cscript.min.js"'
bg_output='"scripts": [ "js/bg.min.js"'

while read line; do
  case "$line" in
    '"js"'*) # content scripts
      is_array_open=true
      echo "$cscript_output" >> "$output"
      ;;

    '"scripts"'*) # background scripts
      is_array_open=true
      echo "$bg_output" >> "$output" 
      ;;

    *)
      if $is_array_open; then
        if [[ "$line" =~ $r_array_closed ]]; then
          echo "$BASH_REMATCH" >> "$output"
          is_array_open=false
        fi
        continue

      fi

      echo "$line" >> "$output"
      ;;

  esac

done < "$input"