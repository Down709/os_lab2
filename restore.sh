#!/bin/bash

dir=$1
mDir=$2

exec 200>antivirus.lock
if ! flock -n 200
then
    echo "antiveiruse is alredy running"
    exit 1
fi

if [ $# -ne 2 ]
then
    echo "2 arguments are needed"
    exit 1
fi

if [ ! -d "$dir" ]
then
    echo "directory doesn't exist"
    exit 1
fi

if [ ! -d "$mDir" ]
then
    echo "malicious directory doesn't exist"
    exit 1
fi

while true
do
 files=("$mDir"/*)
 if [ ! -e "${files[0]}" ]
 then
  echo "no maliciosus files to show"
 break
fi
echo "choose file:"
i=1
for file in "${files[@]}"
do
echo "$i: $file"
((i++))
done

read -r -p ">" choice

if [[ ! "$choice" =~ ^[0-9]+$ ]]
then
    echo "Invalid choice."
    continue
fi

if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#files[@]}" ]
then
    echo "Invalid choice."
    continue
fi

selected_file="${files[$((choice - 1))]}"

echo "For $selected_file:"
echo "1: restore"
echo "2: permanently"
echo "3: go back"

read -r -p "> " action

if [[ ! "$action" =~ ^[0-9]+$ ]]
then
    echo "Invalid choice."
    continue
fi

if [ "$action" -lt 1 ] || [ "$action" -gt 3 ]
then
    echo "Invalid choice."
    continue
fi

if [ "$action" -eq 1 ]
then
  cp "$selected_file" "$dir/"
  rm "$selected_file"
  echo "restored $selected_file to $dir"
  continue
fi

if [ "$action" -eq 2 ]
then
  rm "$selected_file"
  echo "$selected_file is permently removed"
  continue
fi

done
