#!/usr/bin

# flai => find line and insert
# usage: bash <(curl -L https://raw.githubusercontent.com/librz/shell_scripts/main/flai.sh) /path/to/file "first line\nsecond line"

input=$1
insertion=$2
result=""
found=false

while IFS= read -r line
do
  if [[ $found = true ]]; then
    result="$result\n$line"
  else 
    echo "$line" | grep upgrade > /dev/null 2>&1 
    if [[ $? -eq 0 ]]; then
      result="$result\n$line\n$insertion"
      found=true
    else
      result="$result\n$line"
    fi  
  fi  
done < "$input"

if [[ $found = false ]]; then
  echo "not found"
  exit 1
fi

echo -e "$result" > "$input"
