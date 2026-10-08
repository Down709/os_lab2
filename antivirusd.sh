#!/bin/bash

dir=$1
mDir=$2
intervals=$3

if [ $# -ne 3 ]
then
 echo "3 arguments are required"
 exit 1
fi

if [ ! -d "$dir" ]
then
 echo "directory doesn't exist"
 exit 1
fi

ls -l "$dir" > directory-info.new

mkdir -p "$mDir"

if [ ! -f directory-info.last ]
then

  for file in "$dir"/*
do
    malicious=0

    if [[ "$file" == *.exe ]]
    then
        malicious=1
    elif [[ "$file" == *.bat ]]
    then
        malicious=1
    elif [[ "$file" == *.vbs ]]
    then
        malicious=1
    elif [[ "$file" == *.scr ]]
    then
        malicious=1
    elif [[ "$file" == *.ps1 ]]
    then
        malicious=1
    fi

    if grep -qiE "virus|trojan|malware|worm|ransomware" "$file"
    then
        malicious=1
    fi

    if [ "$malicious" -eq 1 ]
    then
        echo "$file is malicious and it is DELETED"
        cp "$file" "$mDir/"
        rm "$file"
    fi
done

 cp directory-info.new directory-info.last
fi

echo "source directory: $dir"
echo "malicious directory: $mDir"
echo "intervals: $intervals sec"


while true
do
    sleep "$intervals"

    ls -l "$dir" > directory-info.new

    if ! diff directory-info.new directory-info.last
    then
        echo "changes detected"

        for file in "$dir"/*
        do
            malicious=0

            if [[ "$file" == *.exe ]]
            then
                malicious=1
            elif [[ "$file" == *.bat ]]
            then
                malicious=1
            elif [[ "$file" == *.vbs ]]
            then
                malicious=1
            elif [[ "$file" == *.scr ]]
            then
                malicious=1
            elif [[ "$file" == *.ps1 ]]
            then
                malicious=1
            fi

            if grep -qiE "virus|trojan|malware|worm|ransomware" "$file"
            then
                malicious=1
            fi

            if [ "$malicious" -eq 1 ]
            then
                echo "$file is malicious and it is DELETED"
                cp "$file" "$mDir/"
                rm "$file"
            fi
        done

        ls -l "$dir" > directory-info.last
    fi
done
